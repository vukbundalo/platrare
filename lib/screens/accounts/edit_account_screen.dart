import 'package:flutter/material.dart';
import 'package:platrare/models/account.dart';

class EditAccountScreen extends StatefulWidget {
  final Account account;
  const EditAccountScreen({super.key, required this.account});

  @override
  EditAccountScreenState createState() => EditAccountScreenState();
}

class EditAccountScreenState extends State<EditAccountScreen> {
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