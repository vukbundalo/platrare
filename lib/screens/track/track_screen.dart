// lib/screens/track/track_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/screens/track/new_track_transaction_screen.dart';
import 'package:platrare/widgets/track_day_group.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});
  @override
  TrackScreenState createState() => TrackScreenState();
}

class TrackScreenState extends State<TrackScreen> {
  final List<TransactionItem> _realized = List.from(dummyRealized);

  @override
  void initState() {
    super.initState();
    _sortRealized();
  }

  void _sortRealized() {
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
      setState(() {
        // 1) Undo the old transaction (including its category)
        _rollback(existing);

        // 2) Replace in both lists
        final i = _realized.indexWhere((t) => t.id == existing.id);
        _realized[i] = result;
        final gi = dummyRealized.indexWhere((t) => t.id == existing.id);
        if (gi != -1) dummyRealized[gi] = result;

        // 3) Apply the new transaction
        _applyImmediate(result);

        // 4) Re‐sort so newest shows first
        _sortRealized();
      });
    } else if (result == 'delete') {
      setState(() {
        _rollback(existing);
        _realized.removeWhere((t) => t.id == existing.id);
        dummyRealized.removeWhere((t) => t.id == existing.id);
      });
    }
  }

  void _mutate(Account acct, double delta) {
    final idx = dummyAccounts.indexWhere((a) => a.name == acct.name);
    if (idx == -1) return;
    final old = dummyAccounts[idx];
    dummyAccounts[idx] = old.copyWith(balance: old.balance + delta);
  }

  void _rollback(TransactionItem tx) {
    // undo main accounts
    switch (tx.type) {
      case TransactionType.expense:
      case TransactionType.income:
        _mutate(tx.toAccount, -tx.amount);
        break;
      case TransactionType.transfer:
      case TransactionType.partnerTransfer:
        if (tx.fromAccount != null) _mutate(tx.fromAccount!, tx.amount);
        _mutate(tx.toAccount, -tx.amount);
        break;
    }
    // undo category if any
    if (tx.category != null) {
      _mutate(tx.category!, -tx.amount);
    }
  }

  void _applyImmediate(TransactionItem tx) {
    // apply main accounts
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
    // apply category if any
    if (tx.category != null) {
      _mutate(tx.category!, tx.amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    _sortRealized();

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
          for (var entry in grouped.entries)
            TrackDayGroup(
              day: entry.key,
              items: entry.value,
              onEdit: (tx) async => _edit(tx),
              onReturn:
                  (tx) => setState(() {
                    _rollback(tx);
                    _realized.removeWhere((t) => t.id == tx.id);
                    dummyRealized.removeWhere((t) => t.id == tx.id);
                    dummyPlanned.add(tx.copyWith());
                  }),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'track_fab', // no hero at all

        child: const Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push<TransactionItem?>(
            context,
            MaterialPageRoute(
              builder: (_) => const NewTrackTransactionScreen(existing: null),
            ),
          );
          if (tx is TransactionItem) {
            setState(() {
              dummyRealized.add(tx);
              _realized.insert(0, tx);
              _applyImmediate(tx);
            });
          }
        },
      ),
    );
  }

}
