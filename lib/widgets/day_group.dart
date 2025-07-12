// lib/widgets/day_group.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/utils/balance_calculator.dart';
import 'package:platrare/widgets/transaction_accounts_summary_card.dart';
import 'package:platrare/widgets/account_balance_card.dart';

/// Renders one calendar‐day’s worth of planned transactions,
/// including its date header, the list of cards (swipe→realize),
/// and a ribbon showing projected balances as of that day.
class DayGroup extends StatelessWidget {
  final DateTime day;
  final List<TransactionItem> items;
  final Future<void> Function(TransactionItem) onEdit;
  final Future<void> Function(TransactionItem) onRealize;

  const DayGroup({
    super.key,
    required this.day,
    required this.items,
    required this.onEdit,
    required this.onRealize,
  });

  @override
  Widget build(BuildContext context) {
    // Compute projected balances using *all* one‐off plans up to this day:
    final proj = computeProjectedBalances(dummyAccounts, dummyPlanned, day);

    // sum of all personal & included‐in‐total accounts
    final avail = proj.entries
        .where(
          (e) => e.key.type == AccountType.personal && e.key.includeInBalance,
        )
        .fold(0.0, (sum, e) => sum + e.value);

    // sum of all personal accounts (liquid)
    final liquid = proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold(0.0, (sum, e) => sum + e.value);

    final personalBalances =
        dummyAccounts
            .where((a) => a.type == AccountType.personal)
            .map((a) => a.copyWith(balance: proj[a]!))
            .toList();

    final partnerBalances =
        dummyAccounts
            .where((a) => a.type == AccountType.partner)
            .map((a) => a.copyWith(balance: proj[a]!))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // — Date header —
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${day.day}/${day.month}/${day.year}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // — Transaction cards (swipe→realize) —
        ...items.map((tx) {
          return Dismissible(
            key: ValueKey(tx.id),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            onDismissed: (_) => onRealize(tx),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: tx.displayIcon,
                title: Text(tx.displayTitle),
                subtitle: Text(tx.displaySubtitle),
                trailing: Text(tx.amount.toStringAsFixed(2)),
                onTap: () => onEdit(tx),
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // — Horizontal balances ribbon —
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              TransactionAccountsSummaryCard(label: 'Available', value: avail),
              const SizedBox(width: 20),
              ...personalBalances.map((a) => AccountBalanceCard(account: a)),
              const SizedBox(width: 20),
              TransactionAccountsSummaryCard(label: 'Liquid', value: liquid),
              const SizedBox(width: 20),
              ...partnerBalances.map((a) => AccountBalanceCard(account: a)),
              const SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
