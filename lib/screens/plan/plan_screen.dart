import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/enums.dart';
import 'package:platrare/models/transaction_item.dart';
import 'new_planned_transaction_screen.dart';
import 'package:platrare/widgets/summary_card.dart';
import 'package:platrare/widgets/account_balance_card.dart';
import 'package:platrare/utils/balance_calculator.dart';



class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
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
    // 1) Group by day
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _planned) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Plan')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          for (var entry in grouped.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${entry.key.day}/${entry.key.month}/${entry.key.year}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Planned transactions
                  ...entry.value.map((tx) {
                    // 1) Decide display title
                    final defaultKey = tx.type.toString().split('.').last;
                    final isDefault = tx.title == defaultKey;
                    String displayTitle;

                    if (!isDefault) {
                      displayTitle = tx.title;
                    } else {
                      switch (tx.type) {
                        case TransactionType.partnerTransfer:
                          final f = tx.fromAccount!;
                          final t = tx.toAccount;
                          if (f.type == AccountType.vendor &&
                              t.type == AccountType.personal) {
                            displayTitle = 'Refund';
                          } else if (f.type == AccountType.personal &&
                              t.type == AccountType.vendor) {
                            displayTitle = 'Expense';
                          } else if (f.type == AccountType.personal &&
                              t.type == AccountType.incomeSource) {
                            displayTitle = 'Return';      // ← new
                          } else if (f.type == AccountType.incomeSource &&
                              t.type == AccountType.personal) {
                            displayTitle = 'Income';
                          } else if (f.type == AccountType.partner &&
                              t.type == AccountType.personal) {
                            displayTitle = 'Invoice';
                          } else if (f.type == AccountType.personal &&
                              t.type == AccountType.partner) {
                            displayTitle = 'Bill';
                          } else {
                            displayTitle = 'Transfer';
                          }
                          break;
                        case TransactionType.transfer:
                          displayTitle = 'Transfer';
                          break;
                        case TransactionType.expense:
                          displayTitle = 'Expense';
                          break;
                        case TransactionType.income:
                          displayTitle = 'Income';
                          break;
                      }
                    }

                    // 2) Decide subtitle
                    String displaySubtitle;
                    if (tx.type == TransactionType.partnerTransfer ||
                        tx.type == TransactionType.transfer) {
                      displaySubtitle =
                          'From ${tx.fromAccount!.name} to ${tx.toAccount.name}';
                    } else {
                      displaySubtitle = tx.toAccount.name;
                    }

                    // 3) Pick the icon + color
                    IconData iconData;
                    Color iconColor;
                    switch (tx.type) {
                      case TransactionType.expense:
                        iconData = Icons.arrow_downward;
                        iconColor = Colors.red;
                        break;
                      case TransactionType.income:
                        iconData = Icons.arrow_upward;
                        iconColor = Colors.green;
                        break;
                      case TransactionType.transfer:
                        iconData = Icons.swap_horiz;
                        iconColor = Colors.blue;
                        break;
                      case TransactionType.partnerTransfer:
                        final f = tx.fromAccount!;
                        final t = tx.toAccount;
                        if ((f.type == AccountType.vendor &&
                                t.type == AccountType.personal) ||
                            (f.type == AccountType.partner &&
                                t.type == AccountType.personal) ||
                            (f.type == AccountType.incomeSource &&
                                t.type == AccountType.personal)) {
                          iconData = Icons.arrow_upward;
                          iconColor = Colors.green;
                        } else {
                          iconData = Icons.arrow_downward;
                          iconColor = Colors.red;
                        }
                        break;
                    }

                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Icon(iconData, color: iconColor),
                        title: Text(displayTitle),
                        subtitle: Text(displaySubtitle),
                        trailing: Text(tx.amount.toStringAsFixed(2)),
                        onTap: () => _edit(tx),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 8),

                  // Horizontal projected balances (shorter ribbon)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SummaryCard(label: 'Available', value: _projectedAvailable(entry.key)),
                        SizedBox(width: 20),
                        ..._projectedPersonalBalances(entry.key).map(
                          (a) => AccountBalanceCard(account: a),
                        ),
                        SummaryCard(label: 'Liquid', value: _projectedLiquid(entry.key)),
                        SizedBox(width: 20),
                        ..._projectedPartnerBalances(entry.key).map(
                          (a) => AccountBalanceCard(account: a),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push(
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
              _planned.sort((a, b) => a.date.compareTo(b.date));
            });
          }
        },
      ),
    );
  }

  double _projectedAvailable(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _planned, day);
    return proj.entries
        .where((e) =>
            e.key.type == AccountType.personal && e.key.includeInBalance)
        .fold(0.0, (s, e) => s + e.value);
  }

  double _projectedLiquid(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _planned, day);
    return proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold(0.0, (s, e) => s + e.value);
  }

  List<Account> _projectedPersonalBalances(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _planned, day);
    return dummyAccounts
        .where((a) => a.type == AccountType.personal)
        .map((a) => Account(
              name: a.name,
              type: a.type,
              balance: proj[a]!,
              includeInBalance: a.includeInBalance,
            ))
        .toList();
  }

  List<Account> _projectedPartnerBalances(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _planned, day);
    return dummyAccounts
        .where((a) => a.type == AccountType.partner)
        .map((a) => Account(
              name: a.name,
              type: a.type,
              balance: proj[a]!,
              includeInBalance: a.includeInBalance,
            ))
        .toList();
  }
}