// lib/widgets/account_card.dart

import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    // Color scheme per type
    switch (account.type) {
      case AccountType.category:
        bgColor = Colors.grey.shade200;
        textColor = Colors.black87;
        break;
      case AccountType.vendor:
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        break;
      case AccountType.incomeSource:
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        break;
      default:
        final positive = account.balance >= 0;
        bgColor = positive ? Colors.green.shade50 : Colors.red.shade50;
        textColor = positive ? Colors.green.shade800 : Colors.red.shade800;
    }

    // Format balance text with or without prefix
    final amt = account.balance;
    final absStr = amt.abs().toStringAsFixed(2);
    String balanceText;

    // Categories, vendors, and income‐sources never get a + or – prefix
    if (account.type == AccountType.category ||
        account.type == AccountType.vendor ||
        account.type == AccountType.incomeSource) {
      balanceText = absStr;
    } else {
      // all other types (personal, partner) show +/– if nonzero
      if (amt == 0) {
        balanceText = absStr;
      } else if (amt > 0) {
        balanceText = '+$absStr';
      } else {
        balanceText = '-$absStr';
      }
    }

    return Card(
      color: bgColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(account.name),
        trailing: Text(
          balanceText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
