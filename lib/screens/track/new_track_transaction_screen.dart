// lib/screens/track/new_track_transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/data/dummy_templates.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';

class NewTrackTransactionScreen extends StatefulWidget {
  final TransactionItem? existing;
  const NewTrackTransactionScreen({super.key, this.existing});

  @override
  NewTrackTransactionScreenState createState() =>
      NewTrackTransactionScreenState();
}

class NewTrackTransactionScreenState extends State<NewTrackTransactionScreen> {
  TransactionType _type = TransactionType.partnerTransfer;
  DateTime _date = DateTime.now();
  Account? _from, _to, _singleAccount, _categoryAccount;
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  // final _noteCtrl = TextEditingController();
  bool _saveAsTemplate = false;
  final _templateNameCtrl = TextEditingController();

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
  List<Account> get _allForPartner => [
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
    final ex = widget.existing;
    if (ex != null) {
      _type = ex.type;
      _date = ex.date;
      _nameCtrl.text = ex.title;
      _amountCtrl.text = ex.amount.abs().toString();
      _categoryAccount = ex.category;
      if (_type == TransactionType.transfer ||
          _type == TransactionType.partnerTransfer) {
        _from = ex.fromAccount;
        _to = ex.toAccount;
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
            title: const Text('Delete Transaction?'),
            content: const Text('This cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
    if (sure == true) Navigator.pop(context, 'delete');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // Guard against a deleted/stale category:
    final availableCategories = _categories;
    if (_categoryAccount != null &&
        !availableCategories.any((c) => c.name == _categoryAccount!.name)) {
      _categoryAccount = null;
    }

    final spacing = 8.0;
    final chipWidth = (MediaQuery.of(context).size.width - 32 - spacing) / 2;

    // — From list —
    List<Account> fromList;
    if (_type == TransactionType.partnerTransfer) {
      fromList = _allForPartner;
    } else if (_type == TransactionType.transfer) {
      fromList = _personal;
    } else {
      fromList = [..._personal, ..._partners];
    }

    // — To list —
    List<Account>? toList;
    if (_type == TransactionType.partnerTransfer) {
      if (_from == null) {
        toList = _allForPartner;
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
          default:
            toList = _allForPartner;
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
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                              _from =
                                  _to =
                                      _singleAccount = _categoryAccount = null;
                            }),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
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

            const SizedBox(height: 16),

            if (dummyTemplates.isNotEmpty)
              DropdownButtonFormField<TransactionItem>(
                isExpanded: true,
                hint: const Text('Load template…'),
                items:
                    dummyTemplates.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: Text(t.title)),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Text('Delete template?'),
                                        content: Text(
                                          '“${t.title}” will be removed.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                                if (confirm == true) {
                                  setState(() => dummyTemplates.remove(t));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Template “${t.title}” deleted',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                selectedItemBuilder:
                    (_) => dummyTemplates.map((t) => Text(t.title)).toList(),
                onChanged: (tmpl) {
                  if (tmpl == null) return;
                  setState(() {
                    _type = tmpl.type;
                    _date = tmpl.date;
                    _from = tmpl.fromAccount;
                    _to = tmpl.toAccount;
                    _singleAccount =
                        (tmpl.type == TransactionType.expense ||
                                tmpl.type == TransactionType.income)
                            ? tmpl.toAccount
                            : null;
                    _categoryAccount = tmpl.category;
                    _nameCtrl.text = tmpl.title;
                    _amountCtrl.text = tmpl.amount.abs().toString();
                  });
                },
              ),
            const SizedBox(height: 12),

            // — Amount —
            TextField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: prefix,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),

            // — Single account for expense/income —
            if (_type == TransactionType.expense ||
                _type == TransactionType.income) ...[
              DropdownButtonFormField<Account>(
                isExpanded: true,
                value: _singleAccount,
                hint: const Text('Account'),
                items:
                    fromList.map((a) {
                      // same label+badge logic you already have…
                      String typeLabel;
                      Color typeColor;
                      switch (a.type) {
                        case AccountType.personal:
                          typeLabel = 'Personal';
                          typeColor = Colors.blue;
                          break;
                        case AccountType.partner:
                          typeLabel = 'Partner';
                          typeColor = Colors.purple;
                          break;
                        case AccountType.vendor:
                          typeLabel = 'Vendor';
                          typeColor = Colors.red;
                          break;
                        case AccountType.incomeSource:
                          typeLabel = 'Income';
                          typeColor = Colors.green;
                          break;
                        default:
                          typeLabel = '';
                          typeColor = Colors.grey;
                      }
                      return DropdownMenuItem<Account>(
                        value: a,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: Text(a.name)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: typeColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged:
                    (v) => setState(() {
                      _singleAccount = v;
                      _categoryAccount =
                          null; // reset category when account changes
                    }),
              ),
              const SizedBox(height: 12),
            ],

            // — From/To for transfers —
            if (_type == TransactionType.transfer ||
                _type == TransactionType.partnerTransfer) ...[
              DropdownButtonFormField<Account>(
                isExpanded:
                    true, // ensure the dropdown fills the available width
                value: _from,
                hint: const Text('From account'),
                items:
                    fromList.map((a) {
                      // Determine a human‐friendly type label and its color
                      String typeLabel;
                      Color typeColor;
                      switch (a.type) {
                        case AccountType.personal:
                          typeLabel = 'Personal';
                          typeColor = Colors.blue;
                          break;
                        case AccountType.partner:
                          typeLabel = 'Partner';
                          typeColor = Colors.purple;
                          break;
                        case AccountType.vendor:
                          typeLabel = 'Vendor';
                          typeColor = Colors.red;
                          break;
                        case AccountType.incomeSource:
                          typeLabel = 'Income';
                          typeColor = Colors.green;
                          break;
                        default:
                          typeLabel = '';
                          typeColor = Colors.grey;
                      }

                      return DropdownMenuItem<Account>(
                        value: a,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: Text(a.name)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: typeColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged:
                    (v) => setState(() {
                      _from = v;
                      _to = null;
                    }),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Account>(
                isExpanded:
                    true, // ensure the dropdown fills the available width
                value: _to,
                hint: const Text('To account'),
                items:
                    toList.map((a) {
                      // Determine a human‐friendly type label and its color
                      String typeLabel;
                      Color typeColor;
                      switch (a.type) {
                        case AccountType.personal:
                          typeLabel = 'Personal';
                          typeColor = Colors.blue;
                          break;
                        case AccountType.partner:
                          typeLabel = 'Partner';
                          typeColor = Colors.purple;
                          break;
                        case AccountType.vendor:
                          typeLabel = 'Vendor';
                          typeColor = Colors.red;
                          break;
                        case AccountType.incomeSource:
                          typeLabel = 'Income';
                          typeColor = Colors.green;
                          break;
                        default:
                          typeLabel = '';
                          typeColor = Colors.grey;
                      }

                      return DropdownMenuItem<Account>(
                        value: a,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(child: Text(a.name)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: typeColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (v) => setState(() => _to = v),
              ),

              const SizedBox(height: 12),
            ],

            // — Name —
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name (optional)'),
            ),
            const SizedBox(height: 12),
            // — Category (only when allowed) —
            ...(() {
              bool canPickCategory = false;
              switch (_type) {
                case TransactionType.expense:
                  canPickCategory =
                      _singleAccount?.type == AccountType.personal;
                  break;
                case TransactionType.income:
                  canPickCategory = false; // <— never allow on income
                  break;
                case TransactionType.partnerTransfer:
                  canPickCategory = _from?.type == AccountType.personal;
                  break;
                case TransactionType.transfer:
                  canPickCategory = false;
                  break;
              }
              if (canPickCategory && _categories.isNotEmpty) {
                return [
                  DropdownButtonFormField<Account>(
                    value: _categoryAccount,
                    hint: const Text('Category'),
                    items:
                        _categories.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          );
                        }).toList(),
                    onChanged: (v) => setState(() => _categoryAccount = v),
                  ),
                  const SizedBox(height: 12),
                ];
              }
              return <Widget>[];
            })(),

            // // — Note (optional) —
            // TextField(
            //   controller: _noteCtrl,
            //   decoration: const InputDecoration(labelText: 'Note'),
            // ),
            // const SizedBox(height: 12),

            // — Date —
            ListTile(
              title: Text(
                'Date: ${_date.toLocal().toIso8601String().split("T").first}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final today = DateTime.now();
                final p = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: today.subtract(const Duration(days: 365)),
                  lastDate: today,
                );
                if (p != null) setState(() => _date = p);
              },
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('Save as template'),
              value: _saveAsTemplate,
              onChanged:
                  (v) => setState(() {
                    _saveAsTemplate = v;
                    if (!v) _templateNameCtrl.clear();
                  }),
            ),
            if (_saveAsTemplate) ...[
              TextField(
                controller: _templateNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Template name',
                  hintText: 'e.g. “Monthly rent”',
                ),
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 24),

            // — Save —
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final raw = double.tryParse(_amountCtrl.text) ?? 0.0;
                if (raw == 0.0) {
                  _showError('Please enter a non-zero amount.');
                  return;
                }
                final amt = (_type == TransactionType.expense) ? -raw : raw;
                final fromAcc =
                    (_type == TransactionType.transfer ||
                            _type == TransactionType.partnerTransfer)
                        ? _from
                        : null;
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
                  fromAccount: fromAcc,
                  toAccount: toAcc,
                  amount: amt,
                  category: _categoryAccount,
                );

                if (_saveAsTemplate) {
                  if (_templateNameCtrl.text.trim().isEmpty) {
                    _showError('Please enter a template name.');
                    return;
                  }
                  dummyTemplates.add(
                    TransactionItem(
                      title: _templateNameCtrl.text.trim(),
                      date: tx.date,
                      type: tx.type,
                      fromAccount: tx.fromAccount,
                      toAccount: tx.toAccount,
                      amount: tx.amount,
                      category: tx.category,
                    ),
                  );
                }

                Navigator.pop(context, tx);
              },
            ),

            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
