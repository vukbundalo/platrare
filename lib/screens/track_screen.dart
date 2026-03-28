import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';
import 'new_transaction_screen.dart';

class TrackScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const TrackScreen({super.key, this.onChanged});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  Future<void> _openNewTransaction() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NewTransactionScreen()),
    );
    if (result == true) {
      setState(() {});
      widget.onChanged?.call();
    }
  }

  ({double spent, double received, int count}) get _thisMonth {
    final now = DateTime.now();
    double spent = 0;
    double received = 0;
    int count = 0;
    for (final t in data.transactions) {
      if (t.date.year == now.year && t.date.month == now.month) {
        count++;
        if (t.nativeAmount != null) {
          final type = t.txType ??
              classifyTransaction(from: t.fromAccount, to: t.toAccount);
          // Rule 3: use locked baseAmount for P&L so historical totals never
          // mutate when exchange rates change.
          final baseValue = t.baseAmount ??
              fx.toBase(t.nativeAmount!, t.currencyCode ?? 'BAM');
          switch (type) {
            case TxType.expense:
            case TxType.settlement:
            case TxType.advance:
            case TxType.bill:
              spent += baseValue;
            case TxType.income:
            case TxType.collection:
            case TxType.invoice:
            case TxType.loan:
              received += baseValue;
            default:
              break;
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

    return Scaffold(
      backgroundColor: cs.surface,
      body: allTx.isEmpty ? _emptyBody(context) : _listBody(context, allTx),
      floatingActionButton: FloatingActionButton(
        heroTag: 'track_fab',
        onPressed: _openNewTransaction,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _emptyBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: cs.surface,
          title: const Text('Track'),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Text('No transactions yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  'Tap + to record your first transaction.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _listBody(BuildContext context, List<Transaction> allTx) {
    final cs = Theme.of(context).colorScheme;

    final grouped = <String, List<Transaction>>{};
    for (final t in allTx) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final stats = _thisMonth;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 130,
          backgroundColor: cs.surface,
          scrolledUnderElevation: 0,
          title: const Text('Track'),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _MiniStat(
                        label: DateFormat('MMMM').format(DateTime.now()),
                        icon: Icons.arrow_outward_rounded,
                        iconColor: const Color(0xFFDC2626),
                        value: '${fx.currencySymbol(settings.baseCurrency)}${stats.spent.toStringAsFixed(0)}',
                        valueColor: const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 8),
                      _MiniStat(
                        label: 'Received',
                        icon: Icons.arrow_downward_rounded,
                        iconColor: const Color(0xFF16A34A),
                        value: '+${fx.currencySymbol(settings.baseCurrency)}${stats.received.toStringAsFixed(0)}',
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
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final day = days[i];
              final txs = grouped[day]!;
              final date = DateTime.parse(day);
              return _DaySection(
                date: date,
                transactions: txs,
                onRefresh: () {
                  setState(() {});
                  widget.onChanged?.call();
                },
              );
            },
            childCount: days.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
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
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500)),
              Text(value,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: valueColor)),
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
      if (t.nativeAmount == null) continue;
      // Use locked baseAmount for a consistent base-currency day total.
      final base = t.baseAmount ??
          fx.toBase(t.nativeAmount!, t.currencyCode ?? 'BAM');
      if (t.fromAccount != null && t.toAccount == null) {
        net -= base;
      } else if (t.toAccount != null && t.fromAccount == null) {
        net += base;
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            children: [
              Text(_dayLabel(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.1)),
              const Spacer(),
              if (!netZero)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: netPos
                        ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                        : const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${netPos ? '+' : ''}${fx.currencySymbol(settings.baseCurrency)}${net.abs().toStringAsFixed(2)}',
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
            border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5)),
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

  /// Stored type takes priority; fall back to live classification for old data.
  TxType get _type =>
      transaction.txType ??
      classifyTransaction(
          from: transaction.fromAccount, to: transaction.toAccount);

  Color _iconBg(BuildContext ctx) =>
      txColor(_type).withValues(alpha: 0.12);
  Color _iconColor(BuildContext ctx) => txColor(_type);
  IconData get _icon => txIcon(_type);

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
    if (t.description != null && t.category != null) parts.add(t.category!);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String _amountDisplay() {
    final amount = transaction.nativeAmount;
    if (amount == null) return '';
    return txAmountDisplay(_type, amount, transaction.currencyCode ?? 'BAM');
  }

  Color _amountColor(BuildContext ctx) => txColor(_type);

  void _delete(BuildContext context) {
    final t = transaction;
    if (t.nativeAmount != null) {
      // Reverse the balance changes in each account's native currency.
      if (t.fromAccount != null) t.fromAccount!.balance += t.nativeAmount!;
      // Rule 4: cross-currency moves used destinationAmount for the receiving
      // account — reverse the same amount.
      if (t.toAccount != null) {
        t.toAccount!.balance -=
            (t.destinationAmount ?? t.nativeAmount!);
      }
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete transaction?'),
        content:
            const Text('This will reverse the account balance changes.'),
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
        return false;
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
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBg(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(_icon, size: 18, color: _iconColor(context)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_title(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              if (transaction.nativeAmount != null) ...[
                const SizedBox(width: 12),
                Text(_amountDisplay(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _amountColor(context))),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
