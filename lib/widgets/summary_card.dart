import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  const SummaryCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
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
              label,
              style: TextStyle(
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value.toStringAsFixed(2),
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