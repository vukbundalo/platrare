// lib/screens/track/new_track_transaction_screen.dart

import 'package:flutter/material.dart';
import 'package:platrare/data/dummy_accounts.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction_item.dart';

class NewTrackTransactionScreen extends StatefulWidget {
  final TransactionItem? existing;
  const NewTrackTransactionScreen({Key? key, this.existing}) : super(key: key);

  @override
  NewTrackTransactionScreenState createState() =>
      NewTrackTransactionScreenState();
}

class NewTrackTransactionScreenState
    extends State<NewTrackTransactionScreen> {
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
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (sure == true) Navigator.pop(context, 'delete');
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
    final chipWidth =
        (MediaQuery.of(context).size.width - 32 - spacing) / 2;

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

    final prefix = _type == TransactionType.expense
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
            IconButton(icon: const Icon(Icons.delete), onPressed: _confirmDelete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          // — Type selector —
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: _typeLabels.entries.map((e) {
              final sel = _type == e.key;
              return SizedBox(
                width: chipWidth,
                child: InkWell(
                  onTap: () => setState(() {
                    _type = e.key;
                    _from = _to = _singleAccount = _categoryAccount = null;
                  }),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: sel ? _typeColors[e.key]!.withOpacity(0.2) : null,
                      border: Border.all(color: sel ? _typeColors[e.key]! : Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(e.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: sel ? _typeColors[e.key]! : Colors.black87,
                            fontWeight: sel ? FontWeight.bold : null)),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // — Amount —
          TextField(
            controller: _amountCtrl,
            decoration: InputDecoration(labelText: 'Amount', prefixText: prefix),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),

          // — Single account for expense/income —
          if (_type == TransactionType.expense || _type == TransactionType.income) ...[
            DropdownButtonFormField<Account>(
              value: _singleAccount,
              hint: const Text('Account'),
              items: fromList
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                  .toList(),
              onChanged: (v) => setState(() => _singleAccount = v),
            ),
            const SizedBox(height: 12),
          ],

          // — From/To for transfers —
          if (_type == TransactionType.transfer ||
              _type == TransactionType.partnerTransfer) ...[
            DropdownButtonFormField<Account>(
              value: _from,
              hint: const Text('From account'),
              items: fromList
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                  .toList(),
              onChanged: (v) => setState(() {
                _from = v;
                _to = null;
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Account>(
              value: _to,
              hint: const Text('To account'),
              items: toList!
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                  .toList(),
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
            bool canPickCategory;
            switch (_type) {
              case TransactionType.expense:
              case TransactionType.income:
                canPickCategory = _singleAccount?.type == AccountType.personal;
                break;
              case TransactionType.partnerTransfer:
                canPickCategory = _from?.type == AccountType.personal;
                break;
              case TransactionType.transfer:
                canPickCategory = false;
                break;
            }
            if (canPickCategory && availableCategories.isNotEmpty) {
              return [
                DropdownButtonFormField<Account>(
                  value: _categoryAccount,
                  hint: const Text('Category'),
                  items: availableCategories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoryAccount = v),
                ),
                const SizedBox(height: 12),
              ];
            }
            return <Widget>[];
          })(),

          // — Note (optional) —
          TextField(
            controller: _noteCtrl,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
          const SizedBox(height: 12),

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

          const SizedBox(height: 24),

          // — Save —
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              final raw = double.tryParse(_amountCtrl.text) ?? 0.0;
              final amt = (_type == TransactionType.expense) ? -raw : raw;
              final fromAcc = (_type == TransactionType.transfer ||
                      _type == TransactionType.partnerTransfer)
                  ? _from
                  : null;
              final toAcc =
                  (_type == TransactionType.expense || _type == TransactionType.income)
                      ? _singleAccount!
                      : _to!;

              final tx = TransactionItem(
                title: _nameCtrl.text.isNotEmpty ? _nameCtrl.text : _type.name,
                date: _date,
                type: _type,
                fromAccount: fromAcc,
                toAccount: toAcc,
                amount: amt,
                category: _categoryAccount,
              );
              Navigator.pop(context, tx);
            },
          ),

          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ]),
      ),
    );
  }
}
