import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/transaction.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final allTransactions = data.transactions;

    if (allTransactions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('History')),
        body: const Center(
          child: Text(
            'No transactions yet.\nAdd one in the New tab.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // Group by day
    final grouped = <String, List<Transaction>>{};
    for (final t in allTransactions) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (ctx, i) {
          final day = days[i];
          final dayTransactions = grouped[day]!;
          final date = DateTime.parse(day);
          return _DayGroup(
            date: date,
            transactions: dayTransactions,
            onRefresh: () => setState(() {}),
          );
        },
      ),
    );
  }
}

class _DayGroup extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final VoidCallback onRefresh;

  const _DayGroup({
    required this.date,
    required this.transactions,
    required this.onRefresh,
  });

  String _formatDate(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateUtils.dateOnly(d);
    if (target == today) return 'Today';
    if (target == yesterday) return 'Yesterday';
    return DateFormat('EEEE, dd MMM yyyy').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Text(
            _formatDate(date),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const Divider(height: 1),
        ...transactions.map(
          (t) => _TransactionTile(transaction: t, onRefresh: onRefresh),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onRefresh;

  const _TransactionTile({
    required this.transaction,
    required this.onRefresh,
  });

  String _formatAmount(double amount) {
    return '€ ${amount.abs().toStringAsFixed(2)}';
  }

  String _buildAccountLine(Transaction t) {
    if (t.fromAccount != null && t.toAccount != null) {
      return '${t.fromAccount!.name} → ${t.toAccount!.name}';
    } else if (t.fromAccount != null) {
      return 'From: ${t.fromAccount!.name}';
    } else if (t.toAccount != null) {
      return 'To: ${t.toAccount!.name}';
    }
    return '';
  }

  String _buildTitle(Transaction t) {
    if (t.description != null) return t.description!;
    if (t.category != null) return t.category!;
    final accounts = _buildAccountLine(t);
    if (accounts.isNotEmpty) return accounts;
    return 'Note';
  }

  String? _buildSubtitle(Transaction t) {
    final parts = <String>[];
    if (t.description != null || t.category != null) {
      final accounts = _buildAccountLine(t);
      if (accounts.isNotEmpty) parts.add(accounts);
    }
    if (t.description != null && t.category != null) parts.add(t.category!);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  Color _amountColor(Transaction t, BuildContext context) {
    if (t.amount == null) return Theme.of(context).colorScheme.onSurface;
    if (t.fromAccount != null && t.toAccount == null) return Colors.red.shade700;
    if (t.toAccount != null && t.fromAccount == null) return Colors.green.shade700;
    return Theme.of(context).colorScheme.secondary;
  }

  String _amountPrefix(Transaction t) {
    if (t.amount == null) return '';
    if (t.fromAccount != null && t.toAccount == null) return '-';
    if (t.toAccount != null && t.fromAccount == null) return '+';
    return '⇄ ';
  }

  IconData _leadingIcon(Transaction t) {
    if (t.fromAccount != null && t.toAccount != null) return Icons.swap_horiz;
    if (t.fromAccount != null) return Icons.arrow_upward;
    if (t.toAccount != null) return Icons.arrow_downward;
    return Icons.notes;
  }

  Color _leadingColor(Transaction t, BuildContext context) {
    if (t.fromAccount != null && t.toAccount != null) {
      return Theme.of(context).colorScheme.secondary;
    }
    if (t.fromAccount != null) return Colors.red.shade700;
    if (t.toAccount != null) return Colors.green.shade700;
    return Theme.of(context).colorScheme.outline;
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete transaction',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text(
          'Account balances will be reversed.',
        ),
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
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _delete(BuildContext context) {
    final t = transaction;
    // Reverse balance effects
    if (t.amount != null) {
      if (t.fromAccount != null) t.fromAccount!.balance += t.amount!;
      if (t.toAccount != null) t.toAccount!.balance -= t.amount!;
    }
    data.transactions.remove(t);
    onRefresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final subtitle = _buildSubtitle(t);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            _leadingColor(t, context).withValues(alpha: 0.12),
        child: Icon(
          _leadingIcon(t),
          color: _leadingColor(t, context),
          size: 20,
        ),
      ),
      title: Text(
        _buildTitle(t),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          : null,
      trailing: t.amount != null
          ? Text(
              '${_amountPrefix(t)}${_formatAmount(t.amount!)}',
              style: TextStyle(
                color: _amountColor(t, context),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            )
          : null,
      onTap: () => _showOptions(context),
    );
  }
}
