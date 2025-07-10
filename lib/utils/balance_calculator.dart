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

Map<Account, double> computeProjectedBalancesForTrack(
  List<Account>           accounts,
  List<TransactionItem>   realized,
  DateTime                asOf,
) {
  // Start from the *current* balances in dummyAccounts.
  final proj = <Account,double>{for (var a in accounts) a: a.balance};

  for (var tx in realized) {
    final txDay = DateTime(tx.date.year, tx.date.month, tx.date.day);
    if (txDay.isAfter(asOf)) {
      switch (tx.type) {
        case TransactionType.expense:
        case TransactionType.income:
          // remove the effect on the 'to' account:
          proj[tx.toAccount] = proj[tx.toAccount]! - tx.amount;
          break;

        case TransactionType.transfer:
        case TransactionType.partnerTransfer:
          // undo the “from” side:
          if (tx.fromAccount != null) {
            final acct = tx.fromAccount!;
            // if it was an incomeSource, we had previously added → undo by subtracting;
            // otherwise we had subtracted → undo by adding.
            final undoDelta =
              acct.type == AccountType.incomeSource
                ? -tx.amount
                : tx.amount;
            proj[acct] = proj[acct]! + undoDelta;
          }
          // undo the credit on the `to` side:
          proj[tx.toAccount] = proj[tx.toAccount]! - tx.amount;
          break;
      }
    }
  }

  return proj;
}