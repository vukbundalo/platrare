import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/screens/accounts/new_account_screen.dart';
import 'package:platrare/screens/accounts/edit_account_screen.dart';
import 'package:platrare/widgets/account_card.dart';
import 'package:platrare/widgets/accounts_summary_card.dart';
import 'package:platrare/widgets/reordable_section.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: AccountSummaryCard(
                    label: 'Available Balance',
                    value: avail,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: AccountSummaryCard(
                    label: 'Liquid Assets',
                    value: liquid,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: AccountSummaryCard(
                    label: 'Partners Balance',
                    value: partnersBal,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: AccountSummaryCard(
                    label: 'Net Worth',
                    value: netWorth,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          ReorderableSection(
            title: 'Personal Accounts',
            items: personalList,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final acct = personalList.removeAt(oldIndex);
                personalList.insert(newIndex, acct);
              });
            },
            itemBuilder: (Account item) {
              return GestureDetector(
                onTap: () => _editOrDelete(item, personalList),
                child: AccountCard(account: item),
              );
            },
          ),
          SizedBox(height: 24),
          ReorderableSection(
            title: 'Partner Accounts',
            items: partnerList,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final acct = partnerList.removeAt(oldIndex);
                partnerList.insert(newIndex, acct);
              });
            },
            itemBuilder: (Account item) {
              return GestureDetector(
                onTap: () => _editOrDelete(item, partnerList),
                child: AccountCard(account: item),
              );
            },
          ),
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
}
