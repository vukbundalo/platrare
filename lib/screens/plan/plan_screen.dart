// lib/screens/plan/plan_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/transaction_item.dart';
import 'new_planned_transaction_screen.dart';
import 'package:platrare/widgets/day_group.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  PlanScreenState createState() => PlanScreenState();
}

class PlanScreenState extends State<PlanScreen> {
  final List<TransactionItem> _master = List.from(dummyPlanned);
  final List<TransactionItem> _occurrences = [];
  late DateTime _windowStart, _windowEnd;
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _master.sort((a, b) => a.date.compareTo(b.date));

    final today = DateTime.now();
    _windowStart = today.subtract(Duration(days: 30));
    _windowEnd = today.add(Duration(days: 90));

    _loadOccurrences(upTo: _windowEnd);

    _scrollController.addListener(() {
      if (!_isLoadingMore &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            NewPlannedTransactionScreen(existing: existing),
      ),
    );

    if (result is TransactionItem) {
      // edited the rule itself
      setState(() {
        final i = _master.indexWhere((r) => r.id == existing.id);
        _master[i] = result;
        final gi = dummyPlanned.indexWhere((t) => t.id == existing.id);
        if (gi != -1) dummyPlanned[gi] = result;
        _master.sort((a, b) => a.date.compareTo(b.date));
        _resetOccurrences();
      });
    } else if (result == 'deleteRule') {
      // remove the entire rule
      setState(() {
        _master.removeWhere((r) => r.id == existing.id);
        dummyPlanned.removeWhere((t) => t.id == existing.id);
        _resetOccurrences();
      });
    } else if (result == 'deleteOccurrence') {
      // skip just this one date
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
      // end recurrence at this date
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

  Iterable<TransactionItem> occurrencesBetween(
      TransactionItem tx, DateTime start, DateTime end) sync* {
    // one‐off
    if (tx.recurrence == Recurrence.none) {
      if (!tx.date.isBefore(start) && tx.date.isBefore(end)) yield tx;
      return;
    }

    final limit = tx.recurrenceEnd != null && tx.recurrenceEnd!.isBefore(end)
        ? tx.recurrenceEnd!
        : end;
    var current = DateTime(tx.date.year, tx.date.month, tx.date.day);
    while (current.isBefore(limit)) {
      if (!current.isBefore(start) &&
          !tx.exceptions.contains(current)) {
        yield tx.copyWith(date: current);
      }
      switch (tx.recurrence) {
        case Recurrence.daily:
          current = current.add(Duration(days: 1));
          break;
        case Recurrence.weekly:
          current = current.add(Duration(days: 7));
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
    _windowEnd = DateTime.now().add(Duration(days: 90));
    _loadOccurrences(upTo: _windowEnd);
  }

  void _loadOccurrences({required DateTime upTo}) {
    for (var rule in _master) {
      _occurrences.addAll(
          occurrencesBetween(rule, _windowStart, upTo));
    }
    _occurrences.sort((a, b) => a.date.compareTo(b.date));
  }

  void _loadMore() {
    _isLoadingMore = true;
    final nextEnd = _windowEnd.add(Duration(days: 90));
    for (var rule in _master) {
      _occurrences.addAll(
          occurrencesBetween(rule, _windowEnd, nextEnd));
    }
    _windowEnd = nextEnd;
    _occurrences.sort((a, b) => a.date.compareTo(b.date));
    setState(() {});
    _isLoadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <DateTime, List<TransactionItem>>{};
    for (var tx in _occurrences) {
      final d = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[d] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Plan')),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          for (var e in grouped.entries)
            DayGroup(day: e.key, items: e.value, onEdit: _edit, allOccurrences: _occurrences),
          if (_isLoadingMore)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                builder: (_) =>
                    NewPlannedTransactionScreen(existing: null)),
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
