import 'package:flutter/material.dart';

void main() => runApp(PlatrareApp());

class PlatrareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platrare',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

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

enum AccountType { personal, partner, budget }

class TransactionItem {
  final String title;
  final DateTime date;
  final double amount;
  final Account account;

  TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.account,
  });
}

// Dummy data
List<Account> dummyAccounts = [
  Account(
    name: 'Cash',
    type: AccountType.personal,
    balance: 200.0,
    includeInBalance: true,
  ),
  Account(
    name: 'Savings',
    type: AccountType.personal,
    balance: 1500.0,
    includeInBalance: true,
  ),
  Account(
    name: 'Pocket Change',
    type: AccountType.personal,
    balance: 50.0,
    includeInBalance: false,
  ),
  Account(
    name: 'Partner: Alice',
    type: AccountType.partner,
    balance: -50.0,
    includeInBalance: false,
  ),
  Account(
    name: 'Partner: Bob',
    type: AccountType.partner,
    balance: 120.0,
    includeInBalance: false,
  ),
  Account(
    name: 'Food Budget',
    type: AccountType.budget,
    balance: 300.0,
    includeInBalance: false,
  ),
];

List<TransactionItem> dummyTransactions = [
  TransactionItem(
    title: 'Grocery Shopping',
    date: DateTime.now().subtract(Duration(days: 1)),
    amount: -45.0,
    account: dummyAccounts[0],
  ),
  TransactionItem(
    title: 'Salary',
    date: DateTime.now().subtract(Duration(days: 2)),
    amount: 1000.0,
    account: dummyAccounts[1],
  ),
];

// Home Page
class HomePage extends StatefulWidget {
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

// Accounts Screen with edit, delete, and reordering
class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late List<Account> personalList;
  late List<Account> partnerList;
  late List<Account> budgetList;

  @override
  void initState() {
    super.initState();
    personalList =
        dummyAccounts.where((a) => a.type == AccountType.personal).toList();
    partnerList =
        dummyAccounts.where((a) => a.type == AccountType.partner).toList();
    budgetList =
        dummyAccounts.where((a) => a.type == AccountType.budget).toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableBalance = personalList
        .where((a) => a.includeInBalance)
        .fold(0.0, (sum, a) => sum + a.balance);
    final liquidAssets = personalList.fold(0.0, (sum, a) => sum + a.balance);
    final partnersBalance = partnerList.fold(0.0, (sum, a) => sum + a.balance);
    final netWorth = liquidAssets + partnersBalance;

    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _summaryCard('Available Balance', availableBalance),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: _summaryCard('Liquid Assets', liquidAssets)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _summaryCard('Partners Balance', partnersBalance),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: _summaryCard('Net Worth', netWorth)),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),

          SectionHeader('Personal Accounts'),
          if (personalList.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No personal accounts yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ReorderableListView(
              key: ValueKey('personal'),
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) => child,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = personalList.removeAt(oldIndex);
                  personalList.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < personalList.length; i++)
                  ReorderableDragStartListener(
                    key: ValueKey(personalList[i].name),
                    index: i,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder:
                                (_) =>
                                    EditAccountScreen(account: personalList[i]),
                          ),
                        );
                        if (result is Account) {
                          setState(() {
                            personalList[i] = result;
                            final idx = dummyAccounts.indexWhere(
                              (a) => a.name == result.name,
                            );
                            dummyAccounts[idx] = result;
                          });
                        } else if (result == 'delete') {
                          setState(() {
                            dummyAccounts.remove(personalList[i]);
                            personalList.removeAt(i);
                          });
                        }
                      },
                      child: AccountCard(account: personalList[i]),
                    ),
                  ),
              ],
            ),
          SizedBox(height: 24),

          SectionHeader('Partner Accounts'),
          if (partnerList.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No partner\'s accounts yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ReorderableListView(
              key: ValueKey('partner'),
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) => child,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = partnerList.removeAt(oldIndex);
                  partnerList.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < partnerList.length; i++)
                  ReorderableDragStartListener(
                    key: ValueKey(partnerList[i].name),
                    index: i,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder:
                                (_) =>
                                    EditAccountScreen(account: partnerList[i]),
                          ),
                        );
                        if (result is Account) {
                          setState(() {
                            partnerList[i] = result;
                            final idx = dummyAccounts.indexWhere(
                              (a) => a.name == result.name,
                            );
                            dummyAccounts[idx] = result;
                          });
                        } else if (result == 'delete') {
                          setState(() {
                            dummyAccounts.remove(partnerList[i]);
                            partnerList.removeAt(i);
                          });
                        }
                      },
                      child: AccountCard(account: partnerList[i]),
                    ),
                  ),
              ],
            ),
          SizedBox(height: 24),

          SectionHeader('Budget Accounts'),
          if (budgetList.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No budgets yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ReorderableListView(
              key: ValueKey('budget'),
              buildDefaultDragHandles: false,
              proxyDecorator: (child, index, animation) => child,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = budgetList.removeAt(oldIndex);
                  budgetList.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < budgetList.length; i++)
                  ReorderableDragStartListener(
                    key: ValueKey(budgetList[i].name),
                    index: i,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder:
                                (_) =>
                                    EditAccountScreen(account: budgetList[i]),
                          ),
                        );
                        if (result is Account) {
                          setState(() {
                            budgetList[i] = result;
                            final idx = dummyAccounts.indexWhere(
                              (a) => a.name == result.name,
                            );
                            dummyAccounts[idx] = result;
                          });
                        } else if (result == 'delete') {
                          setState(() {
                            dummyAccounts.remove(budgetList[i]);
                            budgetList.removeAt(i);
                          });
                        }
                      },
                      child: AccountCard(account: budgetList[i]),
                    ),
                  ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(builder: (_) => NewAccountScreen()),
          );
          if (result is Account) {
            setState(() {
              dummyAccounts.add(result);
              switch (result.type) {
                case AccountType.personal:
                  personalList.add(result);
                  break;
                case AccountType.partner:
                  partnerList.add(result);
                  break;
                case AccountType.budget:
                  budgetList.add(result);
                  break;
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
        padding: EdgeInsets.all(12),
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

// New Account Screen
class NewAccountScreen extends StatefulWidget {
  @override
  _NewAccountScreenState createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  AccountType _type = AccountType.personal;
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  bool _includeInAvailableBalance = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Account')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  AccountType.values.map((type) {
                    final label = type.toString().split('.').last;
                    return ChoiceChip(
                      label: Text(label[0].toUpperCase() + label.substring(1)),
                      selected: _type == type,
                      onSelected: (_) => setState(() => _type = type),
                    );
                  }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Balance'),
            ),
            if (_type == AccountType.personal)
              SwitchListTile(
                title: Text('Include in Available Balance'),
                value: _includeInAvailableBalance,
                onChanged:
                    (v) => setState(() => _includeInAvailableBalance = v),
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final account = Account(
                    name: _nameController.text.trim(),
                    type: _type,
                    balance: double.tryParse(_balanceController.text) ?? 0.0,
                    includeInBalance: _includeInAvailableBalance,
                  );
                  Navigator.pop(context, account);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Account Screen
class EditAccountScreen extends StatefulWidget {
  final Account account;
  const EditAccountScreen({Key? key, required this.account}) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late AccountType _type;
  late TextEditingController _nameCtrl;
  late TextEditingController _balCtrl;
  late bool _includeInAvailableBalance = true;

  @override
  void initState() {
    super.initState();
    _type = widget.account.type;
    _nameCtrl = TextEditingController(text: widget.account.name);
    _balCtrl = TextEditingController(text: widget.account.balance.toString());
    _includeInAvailableBalance = widget.account.includeInBalance;
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete Account?'),
            content: Text('This action cannot be undone.'),
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
    if (confirm == true) {
      Navigator.pop<dynamic>(context, 'delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: _confirmDelete),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  AccountType.values.map((type) {
                    final label = type.toString().split('.').last;
                    return ChoiceChip(
                      label: Text(label[0].toUpperCase() + label.substring(1)),
                      selected: _type == type,
                      onSelected: (_) => setState(() => _type = type),
                    );
                  }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _balCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Balance'),
            ),
            if (_type == AccountType.personal)
              SwitchListTile(
                title: Text('Include in Available Balance'),
                value: _includeInAvailableBalance,
                onChanged:
                    (v) => setState(() => _includeInAvailableBalance = v),
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final updated = Account(
                    name: _nameCtrl.text.trim(),
                    type: _type,
                    balance: double.tryParse(_balCtrl.text) ?? 0.0,
                    includeInBalance: _includeInAvailableBalance,
                  );
                  Navigator.pop(context, updated);
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grouped = <DateTime, List<TransactionItem>>{};
    for (var tx in dummyTransactions) {
      final date = DateTime(tx.date.year, tx.date.month, tx.date.day);
      grouped[date] = [...(grouped[date] ?? []), tx];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Plan')),
      body: ListView(
        children:
            grouped.entries.map((entry) {
              final date = entry.key;
              final items = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...items.map(
                      (tx) => Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(tx.title),
                          subtitle: Text(tx.account.name),
                          trailing: Text(tx.amount.toStringAsFixed(2)),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dummyAccounts.length + 1,
                        itemBuilder: (context, idx) {
                          if (idx == 0) {
                            final sum = dummyAccounts.fold<double>(
                              0,
                              (prev, a) =>
                                  prev + (a.includeInBalance ? a.balance : 0),
                            );
                            return SummaryCard(label: 'Net Worth', value: sum);
                          }
                          final acc = dummyAccounts[idx - 1];
                          return AccountBalanceCard(account: acc);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class TrackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track')),
      body: Center(
        child: Text('Track transactions here (similar layout to Plan)'),
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review')),
      body: Center(child: Text('Statistics and charts will be here')),
    );
  }
}

// Reusable Widgets
class AccountCard extends StatelessWidget {
  final Account account;
  const AccountCard({Key? key, required this.account}) : super(key: key);

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
  SectionHeader(this.title);

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
  AccountBalanceCard({required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(account.name, overflow: TextOverflow.ellipsis),
            SizedBox(height: 4),
            Text(account.balance.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: Colors.white)),
            SizedBox(height: 4),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
