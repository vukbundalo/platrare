import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/transaction.dart';

// ─── Screen ──────────────────────────────────────────────────────────────────

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ── Summary for current month ─────────────────────────────────────────────
  ({double spent, double received, int count}) get _thisMonth {
    final now = DateTime.now();
    double spent = 0;
    double received = 0;
    int count = 0;
    for (final t in data.transactions) {
      if (t.date.year == now.year && t.date.month == now.month) {
        count++;
        if (t.amount != null) {
          if (t.fromAccount != null && t.toAccount == null) {
            spent += t.amount!;
          } else if (t.toAccount != null && t.fromAccount == null) {
            received += t.amount!;
          }
        }
      }
    }
    return (spent: spent, received: received, count: count);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final allTx = data.transactions;

    if (allTx.isEmpty) return _emptyState(context);

    // Group by date key
    final grouped = <String, List<Transaction>>{};
    for (final t in allTx) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final stats = _thisMonth;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MiniStat(
                          label: DateFormat('MMMM').format(DateTime.now()),
                          icon: Icons.arrow_outward_rounded,
                          iconColor: const Color(0xFFDC2626),
                          value: 'KM${stats.spent.toStringAsFixed(0)}',
                          valueColor: const Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 8),
                        _MiniStat(
                          label: 'Received',
                          icon: Icons.arrow_downward_rounded,
                          iconColor: const Color(0xFF16A34A),
                          value: '+KM${stats.received.toStringAsFixed(0)}',
                          valueColor: const Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 8),
                        _MiniStat(
                          label: 'Transactions',
                          icon: Icons.receipt_long_rounded,
                          iconColor: cs.primary,
                          value: '${stats.count}',
                          valueColor: cs.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              title: Text(
                'History',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              titlePadding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 14),
            ),
          ),

          // ── Transaction list ────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final day = days[i];
                final txs = grouped[day]!;
                final date = DateTime.parse(day);
                return _DaySection(
                  date: date,
                  transactions: txs,
                  onRefresh: () => setState(() {}),
                );
              },
              childCount: days.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(title: const Text('History')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_rounded,
                  size: 36, color: cs.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add your first transaction\nfrom the New tab.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mini stat chip ───────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final String value;
  final Color valueColor;

  const _MiniStat({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 10,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: valueColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Day section ──────────────────────────────────────────────────────────────

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final VoidCallback onRefresh;

  const _DaySection({
    required this.date,
    required this.transactions,
    required this.onRefresh,
  });

  String _dayLabel() {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEEE, MMM d').format(date);
  }

  double get _dayNet {
    double net = 0;
    for (final t in transactions) {
      if (t.amount == null) continue;
      if (t.fromAccount != null && t.toAccount == null) {
        net -= t.amount!;
      } else if (t.toAccount != null && t.fromAccount == null) {
        net += t.amount!;
      }
    }
    return net;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final net = _dayNet;
    final netZero = net == 0;
    final netPos = net > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _dayLabel(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              if (!netZero)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: netPos
                        ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                        : const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${netPos ? '+' : ''}KM${net.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: netPos
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: transactions.asMap().entries.map((entry) {
                final isLast = entry.key == transactions.length - 1;
                return Column(
                  children: [
                    _TransactionTile(
                      transaction: entry.value,
                      onRefresh: onRefresh,
                    ),
                    if (!isLast)
                      Divider(
                        height: 0.5,
                        indent: 68,
                        endIndent: 0,
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Transaction tile ─────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onRefresh;

  const _TransactionTile(
      {required this.transaction, required this.onRefresh});

  // ── Derived display helpers ───────────────────────────────────────────────

  bool get _isExpense =>
      transaction.fromAccount != null && transaction.toAccount == null;
  bool get _isIncome =>
      transaction.toAccount != null && transaction.fromAccount == null;
  bool get _isTransfer =>
      transaction.fromAccount != null && transaction.toAccount != null;

  Color _iconBg(BuildContext ctx) {
    if (_isExpense) return const Color(0xFFDC2626).withValues(alpha: 0.12);
    if (_isIncome) return const Color(0xFF16A34A).withValues(alpha: 0.12);
    if (_isTransfer) return const Color(0xFF2563EB).withValues(alpha: 0.12);
    return Theme.of(ctx).colorScheme.surfaceContainerHighest;
  }

  Color _iconColor(BuildContext ctx) {
    if (_isExpense) return const Color(0xFFDC2626);
    if (_isIncome) return const Color(0xFF16A34A);
    if (_isTransfer) return const Color(0xFF2563EB);
    return Theme.of(ctx).colorScheme.onSurfaceVariant;
  }

  IconData get _icon {
    if (_isTransfer) return Icons.swap_horiz_rounded;
    if (_isExpense) return Icons.arrow_outward_rounded;
    if (_isIncome) return Icons.arrow_downward_rounded;
    return Icons.notes_rounded;
  }

  String _title() {
    final t = transaction;
    if (t.description != null) return t.description!;
    if (t.category != null) return t.category!;
    if (t.fromAccount != null && t.toAccount != null) {
      return '${t.fromAccount!.name} → ${t.toAccount!.name}';
    }
    if (t.fromAccount != null) return t.fromAccount!.name;
    if (t.toAccount != null) return t.toAccount!.name;
    return 'Transaction';
  }

  String? _subtitle() {
    final t = transaction;
    final parts = <String>[];
    if (t.description != null || t.category != null) {
      if (t.fromAccount != null && t.toAccount != null) {
        parts.add('${t.fromAccount!.name} → ${t.toAccount!.name}');
      } else if (t.fromAccount != null) {
        parts.add(t.fromAccount!.name);
      } else if (t.toAccount != null) {
        parts.add(t.toAccount!.name);
      }
    }
    if (t.description != null && t.category != null) {
      parts.add(t.category!);
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String _amountDisplay() {
    final t = transaction;
    if (t.amount == null) return '';
    final amt = 'KM${t.amount!.toStringAsFixed(2)}';
    if (_isExpense) return '-$amt';
    if (_isIncome) return '+$amt';
    return '⇄ $amt';
  }

  Color _amountColor(BuildContext ctx) {
    if (_isExpense) return const Color(0xFFDC2626);
    if (_isIncome) return const Color(0xFF16A34A);
    return Theme.of(ctx).colorScheme.secondary;
  }

  // ── Delete flow ───────────────────────────────────────────────────────────

  void _delete(BuildContext context) {
    final t = transaction;
    if (t.amount != null) {
      if (t.fromAccount != null) t.fromAccount!.balance += t.amount!;
      if (t.toAccount != null) t.toAccount!.balance -= t.amount!;
    }
    data.transactions.remove(t);
    onRefresh();
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text(
            'This will reverse the account balance changes.'),
        icon: Icon(Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _delete(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = _subtitle();

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _confirmDelete(context);
        return false; // we handle deletion ourselves
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.withValues(alpha: 0.12),
        child: const Icon(Icons.delete_outline_rounded,
            color: Color(0xFFDC2626), size: 22),
      ),
      child: InkWell(
        onLongPress: () => _confirmDelete(context),
        borderRadius: BorderRadius.circular(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBg(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, size: 18, color: _iconColor(context)),
              ),
              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _title(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Amount
              if (transaction.amount != null) ...[
                const SizedBox(width: 12),
                Text(
                  _amountDisplay(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _amountColor(context),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
