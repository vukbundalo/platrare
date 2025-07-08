import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/enums.dart';

class NewReviewAccountScreen extends StatefulWidget {
  const NewReviewAccountScreen({super.key});

  @override
  NewReviewAccountScreenState createState() => NewReviewAccountScreenState();
}

class NewReviewAccountScreenState extends State<NewReviewAccountScreen> {
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