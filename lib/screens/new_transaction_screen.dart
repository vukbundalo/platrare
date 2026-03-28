import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../models/transaction.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Account? _fromAccount;
  Account? _toAccount;
  String? _category;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double? get _parsedAmount {
    final text = _amountController.text.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    final v = double.tryParse(text);
    if (v == null || v == 0) return null;
    return v;
  }

  bool get _canSave {
    final hasAmount = _parsedAmount != null;
    final hasAccount = _fromAccount != null || _toAccount != null;
    final hasDescription = _descriptionController.text.trim().isNotEmpty;
    final hasCategory = _category != null;

    // Need at least some content
    if (!hasAmount && !hasAccount && !hasDescription && !hasCategory) return false;
    // If there's an amount, must have at least one account
    if (hasAmount && !hasAccount) return false;

    return true;
  }

  void _save() {
    final amount = _parsedAmount;

    if (amount != null) {
      if (_fromAccount != null) _fromAccount!.balance -= amount;
      if (_toAccount != null) _toAccount!.balance += amount;
    }

    data.transactions.insert(
      0,
      Transaction(
        amount: amount,
        fromAccount: _fromAccount,
        toAccount: _toAccount,
        category: _category,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: _date,
      ),
    );

    setState(() {
      _amountController.clear();
      _descriptionController.clear();
      _fromAccount = null;
      _toAccount = null;
      _category = null;
      _date = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction saved'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<Account?> _showAccountPicker({Account? exclude}) {
    return showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _AccountPickerSheet(exclude: exclude),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final isToday = DateUtils.dateOnly(_date) == today;
    final isYesterday =
        DateUtils.dateOnly(_date) == today.subtract(const Duration(days: 1));

    String dateLabel;
    if (isToday) {
      dateLabel = 'Today';
    } else if (isYesterday) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = DateFormat('dd MMM').format(_date);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        actions: [
          TextButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(dateLabel),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: theme.textTheme.headlineMedium,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '€ ',
                border: const OutlineInputBorder(),
                prefixStyle: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // FROM
            _AccountTile(
              label: 'From',
              account: _fromAccount,
              onTap: () async {
                final a = await _showAccountPicker(exclude: _toAccount);
                if (a != null) setState(() => _fromAccount = a);
              },
              onClear: _fromAccount != null
                  ? () => setState(() => _fromAccount = null)
                  : null,
            ),
            const SizedBox(height: 8),

            // TO
            _AccountTile(
              label: 'To',
              account: _toAccount,
              onTap: () async {
                final a = await _showAccountPicker(exclude: _fromAccount);
                if (a != null) setState(() => _toAccount = a);
              },
              onClear: _toAccount != null
                  ? () => setState(() => _toAccount = null)
                  : null,
            ),
            const SizedBox(height: 16),

            // Category
            Text('Category', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: data.categories.map((cat) {
                final selected = _category == cat;
                return FilterChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _category = selected ? null : cat),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Save
            FilledButton(
              onPressed: _canSave ? _save : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final String label;
  final Account? account;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _AccountTile({
    required this.label,
    required this.account,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAccount = account != null;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: hasAccount
              ? (account!.group == AccountGroup.personal
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.tertiaryContainer)
              : theme.colorScheme.surfaceContainerHighest,
          child: Text(
            hasAccount ? account!.name[0].toUpperCase() : label[0],
            style: TextStyle(
              color: hasAccount
                  ? (account!.group == AccountGroup.personal
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onTertiaryContainer)
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(label, style: theme.textTheme.labelMedium),
        subtitle: hasAccount
            ? Text(account!.name, style: theme.textTheme.bodyLarge)
            : Text(
                'Select account',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
        trailing: onClear != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClear,
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _AccountPickerSheet extends StatelessWidget {
  final Account? exclude;

  const _AccountPickerSheet({this.exclude});

  String _formatBalance(double balance) {
    final sign = balance >= 0 ? '+' : '';
    return '$sign€ ${balance.abs().toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal && a != exclude)
        .toList();
    final partner = data.accounts
        .where((a) => a.group == AccountGroup.partner && a != exclude)
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (ctx, ctrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select Account',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              controller: ctrl,
              children: [
                if (personal.isNotEmpty) ...[
                  _sectionHeader(context, 'Personal'),
                  ...personal.map(
                    (a) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          a.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(a.name),
                      subtitle: Text(
                        _formatBalance(a.balance),
                        style: TextStyle(
                          color: a.balance >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (partner.isNotEmpty) ...[
                  _sectionHeader(context, 'Partner'),
                  ...partner.map(
                    (a) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        child: Text(
                          a.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(a.name),
                      subtitle: Text(
                        _formatBalance(a.balance),
                        style: TextStyle(
                          color: a.balance >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
