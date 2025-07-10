import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
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
  late List<Account> budgetList;
  late List<Account> categoryList;
  late List<Account> vendorList;
  late List<Account> incomeList;

  @override
  void initState() {
    super.initState();
    _reloadAll();
  }

  void _reloadAll() {
    budgetList =
        dummyAccounts.where((a) => a.type == AccountType.budget).toList();
    categoryList =
        dummyAccounts.where((a) => a.type == AccountType.category).toList();
    vendorList =
        dummyAccounts.where((a) => a.type == AccountType.vendor).toList();
    incomeList =
        dummyAccounts.where((a) => a.type == AccountType.incomeSource).toList();
  }

  Future<void> _editOrDelete(Account acc, List<Account> list) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => EditReviewAccountScreen(account: acc)),
    );
    if (result is Account) {
      // update global
      final gi = dummyAccounts.indexWhere((a) => a.name == acc.name);
      if (gi != -1) dummyAccounts[gi] = result;
      // update local
      final li = list.indexOf(acc);
      setState(() => list[li] = result);
    } else if (result == 'delete') {
      setState(() {
        dummyAccounts.removeWhere((a) => a.name == acc.name);
        list.remove(acc);
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
          physics: NeverScrollableScrollPhysics(),
          proxyDecorator: (child, index, animation) => child,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final acct = list.removeAt(oldIndex);
              list.insert(newIndex, acct);
            });
          },
          children: [
            for (var acct in list)
              ReorderableDragStartListener(
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
      appBar: AppBar(title: Text('Review')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Budgets', budgetList, ValueKey('b')),
          SizedBox(height: 24),
          _buildSection('Categories', categoryList, ValueKey('c')),
          SizedBox(height: 24),
          _buildSection('Vendors', vendorList, ValueKey('v')),
          SizedBox(height: 24),
          _buildSection('Income Sources', incomeList, ValueKey('i')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<Account?>(
            context,
            MaterialPageRoute(builder: (_) => NewReviewAccountScreen()),
          );
          if (result != null) {
            setState(() {
              dummyAccounts.add(result);
              _reloadAll();
            });
          }
        },
      ),
    );
  }
}