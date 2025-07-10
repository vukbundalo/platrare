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
  const TrackScreen({super.key});

  @override
  TrackScreenState createState() => TrackScreenState();
}

class TrackScreenState extends State<TrackScreen> {
  final List<TransactionItem> _realized = List.from(dummyRealized);

  @override
  void initState() {
    super.initState();
    _realized.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewTrackTransactionScreen(existing: existing),
      ),
    );
    if (result is TransactionItem) {
      setState(() {
        // Replace in both local & global lists
        final idx = _realized.indexOf(existing);
        _realized[idx] = result;
        final gi = dummyRealized.indexWhere((t) => identical(t, existing));
        if (gi != -1) dummyRealized[gi] = result;
        _realized.sort((a, b) => b.date.compareTo(a.date));
      });
    } else if (result == 'delete') {
      setState(() {
        _realized.remove(existing);
        dummyRealized.remove(existing);
        // NOTE: we do NOT automatically roll back the balances here.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _realized) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Track')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          for (var entry in grouped.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${entry.key.day}/${entry.key.month}/${entry.key.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Each realized tx
                  ...entry.value.map((tx) {
                    // title logic (same as PlanScreen)
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
                            displayTitle = 'Return';
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

                    // subtitle logic
                    final displaySubtitle =
                        (tx.type == TransactionType.partnerTransfer ||
                                tx.type == TransactionType.transfer)
                            ? 'From ${tx.fromAccount!.name} to ${tx.toAccount.name}'
                            : tx.toAccount.name;

                    // icon logic
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
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Icon(iconData, color: iconColor),
                        title: Text(displayTitle),
                        subtitle: Text(displaySubtitle),
                        trailing: Text(tx.amount.toStringAsFixed(2)),
                        onTap: () => _edit(tx),
                      ),
                    );
                  }),

                  SizedBox(height: 8),

                  // Horizontal “actual” balances
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TransactionAccountsSummaryCard(
                          label: 'Available',
                          value: _actualAvailable(entry.key),
                        ),
                        SizedBox(width: 20),
                        ..._actualPersonalBalances(
                          entry.key,
                        ).map((a) => AccountBalanceCard(account: a)),
                        TransactionAccountsSummaryCard(
                          label: 'Liquid',
                          value: _actualLiquid(entry.key),
                        ),
                        SizedBox(width: 20),
                        ..._actualPartnerBalances(
                          entry.key,
                        ).map((a) => AccountBalanceCard(account: a)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
              _realized.add(tx);
            });
          }
        },
      ),
    );
  }

  double _actualAvailable(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _realized, day);
    return proj.entries
        .where(
          (e) => e.key.type == AccountType.personal && e.key.includeInBalance,
        )
        .fold(0.0, (s, e) => s + e.value);
  }

  double _actualLiquid(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _realized, day);
    return proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold(0.0, (s, e) => s + e.value);
  }

  List<Account> _actualPersonalBalances(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _realized, day);
    return dummyAccounts
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
  }

  List<Account> _actualPartnerBalances(DateTime day) {
    final proj = computeProjectedBalances(dummyAccounts, _realized, day);
    return dummyAccounts
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
  }
}
