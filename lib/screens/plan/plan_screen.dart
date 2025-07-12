// lib/screens/plan/plan_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/widgets/day_group.dart';
import 'new_planned_transaction_screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  PlanScreenState createState() => PlanScreenState();
}

class PlanScreenState extends State<PlanScreen> {
  // all planned items, one-offs only
  final List<TransactionItem> _planned = List.from(dummyPlanned);

  @override
  void initState() {
    super.initState();
    _sortPlanned();
  }

  void _sortPlanned() {
    _planned.sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => NewPlannedTransactionScreen(existing: existing),
      ),
    );

    if (result is TransactionItem) {
      // update or replace
      setState(() {
        final idx = _planned.indexWhere((t) => t.id == existing.id);
        if (idx != -1) {
          _planned[idx] = result;
          // also update global
          final gi = dummyPlanned.indexWhere((t) => t.id == existing.id);
          if (gi != -1) dummyPlanned[gi] = result;
        }
        _sortPlanned();
      });
    } else if (result == 'deleteRule') {
      // delete this one-off
      setState(() {
        _planned.removeWhere((t) => t.id == existing.id);
        dummyPlanned.removeWhere((t) => t.id == existing.id);
      });
    }
  }

  /// Helper to mutate dummyAccounts immediately
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

/// Apply a realized tx’s effect to your real balances (and its category).
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

  // **also** adjust the category, if any
  if (tx.category != null) {
    _mutate(tx.category!, tx.amount);
  }
}

  Future<void> _realize(TransactionItem occ) async {
    // cap future dates at today
    final today = DateTime.now();
    final realizedDate = occ.date.isAfter(today)
        ? DateTime(today.year, today.month, today.day)
        : occ.date;

    // build & apply
    final realizedTx = occ.copyWith(date: realizedDate);
    _applyImmediate(realizedTx);

    // add to realized
    dummyRealized.add(realizedTx);

    // remove from planned
    setState(() {
      _planned.removeWhere((t) => t.id == occ.id);
      dummyPlanned.removeWhere((t) => t.id == occ.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // group by calendar day
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _planned) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var entry in grouped.entries)
            DayGroup(
              day: entry.key,
              items: entry.value,
              onEdit: _edit,
              onRealize: _realize,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push<TransactionItem?>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  NewPlannedTransactionScreen(existing: null),
            ),
          );
          if (tx is TransactionItem) {
            setState(() {
              dummyPlanned.add(tx);
              _planned.add(tx);
              _sortPlanned();
            });
          }
        },
      ),
    );
  }
}
