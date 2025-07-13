import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_realized.dart';
import 'package:platrare/data/dummy_planned.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/screens/review/edit_review_account_screen.dart';
import 'package:platrare/screens/review/new_review_account_screen.dart';
import 'package:platrare/widgets/account_card.dart';
import 'package:platrare/widgets/section_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  late List<Account> categoryList;
  late List<Account> vendorList;
  late List<Account> incomeList;

  @override
  void initState() {
    super.initState();
    // initialize from dummy data
    categoryList = dummyAccounts
        .where((a) => a.type == AccountType.category)
        .toList();
    vendorList = dummyAccounts
        .where((a) => a.type == AccountType.vendor)
        .map((a) => a.copyWith(balance: -a.balance.abs()))
        .toList();
    incomeList = dummyAccounts
        .where((a) => a.type == AccountType.incomeSource)
        .map((a) => a.copyWith(balance: a.balance.abs()))
        .toList();
    _applySavedOrder();
  }

  Future<void> _applySavedOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCats = prefs.getStringList('review_category_order');
    if (savedCats != null) {
      categoryList.sort(
        (a, b) => savedCats.indexOf(a.name).compareTo(savedCats.indexOf(b.name)),
      );
    }
    final savedVendors = prefs.getStringList('review_vendor_order');
    if (savedVendors != null) {
      vendorList.sort(
        (a, b) => savedVendors.indexOf(a.name).compareTo(savedVendors.indexOf(b.name)),
      );
    }
    final savedIncome = prefs.getStringList('review_income_order');
    if (savedIncome != null) {
      incomeList.sort(
        (a, b) => savedIncome.indexOf(a.name).compareTo(savedIncome.indexOf(b.name)),
      );
    }
    setState(() {});
  }

  Future<void> _saveOrder(String key, List<Account> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list.map((a) => a.name).toList());
  }

  Future<void> _editOrDelete(Account acc, List<Account> list) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => EditReviewAccountScreen(account: acc)),
    );
    if (result is Account) {
      // 1) Update the account itself
      final gi = dummyAccounts.indexWhere((a) => a.name == acc.name);
      if (gi != -1) dummyAccounts[gi] = result;
      // update in this list too
      final idx = list.indexWhere((a) => a.name == acc.name);
      if (idx != -1) list[idx] = result;
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

  Widget _buildSection(String title, List<Account> list, String prefKey) {
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
          key: ValueKey(prefKey),
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          proxyDecorator: (child, index, animation) => child,
          physics: NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) async {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final acct = list.removeAt(oldIndex);
              list.insert(newIndex, acct);
            });
            await _saveOrder(prefKey, list);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Categories', categoryList, 'review_category_order'),
          const SizedBox(height: 24),
          _buildSection('Vendors', vendorList, 'review_vendor_order'),
          const SizedBox(height: 24),
          _buildSection('Income Sources', incomeList, 'review_income_order'),
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
              // also add to appropriate list maintaining order
              switch (result.type) {
                case AccountType.category:
                  categoryList.add(result);
                  _saveOrder('review_category_order', categoryList);
                  break;
                case AccountType.vendor:
                  vendorList.add(result);
                  _saveOrder('review_vendor_order', vendorList);
                  break;
                case AccountType.incomeSource:
                  incomeList.add(result);
                  _saveOrder('review_income_order', incomeList);
                  break;
                default:
                  break;
              }
            });
          }
        },
      ),
    );
  }
}
