import 'package:flutter/material.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  void _addAccount() async {
    final result = await showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const _AccountFormSheet(),
    );
    if (result != null) {
      setState(() => data.accounts.add(result));
    }
  }

  void _editAccount(Account account) async {
    final deleted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _AccountFormSheet(account: account),
    );
    if (deleted == true) {
      setState(() => data.accounts.remove(account));
    } else {
      setState(() {});
    }
  }

  void _addCategory() async {
    final controller = TextEditingController();
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('New Category'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Category name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) =>
                Navigator.pop(ctx, v.trim().isEmpty ? null : v.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final v = controller.text.trim();
                Navigator.pop(ctx, v.isEmpty ? null : v);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
      if (result != null && !data.categories.contains(result)) {
        setState(() => data.categories.add(result));
      }
    } finally {
      controller.dispose();
    }
  }

  void _deleteCategory(String category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text('"$category" will be removed from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => data.categories.remove(category));
            },
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  double get _personalTotal => data.accounts
      .where((a) => a.group == AccountGroup.personal)
      .fold(0.0, (sum, a) => sum + a.balance);

  double get _netTotal =>
      data.accounts.fold(0.0, (sum, a) => sum + a.balance);

  @override
  Widget build(BuildContext context) {
    final personal =
        data.accounts.where((a) => a.group == AccountGroup.personal).toList();
    final partner =
        data.accounts.where((a) => a.group == AccountGroup.partner).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'accounts_fab',
        onPressed: _addAccount,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          // Summary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Personal',
                    amount: _personalTotal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Net (all accounts)',
                    amount: _netTotal,
                  ),
                ),
              ],
            ),
          ),

          if (personal.isNotEmpty) ...[
            _SectionHeader('Personal'),
            ...personal.map(
              (a) => _AccountTile(account: a, onTap: () => _editAccount(a)),
            ),
          ],

          if (partner.isNotEmpty) ...[
            _SectionHeader('Partner'),
            ...partner.map(
              (a) => _AccountTile(account: a, onTap: () => _editAccount(a)),
            ),
          ],

          // Categories
          const SizedBox(height: 8),
          _SectionHeader('Categories'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ...data.categories.map(
                  (cat) => Chip(
                    label: Text(cat),
                    onDeleted: () => _deleteCategory(cat),
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  onPressed: _addCategory,
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;

  const _SummaryCard({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = amount >= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              '${isPositive ? '' : '-'}€ ${amount.abs().toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                color:
                    isPositive ? Colors.green.shade700 : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;

  const _AccountTile({required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = account.balance >= 0;
    final isPersonal = account.group == AccountGroup.personal;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPersonal
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.tertiaryContainer,
        child: Text(
          account.name[0].toUpperCase(),
          style: TextStyle(
            color: isPersonal
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(account.name),
      trailing: Text(
        '${isPositive ? '+' : '-'}€ ${account.balance.abs().toStringAsFixed(2)}',
        style: TextStyle(
          color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _AccountFormSheet extends StatefulWidget {
  final Account? account;

  const _AccountFormSheet({this.account});

  @override
  State<_AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<_AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountGroup _group;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final balance = double.tryParse(
            _balanceController.text.trim().replaceAll(',', '.')) ??
        0.0;

    if (widget.account != null) {
      widget.account!.name = name;
      widget.account!.balance = balance;
      widget.account!.group = _group;
      Navigator.pop(context, false);
    } else {
      Navigator.pop(
        context,
        Account(name: name, group: _group, balance: balance),
      );
    }
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text('This account will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.account != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEdit ? 'Edit Account' : 'New Account',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SegmentedButton<AccountGroup>(
            segments: const [
              ButtonSegment(
                value: AccountGroup.personal,
                label: Text('Personal'),
              ),
              ButtonSegment(
                value: AccountGroup.partner,
                label: Text('Partner'),
              ),
            ],
            selected: {_group},
            onSelectionChanged: (s) => setState(() => _group = s.first),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            autofocus: !isEdit,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Current Balance',
              prefixText: '€ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: Text(isEdit ? 'Save' : 'Add Account'),
          ),
          if (isEdit) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _delete,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
