import 'package:platrare/models/account.dart';
import 'package:platrare/models/enums.dart';

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