import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../utils/projections.dart' as proj;

class NewPlannedTransactionScreen extends StatefulWidget {
  const NewPlannedTransactionScreen({super.key});

  @override
  State<NewPlannedTransactionScreen> createState() =>
      _NewPlannedTransactionScreenState();
}

class _NewPlannedTransactionScreenState
    extends State<NewPlannedTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Account? _fromAccount;
  Account? _toAccount;
  String? _category;
  // Default to tomorrow so it's clearly a future plan
  DateTime _date = DateTime.now().add(const Duration(days: 1));

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

    if (!hasAmount && !hasAccount && !hasDescription && !hasCategory) {
      return false;
    }
    if (hasAmount && !hasAccount) return false;
    return true;
  }

  void _save() {
    Navigator.pop(
      context,
      PlannedTransaction(
        amount: _parsedAmount,
        fromAccount: _fromAccount,
        toAccount: _toAccount,
        category: _category,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: _date,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      helpText: 'Select planned date',
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
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDay = DateUtils.dateOnly(_date);

    String dateLabel;
    if (selectedDay == today) {
      dateLabel = 'Today';
    } else if (selectedDay == tomorrow) {
      dateLabel = 'Tomorrow';
    } else {
      dateLabel = DateFormat('dd MMM yyyy').format(_date);
    }

    final balances = proj.projectBalances(_date);
    final personal = data.accounts.where((a) => a.group == AccountGroup.personal).toList();
    final partner = data.accounts.where((a) => a.group == AccountGroup.partner).toList();
    final totalPersonal = proj.personalTotal(balances);
    final totalPositive = totalPersonal >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Transaction'),
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
            // Projected balances card
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event, color: theme.colorScheme.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Account snapshot on $dateLabel',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _pickDate,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Change date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Personal total highlight
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: totalPositive
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: totalPositive
                              ? Colors.green.withValues(alpha: 0.3)
                              : Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Personal total',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: totalPositive
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${totalPositive ? '+' : '-'}€${totalPersonal.abs().toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: totalPositive
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (personal.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'PERSONAL',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: personal.map((a) {
                            final bal = balances[a.id] ?? a.balance;
                            final pos = bal >= 0;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: pos
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: pos
                                      ? Colors.green.withValues(alpha: 0.3)
                                      : Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.name,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${pos ? '+' : '-'}€${bal.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: pos
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    if (partner.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'PARTNER',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.tertiary,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: partner.map((a) {
                            final bal = balances[a.id] ?? a.balance;
                            final pos = bal >= 0;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: pos
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: pos
                                      ? Colors.green.withValues(alpha: 0.3)
                                      : Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.name,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${pos ? '+' : '-'}€${bal.abs().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: pos
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

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

            FilledButton(
              onPressed: _canSave ? _save : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Add to Plan', style: TextStyle(fontSize: 18)),
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
        trailing: onClear != null
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
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
          Text('Select Account',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              controller: ctrl,
              children: [
                if (personal.isNotEmpty) ...[
                  _header(context, 'Personal'),
                  ...personal.map((a) => ListTile(
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
                      )),
                ],
                if (partner.isNotEmpty) ...[
                  _header(context, 'Partner'),
                  ...partner.map((a) => ListTile(
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
                      )),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String title) {
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
