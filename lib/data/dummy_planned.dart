import 'package:platrare/models/transaction_item.dart';
import 'dummy_accounts.dart';

List<TransactionItem> dummyPlanned = [
  TransactionItem(
    title: 'Future Gym Fee',
    date: DateTime.now().add(Duration(days: 3)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts.firstWhere((a) => a.name == 'Cash'),
    amount: -30.0,
  ),
  TransactionItem(
    title: 'Future Gym Fee',
    date: DateTime.now().add(Duration(days: 4)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts.firstWhere((a) => a.name == 'Cash'),
    amount: -30.0,
  ),
  TransactionItem(
    title: 'Future Gym Fee',
    date: DateTime.now().add(Duration(days: 5)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts.firstWhere((a) => a.name == 'Cash'),
    amount: -30.0,
  ),
  TransactionItem(
    title: 'Future Gym Fee',
    date: DateTime.now().add(Duration(days: 6)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts.firstWhere((a) => a.name == 'Cash'),
    amount: -30.0,
  ),
  TransactionItem(
    title: 'Future Gym Fee',
    date: DateTime.now().add(Duration(days: 7)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts.firstWhere((a) => a.name == 'Cash'),
    amount: -30.0,
  ),
];
