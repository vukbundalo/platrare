import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';

Map<Account, double> computeProjectedBalances(
  List<Account> accounts,
  List<TransactionItem> planned,
  DateTime upToDate,
) {
  // 1) Start from “today” balances
  final proj = <Account, double>{for (var a in accounts) a: a.balance};

  // 2) Apply **all** planned tx whose date ≤ upToDate
  for (var tx in planned) {
    final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
    if (day.isAfter(upToDate)) continue;

    switch (tx.type) {
      case TransactionType.transfer:
      case TransactionType.partnerTransfer:
        // debit the `from`
        if (tx.fromAccount != null) {
          proj[tx.fromAccount!] = (proj[tx.fromAccount!] ?? 0) - tx.amount;
        }
        // credit the `to`
        proj[tx.toAccount] = (proj[tx.toAccount] ?? 0) + tx.amount;
        break;

      case TransactionType.expense:
      case TransactionType.income:
        // single‐account adjustment
        proj[tx.toAccount] = (proj[tx.toAccount] ?? 0) + tx.amount;
        break;
    }
  }

  return proj;
}