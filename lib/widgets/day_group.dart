// lib/widgets/day_group.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/utils/balance_calculator.dart';
import 'package:platrare/widgets/transaction_accounts_summary_card.dart';
import 'package:platrare/widgets/account_balance_card.dart';

/// Renders one calendar‐day’s worth of planned transactions,
/// including its date header, the list of cards (now swipeable
/// even for future-dated items), and the horizontal balances ribbon.
class DayGroup extends StatelessWidget {
  final DateTime day;
  final List<TransactionItem> items;
  final List<TransactionItem> allOccurrences;
  final Future<void> Function(TransactionItem) onEdit;
  final Future<void> Function(TransactionItem) onRealize;

  const DayGroup({
    Key? key,
    required this.day,
    required this.items,
    required this.allOccurrences,
    required this.onEdit,
    required this.onRealize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) Compute projected balances up to this day
    final proj = computeProjectedBalances(dummyAccounts, allOccurrences, day);

    final avail = proj.entries
        .where(
          (e) => e.key.type == AccountType.personal && e.key.includeInBalance,
        )
        .fold(0.0, (sum, e) => sum + e.value);

    final liquid = proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold(0.0, (sum, e) => sum + e.value);

    final personalBalances =
        dummyAccounts
            .where((a) => a.type == AccountType.personal)
            .map(
              (a) => Account(
                name: a.name,
                type: a.type,
                balance: proj[a]!,
                includeInBalance: a.includeInBalance,
              ),
            )
            .toList();

    final partnerBalances =
        dummyAccounts
            .where((a) => a.type == AccountType.partner)
            .map(
              (a) => Account(
                name: a.name,
                type: a.type,
                balance: proj[a]!,
                includeInBalance: a.includeInBalance,
              ),
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // — Date header —
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${day.day}/${day.month}/${day.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          // — Transaction cards — all swipeable now
          ...items.map((tx) {
            final card = Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: tx.displayIcon,
                title: Text(tx.displayTitle),
                subtitle: Text(tx.displaySubtitle),
                trailing: Text(tx.amount.toStringAsFixed(2)),
                onTap: () async => await onEdit(tx),
              ),
            );

            return Dismissible(
              key: ValueKey(tx.id),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: const Icon(Icons.check, color: Colors.white),
              ),
              onDismissed: (_) async {
                await onRealize(tx);
              },
              child: card,
            );
          }),

          const SizedBox(height: 8),

          // — Horizontal balances ribbon —
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TransactionAccountsSummaryCard(
                  label: 'Available',
                  value: avail,
                ),
                const SizedBox(width: 20),
                ...personalBalances.map((a) => AccountBalanceCard(account: a)),
                TransactionAccountsSummaryCard(label: 'Liquid', value: liquid),
                const SizedBox(width: 20),
                ...partnerBalances.map((a) => AccountBalanceCard(account: a)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
