import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import '../utils/projections.dart' as proj;
import 'new_planned_transaction_screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {

  void _confirm(PlannedTransaction pt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
    // Apply to real balances
    if (pt.amount != null) {
      if (pt.fromAccount != null) pt.fromAccount!.balance -= pt.amount!;
      if (pt.toAccount != null) pt.toAccount!.balance += pt.amount!;
    }

    // Move to history — use the planned date, not the confirmation date
    data.transactions.insert(
      0,
      Transaction(
        amount: pt.amount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        category: pt.category,
        description: pt.description,
        date: pt.date,
      ),
    );

    data.plannedTransactions.remove(pt);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction confirmed and applied')),
    );
  }

  void _delete(PlannedTransaction pt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete planned transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => data.plannedTransactions.remove(pt));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    final planned = data.plannedTransactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'plan_fab',
        onPressed: _addPlanned,
        child: const Icon(Icons.add),
      ),
      body: planned.isEmpty
          ? _emptyState()
          : _timeline(planned),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          const Text(
            'No planned transactions yet.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to plan a future transaction.',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _timeline(List<PlannedTransaction> planned) {
    // Group by day
    final grouped = <String, List<PlannedTransaction>>{};
    for (final pt in planned) {
      final key = DateFormat('yyyy-MM-dd').format(pt.date);
      grouped.putIfAbsent(key, () => []).add(pt);
    }
    final days = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
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
          onConfirm: _confirm,
          onDelete: _delete,
        );
      },
    );
  }
}

class _DayGroup extends StatelessWidget {
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

  String _formatDate(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final target = DateUtils.dateOnly(d);
    if (target == today) return 'Today';
    if (target == tomorrow) return 'Tomorrow';
    return DateFormat('EEEE, dd MMM yyyy').format(d);
  }

  bool get _isPast =>
      DateUtils.dateOnly(date).isBefore(DateUtils.dateOnly(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final partner = data.accounts
        .where((a) => a.group == AccountGroup.partner)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          color: _isPast
              ? theme.colorScheme.errorContainer.withValues(alpha: 0.3)
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Icon(
                _isPast ? Icons.warning_amber_rounded : Icons.event,
                size: 16,
                color: _isPast
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(date),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: _isPast
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isPast) ...[
                const SizedBox(width: 8),
                Text(
                  '— overdue',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Planned transactions
        ...planned.map(
          (pt) => _PlannedTile(
            pt: pt,
            onConfirm: () => onConfirm(pt),
            onDelete: () => onDelete(pt),
          ),
        ),

        // Projected balances ribbon
        Container(
          color: theme.colorScheme.surfaceContainerLow,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Projected balances after this day',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 8),
              // Personal total
              Builder(builder: (context) {
                final total = proj.personalTotal(projectedBalances);
                final pos = total >= 0;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: pos
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: pos
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Personal total',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: pos ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${pos ? '+' : '-'}€${total.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: pos ? Colors.green.shade800 : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              if (personal.isNotEmpty) ...[
                Text(
                  'PERSONAL',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: personal
                        .map((a) => _BalanceChip(
                              name: a.name,
                              balance: projectedBalances[a.id] ?? a.balance,
                            ))
                        .toList(),
                  ),
                ),
              ],
              if (partner.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'PARTNER',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: partner
                        .map((a) => _BalanceChip(
                              name: a.name,
                              balance: projectedBalances[a.id] ?? a.balance,
                              isPartner: true,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),

        const Divider(height: 1),
      ],
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String name;
  final double balance;
  final bool isPartner;

  const _BalanceChip({
    required this.name,
    required this.balance,
    this.isPartner = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = balance >= 0;
    final color = isPositive ? Colors.green.shade700 : Colors.red.shade700;
    final bgColor = isPositive
        ? Colors.green.withValues(alpha: 0.1)
        : Colors.red.withValues(alpha: 0.1);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isPartner
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}€${balance.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
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

  String _buildTitle() {
    if (pt.description != null) return pt.description!;
    if (pt.category != null) return pt.category!;
    if (pt.fromAccount != null && pt.toAccount != null) {
      return '${pt.fromAccount!.name} → ${pt.toAccount!.name}';
    }
    if (pt.fromAccount != null) return 'From ${pt.fromAccount!.name}';
    if (pt.toAccount != null) return 'To ${pt.toAccount!.name}';
    return 'Planned transaction';
  }

  String? _buildSubtitle() {
    final parts = <String>[];
    if (pt.description != null || pt.category != null) {
      if (pt.fromAccount != null && pt.toAccount != null) {
        parts.add('${pt.fromAccount!.name} → ${pt.toAccount!.name}');
      } else if (pt.fromAccount != null) {
        parts.add('From: ${pt.fromAccount!.name}');
      } else if (pt.toAccount != null) {
        parts.add('To: ${pt.toAccount!.name}');
      }
    }
    if (pt.description != null && pt.category != null) parts.add(pt.category!);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String _amountPrefix() {
    if (pt.fromAccount != null && pt.toAccount == null) return '-';
    if (pt.toAccount != null && pt.fromAccount == null) return '+';
    return '⇄ ';
  }

  Color _amountColor(BuildContext context) {
    if (pt.fromAccount != null && pt.toAccount == null) return Colors.red.shade700;
    if (pt.toAccount != null && pt.fromAccount == null) return Colors.green.shade700;
    return Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _buildSubtitle();

    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.schedule, color: Colors.grey),
      ),
      title: Text(_buildTitle(), maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.outline),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pt.amount != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${_amountPrefix()}€${pt.amount!.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  color: _amountColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.shade300,
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
          ),
          // Confirm
          FilledButton.tonal(
            onPressed: onConfirm,
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Text('Confirm', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
