import 'package:flutter/material.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/models/account.dart';

extension TransactionPresentation on TransactionItem {
  /// If user typed a custom title, use it.
  /// Otherwise fall back to a sensible default per your rules.
  String get displayTitle {
    // if they entered something other than the enum name, use it
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
        // your “refund / bill / invoice / return” rules:
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

  /// Always shows which account(s) are involved:
  String get displaySubtitle {
    if (type == TransactionType.transfer || type == TransactionType.partnerTransfer) {
      return 'From ${fromAccount!.name} to ${toAccount.name}';
    } else {
      // expense/income only touch one account
      return toAccount.name;
    }
  }

  /// Pick the right icon + color
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
        final isIn = (f.type == AccountType.vendor && t.type == AccountType.personal)
            || (f.type == AccountType.partner && t.type == AccountType.personal)
            || (f.type == AccountType.incomeSource && t.type == AccountType.personal);
        return Icon(isIn ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isIn ? Colors.green : Colors.red);
    }
  }
}
