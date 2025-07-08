import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/enums.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/screens/accounts/new_account_screen.dart';
import 'package:platrare/screens/accounts/edit_account_screen.dart';
import 'package:platrare/widgets/section_header.dart';
import 'package:platrare/widgets/account_card.dart';



class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  AccountsScreenState createState() => AccountsScreenState();
}

class AccountsScreenState extends State<AccountsScreen> {
  late List<Account> personalList;
  late List<Account> partnerList; // show all partners here

  @override
  void initState() {
    super.initState();
    personalList =
        dummyAccounts.where((a) => a.type == AccountType.personal).toList();
    partnerList =
        dummyAccounts.where((a) => a.type == AccountType.partner).toList();
  }

  Future<void> _editOrDelete(Account acc, List<Account> list) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => EditAccountScreen(account: acc)),
    );

    if (result is Account) {
      // Replace in both dummyAccounts and our local list
      final globalIndex = dummyAccounts.indexWhere((a) => a.name == acc.name);
      if (globalIndex != -1) dummyAccounts[globalIndex] = result;

      final localIndex = list.indexOf(acc);
      setState(() {
        list[localIndex] = result;
      });
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
    final avail = personalList
        .where((a) => a.includeInBalance)
        .fold(0.0, (sum, a) => sum + a.balance);
    final liquid = personalList.fold(0.0, (sum, a) => sum + a.balance);
    final partnersBal = partnerList.fold(0.0, (sum, a) => sum + a.balance);
    final netWorth = liquid + partnersBal;

    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _summaryCard('Available Balance', avail)),
              SizedBox(width: 8),
              Expanded(child: _summaryCard('Liquid Assets', liquid)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _summaryCard('Partners Balance', partnersBal)),
              SizedBox(width: 8),
              Expanded(child: _summaryCard('Net Worth', netWorth)),
            ],
          ),
          SizedBox(height: 24),
          _buildSection('Personal Accounts', personalList, ValueKey('p')),
          SizedBox(height: 24),
          _buildSection('Partner Accounts', partnerList, ValueKey('pr')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newAcc = await Navigator.push<Account?>(
            context,
            MaterialPageRoute(builder: (_) => NewAccountScreen()),
          );
          if (newAcc != null) {
            setState(() {
              dummyAccounts.add(newAcc);
              if (newAcc.type == AccountType.personal) {
                personalList.add(newAcc);
              } else if (newAcc.type == AccountType.partner) {
                partnerList.add(newAcc);
              }
            });
          }
        },
      ),
    );
  }

  Widget _summaryCard(String label, double value) {
    final color = value >= 0 ? Colors.greenAccent : Colors.redAccent;
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}