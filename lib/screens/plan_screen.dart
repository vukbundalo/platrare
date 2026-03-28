import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/projections.dart' as proj;
import '../utils/tx_display.dart';
import 'new_planned_transaction_screen.dart';

const _kExpenseColor = Color(0xFFDC2626);
const _kIncomeColor = Color(0xFF16A34A);

class PlanScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const PlanScreen({super.key, this.onChanged});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  void _confirm(PlannedTransaction pt) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm transaction?'),
        content: const Text(
          'This will apply the transaction to your real account balances and move it to History.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _realize(pt);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _realize(PlannedTransaction pt) {
    if (pt.nativeAmount != null) {
      // Deduct from source in its native currency.
      if (pt.fromAccount != null) {
        pt.fromAccount!.balance -= pt.nativeAmount!;
      }
      // Rule 4: cross-currency — credit destinationAmount; same-currency —
      // credit nativeAmount.
      if (pt.toAccount != null) {
        final credit = (pt.destinationAmount != null &&
                pt.toAccount!.currencyCode != pt.fromAccount?.currencyCode)
            ? pt.destinationAmount!
            : pt.nativeAmount!;
        pt.toAccount!.balance += credit;
      }
    }

    // Rule 3: lock baseAmount + exchangeRate at realization time.
    final ccy = pt.currencyCode ?? 'BAM';
    final rate = fx.rateToBase(ccy);
    final baseAmt = pt.nativeAmount != null ? pt.nativeAmount! * rate : null;

    data.transactions.insert(
      0,
      Transaction(
        nativeAmount: pt.nativeAmount,
        currencyCode: ccy,
        baseAmount: baseAmt,
        exchangeRate: rate,
        destinationAmount: pt.destinationAmount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        category: pt.category,
        description: pt.description,
        date: pt.date,
        txType: pt.txType,
      ),
    );

    data.plannedTransactions.remove(pt);
    setState(() {});
    widget.onChanged?.call();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction confirmed and applied'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _delete(PlannedTransaction pt) {
    HapticFeedback.lightImpact();
    setState(() => data.plannedTransactions.remove(pt));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Planned transaction removed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() {
            data.plannedTransactions.add(pt);
            data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
          }),
        ),
      ),
    );
  }

  Future<void> _addPlanned() async {
    final result = await Navigator.push<PlannedTransaction>(
      context,
      MaterialPageRoute(builder: (_) => const NewPlannedTransactionScreen()),
    );
    if (result != null) {
      setState(() {
        data.plannedTransactions.add(result);
        data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
      });
    }
  }

  // Summary stats
  int get _overdueCount {
    final today = DateUtils.dateOnly(DateTime.now());
    return data.plannedTransactions
        .where((pt) => DateUtils.dateOnly(pt.date).isBefore(today))
        .length;
  }

  double get _totalPlanned {
    return data.plannedTransactions
        .where((pt) => pt.fromAccount != null && pt.toAccount == null)
        .fold(0.0, (s, pt) => s + (pt.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final planned = data.plannedTransactions;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: planned.isEmpty ? 0 : 130,
            backgroundColor: cs.surface,
            title: const Text('Plan'),
            actions: [
              if (_overdueCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    avatar: Icon(Icons.warning_amber_rounded,
                        size: 14, color: cs.error),
                    label: Text('$_overdueCount overdue',
                        style: TextStyle(
                            color: cs.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    backgroundColor: cs.errorContainer.withValues(alpha: 0.6),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
            flexibleSpace: planned.isEmpty
                ? null
                : FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 52, 16, 12),
                      child: Row(
                        children: [
                          _HeaderStat(
                            label: 'Upcoming',
                            value: '${planned.length}',
                            icon: Icons.event_note_rounded,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 12),
                          _HeaderStat(
                            label: 'Total expenses',
                            value: 'KM${_totalPlanned.toStringAsFixed(0)}',
                            icon: Icons.trending_down_rounded,
                            color: _kExpenseColor,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          if (planned.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(onAdd: _addPlanned),
            )
          else
            _PlanTimeline(
              planned: planned,
              onConfirm: _confirm,
              onDelete: _delete,
            ),
        ],
      ),
      floatingActionButton: planned.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'plan_fab',
              onPressed: _addPlanned,
              icon: const Icon(Icons.add),
              label: const Text('Plan'),
            ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _HeaderStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500)),
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: -0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_note_rounded,
                size: 44, color: cs.primary),
          ),
          const SizedBox(height: 24),
          Text('Nothing planned yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Plan upcoming expenses, income,\nor transfers in advance.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add first plan'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTimeline extends StatelessWidget {
  final List<PlannedTransaction> planned;
  final void Function(PlannedTransaction) onConfirm;
  final void Function(PlannedTransaction) onDelete;

  const _PlanTimeline({
    required this.planned,
    required this.onConfirm,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<PlannedTransaction>>{};
    for (final pt in planned) {
      final key = DateFormat('yyyy-MM-dd').format(pt.date);
      grouped.putIfAbsent(key, () => []).add(pt);
    }
    final days = grouped.keys.toList()..sort();

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 100, top: 8),
      sliver: SliverList.builder(
        itemCount: days.length,
        itemBuilder: (ctx, i) {
          final day = days[i];
          final date = DateTime.parse(day);
          final dayPlanned = grouped[day]!;
          final projectedBalances = proj.projectBalances(date);
          return _DayGroup(
            date: date,
            planned: dayPlanned,
            projectedBalances: projectedBalances,
            onConfirm: onConfirm,
            onDelete: onDelete,
          );
        },
      ),
    );
  }
}

class _DayGroup extends StatefulWidget {
  final DateTime date;
  final List<PlannedTransaction> planned;
  final Map<String, double> projectedBalances;
  final void Function(PlannedTransaction) onConfirm;
  final void Function(PlannedTransaction) onDelete;

  const _DayGroup({
    required this.date,
    required this.planned,
    required this.projectedBalances,
    required this.onConfirm,
    required this.onDelete,
  });

  @override
  State<_DayGroup> createState() => _DayGroupState();
}

class _DayGroupState extends State<_DayGroup> {
  bool _showProjection = false;

  String _formatDate(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final target = DateUtils.dateOnly(d);
    if (target == today) return 'Today';
    if (target == tomorrow) return 'Tomorrow';
    final diff = target.difference(today).inDays;
    if (diff > 0 && diff <= 6) return DateFormat('EEEE').format(d);
    return DateFormat('EEE, d MMM yyyy').format(d);
  }

  bool get _isPast =>
      DateUtils.dateOnly(widget.date)
          .isBefore(DateUtils.dateOnly(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final individuals = data.accounts
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final entities = data.accounts
        .where((a) => a.group == AccountGroup.entities)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header row
          Row(
            children: [
              // Timeline dot
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPast ? cs.error : cs.primary,
                  border: Border.all(
                    color: _isPast
                        ? cs.error.withValues(alpha: 0.3)
                        : cs.primary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
              ),
              Text(
                _formatDate(widget.date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _isPast ? cs.error : cs.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              if (_isPast) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('overdue',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: cs.onErrorContainer)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Card containing all items for this day
          Card(
            margin: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                // Planned transaction tiles
                ...widget.planned.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final pt = entry.value;
                  return Column(
                    children: [
                      if (idx > 0)
                        Divider(
                            height: 1,
                            indent: 56,
                            color:
                                cs.outlineVariant.withValues(alpha: 0.4)),
                      _PlannedTile(
                        pt: pt,
                        onConfirm: () => widget.onConfirm(pt),
                        onDelete: () => widget.onDelete(pt),
                      ),
                    ],
                  );
                }),

                // Projection toggle
                InkWell(
                  onTap: () => setState(() => _showProjection = !_showProjection),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(16)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_outlined,
                            size: 14, color: cs.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Projected balances',
                          style: TextStyle(
                              fontSize: 12,
                              color: cs.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Icon(
                          _showProjection
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: cs.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                // Projection panel
                if (_showProjection) ...[
                  Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.4)),
                  _ProjectionPanel(
                    projectedBalances: widget.projectedBalances,
                    personal: personal,
                    individuals: individuals,
                    entities: entities,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ProjectionPanel extends StatelessWidget {
  final Map<String, double> projectedBalances;
  final List<Account> personal;
  final List<Account> individuals;
  final List<Account> entities;

  const _ProjectionPanel({
    required this.projectedBalances,
    required this.personal,
    required this.individuals,
    required this.entities,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = proj.personalTotal(projectedBalances);
    final pos = total >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal total
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: pos
                  ? _kIncomeColor.withValues(alpha: 0.08)
                  : _kExpenseColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: pos
                    ? _kIncomeColor.withValues(alpha: 0.25)
                    : _kExpenseColor.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Text('Personal total',
                    style: TextStyle(
                        fontSize: 12,
                        color: pos
                            ? _kIncomeColor
                            : _kExpenseColor,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  '${pos ? '+' : ''}KM${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: pos ? _kIncomeColor : _kExpenseColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ],
            ),
          ),

          if (personal.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('PERSONAL',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: personal
                    .map((a) => _BalanceChip(
                          name: a.name,
                          balance: projectedBalances[a.id] ?? a.balance,
                          currencyCode: a.currencyCode,
                        ))
                    .toList(),
              ),
            ),
          ],
          if (individuals.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('INDIVIDUALS',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.tertiary)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: individuals
                    .map((a) => _BalanceChip(
                          name: a.name,
                          balance: projectedBalances[a.id] ?? a.balance,
                          currencyCode: a.currencyCode,
                          isPartner: true,
                        ))
                    .toList(),
              ),
            ),
          ],
          if (entities.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('ENTITIES',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.secondary)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: entities
                    .map((a) => _BalanceChip(
                          name: a.name,
                          balance: projectedBalances[a.id] ?? a.balance,
                          currencyCode: a.currencyCode,
                          isPartner: true,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String name;
  final double balance;
  final String currencyCode;
  final bool isPartner;

  const _BalanceChip({
    required this.name,
    required this.balance,
    required this.currencyCode,
    this.isPartner = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPositive = balance >= 0;
    final color = isPositive ? _kIncomeColor : _kExpenseColor;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 10,
              color: isPartner ? cs.tertiary : cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${isPositive ? '+' : ''}${fx.currencySymbol(currencyCode)}${balance.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannedTile extends StatelessWidget {
  final PlannedTransaction pt;
  final VoidCallback onConfirm;
  final VoidCallback onDelete;

  const _PlannedTile({
    required this.pt,
    required this.onConfirm,
    required this.onDelete,
  });

  TxType get _type =>
      pt.txType ??
      classifyTransaction(from: pt.fromAccount, to: pt.toAccount);

  Color get _typeColor => txColor(_type);
  IconData get _typeIcon => txIcon(_type);

  String _buildTitle() {
    if (pt.description != null) return pt.description!;
    if (pt.category != null) return pt.category!;
    if (pt.fromAccount != null && pt.toAccount != null) {
      return '${pt.fromAccount!.name} → ${pt.toAccount!.name}';
    }
    if (pt.fromAccount != null) return pt.fromAccount!.name;
    if (pt.toAccount != null) return pt.toAccount!.name;
    return 'Planned transaction';
  }

  String? _buildSubtitle() {
    final parts = <String>[];
    if (pt.description != null && pt.category != null) parts.add(pt.category!);
    if (pt.fromAccount != null || pt.toAccount != null) {
      if (pt.description != null || pt.category != null) {
        if (pt.fromAccount != null && pt.toAccount != null) {
          parts.add('${pt.fromAccount!.name} → ${pt.toAccount!.name}');
        } else if (pt.fromAccount != null) {
          parts.add(pt.fromAccount!.name);
        } else if (pt.toAccount != null) {
          parts.add(pt.toAccount!.name);
        }
      }
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = _buildSubtitle();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon, size: 18, color: _typeColor),
          ),
          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildTitle(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Amount
          if (pt.nativeAmount != null)
            Text(
              txAmountDisplay(_type, pt.nativeAmount!, pt.currencyCode ?? 'BAM'),
              style: TextStyle(
                color: _typeColor,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          const SizedBox(width: 4),

          // Action menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded,
                size: 18, color: cs.onSurfaceVariant),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'confirm',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        size: 18, color: cs.primary),
                    const SizedBox(width: 10),
                    const Text('Confirm'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 18, color: cs.error),
                    const SizedBox(width: 10),
                    Text('Delete',
                        style: TextStyle(color: cs.error)),
                  ],
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'confirm') onConfirm();
              if (v == 'delete') onDelete();
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }
}
