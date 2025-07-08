import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

class AccountBalanceCard extends StatelessWidget {
  final Account account;
  const AccountBalanceCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final isPositive = account.balance >= 0;
    return Card(
      color: isPositive ? Colors.green[50] : Colors.red[50],
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              account.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              account.balance.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
