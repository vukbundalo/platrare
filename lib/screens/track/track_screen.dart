import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/screens/track/new_track_transaction_screen.dart';
import 'package:platrare/widgets/account_balance_card.dart';
import 'package:platrare/widgets/transaction_accounts_summary_card.dart';
import 'package:platrare/utils/balance_calculator.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({Key? key}) : super(key: key);
  @override
  TrackScreenState createState() => TrackScreenState();
}

class TrackScreenState extends State<TrackScreen> {
  final List<TransactionItem> _realized = List.from(dummyRealized);

  @override
  void initState() {
    super.initState();
    // show newest first
    _realized.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => NewTrackTransactionScreen(existing: existing),
      ),
    );

    if (result is TransactionItem) {
      // user edited the transaction
      setState(() {
        final i = _realized.indexWhere((t) => t.id == existing.id);
        _realized[i] = result;
        final gi = dummyRealized.indexWhere((t) => t.id == existing.id);
        if (gi != -1) dummyRealized[gi] = result;
        _realized.sort((a, b) => b.date.compareTo(a.date));
      });
    } else if (result == 'delete') {
      // user deleted → undo its effect then remove it
      setState(() {
        _rollback(existing);
        _realized.removeWhere((t) => t.id == existing.id);
        dummyRealized.removeWhere((t) => t.id == existing.id);
      });
    }
  }

  /// Helper to mutate dummyAccounts
  void _mutate(Account acct, double delta) {
    final idx = dummyAccounts.indexWhere((a) => a.name == acct.name);
    if (idx == -1) return;
    final old = dummyAccounts[idx];
    dummyAccounts[idx] = Account(
      name: old.name,
      type: old.type,
      balance: old.balance + delta,
      includeInBalance: old.includeInBalance,
    );
  }

  /// Undo a realized tx’s effect on balances
  void _rollback(TransactionItem tx) {
    switch (tx.type) {
      case TransactionType.expense:
      case TransactionType.income:
        // remove its amount from the toAccount
        _mutate(tx.toAccount, -tx.amount);
        break;

      case TransactionType.transfer:
      case TransactionType.partnerTransfer:
        if (tx.fromAccount != null) {
          _mutate(tx.fromAccount!, tx.amount);
        }
        _mutate(tx.toAccount, -tx.amount);
        break;
    }
  }

  /// When adding a new track transaction, apply its effect immediately
  void _applyImmediate(TransactionItem tx) {
    switch (tx.type) {
      case TransactionType.expense:
      case TransactionType.income:
        _mutate(tx.toAccount, tx.amount);
        break;
      case TransactionType.transfer:
      case TransactionType.partnerTransfer:
        if (tx.fromAccount != null) _mutate(tx.fromAccount!, -tx.amount);
        _mutate(tx.toAccount, tx.amount);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // group by calendar‐day
    final grouped = <DateTime, List<TransactionItem>>{};
    for (var tx in _realized) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Track')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var entry in grouped.entries) ...[
            // Day header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '${entry.key.day}/${entry.key.month}/${entry.key.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // each realized transaction
            ...entry.value.map(
              (tx) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: tx.displayIcon,
                  title: Text(tx.displayTitle),
                  subtitle: Text(tx.displaySubtitle),
                  trailing: Text(tx.amount.toStringAsFixed(2)),
                  onTap: () => _edit(tx),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // “Actual” balances ribbon as of that day
            _buildBalancesRibbon(entry.key),
            const SizedBox(height: 100),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push<TransactionItem?>(
            context,
            MaterialPageRoute(
              builder: (_) => NewTrackTransactionScreen(existing: null),
            ),
          );
          if (tx is TransactionItem) {
            setState(() {
              dummyRealized.add(tx);
              _realized.insert(0, tx);
              _applyImmediate(tx); // balances update
            });
          }
        },
      ),
    );
  }

  Widget _buildBalancesRibbon(DateTime day) {
    final proj = computeProjectedBalancesForTrack(
      dummyAccounts,
      _realized,
      day,
    );

    final avail = proj.entries
        .where(
          (e) => e.key.type == AccountType.personal && e.key.includeInBalance,
        )
        .fold(0.0, (s, e) => s + e.value);

    final liquid = proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold(0.0, (s, e) => s + e.value);

    final personalBalances =
        dummyAccounts
            .where((a) => a.type == AccountType.personal)
            .map(
              (a) => Account(
                name: a.name,
                type: a.type,
                balance: proj[a]!,
                includeInBalance: a.includeInBalance,
              ),
            )
            .toList();

    final partnerBalances =
        dummyAccounts
            .where((a) => a.type == AccountType.partner)
            .map(
              (a) => Account(
                name: a.name,
                type: a.type,
                balance: proj[a]!,
                includeInBalance: a.includeInBalance,
              ),
            )
            .toList();

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          TransactionAccountsSummaryCard(label: 'Available', value: avail),
          const SizedBox(width: 20),
          ...personalBalances.map((a) => AccountBalanceCard(account: a)),
          TransactionAccountsSummaryCard(label: 'Liquid', value: liquid),
          const SizedBox(width: 20),
          ...partnerBalances.map((a) => AccountBalanceCard(account: a)),
        ],
      ),
    );
  }
}
