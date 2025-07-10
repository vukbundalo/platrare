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
  final List<TransactionItem> _planned = List.from(dummyPlanned);

  @override
  void initState() {
    super.initState();
    _planned.sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewPlannedTransactionScreen(existing: existing),
      ),
    );
    if (result is TransactionItem) {
      setState(() {
        final idx = _planned.indexOf(existing);
        _planned[idx] = result;
        final gi = dummyPlanned.indexWhere((t) => identical(t, existing));
        if (gi != -1) dummyPlanned[gi] = result;
        _planned.sort((a, b) => a.date.compareTo(b.date));
      });
    } else if (result == 'delete') {
      setState(() {
        _planned.remove(existing);
        dummyPlanned.remove(existing);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // group by calendar-day
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _planned) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var entry in grouped.entries)
            DayGroup(
              day: entry.key,
              items: entry.value,
              onEdit: _edit,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
              _planned.add(tx);
              _planned.sort((a, b) => a.date.compareTo(b.date));
            });
          }
        },
      ),
    );
  }
}
