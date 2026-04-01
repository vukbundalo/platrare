import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/projections.dart' as proj;
import '../utils/tx_display.dart';
import 'new_planned_transaction_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';
import 'transaction_detail_screen.dart';

const _kExpenseColor = Color(0xFFDC2626);
const _kIncomeColor = Color(0xFF16A34A);

class PlanScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const PlanScreen({super.key, this.onChanged});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  DateTime _snapshotDate = DateUtils.dateOnly(DateTime.now());
  String? _typeFilter;
  bool _detailExpanded = false;

  Future<void> _pickSnapshotDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _snapshotDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null && mounted) setState(() => _snapshotDate = picked);
  }

  void _confirm(PlannedTransaction pt) {
    final today = DateUtils.dateOnly(DateTime.now());
    final ptDate = DateUtils.dateOnly(pt.date);
    final isRepeated = pt.repeatInterval != RepeatInterval.none;

    if (isRepeated && ptDate.isAfter(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Cannot confirm — this recurrence is scheduled for ${DateFormat('d MMM').format(pt.date)}'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

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
              _realize(pt, realizationDate: today);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _realize(PlannedTransaction pt, {DateTime? realizationDate}) {
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
        date: realizationDate ?? pt.date,
        txType: pt.txType,
      ),
    );

    data.plannedTransactions.remove(pt);

    // Auto-spawn the next occurrence for repeated transactions.
    if (pt.repeatInterval != RepeatInterval.none) {
      final nextDate = nextOccurrence(pt.date, pt.repeatInterval);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: pt.nativeAmount,
        currencyCode: pt.currencyCode,
        destinationAmount: pt.destinationAmount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        category: pt.category,
        description: pt.description,
        date: nextDate,
        txType: pt.txType,
        repeatInterval: pt.repeatInterval,
      ));
      data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    }

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
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Planned transaction removed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            messenger.clearSnackBars();
            setState(() {
              data.plannedTransactions.add(pt);
              data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
            });
          },
        ),
      ),
    );
  }

  void _deleteWithRepeatChoice(PlannedTransaction pt) {
    if (pt.repeatInterval == RepeatInterval.none) {
      _delete(pt);
      return;
    }

    HapticFeedback.lightImpact();
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete repeated transaction?'),
        content: const Text(
            'Do you want to remove only this occurrence or cancel all future occurrences?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'this'),
            child: const Text('This only'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'all'),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('All'),
          ),
        ],
      ),
    ).then((choice) {
      if (choice == null || !mounted) return;
      if (choice == 'all') {
        _delete(pt);
      } else {
        // Delete this occurrence and spawn the next one.
        final nextDate = nextOccurrence(pt.date, pt.repeatInterval);
        setState(() {
          data.plannedTransactions.remove(pt);
          data.plannedTransactions.add(PlannedTransaction(
            nativeAmount: pt.nativeAmount,
            currencyCode: pt.currencyCode,
            destinationAmount: pt.destinationAmount,
            fromAccount: pt.fromAccount,
            toAccount: pt.toAccount,
            category: pt.category,
            description: pt.description,
            date: nextDate,
            txType: pt.txType,
            repeatInterval: pt.repeatInterval,
          ));
          data.plannedTransactions
              .sort((a, b) => a.date.compareTo(b.date));
        });
        widget.onChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Occurrence removed, next one scheduled'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
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

  Future<void> _addAccount() async {
    final result = await showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) => const AccountFormSheet(),
    );
    if (result != null) {
      setState(() => data.accounts.add(result));
      widget.onChanged?.call();
    }
  }

  Future<void> _edit(PlannedTransaction pt) async {
    final result = await Navigator.push<PlannedTransaction>(
      context,
      MaterialPageRoute(
          builder: (_) => NewPlannedTransactionScreen(existing: pt)),
    );
    if (result != null) {
      setState(() {
        final idx = data.plannedTransactions.indexWhere((t) => t.id == pt.id);
        if (idx >= 0) {
          data.plannedTransactions[idx] = result;
        } else {
          data.plannedTransactions.add(result);
        }
        data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
      });
    }
  }

  void _openPlannedDetail(PlannedTransaction pt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlannedTransactionDetailScreen(
          pt: pt,
          onConfirm: () => _confirm(pt),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final planned = _typeFilter == null
        ? data.plannedTransactions
        : data.plannedTransactions.where((pt) {
            final type = pt.txType ??
                classifyTransaction(
                    from: pt.fromAccount, to: pt.toAccount);
            if (_typeFilter == 'income') {
              return type == TxType.income ||
                  type == TxType.invoice ||
                  type == TxType.collection;
            } else if (_typeFilter == 'expense') {
              return type == TxType.expense ||
                  type == TxType.bill ||
                  type == TxType.settlement ||
                  type == TxType.advance;
            } else if (_typeFilter == 'transfer') {
              return type == TxType.transfer ||
                  type == TxType.loan ||
                  type == TxType.offset;
            }
            return true;
          }).toList();

    // Compute once per build — used by both hero and detail card.
    final balances = proj.projectBalances(_snapshotDate);
    final snapshotPersonal = proj.personalTotal(balances);
    final snapshotNet = proj.netWorthInBase(balances);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: const Text('Plan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()),
                  );
                  if (mounted) setState(() {});
                  widget.onChanged?.call();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ProjectionHero(
                      personal: snapshotPersonal,
                      net: snapshotNet,
                      date: _snapshotDate,
                      expanded: _detailExpanded,
                      typeFilter: _typeFilter,
                      onPickDate: _pickSnapshotDate,
                      onToggle: () =>
                          setState(() => _detailExpanded = !_detailExpanded),
                      onTypeFilter: (v) => setState(() => _typeFilter = v),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded per-account detail card
          if (_detailExpanded)
            SliverToBoxAdapter(
              child: _ProjectionDetailCard(balances: balances),
            ),
          if (planned.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: data.accounts.isEmpty
                  ? _EmptyState(
                      onAdd: _addAccount,
                      hasAccounts: false,
                    )
                  : _EmptyState(
                      onAdd: _addPlanned,
                      hasAccounts: true,
                    ),
            )
          else
            _PlanTimeline(
              planned: planned,
              onConfirm: _confirm,
              onDelete: _deleteWithRepeatChoice,
              onEdit: _edit,
              onTap: _openPlannedDetail,
            ),
        ],
      ),
      floatingActionButton: planned.isEmpty
          ? null
          : FloatingActionButton(
              heroTag: 'plan_fab',
              onPressed: _addPlanned,
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _ProjectionHero extends StatelessWidget {
  final double personal;
  final double net;
  final DateTime date;
  final bool expanded;
  final String? typeFilter;
  final VoidCallback onPickDate;
  final VoidCallback onToggle;
  final ValueChanged<String?> onTypeFilter;

  const _ProjectionHero({
    required this.personal,
    required this.net,
    required this.date,
    required this.expanded,
    required this.typeFilter,
    required this.onPickDate,
    required this.onToggle,
    required this.onTypeFilter,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sym = fx.currencySymbol(settings.baseCurrency);
    final personalPos = personal >= 0;
    final netPos = net >= 0;
    final borderColor =
        personalPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final personalColor =
        personalPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final netColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    Widget filterChip(String key, IconData icon) {
      final active = typeFilter == key;
      return GestureDetector(
        onTap: () => onTypeFilter(active ? null : key),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 15,
              color: active ? cs.primary : cs.onSurfaceVariant),
        ),
      );
    }

    Widget actionChip({required IconData icon, required bool active, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 15,
              color: active ? cs.primary : cs.onSurfaceVariant),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: borderColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Balance / Net row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Projected Balance',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      '${personal > 0 ? '+' : ''}${personal.toStringAsFixed(2)} $sym',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: personalColor,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: borderColor.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Net',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    '${net > 0 ? '+' : ''}${net.toStringAsFixed(2)} $sym',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: netColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 5 equal chips
          Row(
            children: [
              Expanded(child: filterChip('income', Icons.arrow_downward_rounded)),
              const SizedBox(width: 6),
              Expanded(child: filterChip('expense', Icons.arrow_upward_rounded)),
              const SizedBox(width: 6),
              Expanded(child: filterChip('transfer', Icons.swap_horiz_rounded)),
              const SizedBox(width: 6),
              Expanded(
                child: actionChip(
                  icon: Icons.calendar_today_rounded,
                  active: DateUtils.dateOnly(date) != DateUtils.dateOnly(DateTime.now()),
                  onTap: onPickDate,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: actionChip(
                  icon: expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  active: expanded,
                  onTap: onToggle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectionDetailCard extends StatelessWidget {
  final Map<String, double> balances;
  const _ProjectionDetailCard({required this.balances});

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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (personal.isNotEmpty) ...[
                Text('PERSONAL',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                        color: cs.primary)),
                const SizedBox(height: 6),
                ...personal.map((a) => _BalanceChip(
                      name: a.name,
                      balance: balances[a.id] ?? a.balance,
                      currencyCode: a.currencyCode,
                    )),
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
                ...individuals.map((a) => _BalanceChip(
                      name: a.name,
                      balance: balances[a.id] ?? a.balance,
                      currencyCode: a.currencyCode,
                      isPartner: true,
                    )),
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
                ...entities.map((a) => _BalanceChip(
                      name: a.name,
                      balance: balances[a.id] ?? a.balance,
                      currencyCode: a.currencyCode,
                      isPartner: true,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  final bool hasAccounts;
  const _EmptyState({required this.onAdd, required this.hasAccounts});

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
            child: Icon(
              hasAccounts
                  ? Icons.event_note_rounded
                  : Icons.account_balance_wallet_rounded,
              size: 44,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasAccounts ? 'Nothing planned for now' : 'No accounts yet',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            hasAccounts
                ? 'Plan upcoming transactions.'
                : 'Add your first account before planning transactions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(hasAccounts ? 'Add plan' : 'Add account'),
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
  final void Function(PlannedTransaction) onEdit;
  final void Function(PlannedTransaction) onTap;

  const _PlanTimeline({
    required this.planned,
    required this.onConfirm,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
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
      padding: const EdgeInsets.only(bottom: 100),
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
            onEdit: onEdit,
            onTap: onTap,
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
  final void Function(PlannedTransaction) onEdit;
  final void Function(PlannedTransaction) onTap;

  const _DayGroup({
    required this.date,
    required this.planned,
    required this.projectedBalances,
    required this.onConfirm,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header — same style as track screen
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            children: [
              Text(
                _formatDate(widget.date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),

        // Card — same container style as track screen
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // Planned transaction tiles
                ...widget.planned.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final pt = entry.value;
                  final today = DateUtils.dateOnly(DateTime.now());
                  final ptDay = DateUtils.dateOnly(pt.date);
                  final isOverdue = ptDay.isBefore(today);
                  return Dismissible(
                    key: ValueKey(pt.id),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        widget.onDelete(pt);
                      } else {
                        widget.onConfirm(pt);
                      }
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                      child: const Icon(Icons.check_circle_outline_rounded,
                          color: Color(0xFF16A34A), size: 22),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red.withValues(alpha: 0.12),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Color(0xFFDC2626), size: 22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (idx > 0)
                          Divider(
                              height: 0.5,
                              indent: 56,
                              color: cs.outlineVariant.withValues(alpha: 0.4)),
                        if (isOverdue)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    size: 14, color: cs.error),
                                const SizedBox(width: 6),
                                Text(
                                  'Overdue',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: cs.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        _PlannedTile(
                          pt: pt,
                          onTap: () => widget.onTap(pt),
                          onLongPress: () => widget.onEdit(pt),
                          showProjection: idx == widget.planned.length - 1
                              ? _showProjection
                              : false,
                          onToggleProjection: idx == widget.planned.length - 1
                              ? () => setState(
                                  () => _showProjection = !_showProjection)
                              : null,
                        ),
                      ],
                    ),
                  );
                }),

                // Projection panel
                if (_showProjection) ...[
                  Divider(
                      height: 0.5,
                      color: cs.outlineVariant.withValues(alpha: 0.4)),
                  _ProjectionPanel(
                    projectedBalances: widget.projectedBalances,
                    personal: personal,
                    individuals: individuals,
                    entities: entities,
                    gainIds: {
                      for (final pt in widget.planned)
                        if (pt.toAccount != null) pt.toAccount!.id,
                    },
                    loseIds: {
                      for (final pt in widget.planned)
                        if (pt.fromAccount != null) pt.fromAccount!.id,
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectionPanel extends StatelessWidget {
  final Map<String, double> projectedBalances;
  final List<Account> personal;
  final List<Account> individuals;
  final List<Account> entities;
  final Set<String> gainIds;
  final Set<String> loseIds;

  const _ProjectionPanel({
    required this.projectedBalances,
    required this.personal,
    required this.individuals,
    required this.entities,
    this.gainIds = const {},
    this.loseIds = const {},
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
                Text('Balance',
                    style: TextStyle(
                        fontSize: 12,
                        color: pos
                            ? _kIncomeColor
                            : _kExpenseColor,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  '${total > 0 ? '+' : ''}${total.toStringAsFixed(2)} KM',
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
            ...personal.map((a) => _BalanceChip(
                  name: a.name,
                  balance: projectedBalances[a.id] ?? a.balance,
                  currencyCode: a.currencyCode,
                  isGain: gainIds.contains(a.id),
                  isLose: loseIds.contains(a.id),
                )),
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
            ...individuals.map((a) => _BalanceChip(
                  name: a.name,
                  balance: projectedBalances[a.id] ?? a.balance,
                  currencyCode: a.currencyCode,
                  isPartner: true,
                  isGain: gainIds.contains(a.id),
                  isLose: loseIds.contains(a.id),
                )),
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
            ...entities.map((a) => _BalanceChip(
                  name: a.name,
                  balance: projectedBalances[a.id] ?? a.balance,
                  currencyCode: a.currencyCode,
                  isPartner: true,
                  isGain: gainIds.contains(a.id),
                  isLose: loseIds.contains(a.id),
                )),
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
  final bool isGain;
  final bool isLose;

  const _BalanceChip({
    required this.name,
    required this.balance,
    required this.currencyCode,
    this.isPartner = false,
    this.isGain = false,
    this.isLose = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAffected = isGain || isLose;
    final color = isGain ? _kIncomeColor : isLose ? _kExpenseColor : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isAffected
            ? color!.withValues(alpha: 0.14)
            : cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAffected
              ? color!.withValues(alpha: 0.7)
              : cs.outlineVariant.withValues(alpha: 0.4),
          width: isAffected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          if (isAffected)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              color: isPartner ? cs.tertiary : cs.primary,
              fontWeight: isAffected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${balance > 0 ? '+' : ''}${balance.toStringAsFixed(2)} ${fx.currencySymbol(currencyCode)}',
            style: TextStyle(
              color: isAffected ? color : cs.onSurfaceVariant,
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
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool showProjection;
  final VoidCallback? onToggleProjection;

  const _PlannedTile({
    required this.pt,
    required this.onTap,
    required this.onLongPress,
    this.showProjection = false,
    this.onToggleProjection,
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

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
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
                if (subtitle != null || pt.repeatInterval != RepeatInterval.none) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (pt.repeatInterval != RepeatInterval.none) ...[
                        Icon(Icons.repeat_rounded,
                            size: 11, color: cs.primary),
                        const SizedBox(width: 3),
                        Text(
                          repeatLabel(pt.repeatInterval),
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        if (subtitle != null)
                          Text(' · ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant)),
                      ],
                      if (subtitle != null)
                        Expanded(
                          child: Text(
                            subtitle,
                            style: TextStyle(
                                fontSize: 11, color: cs.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
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
          if (onToggleProjection != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onToggleProjection,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                showProjection
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
