import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

enum ReviewAccountType {category, vendor, incomeSource }



/// Screen for creating a new review item (Category, Vendor, or Income Source)
class NewReviewAccountScreen extends StatefulWidget {
  const NewReviewAccountScreen({super.key});

  @override
  NewReviewAccountScreenState createState() => NewReviewAccountScreenState();
}

class NewReviewAccountScreenState extends State<NewReviewAccountScreen> {
  final _nameCtrl = TextEditingController();
  final _balCtrl = TextEditingController(text: '0');


  /// Currently selected type
  ReviewAccountType _rtype = ReviewAccountType.category;

  static const Map<ReviewAccountType, String> _typeLabels = {
    ReviewAccountType.category: 'Category',
    ReviewAccountType.vendor: 'Vendor',
    ReviewAccountType.incomeSource: 'Income Source',
  };

  @override
  Widget build(BuildContext context) {
    final totalPadding = 16.0 * 2;
    final spacing = 8.0;
    final chipWidth = (MediaQuery.of(context).size.width - totalPadding - spacing) / 2;

    return Scaffold(
      appBar: AppBar(title: const Text('New Review Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 2×2 grid of type selector chips
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: _typeLabels.entries.map((entry) {
                final type = entry.key;
                final selected = _rtype == type;
                return SizedBox(
                  width: chipWidth,
                  child: InkWell(
                    onTap: () => setState(() => _rtype = type),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: selected
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

            const SizedBox(height: 24),

            // Name input
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 12),

            // Starting balance input
            TextField(
              controller: _balCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            const Spacer(),

            // Save button
            ElevatedButton(
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;

                final bal = double.tryParse(_balCtrl.text) ?? 0.0;
                late final Account acct;

                switch (_rtype) {
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
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
