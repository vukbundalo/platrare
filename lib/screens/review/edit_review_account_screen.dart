import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

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