// lib/screens/plan/new_planned_transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';

class NewPlannedTransactionScreen extends StatefulWidget {
  final TransactionItem? existing;
  const NewPlannedTransactionScreen({super.key, this.existing});

  @override
  NewPlannedTransactionScreenState createState() =>
      NewPlannedTransactionScreenState();
}

class NewPlannedTransactionScreenState
    extends State<NewPlannedTransactionScreen> {
  TransactionType _type = TransactionType.partnerTransfer;
  DateTime _date = DateTime.now();
  Account? _from, _to, _singleAccount, _categoryAccount;
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  // final _noteCtrl = TextEditingController();

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
      if (_type == TransactionType.transfer ||
          _type == TransactionType.partnerTransfer) {
        _from = ex.fromAccount;
        _to = ex.toAccount;
      } else {
        _singleAccount = ex.toAccount;
      }
      if (ex.toAccount.type == AccountType.category) {
        _categoryAccount = ex.toAccount;
      }
    }
  }

 Future<void> _confirmDelete() async {
  final sure = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
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

  if (sure == true) {
    Navigator.pop(context, 'deleteRule');
  }
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
            toList = [..._partners, ..._vendors, ..._incomeSources];
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
          case AccountType.category:
          case AccountType.budget:
            toList = _allForPartnerTx;
            break;
        }
      }
    } else if (_type == TransactionType.transfer) {
      toList = _personal.where((a) => a != _from).toList();
    } else {
      toList = _personal;
    }

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
              ...[
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
            SizedBox(height: 12),

            // — Category —
            if (_categories.isNotEmpty) ...[
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
              SizedBox(height: 12),
            ],

            // // — Recurrence picker —      ← NEW
            // DropdownButtonFormField<Recurrence>(
            //   value: _recurrence,
            //   decoration: InputDecoration(labelText: 'Repeat'),
            //   items:
            //       Recurrence.values
            //           .map(
            //             (r) => DropdownMenuItem(value: r, child: Text(r.label)),
            //           )
            //           .toList(),
            //   onChanged: (r) => setState(() => _recurrence = r!),
            // ),
            // SizedBox(height: 12),

            // // — Note —
            // TextField(
            //   controller: _noteCtrl,
            //   decoration: InputDecoration(labelText: 'Note'),
            // ),
            // SizedBox(height: 12),

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
                final toAcc =
                    (_type == TransactionType.expense ||
                            _type == TransactionType.income)
                        ? _singleAccount!
                        : _to!;
                final tx = TransactionItem(
                  id: widget.existing?.id,
                  title:
                      _nameCtrl.text.isNotEmpty ? _nameCtrl.text : _type.name,
                  date: _date,
                  type: _type,
                  fromAccount: _from,
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
