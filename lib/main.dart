import 'package:flutter/material.dart';

void main() => runApp(PlatrareApp());

class PlatrareApp extends StatelessWidget {
  const PlatrareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Platrare',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Enums
enum AccountType { personal, partner, vendor, incomeSource, budget, category }

enum TransactionType { expense, income, transfer, partnerTransfer }

enum ReviewAccountType { budget, category, vendor, incomeSource }

enum TransactionStatus { planned, realized }

// Models
class Account {
  final String name;
  final AccountType type;
  final double balance;
  final bool includeInBalance;

  Account({
    required this.name,
    required this.type,
    required this.balance,
    required this.includeInBalance,
  });
}

class TransactionItem {
  final String title;
  final DateTime date;
  final TransactionType type;
  final Account? fromAccount;
  final Account toAccount;
  final double amount;
  TransactionItem({
    required this.title,
    required this.date,
    required this.type,
    this.fromAccount,
    required this.toAccount,
    required this.amount,
  });
}

// Dummy data
List<Account> dummyAccounts = [
  // — Personal Accounts —
  Account(
    name: 'Cash',
    type: AccountType.personal,
    balance: 300.0,
    includeInBalance: true,
  ),
  Account(
    name: 'Card',
    type: AccountType.personal,
    balance: 450.0,
    includeInBalance: true,
  ),
  Account(
    name: 'Piggy bank',
    type: AccountType.personal,
    balance: 27.0,
    includeInBalance: false,
  ),

  // — Partner Accounts —
  Account(
    name: 'Nevena Bundalo',
    type: AccountType.partner,
    balance: 454,
    includeInBalance: false,
  ),
  Account(
    name: 'Željko Bundalo',
    type: AccountType.partner,
    balance: -3143,
    includeInBalance: false,
  ),
  Account(
    name: 'Nova Banka',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'Electricity',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'Building',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'RTV',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),
  Account(
    name: 'Sanitation',
    type: AccountType.partner,
    balance: -1400,
    includeInBalance: false,
  ),

  // — Vendor Accounts —
  Account(
    name: 'Replay',
    type: AccountType.vendor,
    balance: 240,
    includeInBalance: false,
  ),
  Account(
    name: 'Moj Market',
    type: AccountType.vendor,
    balance: 423,
    includeInBalance: false,
  ),

  // — Income Source Accounts —
  Account(
    name: 'East Code d.o.o',
    type: AccountType.incomeSource,
    balance: 54000,
    includeInBalance: false,
  ),
  Account(
    name: 'Apiary Bundalo',
    type: AccountType.incomeSource,
    balance: 4500,
    includeInBalance: false,
  ),

  // — Budget Accounts —
  Account(
    name: 'Food',
    type: AccountType.budget,
    balance: 300.0,
    includeInBalance: false,
  ),
  Account(
    name: 'Coffee',
    type: AccountType.budget,
    balance: 150.0,
    includeInBalance: false,
  ),

  // — Category Accounts —
  Account(
    name: 'Nightout',
    type: AccountType.category,
    balance: 220,
    includeInBalance: false,
  ),
  Account(
    name: 'Car',
    type: AccountType.category,
    balance: 700,
    includeInBalance: false,
  ),
];

List<TransactionItem> dummyTransactions = [
  TransactionItem(
    title: 'Grocery Shopping',
    date: DateTime.now().subtract(Duration(days: 1)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts[0],
    amount: -45.0,
  ),
  TransactionItem(
    title: 'Salary',
    date: DateTime.now().subtract(Duration(days: 2)),
    type: TransactionType.income,
    fromAccount: null,
    toAccount: dummyAccounts[1],
    amount: 1000.0,
  ),
];

List<TransactionItem> dummyPlanned = [
  TransactionItem(
    title: 'Future Gym Fee',
    date: DateTime.now().add(Duration(days: 3)),
    type: TransactionType.expense,
    fromAccount: null,
    toAccount: dummyAccounts.firstWhere((a) => a.name == 'Cash'),
    amount: -30.0,
  ),
];

List<TransactionItem> dummyRealized =
    dummyTransactions.map((tx) {
      // 1) Determine type by sign
      final txnType =
          tx.amount < 0 ? TransactionType.expense : TransactionType.income;

      // 2) Only partnerTransfer/transfer ever have a fromAccount
      final Account? from =
          (txnType == TransactionType.partnerTransfer ||
                  txnType == TransactionType.transfer)
              ? tx.fromAccount
              : null;

      // 3) The “toAccount” is your old tx.account
      final Account to = tx.toAccount;

      return TransactionItem(
        title: tx.title,
        date: tx.date,
        type: txnType,
        fromAccount: from,
        toAccount: to,
        amount: tx.amount,
      );
    }).toList();

// Functions

// Compute projected balances up to a given date:
Map<Account, double> computeProjectedBalances(
  List<Account> accounts,
  List<TransactionItem> planned,
  DateTime upToDate,
) {
  // 1) Start from “today” balances
  final proj = <Account, double>{for (var a in accounts) a: a.balance};

  // 2) Apply **all** planned tx whose date ≤ upToDate
  for (var tx in planned) {
    final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
    if (day.isAfter(upToDate)) continue;

    switch (tx.type) {
      case TransactionType.transfer:
      case TransactionType.partnerTransfer:
        // debit the `from`
        if (tx.fromAccount != null) {
          proj[tx.fromAccount!] = (proj[tx.fromAccount!] ?? 0) - tx.amount;
        }
        // credit the `to`
        proj[tx.toAccount] = (proj[tx.toAccount] ?? 0) + tx.amount;
        break;

      case TransactionType.expense:
      case TransactionType.income:
        // single‐account adjustment
        proj[tx.toAccount] = (proj[tx.toAccount] ?? 0) + tx.amount;
        break;
    }
  }

  return proj;
}

// Home Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _screens = [
    AccountsScreen(),
    PlanScreen(),
    TrackScreen(),
    ReviewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Track'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Review',
          ),
        ],
      ),
    );
  }
}

// Account Screen

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
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

class NewAccountScreen extends StatefulWidget {
  const NewAccountScreen({super.key});

  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  AccountType _type = AccountType.personal;
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0');
  bool _includeInAvailableBalance = true;

  static const Map<AccountType, String> _labels = {
    AccountType.personal: 'Personal',
    AccountType.partner: 'Partner',
  };

  @override
  Widget build(BuildContext context) {
    // two chips → each takes half the width (minus padding & spacing)
    final totalPadding = 16.0 * 2;
    final spacing = 8.0;
    final chipWidth =
        (MediaQuery.of(context).size.width - totalPadding - spacing) / 2;

    return Scaffold(
      appBar: AppBar(title: Text('New Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // —— 1×2 Grid of “Chips” ——
            Wrap(
              spacing: spacing,
              children:
                  _labels.entries.map((e) {
                    final selected = _type == e.key;
                    return SizedBox(
                      width: chipWidth,
                      child: InkWell(
                        onTap: () => setState(() => _type = e.key),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                            border: Border.all(
                              color:
                                  selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.value,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 24),

            // —— Name & Balance Fields ——
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Starting Balance'),
            ),

            // —— Only for Personal ——
            if (_type == AccountType.personal) ...[
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Include in Available Balance'),
                value: _includeInAvailableBalance,
                onChanged:
                    (v) => setState(() => _includeInAvailableBalance = v),
              ),
            ],

            Spacer(),

            // —— Save Button ——
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final bal = double.tryParse(_balanceController.text) ?? 0.0;
                final acct = Account(
                  name: name,
                  type: _type,
                  balance: bal,
                  includeInBalance:
                      _type == AccountType.personal &&
                      _includeInAvailableBalance,
                );
                Navigator.pop(context, acct);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditAccountScreen extends StatefulWidget {
  final Account account;
  const EditAccountScreen({super.key, required this.account});

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _balCtrl;
  late bool _includeInAvailable;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.account.name);
    _balCtrl = TextEditingController(text: widget.account.balance.toString());
    _includeInAvailable = widget.account.includeInBalance;
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Account?'),
            content: Text('This action cannot be undone.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      Navigator.pop(context, 'delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPersonal = widget.account.type == AccountType.personal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: _confirmDelete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12),

            // Current Balance
            TextField(
              controller: _balCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Current Balance'),
            ),

            // Include toggle only for personal accounts
            if (isPersonal) ...[
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Include in Available Balance'),
                value: _includeInAvailable,
                onChanged: (v) => setState(() => _includeInAvailable = v),
              ),
            ],

            Spacer(),

            // Save
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;

                final bal = double.tryParse(_balCtrl.text) ?? 0.0;
                final updated = Account(
                  name: name,
                  type: widget.account.type, // preserve original type
                  balance: bal,
                  includeInBalance: _includeInAvailable,
                );
                Navigator.pop(context, updated);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Plan Screen

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final List<TransactionItem> _planned = List.from(dummyPlanned);

  @override
  void initState() {
    super.initState();
    _planned.sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> _edit(TransactionItem existing) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewPlannedTransactionScreen(existing: existing),
      ),
    );

    if (result is TransactionItem) {
      setState(() {
        final idx = _planned.indexOf(existing);
        _planned[idx] = result;
        final gi = dummyPlanned.indexWhere((t) => identical(t, existing));
        if (gi != -1) dummyPlanned[gi] = result;
        _planned.sort((a, b) => a.date.compareTo(b.date));
      });
    } else if (result == 'delete') {
      setState(() {
        _planned.remove(existing);
        dummyPlanned.remove(existing);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1) Group by day
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _planned) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      (grouped[day] ??= []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Plan')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children:
            grouped.entries.map((entry) {
              final day = entry.key;
              final items = entry.value;

              // 2) Projected balances up to this date
              final proj = computeProjectedBalances(
                dummyAccounts,
                _planned,
                day,
              );

              // 3) Summaries
              final avail = proj.entries
                  .where(
                    (e) =>
                        e.key.type == AccountType.personal &&
                        e.key.includeInBalance,
                  )
                  .fold(0.0, (s, e) => s + e.value);
              final liquid = proj.entries
                  .where((e) => e.key.type == AccountType.personal)
                  .fold(0.0, (s, e) => s + e.value);

              final personal = dummyAccounts.where(
                (a) => a.type == AccountType.personal,
              );
              final partners = dummyAccounts.where(
                (a) => a.type == AccountType.partner,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${day.day}/${day.month}/${day.year}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Planned transactions
                    ...items.map((tx) {
                      // 1) Decide display title
                      final defaultKey = tx.type.toString().split('.').last;
                      final isDefault = tx.title == defaultKey;
                      String displayTitle;

                      if (!isDefault) {
                        displayTitle = tx.title;
                      } else {
                        switch (tx.type) {
                          case TransactionType.partnerTransfer:
                            final f = tx.fromAccount!;
                            final t = tx.toAccount;
                            // your new partner-transfer naming rules:
                            if (f.type == AccountType.vendor &&
                                t.type == AccountType.personal) {
                              displayTitle = 'Refund';
                            } else if (f.type == AccountType.personal &&
                                t.type == AccountType.vendor) {
                              displayTitle = 'Expense';
                            } else if (f.type == AccountType.incomeSource &&
                                t.type == AccountType.personal) {
                              displayTitle = 'Income';
                            } else if (f.type == AccountType.partner &&
                                t.type == AccountType.personal) {
                              displayTitle = 'Invoice';
                            } else if (f.type == AccountType.personal &&
                                t.type == AccountType.partner) {
                              displayTitle = 'Bill';
                            } else {
                              displayTitle = 'Transfer';
                            }
                            break;
                          case TransactionType.transfer:
                            displayTitle = 'Transfer';
                            break;
                          case TransactionType.expense:
                            displayTitle = 'Expense';
                            break;
                          case TransactionType.income:
                            displayTitle = 'Income';
                            break;
                        }
                      }

                      // 2) Decide subtitle
                      String displaySubtitle;
                      if (tx.type == TransactionType.partnerTransfer ||
                          tx.type == TransactionType.transfer) {
                        displaySubtitle =
                            'From ${tx.fromAccount!.name} to ${tx.toAccount.name}';
                      } else {
                        displaySubtitle = tx.toAccount.name;
                      }

                      // 3) Pick the icon + color
                      IconData iconData;
                      Color iconColor;
                      switch (tx.type) {
                        case TransactionType.expense:
                          iconData = Icons.arrow_downward;
                          iconColor = Colors.red;
                          break;
                        case TransactionType.income:
                          iconData = Icons.arrow_upward;
                          iconColor = Colors.green;
                          break;
                        case TransactionType.transfer:
                          iconData = Icons.swap_horiz;
                          iconColor = Colors.blue;
                          break;
                        case TransactionType.partnerTransfer:
                          final f = tx.fromAccount!;
                          final t = tx.toAccount;
                          if ((f.type == AccountType.vendor &&
                                  t.type == AccountType.personal) ||
                              (f.type == AccountType.partner &&
                                  t.type == AccountType.personal) ||
                              (f.type == AccountType.incomeSource &&
                                  t.type == AccountType.personal)) {
                            iconData = Icons.arrow_upward;
                            iconColor = Colors.green;
                          } else {
                            iconData = Icons.arrow_downward;
                            iconColor = Colors.red;
                          }
                          break;
                      }

                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Icon(iconData, color: iconColor),
                          title: Text(displayTitle),
                          subtitle: Text(displaySubtitle),
                          trailing: Text(tx.amount.toStringAsFixed(2)),
                          onTap: () => _edit(tx),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 8),

                    // Horizontal projected balances (shorter ribbon)
                    SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SummaryCard(label: 'Available', value: avail),
                          SizedBox(width: 20),
                          ...personal.map(
                            (a) => AccountBalanceCard(
                              account: Account(
                                name: a.name,
                                type: a.type,
                                balance: proj[a]!,
                                includeInBalance: a.includeInBalance,
                              ),
                            ),
                          ),
                          SummaryCard(label: 'Liquid', value: liquid),
                          SizedBox(width: 20),
                          ...partners.map(
                            (a) => AccountBalanceCard(
                              account: Account(
                                name: a.name,
                                type: a.type,
                                balance: proj[a]!,
                                includeInBalance: a.includeInBalance,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              );
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewPlannedTransactionScreen(existing: null),
            ),
          );
          if (tx is TransactionItem) {
            setState(() {
              dummyPlanned.add(tx);
              _planned.add(tx);
              _planned.sort((a, b) => a.date.compareTo(b.date));
            });
          }
        },
      ),
    );
  }
}

// NewPlannedTransactionScreen.dart

class NewPlannedTransactionScreen extends StatefulWidget {
  final TransactionItem? existing;
  const NewPlannedTransactionScreen({super.key, this.existing});

  @override
  _NewPlannedTransactionScreenState createState() =>
      _NewPlannedTransactionScreenState();
}

class _NewPlannedTransactionScreenState
    extends State<NewPlannedTransactionScreen> {
  TransactionType _type = TransactionType.partnerTransfer;
  DateTime _date = DateTime.now();
  Account? _from, _to, _singleAccount, _categoryAccount;
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  List<Account> get _personal =>
      dummyAccounts.where((a) => a.type == AccountType.personal).toList();
  List<Account> get _partners =>
      dummyAccounts.where((a) => a.type == AccountType.partner).toList();
  List<Account> get _vendors =>
      dummyAccounts.where((a) => a.type == AccountType.vendor).toList();
  List<Account> get _incomeSources =>
      dummyAccounts.where((a) => a.type == AccountType.incomeSource).toList();
  List<Account> get _categories =>
      dummyAccounts.where((a) => a.type == AccountType.category).toList();

  List<Account> get _allForPartnerTx => [
    ..._personal,
    ..._partners,
    ..._vendors,
    ..._incomeSources,
  ];

  static const _typeLabels = {
    TransactionType.partnerTransfer: 'Partner Transaction',
    TransactionType.transfer: 'Internal Transfer',
    TransactionType.expense: 'Expense / Bill',
    TransactionType.income: 'Income / Invoice',
  };
  static const _typeColors = {
    TransactionType.partnerTransfer: Colors.purple,
    TransactionType.transfer: Colors.blue,
    TransactionType.expense: Colors.red,
    TransactionType.income: Colors.green,
  };

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final ex = widget.existing!;
      _type = ex.type;
      _date = ex.date;
      _nameCtrl.text = ex.title;
      _amountCtrl.text = ex.amount.abs().toString();
      _categoryAccount =
          ex.toAccount.type == AccountType.category ? ex.toAccount : null;
      if (_type == TransactionType.transfer ||
          _type == TransactionType.partnerTransfer) {
        _to = ex.toAccount;
        _from = ex.fromAccount;
      } else {
        _singleAccount = ex.toAccount;
      }
    }
  }

  Future<void> _confirmDelete() async {
    final sure = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete Planned?'),
            content: Text('Remove this planned transaction?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
    if (sure == true) Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    final spacing = 8.0;
    final chipWidth = (MediaQuery.of(context).size.width - 32 - spacing) / 2;

    // —— From list ——
    List<Account> fromList;
    if (_type == TransactionType.partnerTransfer) {
      fromList = _allForPartnerTx;
    } else if (_type == TransactionType.transfer) {
      fromList = _personal;
    } else {
      fromList = [..._personal, ..._partners];
    }

    // —— To list ——
    List<Account>? toList;
    if (_type == TransactionType.partnerTransfer) {
      if (_from == null) {
        toList = _allForPartnerTx;
      } else {
        switch (_from!.type) {
          case AccountType.personal:
            toList = [..._partners, ..._vendors];
            break;
          case AccountType.partner:
            toList = [..._personal, ..._vendors];
            break;
          case AccountType.vendor:
            toList = [..._personal, ..._partners];
            break;
          case AccountType.incomeSource:
            toList = [..._personal];
            break;
          default:
            toList = _allForPartnerTx;
        }
      }
    } else if (_type == TransactionType.transfer) {
      toList = _personal.where((a) => a != _from).toList();
    } else if (_type == TransactionType.income) {
      toList = _personal;
    }

    // —— Prefix for amount field ——
    final prefix =
        _type == TransactionType.expense
            ? '-'
            : _type == TransactionType.income
            ? '+'
            : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing == null ? 'New Transaction' : 'Edit Transaction',
        ),
        actions: [
          if (widget.existing != null)
            IconButton(icon: Icon(Icons.delete), onPressed: _confirmDelete),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // — Type selector —
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children:
                  _typeLabels.entries.map((e) {
                    final sel = _type == e.key;
                    return SizedBox(
                      width: chipWidth,
                      child: InkWell(
                        onTap:
                            () => setState(() {
                              _type = e.key;
                              _from = _to = _singleAccount = null;
                            }),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                sel
                                    ? _typeColors[e.key]!.withOpacity(0.2)
                                    : null,
                            border: Border.all(
                              color: sel ? _typeColors[e.key]! : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: sel ? _typeColors[e.key]! : Colors.black87,
                              fontWeight: sel ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 16),

            // — Amount —
            TextField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: prefix,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            SizedBox(height: 12),

            // — Single Account (expense/income) —
            if (_type == TransactionType.expense ||
                _type == TransactionType.income) ...[
              DropdownButtonFormField<Account>(
                value: _singleAccount,
                hint: Text('Account'),
                items:
                    fromList
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.name)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _singleAccount = v),
              ),
              SizedBox(height: 12),
            ],

            // — From/To (transfer/partner) —
            if (_type == TransactionType.transfer ||
                _type == TransactionType.partnerTransfer) ...[
              DropdownButtonFormField<Account>(
                value: _from,
                hint: Text('From account'),
                items:
                    fromList
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.name)),
                        )
                        .toList(),
                onChanged:
                    (v) => setState(() {
                      _from = v;
                      _to = null;
                    }),
              ),
              SizedBox(height: 12),
              if (toList != null) ...[
                DropdownButtonFormField<Account>(
                  value: _to,
                  hint: Text('To account'),
                  items:
                      toList
                          .map(
                            (a) =>
                                DropdownMenuItem(value: a, child: Text(a.name)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _to = v),
                ),
                SizedBox(height: 12),
              ],
            ],

            // — Name —
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name (optional)'),
            ),

            // — Category —
            if (_categories.isNotEmpty) ...[
              SizedBox(height: 12),
              DropdownButtonFormField<Account>(
                value: _categoryAccount,
                hint: Text('Category'),
                items:
                    _categories
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _categoryAccount = v),
              ),
            ],

            SizedBox(height: 12),

            // — Note —
            TextField(
              controller: _noteCtrl,
              decoration: InputDecoration(labelText: 'Note'),
            ),

            SizedBox(height: 12),

            // — Date —
            ListTile(
              title: Text(
                'Date: ${_date.toLocal().toIso8601String().split("T").first}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final p = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (p != null) setState(() => _date = p);
              },
            ),

            SizedBox(height: 24),

            // — Save —
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final raw = double.tryParse(_amountCtrl.text) ?? 0.0;
                final amt = (_type == TransactionType.expense) ? -raw : raw;

                final to =
                    (_type == TransactionType.expense ||
                            _type == TransactionType.income)
                        ? _singleAccount!
                        : _to!;

                final tx = TransactionItem(
                  title:
                      _nameCtrl.text.isNotEmpty
                          ? _nameCtrl.text
                          : _type.toString().split('.').last,
                  date: _date,
                  type: _type,
                  fromAccount: _from,
                  toAccount: to,
                  amount: amt,
                );

                Navigator.pop(context, tx);
              },
            ),

            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Track Screen

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final List<TransactionItem> _realized = List.from(dummyRealized);

  @override
  Widget build(BuildContext context) {
    // sort newest first
    _realized.sort((a, b) => b.date.compareTo(a.date));

    // group by day
    final Map<DateTime, List<TransactionItem>> grouped = {};
    for (var tx in _realized) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      grouped.putIfAbsent(day, () => []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Track')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children:
            grouped.entries.map((entry) {
              final day = entry.key;
              final items = entry.value;

              // actual running balances up to this day
              final proj = computeProjectedBalances(
                dummyAccounts,
                _realized,
                day,
              );

              final avail = proj.entries
                  .where(
                    (e) =>
                        e.key.type == AccountType.personal &&
                        e.key.includeInBalance,
                  )
                  .fold(0.0, (s, e) => s + e.value);
              final liquid = proj.entries
                  .where((e) => e.key.type == AccountType.personal)
                  .fold(0.0, (s, e) => s + e.value);

              final personal =
                  dummyAccounts
                      .where((a) => a.type == AccountType.personal)
                      .toList();
              final partners =
                  dummyAccounts
                      .where((a) => a.type == AccountType.partner)
                      .toList();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${day.day}/${day.month}/${day.year}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Realized transactions
                    ...items.map(
                      (tx) => Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(tx.title),
                          subtitle: Text(tx.toAccount.name),
                          trailing: Text(tx.amount.toStringAsFixed(2)),
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    // Horizontal actual balances
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SummaryCard(label: 'Available', value: avail),
                          SizedBox(width: 8),
                          SummaryCard(label: 'Liquid', value: liquid),
                          SizedBox(width: 8),
                          ...personal.map(
                            (a) => AccountBalanceCard(
                              account: Account(
                                name: a.name,
                                type: a.type,
                                balance: proj[a]!,
                                includeInBalance: a.includeInBalance,
                              ),
                            ),
                          ),
                          ...partners.map(
                            (a) => AccountBalanceCard(
                              account: Account(
                                name: a.name,
                                type: a.type,
                                balance: proj[a]!,
                                includeInBalance: a.includeInBalance,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final tx = await Navigator.push<TransactionItem?>(
            context,
            MaterialPageRoute(builder: (_) => NewTransactionScreen()),
          );
          if (tx != null) {
            setState(() {
              dummyRealized.add(tx);
              _realized.add(tx);
            });
          }
        },
      ),
    );
  }
}

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  TransactionType _type = TransactionType.partnerTransfer;
  DateTime _date = DateTime.now();
  Account? _from;
  Account? _to;
  Account? _singleAccount; // for expense/income
  Account? _categoryAccount;
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  List<Account> get _personal =>
      dummyAccounts.where((a) => a.type == AccountType.personal).toList();
  List<Account> get _partners =>
      dummyAccounts.where((a) => a.type == AccountType.partner).toList();
  List<Account> get _vendors =>
      dummyAccounts.where((a) => a.type == AccountType.vendor).toList();
  List<Account> get _incomeSources =>
      dummyAccounts.where((a) => a.type == AccountType.incomeSource).toList();
  List<Account> get _categories =>
      dummyAccounts.where((a) => a.type == AccountType.category).toList();

  List<Account> get _allForPartnerTx => [
    ..._personal,
    ..._partners,
    ..._vendors,
    ..._incomeSources,
  ];

  static const _typeLabels = {
    TransactionType.partnerTransfer: 'Partner Transaction',
    TransactionType.transfer: 'Internal Transfer',
    TransactionType.expense: 'Expense / Bill',
    TransactionType.income: 'Income / Invoice',
  };
  static const _typeColors = {
    TransactionType.partnerTransfer: Colors.purple,
    TransactionType.transfer: Colors.blue,
    TransactionType.expense: Colors.red,
    TransactionType.income: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = 8.0;
    final chipWidth = (MediaQuery.of(context).size.width - 32 - spacing) / 2;

    // —— build “from” list ——
    List<Account> fromList;
    if (_type == TransactionType.partnerTransfer) {
      fromList = _allForPartnerTx;
    } else if (_type == TransactionType.transfer) {
      fromList = _personal;
    } else {
      fromList = [..._personal, ..._partners];
    }

    // —— build “to” list ——
    List<Account>? toList;
    if (_type == TransactionType.partnerTransfer) {
      if (_from == null) {
        toList = _allForPartnerTx;
      } else {
        switch (_from!.type) {
          case AccountType.personal:
            toList = [..._partners, ..._vendors];
            break;
          case AccountType.partner:
            toList = [..._personal, ..._vendors];
            break;
          case AccountType.vendor:
            toList = [..._personal, ..._partners];
            break;
          case AccountType.incomeSource:
            toList = [..._personal];
            break;
          default:
            toList = _allForPartnerTx;
        }
      }
    } else if (_type == TransactionType.transfer) {
      toList = _personal.where((a) => a != _from).toList();
    } else if (_type == TransactionType.income) {
      toList = _personal;
    }

    // —— prefix for amount field ——
    final prefix =
        _type == TransactionType.expense
            ? '-'
            : _type == TransactionType.income
            ? '+'
            : null;

    return Scaffold(
      appBar: AppBar(title: Text('New Transaction')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // — Type selector (2×2 grid) —
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children:
                  _typeLabels.entries.map((e) {
                    final sel = _type == e.key;
                    return SizedBox(
                      width: chipWidth,
                      child: InkWell(
                        onTap:
                            () => setState(() {
                              _type = e.key;
                              _from = _to = _singleAccount = null;
                            }),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                sel
                                    ? _typeColors[e.key]!.withOpacity(0.2)
                                    : null,
                            border: Border.all(
                              color: sel ? _typeColors[e.key]! : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: sel ? _typeColors[e.key]! : Colors.black87,
                              fontWeight: sel ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 16),

            // — Amount —
            TextField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: prefix,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            SizedBox(height: 12),

            // — Single Account for Expense/Income —
            if (_type == TransactionType.expense ||
                _type == TransactionType.income) ...[
              DropdownButtonFormField<Account>(
                value: _singleAccount,
                hint: Text('Account'),
                items:
                    fromList
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.name)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _singleAccount = v),
              ),
              SizedBox(height: 12),
            ],

            // — From & To for Transfer & PartnerTransfer —
            if (_type == TransactionType.transfer ||
                _type == TransactionType.partnerTransfer) ...[
              DropdownButtonFormField<Account>(
                value: _from,
                hint: Text('From account'),
                items:
                    fromList
                        .map(
                          (a) =>
                              DropdownMenuItem(value: a, child: Text(a.name)),
                        )
                        .toList(),
                onChanged:
                    (v) => setState(() {
                      _from = v;
                      _to = null;
                    }),
              ),
              SizedBox(height: 12),
              if (toList != null) ...[
                DropdownButtonFormField<Account>(
                  value: _to,
                  hint: Text('To account'),
                  items:
                      toList
                          .map(
                            (a) =>
                                DropdownMenuItem(value: a, child: Text(a.name)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _to = v),
                ),
                SizedBox(height: 12),
              ],
            ],

            // — Optional Name —
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name (optional)'),
            ),

            // — Category —
            if (_categories.isNotEmpty) ...[
              SizedBox(height: 12),
              DropdownButtonFormField<Account>(
                value: _categoryAccount,
                hint: Text('Category'),
                items:
                    _categories
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _categoryAccount = v),
              ),
            ],

            SizedBox(height: 12),

            // — Note —
            TextField(
              controller: _noteCtrl,
              decoration: InputDecoration(labelText: 'Note'),
            ),

            SizedBox(height: 12),

            // — Date —
            ListTile(
              title: Text(
                'Date: ${_date.toLocal().toIso8601String().split("T").first}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final p = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (p != null) setState(() => _date = p);
              },
            ),

            SizedBox(height: 24),

            // — Save —
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final raw = double.tryParse(_amountCtrl.text) ?? 0.0;
                final amt = _type == TransactionType.expense ? -raw : raw;

                // pick fromAccount only for transfers
                final Account? fromAcc =
                    (_type == TransactionType.transfer ||
                            _type == TransactionType.partnerTransfer)
                        ? _from
                        : null;

                // pick toAccount: singleAccount for expense/income, else _to
                final Account toAcc =
                    (_type == TransactionType.expense ||
                            _type == TransactionType.income)
                        ? _singleAccount!
                        : _to!;

                // update category balance if needed
                if (_categoryAccount != null) {
                  final idx = dummyAccounts.indexWhere(
                    (a) => a.name == _categoryAccount!.name,
                  );
                  if (idx != -1) {
                    final c = dummyAccounts[idx];
                    dummyAccounts[idx] = Account(
                      name: c.name,
                      type: c.type,
                      balance: c.balance + raw.abs(),
                      includeInBalance: c.includeInBalance,
                    );
                  }
                }

                final tx = TransactionItem(
                  title:
                      _nameCtrl.text.isNotEmpty
                          ? _nameCtrl.text
                          : _type.toString().split('.').last,
                  date: _date,
                  type: _type,
                  fromAccount: fromAcc,
                  toAccount: toAcc,
                  amount: amt,
                );

                Navigator.pop(context, tx);
              },
            ),

            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
// Review Screen

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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

class NewReviewAccountScreen extends StatefulWidget {
  const NewReviewAccountScreen({super.key});

  @override
  _NewReviewAccountScreenState createState() => _NewReviewAccountScreenState();
}

class _NewReviewAccountScreenState extends State<NewReviewAccountScreen> {
  ReviewAccountType _rtype = ReviewAccountType.budget;
  final _nameCtrl = TextEditingController();
  final _balCtrl = TextEditingController(text: '0');

  static const Map<ReviewAccountType, String> _typeLabels = {
    ReviewAccountType.budget: 'Budget',
    ReviewAccountType.category: 'Category',
    ReviewAccountType.vendor: 'Vendor',
    ReviewAccountType.incomeSource: 'Income Source',
  };

  @override
  Widget build(BuildContext context) {
    // compute width so two fit per row (minus padding + spacing)
    final totalPadding = 16.0 * 2;
    final spacing = 8.0;
    final chipWidth =
        (MediaQuery.of(context).size.width - totalPadding - spacing) / 2;

    return Scaffold(
      appBar: AppBar(title: Text('New Review Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ——— 2×2 Grid of “Chips” ———
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children:
                  _typeLabels.entries.map((entry) {
                    final type = entry.key;
                    final selected = _rtype == type;
                    return SizedBox(
                      width: chipWidth,
                      child: InkWell(
                        onTap: () => setState(() => _rtype = type),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                            border: Border.all(
                              color:
                                  selected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            entry.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 24),

            // ——— Name ———
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name'),
            ),

            SizedBox(height: 12),

            // ——— Starting Balance ———
            TextField(
              controller: _balCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Amount'),
            ),

            Spacer(),

            // ——— Save ———
            ElevatedButton(
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;

                final bal = double.tryParse(_balCtrl.text) ?? 0.0;
                late Account acct;

                switch (_rtype) {
                  case ReviewAccountType.budget:
                    acct = Account(
                      name: name,
                      type: AccountType.budget,
                      balance: bal,
                      includeInBalance: false,
                    );
                    break;
                  case ReviewAccountType.category:
                    acct = Account(
                      name: name,
                      type: AccountType.category,
                      balance: bal,
                      includeInBalance: false,
                    );
                    break;
                  case ReviewAccountType.vendor:
                    acct = Account(
                      name: name,
                      type: AccountType.vendor,
                      balance: bal,
                      includeInBalance: false,
                    );
                    break;
                  case ReviewAccountType.incomeSource:
                    acct = Account(
                      name: name,
                      type: AccountType.incomeSource,
                      balance: bal,
                      includeInBalance: false,
                    );
                    break;
                }

                Navigator.pop(context, acct);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditReviewAccountScreen extends StatefulWidget {
  final Account account;
  const EditReviewAccountScreen({super.key, required this.account});

  @override
  _EditReviewAccountScreenState createState() =>
      _EditReviewAccountScreenState();
}

class _EditReviewAccountScreenState extends State<EditReviewAccountScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _balCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.account.name);
    _balCtrl = TextEditingController(text: widget.account.balance.toString());
  }

  Future<bool?> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete?'),
            content: Text('Remove "${widget.account.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Review Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await _confirmDelete();
              if (confirm == true) Navigator.pop(context, 'delete');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _balCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Current amount'),
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;
                final bal = double.tryParse(_balCtrl.text) ?? 0.0;
                Navigator.pop(
                  context,
                  Account(
                    name: name,
                    type: widget.account.type,
                    balance: bal,
                    includeInBalance: widget.account.includeInBalance,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widgets
class AccountCard extends StatelessWidget {
  final Account account;
  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final bgColor = account.balance >= 0 ? Colors.green[50] : Colors.red[50];
    final textColor =
        account.balance >= 0 ? Colors.green[800] : Colors.red[800];
    return Card(
      color: bgColor,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(account.name),
        //subtitle: Text(account.type.toString().split('.').last),
        trailing: Text(
          account.balance.toStringAsFixed(2),
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AccountBalanceCard extends StatelessWidget {
  final Account account;
  const AccountBalanceCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final isPositive = account.balance >= 0;
    return Card(
      color: isPositive ? Colors.green[50] : Colors.red[50],
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              account.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              account.balance.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  const SummaryCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    return Card(
      color: isPositive ? Colors.green[50] : Colors.red[50],
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
