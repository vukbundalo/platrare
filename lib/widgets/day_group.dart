import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/utils/balance_calculator.dart';
import 'package:platrare/widgets/transaction_accounts_summary_card.dart';
import 'package:platrare/widgets/account_balance_card.dart';
import 'package:platrare/extensions/transaction_item_ext.dart';

/// Renders one calendar‐day’s worth of planned transactions,
/// *including* its date header, the list of cards, and the
/// horizontal balances ribbon.
class DayGroup extends StatelessWidget {
  final DateTime day;
  final List<TransactionItem> items;
  final void Function(TransactionItem) onEdit;

  const DayGroup({
    Key? key,
    required this.day,
    required this.items,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // compute balances by applying all planned tx ≤ this day
    final proj = computeProjectedBalances(dummyAccounts, dummyPlanned, day);

    // available = sum of personal & includeInBalance
    final avail = proj.entries
        .where((e) =>
            e.key.type == AccountType.personal && e.key.includeInBalance)
        .fold(0.0, (s, e) => s + e.value);

    // liquid = sum of all personal
    final liquid = proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold(0.0, (s, e) => s + e.value);

    // per‐account cards
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
          // — Date header —
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${day.day}/${day.month}/${day.year}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          // — Transaction cards —
          ...items.map((tx) => Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: tx.displayIcon,
                  title: Text(tx.displayTitle),
                  subtitle: Text(tx.displaySubtitle),
                  trailing: Text(tx.amount.toStringAsFixed(2)),
                  onTap: () => onEdit(tx),
                ),
              )),

          const SizedBox(height: 8),

          // — Horizontal balances ribbon —
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TransactionAccountsSummaryCard(
                    label: 'Available', value: avail),
                const SizedBox(width: 20),
                ...personalBalances
                    .map((a) => AccountBalanceCard(account: a)),
                TransactionAccountsSummaryCard(label: 'Liquid', value: liquid),
                const SizedBox(width: 20),
                ...partnerBalances
                    .map((a) => AccountBalanceCard(account: a)),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
