import 'package:uuid/uuid.dart';
import 'account.dart';

class PlannedTransaction {
  final String id;
  final double? amount;
  final Account? fromAccount;
  final Account? toAccount;
  final String? category;
  final String? description;
  final DateTime date;

  PlannedTransaction({
    String? id,
    this.amount,
    this.fromAccount,
    this.toAccount,
    this.category,
    this.description,
    required this.date,
  }) : id = id ?? const Uuid().v4();
}
