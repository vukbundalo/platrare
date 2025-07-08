import 'package:platrare/models/enums.dart';
import 'package:platrare/models/transaction_item.dart';
import 'dummy_accounts.dart';

List<TransactionItem> dummyTransactions = [
  TransactionItem(
    title: 'Grocery Shopping',
    date: DateTime.now().subtract(Duration(days: 1)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts[0],
    amount: -45.0,
  ),
  TransactionItem(
    title: 'Salary',
    date: DateTime.now().subtract(Duration(days: 2)),
    type: TransactionType.income,
    fromAccount: null,
    toAccount: dummyAccounts[1],
    amount: 1000.0,
  ),
];