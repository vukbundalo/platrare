import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

class NewAccountScreen extends StatefulWidget {
  const NewAccountScreen({super.key});

  @override
  NewAccountScreenState createState() => NewAccountScreenState();
}

class NewAccountScreenState extends State<NewAccountScreen> {
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