import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/utils/balance_calculator.dart';
import 'package:platrare/widgets/transaction_accounts_summary_card.dart';
import 'package:platrare/widgets/account_balance_card.dart';

/// A single day’s block in the Track screen.
class TrackDayGroup extends StatelessWidget {
  final DateTime day;
  final List<TransactionItem> items;
  final void Function(TransactionItem) onEdit;

  const TrackDayGroup({
    super.key,
    required this.day,
    required this.items,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // 1) Compute “as‐of‐this‐day” balances by reversing any tx > day
    final proj = computeProjectedBalancesForTrack(
      dummyAccounts,
      dummyRealized,
      day,
    );

    // 2) Totals
    final available = proj.entries
        .where((e) =>
            e.key.type == AccountType.personal && e.key.includeInBalance)
        .fold<double>(0, (sum, e) => sum + e.value);

    final liquid = proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold<double>(0, (sum, e) => sum + e.value);

    // 3) Per‐account snapshots
    final personalBalances = dummyAccounts
        .where((a) => a.type == AccountType.personal)
        .map((a) => Account(
              name: a.name,
              type: a.type,
              balance: proj[a]!,
              includeInBalance: a.includeInBalance,
            ))
        .toList();

    final partnerBalances = dummyAccounts
        .where((a) => a.type == AccountType.partner)
        .map((a) => Account(
              name: a.name,
              type: a.type,
              balance: proj[a]!,
              includeInBalance: a.includeInBalance,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // — Day header —
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${day.day}/${day.month}/${day.year}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          // — Each realized tx —
          ...items.map((tx) => Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: tx.displayIcon,
                  title: Text(tx.displayTitle),
                  subtitle: Text(tx.displaySubtitle),
                  trailing: Text(tx.amount.toStringAsFixed(2)),
                  onTap: () => onEdit(tx),
                ),
              )),

          const SizedBox(height: 8),

          // — Actual balances ribbon —
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TransactionAccountsSummaryCard(
                    label: 'Available', value: available),
                const SizedBox(width: 20),
                // personal
                ...personalBalances
                    .map((a) => AccountBalanceCard(account: a)),
                TransactionAccountsSummaryCard(label: 'Liquid', value: liquid),
                const SizedBox(width: 20),
                // partner
                ...partnerBalances
                    .map((a) => AccountBalanceCard(account: a)),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
