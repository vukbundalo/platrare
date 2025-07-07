import 'package:flutter/material.dart';

void main() => runApp(PlatrareApp());

class PlatrareApp extends StatelessWidget {
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

enum AccountType { personal, partner, vendor, incomeSource, budget, category }

List<String> dummyCategories = [];

enum ReviewAccountType { budget, category, vendor, incomeSource }

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
    name: 'Savings',
    type: AccountType.personal,
    balance: 1400.0,
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

class AccountsScreen extends StatefulWidget {
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
  const EditAccountScreen({Key? key, required this.account}) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late AccountType _type;
  late TextEditingController _nameCtrl;
  late TextEditingController _balCtrl;
  late bool _includeInAvailableBalance;

  static const Map<AccountType, String> _labels = {
    AccountType.personal: 'Personal',
    AccountType.partner: 'Partner',
  };

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
    if (confirm == true) Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    // make two equal-width chips per row
    final totalPad = 16.0 * 2;
    final spacing = 8.0;
    final chipW = (MediaQuery.of(context).size.width - totalPad - spacing) / 2;

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
          children: [
            // — 2-column “chips” for personal/partner —
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children:
                  _labels.entries.map((e) {
                    final sel = _type == e.key;
                    return SizedBox(
                      width: chipW,
                      child: InkWell(
                        onTap: () => setState(() => _type = e.key),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                sel
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                            border: Border.all(
                              color:
                                  sel
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: sel ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 24),

            // — Name & Balance —
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _balCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Starting Balance'),
            ),

            // — Include toggle only for Personal —
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

            // — Save Button —
            ElevatedButton(
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;

                final bal = double.tryParse(_balCtrl.text) ?? 0.0;
                final updated = Account(
                  name: name,
                  type: _type,
                  balance: bal,
                  includeInBalance: _includeInAvailableBalance,
                );
                Navigator.pop(context, updated);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Reuse your existing models:
enum TransactionType { expense, income, transfer, partnerTransfer }

const Map<TransactionType, List<String>> _categories = {
  TransactionType.expense: ['Food', 'Transport', 'Utilities', 'Shopping'],
  TransactionType.income: ['Salary', 'Gift', 'Interest'],
  TransactionType.transfer: [],
  TransactionType.partnerTransfer: [],
};

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // start with your dummyTransactions
  List<TransactionItem> _planned = List.from(dummyTransactions);

  @override
  Widget build(BuildContext context) {
    // group by date
    final grouped = <DateTime, List<TransactionItem>>{};
    for (var tx in _planned) {
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
        onPressed: () async {
          final newTx = await Navigator.push<TransactionItem?>(
            context,
            MaterialPageRoute(builder: (_) => NewTransactionScreen()),
          );
          if (newTx != null) {
            setState(() => _planned.add(newTx));
          }
        },
      ),
    );
  }
}

class NewTransactionScreen extends StatefulWidget {
  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  TransactionType _type = TransactionType.partnerTransfer;
  DateTime _date = DateTime.now();
  Account? _from;
  Account? _to;
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
    TransactionType.partnerTransfer: 'Partner Transfer',
    TransactionType.transfer: 'Transfer',
    TransactionType.expense: 'Expense',
    TransactionType.income: 'Income',
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

    // From list
    final fromList =
        (_type == TransactionType.partnerTransfer)
            ? [..._personal, ..._partners, ..._vendors, ..._incomeSources]
            : (_type == TransactionType.transfer ||
                _type == TransactionType.expense)
            ? _personal
            : <Account>[];

    // To list
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

    // choose prefix for amount
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
          children: [
            // type selector
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
                              _from = _to = null;
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

            // Amount with dynamic prefix
            TextField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: prefix,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            SizedBox(height: 12),

            // From account (hide for Income)
            if (_type != TransactionType.income) ...[
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
            ],

            // To account
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

            // Name
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Name (optional)'),
            ),

            // Category
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

            // Note
            TextField(
              controller: _noteCtrl,
              decoration: InputDecoration(labelText: 'Note'),
            ),

            SizedBox(height: 12),

            // Date
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

            // Save
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final raw = double.tryParse(_amountCtrl.text) ?? 0.0;
                final amt = _type == TransactionType.expense ? -raw : raw;
                final target =
                    (_type == TransactionType.income ? _to! : (_to ?? _from!));

                // update category balance
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
                  amount: amt,
                  account: target,
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

// review_screen.dart

// review_screen.dart

class ReviewScreen extends StatefulWidget {
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
    budgetList     = dummyAccounts.where((a) => a.type==AccountType.budget).toList();
    categoryList   = dummyAccounts.where((a) => a.type==AccountType.category).toList();
    vendorList     = dummyAccounts.where((a) => a.type==AccountType.vendor).toList();
    incomeList     = dummyAccounts.where((a) => a.type==AccountType.incomeSource).toList();
  }

  Future<void> _editOrDelete(Account acc, List<Account> list) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => EditReviewAccountScreen(account: acc)),
    );
    if (result is Account) {
      // update global
      final gi = dummyAccounts.indexWhere((a)=>a.name==acc.name);
      if(gi!=-1) dummyAccounts[gi] = result;
      // update local
      final li = list.indexOf(acc);
      setState(() => list[li] = result);
    } else if (result=='delete') {
      setState(() {
        dummyAccounts.removeWhere((a)=>a.name==acc.name);
        list.remove(acc);
      });
    }
  }

  Widget _buildSection(String title, List<Account> list, Key key) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical:16),
        child: Center(child: Text('No $title yet.', style:TextStyle(color:Colors.grey))),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        SectionHeader(title),
        ReorderableListView(
          key: key,
          buildDefaultDragHandles: false,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
proxyDecorator: (child, index, animation) => child,
          onReorder:(oldIndex,newIndex){
            setState(() {
              if(newIndex>oldIndex)newIndex--;
              final acct=list.removeAt(oldIndex);
              list.insert(newIndex,acct);
            });
          },
          children:[
            for(var acct in list)
              ReorderableDragStartListener(
                key: ValueKey(acct.name),
                index: list.indexOf(acct),
                child: GestureDetector(
                  onTap: ()=>_editOrDelete(acct,list),
                  child: AccountCard(account:acct),
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
          SizedBox(height:24),
          _buildSection('Categories', categoryList, ValueKey('c')),
          SizedBox(height:24),
          _buildSection('Vendors', vendorList, ValueKey('v')),
          SizedBox(height:24),
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
          if (result!=null) {
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
              decoration: InputDecoration(labelText: 'Starting Balance'),
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
  const EditReviewAccountScreen({Key? key, required this.account}) : super(key: key);

  @override
  _EditReviewAccountScreenState createState() => _EditReviewAccountScreenState();
}

class _EditReviewAccountScreenState extends State<EditReviewAccountScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _balCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.account.name);
    _balCtrl  = TextEditingController(text: widget.account.balance.toString());
  }

  Future<bool?> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
        title: Text('Edit Item'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await _confirmDelete();
              if (confirm == true) Navigator.pop(context, 'delete');
            },
          )
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
              decoration: InputDecoration(labelText: 'Starting Balance'),
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;
                final bal = double.tryParse(_balCtrl.text) ?? 0.0;
                Navigator.pop(context, Account(
                  name: name,
                  type: widget.account.type,
                  balance: bal,
                  includeInBalance: widget.account.includeInBalance,
                ));
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
