// lib/screens/plan/plan_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/widgets/day_group.dart';
import 'new_planned_transaction_screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  PlanScreenState createState() => PlanScreenState();
}

class PlanScreenState extends State<PlanScreen> {
  final List<TransactionItem> _master     = List.from(dummyPlanned);
  final List<TransactionItem> _occurrences = [];
  late DateTime _windowStart, _windowEnd;
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _master.sort((a, b) => a.date.compareTo(b.date));
    final today = DateTime.now();
    _windowStart = today.subtract(const Duration(days: 30));
    _windowEnd   = today.add(const Duration(days: 90));
    _loadOccurrences(upTo: _windowEnd);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isLoadingMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => NewPlannedTransactionScreen(existing: existing),
      ),
    );
    if (result is TransactionItem) {
      setState(() {
        final i = _master.indexWhere((r) => r.id == existing.id);
        _master[i] = result;
        final gi = dummyPlanned.indexWhere((t) => t.id == existing.id);
        if (gi != -1) dummyPlanned[gi] = result;
        _master.sort((a, b) => a.date.compareTo(b.date));
        _resetOccurrences();
      });
    } else if (result == 'deleteRule') {
      setState(() {
        _master.removeWhere((r) => r.id == existing.id);
        dummyPlanned.removeWhere((t) => t.id == existing.id);
        _resetOccurrences();
      });
    } else if (result == 'deleteOccurrence') {
      setState(() {
        final i = _master.indexWhere((r) => r.id == existing.id);
        final rule = _master[i];
        final updated = rule.copyWith(
          exceptions: [...rule.exceptions, existing.date],
        );
        _master[i] = updated;
        dummyPlanned[i] = updated;
        _resetOccurrences();
      });
    } else if (result == 'deleteFuture') {
      setState(() {
        final i = _master.indexWhere((r) => r.id == existing.id);
        final rule = _master[i];
        final updated = rule.copyWith(recurrenceEnd: existing.date);
        _master[i] = updated;
        dummyPlanned[i] = updated;
        _resetOccurrences();
      });
    }
  }

  /// Mutate a single account’s balance.
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

  /// Immediately apply a realized tx to your real balances.
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

  Future<void> _realize(TransactionItem occ) async {
    final today = DateTime.now();
    final realizedDate = occ.date.isAfter(today)
        ? DateTime(today.year, today.month, today.day)
        : occ.date;

    // 1) Build the realized transaction and apply it immediately:
    final realizedTx = occ.copyWith(date: realizedDate);
    _applyImmediate(realizedTx);

    // 2) Add to the realized list:
    dummyRealized.add(realizedTx);

    // 3) Remove this occurrence from the plan:
    setState(() {
      final i = _master.indexWhere((r) => r.id == occ.id);
      final rule = _master[i];
      if (rule.recurrence == Recurrence.none) {
        _master.removeAt(i);
        dummyPlanned.removeWhere((t) => t.id == occ.id);
      } else {
        final updated = rule.copyWith(
          exceptions: [...rule.exceptions, occ.date],
        );
        _master[i] = updated;
        dummyPlanned[i] = updated;
      }
      _resetOccurrences();
    });
  }

  Iterable<TransactionItem> occurrencesBetween(
      TransactionItem tx, DateTime start, DateTime end) sync* {
    if (tx.recurrence == Recurrence.none) {
      if (!tx.date.isBefore(start) && tx.date.isBefore(end)) yield tx;
      return;
    }
    final limit = tx.recurrenceEnd != null && tx.recurrenceEnd!.isBefore(end)
        ? tx.recurrenceEnd!
        : end;
    var current = DateTime(tx.date.year, tx.date.month, tx.date.day);
    while (current.isBefore(limit)) {
      if (!current.isBefore(start) && !tx.exceptions.contains(current)) {
        yield tx.copyWith(date: current);
      }
      switch (tx.recurrence) {
        case Recurrence.daily:
          current = current.add(const Duration(days: 1));
          break;
        case Recurrence.weekly:
          current = current.add(const Duration(days: 7));
          break;
        case Recurrence.monthly:
          current = DateTime(
              current.year, current.month + 1, current.day);
          break;
        case Recurrence.yearly:
          current = DateTime(
              current.year + 1, current.month, current.day);
          break;
        default:
          return;
      }
    }
  }

  void _resetOccurrences() {
    _occurrences.clear();
    _windowEnd = DateTime.now().add(const Duration(days: 90));
    _loadOccurrences(upTo: _windowEnd);
  }

  void _loadOccurrences({required DateTime upTo}) {
    for (var rule in _master) {
      _occurrences.addAll(
        occurrencesBetween(rule, _windowStart, upTo),
      );
    }
    _occurrences.sort((a, b) => a.date.compareTo(b.date));
  }

  void _loadMore() {
    _isLoadingMore = true;
    final nextEnd = _windowEnd.add(const Duration(days: 90));
    for (var rule in _master) {
      _occurrences.addAll(
        occurrencesBetween(rule, _windowEnd, nextEnd),
      );
    }
    _windowEnd = nextEnd;
    _occurrences.sort((a, b) => a.date.compareTo(b.date));
    setState(() {});
    _isLoadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _occurrences) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Plan')),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          for (var entry in grouped.entries)
            DayGroup(
              day: entry.key,
              items: entry.value,
              allOccurrences: _occurrences,
              onEdit: _edit,
              onRealize: _realize,
            ),
          if (_isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push<TransactionItem?>(
            context,
            MaterialPageRoute(
              builder: (_) => NewPlannedTransactionScreen(existing: null),
            ),
          );
          if (tx is TransactionItem) {
            setState(() {
              dummyPlanned.add(tx);
              _master.add(tx);
              _master.sort((a, b) => a.date.compareTo(b.date));
              _resetOccurrences();
            });
          }
        },
      ),
    );
  }
}
