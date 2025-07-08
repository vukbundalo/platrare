import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final bgColor = account.balance >= 0 ? Colors.green[50] : Colors.red[50];
    final textColor =
        account.balance >= 0 ? Colors.green[800] : Colors.red[800];
    return Card(
      color: bgColor,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(account.name),
        //subtitle: Text(account.type.toString().split('.').last),
        trailing: Text(
          account.balance.toStringAsFixed(2),
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}