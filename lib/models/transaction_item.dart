import 'package:platrare/models/account.dart';

enum TransactionType { expense, income, transfer, partnerTransfer }

class TransactionItem {
  final String title;
  final DateTime date;
  final TransactionType type;
  final Account? fromAccount;
  final Account toAccount;
  final double amount;
  TransactionItem({
    required this.title,
    required this.date,
    required this.type,
    this.fromAccount,
    required this.toAccount,
    required this.amount,
  });
}