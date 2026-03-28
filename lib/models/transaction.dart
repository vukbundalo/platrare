import 'package:uuid/uuid.dart';
import 'account.dart';

class Transaction {
  final String id;
  final double? amount;
  final Account? fromAccount;
  final Account? toAccount;
  final String? category;
  final String? description;
  final DateTime date;

  Transaction({
    String? id,
    this.amount,
    this.fromAccount,
    this.toAccount,
    this.category,
    this.description,
    DateTime? date,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();
}
