// lib/models/transaction_item.dart

import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';
import 'package:uuid/uuid.dart';

/// What kind of transaction this is.
enum TransactionType { expense, income, transfer, partnerTransfer }

/// How often a planned transaction repeats.



/// A single financial transaction, one-off or recurring.
class TransactionItem {
  final String        id;
  final String        title;
  final DateTime      date;
  final TransactionType type;
  final Account?      fromAccount;
  final Account       toAccount;
  final double        amount;
  final DateTime?     recurrenceEnd;
  final List<DateTime> exceptions;
  final Account?      category;
  // final String?       note;

  TransactionItem({
    String?           id,
    required this.title,
    required this.date,
    required this.type,
    this.fromAccount,
    required this.toAccount,
    required this.amount,
    this.recurrenceEnd,
    List<DateTime>?   exceptions,
    this.category,
    // this.note,
  })  : id         = id ?? const Uuid().v4(),
        exceptions = exceptions ?? const [];

  TransactionItem copyWith({
    String?           title,
    DateTime?         date,
    TransactionType?  type,
    Account?          fromAccount,
    Account?          toAccount,
    double?           amount,
    DateTime?         recurrenceEnd,
    List<DateTime>?   exceptions,
    Account?          category,
    // String?           note,
  }) =>
      TransactionItem(
        id            : id,
        title         : title         ?? this.title,
        date          : date          ?? this.date,
        type          : type          ?? this.type,
        fromAccount   : fromAccount   ?? this.fromAccount,
        toAccount     : toAccount     ?? this.toAccount,
        amount        : amount        ?? this.amount,
        recurrenceEnd : recurrenceEnd ?? this.recurrenceEnd,
        exceptions    : exceptions    ?? this.exceptions,
        category      : category      ?? this.category,
        // note          : note          ?? this.note,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Presentation helpers on TransactionItem
extension TransactionPresentation on TransactionItem {
  String get displayTitle {
    if (title != type.name) return title;
    switch (type) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.partnerTransfer:
        final f = fromAccount!;
        final t = toAccount;
        if (f.type == AccountType.vendor && t.type == AccountType.personal) {
          return 'Refund';
        }
        if (f.type == AccountType.personal && t.type == AccountType.vendor) {
          return 'Expense';
        }
        if (f.type == AccountType.personal && t.type == AccountType.incomeSource) {
          return 'Return';
        }
        if (f.type == AccountType.incomeSource && t.type == AccountType.personal) {
          return 'Income';
        }
        if (f.type == AccountType.partner && t.type == AccountType.personal) {
          return 'Invoice';
        }
        if (f.type == AccountType.personal && t.type == AccountType.partner) {
          return 'Bill';
        }
        return 'Transfer';
    }
  }

  String get displaySubtitle {
    if (type == TransactionType.transfer ||
        type == TransactionType.partnerTransfer) {
      return 'From ${fromAccount!.name} to ${toAccount.name}';
    } else {
      return toAccount.name;
    }
  }

  Icon get displayIcon {
    switch (type) {
      case TransactionType.expense:
        return Icon(Icons.arrow_downward, color: Colors.red);
      case TransactionType.income:
        return Icon(Icons.arrow_upward, color: Colors.green);
      case TransactionType.transfer:
        return Icon(Icons.swap_horiz, color: Colors.blue);
      case TransactionType.partnerTransfer:
        final f = fromAccount!;
        final t = toAccount;
        final isIn = (f.type == AccountType.vendor && t.type == AccountType.personal) ||
            (f.type == AccountType.partner && t.type == AccountType.personal) ||
            (f.type == AccountType.incomeSource && t.type == AccountType.personal);
        return Icon(isIn ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isIn ? Colors.green : Colors.red);
    }
  }
}
