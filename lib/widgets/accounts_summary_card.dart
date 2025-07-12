import 'package:flutter/material.dart';

class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? Colors.green.shade50 : Colors.red.shade100;
    final txColor = value >= 0 ? Colors.green.shade800 : Colors.red.shade800;

    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 16,
                color: txColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
