import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/widgets/account_balance_card.dart';
import 'package:platrare/widgets/transaction_accounts_summary_card.dart';
import 'package:platrare/utils/balance_calculator.dart';

/// One calendar‐day’s worth of realized transactions,
/// swipe‐to‐return‐to‐plan + balances ribbon.
class TrackDayGroup extends StatelessWidget {
  final DateTime day;
  final List<TransactionItem> items;
  final Future<void> Function(TransactionItem) onEdit;
  final void Function(TransactionItem) onReturn;

  const TrackDayGroup({
    super.key,
    required this.day,
    required this.items,
    required this.onEdit,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    // compute balances as of this day
    final proj = computeProjectedBalancesForTrack(
      dummyAccounts,
      items,
      day,
    );
    final avail = proj.entries
        .where((e) => e.key.type == AccountType.personal && e.key.includeInBalance)
        .fold<double>(0, (sum, e) => sum + e.value);
    final liquid = proj.entries
        .where((e) => e.key.type == AccountType.personal)
        .fold<double>(0, (sum, e) => sum + e.value);

    final personalBalances = dummyAccounts
        .where((a) => a.type == AccountType.personal)
        .map((a) => a.copyWith(balance: proj[a]!))
        .toList();
    final partnerBalances = dummyAccounts
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

        // — Transactions (swipe left to return to Plan) —
        ...items.map((tx) => Dismissible(
              key: ValueKey(tx.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.orange,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.undo, color: Colors.white),
              ),
              onDismissed: (_) => onReturn(tx),
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
            )),

        const SizedBox(height: 8),

        // — Balances ribbon as of that day —
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
