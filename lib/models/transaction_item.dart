// lib/models/transaction_item.dart

import 'package:platrare/models/account.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { expense, income, transfer, partnerTransfer }
enum Recurrence { none, daily, weekly, monthly, yearly }

extension RecurrencePresentation on Recurrence {
  String get label {
    switch (this) {
      case Recurrence.none:
        return 'Never';
      case Recurrence.daily:
        return 'Daily';
      case Recurrence.weekly:
        return 'Weekly';
      case Recurrence.monthly:
        return 'Monthly';
      case Recurrence.yearly:
        return 'Yearly';
    }
  }
}

class TransactionItem {
  final String id;
  final String title;
  final DateTime date;
  final TransactionType type;
  final Account? fromAccount;
  final Account toAccount;
  final double amount;

  /// NEW: how often it repeats
  final Recurrence recurrence;

  /// NEW: never generate past this date
  final DateTime? recurrenceEnd;

  /// NEW: dates to skip
  final List<DateTime> exceptions;

  TransactionItem({
    String? id,
    required this.title,
    required this.date,
    required this.type,
    this.fromAccount,
    required this.toAccount,
    required this.amount,
    this.recurrence = Recurrence.none,
    this.recurrenceEnd,
    List<DateTime>? exceptions,
  })  : id = id ?? const Uuid().v4(),
        exceptions = exceptions ?? const [];

  TransactionItem copyWith({
    String? title,
    DateTime? date,
    TransactionType? type,
    Account? fromAccount,
    Account? toAccount,
    double? amount,
    Recurrence? recurrence,
    DateTime? recurrenceEnd,
    List<DateTime>? exceptions,
  }) {
    return TransactionItem(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      amount: amount ?? this.amount,
      recurrence: recurrence ?? this.recurrence,
      recurrenceEnd: recurrenceEnd ?? this.recurrenceEnd,
      exceptions: exceptions ?? this.exceptions,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TransactionItem && other.id == id;
  @override
  int get hashCode => id.hashCode;
}
