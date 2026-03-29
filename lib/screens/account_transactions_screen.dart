import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';

class AccountTransactionsScreen extends StatefulWidget {
  final Account account;
  const AccountTransactionsScreen({super.key, required this.account});

  @override
  State<AccountTransactionsScreen> createState() =>
      _AccountTransactionsScreenState();
}

class _AccountTransactionsScreenState
    extends State<AccountTransactionsScreen> {
  List<Transaction> get _transactions => data.transactions
      .where((t) =>
          t.fromAccount?.id == widget.account.id ||
          t.toAccount?.id == widget.account.id)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  void _delete(Transaction t) {
    if (t.nativeAmount != null) {
      if (t.fromAccount != null) t.fromAccount!.balance += t.nativeAmount!;
      if (t.toAccount != null) {
        t.toAccount!.balance -= (t.destinationAmount ?? t.nativeAmount!);
      }
    }
    data.transactions.remove(t);
    setState(() {});
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(Transaction t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete transaction?'),
        content: const Text('This will reverse the account balance changes.'),
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
              _delete(t);
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
    final account = widget.account;
    final isPersonal = account.group == AccountGroup.personal;
    final isEntities = account.group == AccountGroup.entities;
    final avatarBg = isPersonal
        ? cs.primaryContainer
        : isEntities
            ? cs.secondaryContainer
            : cs.tertiaryContainer;
    final avatarFg = isPersonal
        ? cs.onPrimaryContainer
        : isEntities
            ? cs.onSecondaryContainer
            : cs.onTertiaryContainer;
    final balPos = account.balance >= 0;
    final balColor =
        balPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    final txs = _transactions;

    // Group by date
    final grouped = <String, List<Transaction>>{};
    for (final t in txs) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: Text(account.name),
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
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: avatarBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              account.name[0].toUpperCase(),
                              style: TextStyle(
                                color: avatarFg,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${account.balance > 0 ? '+' : ''}${account.balance.toStringAsFixed(2)} ${fx.currencySymbol(account.currencyCode)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: balColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              '${txs.length} transaction${txs.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (txs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 48, color: cs.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      'No transactions yet',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final day = days[i];
                    final dayTxs = grouped[day]!;
                    final date = DateTime.parse(day);
                    return _DaySection(
                      date: date,
                      transactions: dayTxs,
                      focusAccount: account,
                      onDelete: _confirmDelete,
                    );
                  },
                  childCount: days.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final Account focusAccount;
  final void Function(Transaction) onDelete;

  const _DaySection({
    required this.date,
    required this.transactions,
    required this.focusAccount,
    required this.onDelete,
  });

  String _dayLabel() {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEEE, d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(
            _dayLabel(),
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.1),
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
                    _TxTile(
                      transaction: entry.value,
                      focusAccount: focusAccount,
                      onDelete: () => onDelete(entry.value),
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

class _TxTile extends StatelessWidget {
  final Transaction transaction;
  final Account focusAccount;
  final VoidCallback onDelete;

  const _TxTile({
    required this.transaction,
    required this.focusAccount,
    required this.onDelete,
  });

  TxType get _type =>
      transaction.txType ??
      classifyTransaction(
          from: transaction.fromAccount, to: transaction.toAccount);

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

  // Show the counterpart account (not the focus account)
  String? _counterpart() {
    final t = transaction;
    final fid = focusAccount.id;
    if (t.fromAccount?.id == fid && t.toAccount != null) {
      return t.toAccount!.name;
    }
    if (t.toAccount?.id == fid && t.fromAccount != null) {
      return t.fromAccount!.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typeColor = txColor(_type);
    final counterpart = _counterpart();

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
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
        onLongPress: onDelete,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(txIcon(_type), size: 18, color: typeColor),
              ),
              const SizedBox(width: 12),
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
                          color: cs.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 10, color: cs.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Text(
                          DateFormat('d MMM yyyy').format(transaction.date),
                          style: TextStyle(
                              fontSize: 11, color: cs.onSurfaceVariant),
                        ),
                        if (counterpart != null) ...[
                          Text('  ·  ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant)),
                          Expanded(
                            child: Text(
                              counterpart,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (transaction.nativeAmount != null)
                Text(
                  txAmountDisplay(
                      _type, transaction.nativeAmount!, transaction.currencyCode ?? 'BAM'),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: typeColor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
