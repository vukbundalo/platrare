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

    switch (account.type) {
      case AccountType.category:
        // light grey background, dark text
        bgColor = Colors.grey.shade200;
        textColor = Colors.black87;
        break;
      case AccountType.vendor:
        // red tint background/text
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        break;
      case AccountType.incomeSource:
        // green tint background/text
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        break;
      default:
        // fallback: positive = green, negative = red
        final positive = account.balance >= 0;
        bgColor = positive ? Colors.green.shade50 : Colors.red.shade50;
        textColor = positive ? Colors.green.shade800 : Colors.red.shade800;
    }

    return Card(
      color: bgColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(account.name),
        trailing: Text(
          // always show absolute value
          account.balance.abs().toStringAsFixed(2),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
