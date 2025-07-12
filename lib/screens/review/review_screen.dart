// lib/screens/review/review_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/screens/review/edit_review_account_screen.dart';
import 'package:platrare/screens/review/new_review_account_screen.dart';
import 'package:platrare/widgets/account_card.dart';
import 'package:platrare/widgets/section_header.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  Future<void> _editOrDelete(Account acc, List<Account> list) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => EditReviewAccountScreen(account: acc)),
    );
    if (result is Account) {
      // 1) Update the account itself
      final gi = dummyAccounts.indexWhere((a) => a.name == acc.name);
      if (gi != -1) dummyAccounts[gi] = result;
      setState(() {});
    } else if (result == 'delete') {
      // 2a) Scrub this category off of every realized TX
      for (var i = 0; i < dummyRealized.length; i++) {
        final tx = dummyRealized[i];
        if (tx.category?.name == acc.name) {
          dummyRealized[i] = tx.copyWith(category: null);
        }
      }
      // 2b) Scrub this category off of every planned TX
      for (var i = 0; i < dummyPlanned.length; i++) {
        final tx = dummyPlanned[i];
        if (tx.category?.name == acc.name) {
          dummyPlanned[i] = tx.copyWith(category: null);
        }
      }
      // 3) Then remove the account itself
      setState(() {
        dummyAccounts.removeWhere((a) => a.name == acc.name);
        list.removeWhere((a) => a.name == acc.name);
      });
    }
  }

  Widget _buildSection(String title, List<Account> list, Key key) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text('No $title yet.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title),
        ReorderableListView(
          key: key,
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          proxyDecorator: (child, index, animation) => child,
          physics: NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final acct = list.removeAt(oldIndex);
              list.insert(newIndex, acct);
            });
          },
          children: [
            for (var acct in list)
              ReorderableDelayedDragStartListener(
                key: ValueKey(acct.name),
                index: list.indexOf(acct),
                child: GestureDetector(
                  onTap: () => _editOrDelete(acct, list),
                  child: AccountCard(account: acct),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // derive fresh lists on every build
    final categoryList =
        dummyAccounts.where((a) => a.type == AccountType.category).toList();
    final vendorList =
        dummyAccounts
            .where((a) => a.type == AccountType.vendor)
            .map((a) => a.copyWith(balance: -a.balance.abs()))
            .toList();
    final incomeList =
        dummyAccounts
            .where((a) => a.type == AccountType.incomeSource)
            .map((a) => a.copyWith(balance: a.balance.abs()))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Categories', categoryList, const ValueKey('c')),
          const SizedBox(height: 24),
          _buildSection('Vendors', vendorList, const ValueKey('v')),
          const SizedBox(height: 24),
          _buildSection('Income Sources', incomeList, const ValueKey('i')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<Account?>(
            context,
            MaterialPageRoute(builder: (_) => const NewReviewAccountScreen()),
          );
          if (result != null) {
            setState(() {
              dummyAccounts.add(result);
            });
          }
        },
      ),
    );
  }
}
