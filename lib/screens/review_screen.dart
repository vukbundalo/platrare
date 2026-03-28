import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../utils/fx.dart' as fx;

class ReviewScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const ReviewScreen({super.key, this.onChanged});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _spendingThisMonth = true;

  // ── Account mutations ──────────────────────────────────────────────────────

  void _addAccount() async {
    final result = await showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const _AccountFormSheet(),
    );
    if (result != null) {
      setState(() => data.accounts.add(result));
      widget.onChanged?.call();
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
    widget.onChanged?.call();
  }

  void _addCategory(List<String> targetList) async {
    final controller = TextEditingController();
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Text('New Category'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration:
                const InputDecoration(labelText: 'Category name'),
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
      if (result != null && !targetList.contains(result)) {
        setState(() => targetList.add(result));
      }
    } finally {
      controller.dispose();
    }
  }

  void _deleteCategory(String category, List<String> targetList) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete category?'),
        content: Text('"$category" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => targetList.remove(category));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Computed values ────────────────────────────────────────────────────────

  // Rule 5: multiply CURRENT native balances by CURRENT live rates.
  // Never sum historical locked baseAmounts for the balance sheet.
  double get _personalTotal => data.accounts
      .where((a) => a.group == AccountGroup.personal && a.includeInBalance)
      .fold(0.0, (sum, a) => sum + fx.toBase(a.balance, a.currencyCode));

  double get _netTotal => data.accounts
      .where((a) => a.includeInBalance)
      .fold(0.0, (sum, a) => sum + fx.toBase(a.balance, a.currencyCode));

  // Returns {category: total} for expense transactions, filtered by period
  Map<String, ({double total, int count})> get _categorySpending {
    final now = DateTime.now();
    final result = <String, ({double total, int count})>{};

    for (final t in data.transactions) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      const expenseTypes = {
        TxType.expense, TxType.settlement, TxType.advance,
      };
      if (!expenseTypes.contains(type)) continue;
      if (t.nativeAmount == null) continue;
      if (_spendingThisMonth &&
          (t.date.year != now.year || t.date.month != now.month)) {
        continue;
      }

      // Rule 3: use the locked baseAmount for historical P&L charts so that
      // past spending totals never mutate when exchange rates change.
      final baseValue = t.baseAmount ??
          fx.toBase(t.nativeAmount!, t.currencyCode ?? 'BAM');

      final key = t.category ?? 'Uncategorized';
      final existing = result[key];
      if (existing == null) {
        result[key] = (total: baseValue, count: 1);
      } else {
        result[key] = (
          total: existing.total + baseValue,
          count: existing.count + 1,
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final individuals = data.accounts
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final entities = data.accounts
        .where((a) => a.group == AccountGroup.entities)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar with net worth ────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: cs.surface,
            title: const Text('Review'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add account',
                onPressed: _addAccount,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
                child: _NetWorthHero(
                  personal: _personalTotal,
                  net: _netTotal,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(bottom: 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Accounts ──────────────────────────────────────────────
                if (personal.isNotEmpty) ...[
                  _SectionLabel('Personal'),
                  ...personal.map(
                    (a) => _AccountCard(
                        account: a, onTap: () => _editAccount(a)),
                  ),
                  const SizedBox(height: 4),
                ],
                if (individuals.isNotEmpty) ...[
                  _SectionLabel('Individuals'),
                  ...individuals.map(
                    (a) => _AccountCard(
                        account: a, onTap: () => _editAccount(a)),
                  ),
                  const SizedBox(height: 4),
                ],
                if (entities.isNotEmpty) ...[
                  _SectionLabel('Entities'),
                  ...entities.map(
                    (a) => _AccountCard(
                        account: a, onTap: () => _editAccount(a)),
                  ),
                  const SizedBox(height: 4),
                ],
                if (personal.isEmpty && individuals.isEmpty && entities.isEmpty)
                  _EmptyAccountsHint(onAdd: _addAccount),

                // ── Spending by category ──────────────────────────────────
                _SpendingSection(
                  spending: _categorySpending,
                  thisMonth: _spendingThisMonth,
                  onToggle: () =>
                      setState(() => _spendingThisMonth = !_spendingThisMonth),
                ),

                // ── Categories management ─────────────────────────────────
                _SectionLabel('Categories'),
                _CategoriesSection(
                  onAddIncome: () => _addCategory(data.incomeCategories),
                  onAddExpense: () => _addCategory(data.expenseCategories),
                  onDeleteIncome: (c) =>
                      _deleteCategory(c, data.incomeCategories),
                  onDeleteExpense: (c) =>
                      _deleteCategory(c, data.expenseCategories),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Net Worth Hero ───────────────────────────────────────────────────────────

class _NetWorthHero extends StatelessWidget {
  final double personal;
  final double net;
  const _NetWorthHero({required this.personal, required this.net});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final netPos = net >= 0;
    final netColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final balanceColor = personal >= 0
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: balanceColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: balanceColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Balance',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  '${personal >= 0 ? '+' : ''}KM${personal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: personal >= 0
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: netColor.withValues(alpha: 0.2),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Net',
                  style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                '${netPos ? '+' : ''}KM${net.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: netColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Spending section ─────────────────────────────────────────────────────────

class _SpendingSection extends StatelessWidget {
  final Map<String, ({double total, int count})> spending;
  final bool thisMonth;
  final VoidCallback onToggle;

  const _SpendingSection({
    required this.spending,
    required this.thisMonth,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount =
        sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalSpent =
        sorted.fold(0.0, (s, e) => s + e.value.total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 6),
          child: Row(
            children: [
              Text('SPENDING',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                      letterSpacing: 0.8)),
              const Spacer(),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        thisMonth
                            ? DateFormat('MMMM').format(DateTime.now())
                            : 'All time',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.swap_horiz_rounded,
                          size: 14, color: cs.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        if (sorted.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pie_chart_outline_rounded,
                        size: 18, color: cs.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Text(
                      thisMonth
                          ? 'No expenses this month'
                          : 'No expenses recorded',
                      style: TextStyle(
                          color: cs.onSurfaceVariant, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          // Total row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.summarize_outlined,
                        size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text('Total spent',
                        style: TextStyle(
                            fontSize: 13, color: cs.onSurfaceVariant)),
                    const Spacer(),
                    Text(
                      '-KM${totalSpent.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDC2626)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Per-category rows
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Column(
                children: sorted.asMap().entries.map((entry) {
                  final isLast = entry.key == sorted.length - 1;
                  final cat = entry.value.key;
                  final info = entry.value.value;
                  final frac =
                      maxAmount > 0 ? info.total / maxAmount : 0.0;
                  return _CategoryRow(
                    category: cat,
                    total: info.total,
                    count: info.count,
                    fraction: frac,
                    isLast: isLast,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final double total;
  final int count;
  final double fraction;
  final bool isLast;

  const _CategoryRow({
    required this.category,
    required this.total,
    required this.count,
    required this.fraction,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const expenseColor = Color(0xFFDC2626);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Category icon
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color:
                          expenseColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        category[0].toUpperCase(),
                        style: const TextStyle(
                          color: expenseColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        Text(
                          '$count transaction${count == 1 ? '' : 's'}',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '-KM${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: expenseColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 4,
                  backgroundColor:
                      expenseColor.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      expenseColor),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 0.5,
            indent: 58,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
      ],
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;
  const _AccountCard({required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPersonal = account.group == AccountGroup.personal;
    final isEntities = account.group == AccountGroup.entities;
    final isPositive = account.balance >= 0;
    final balanceColor =
        isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    final avatarBg = isPersonal
        ? cs.primaryContainer
        : isEntities
            ? cs.secondaryContainer
            : cs.tertiaryContainer;
    final avatarFg = isPersonal
        ? cs.onPrimaryContainer
        : isEntities
            ? cs.onSecondaryContainer
            : cs.onTertiaryContainer;
    final groupLabel = isPersonal
        ? 'Personal'
        : isEntities
            ? 'Entity'
            : 'Individual';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: avatarBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      account.name[0].toUpperCase(),
                      style: TextStyle(
                        color: avatarFg,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(groupLabel,
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}${fx.currencySymbol(account.currencyCode)}${account.balance.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                          color: balanceColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                    if (!account.includeInBalance)
                      Text('excluded',
                          style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyAccountsHint extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyAccountsHint({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline_rounded,
                  color: cs.primary, size: 20),
              const SizedBox(width: 10),
              Text('Add your first account',
                  style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;
  final void Function(String) onDeleteIncome;
  final void Function(String) onDeleteExpense;

  const _CategoriesSection({
    required this.onAddIncome,
    required this.onAddExpense,
    required this.onDeleteIncome,
    required this.onDeleteExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubSection(
                label: 'Income',
                color: const Color(0xFF16A34A),
                categories: data.incomeCategories,
                onAdd: onAddIncome,
                onDelete: onDeleteIncome,
              ),
              const SizedBox(height: 12),
              _SubSection(
                label: 'Expense',
                color: const Color(0xFFDC2626),
                categories: data.expenseCategories,
                onAdd: onAddExpense,
                onDelete: onDeleteExpense,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubSection extends StatelessWidget {
  final String label;
  final Color color;
  final List<String> categories;
  final VoidCallback onAdd;
  final void Function(String) onDelete;

  const _SubSection({
    required this.label,
    required this.color,
    required this.categories,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: color,
              ),
            ),
            const Spacer(),
            if (categories.isEmpty)
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ...categories.map(
              (cat) => Chip(
                label: Text(cat, style: const TextStyle(fontSize: 12)),
                onDeleted: () => onDelete(cat),
                deleteIcon: const Icon(Icons.close_rounded, size: 13),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            ActionChip(
              avatar: Icon(Icons.add_rounded, size: 14, color: color),
              label: Text('Add',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
              onPressed: onAdd,
              side: BorderSide(color: color.withValues(alpha: 0.35)),
              backgroundColor: color.withValues(alpha: 0.08),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Account Form Sheet ───────────────────────────────────────────────────────

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
  late bool _includeInBalance;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
    _includeInBalance = widget.account?.includeInBalance ?? true;
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
      widget.account!.includeInBalance = _includeInBalance;
      Navigator.pop(context, false);
    } else {
      Navigator.pop(
        context,
        Account(
          name: name,
          group: _group,
          balance: balance,
          includeInBalance: _includeInBalance,
        ),
      );
    }
  }

  String get _groupDescription => switch (_group) {
        AccountGroup.personal => 'Your own wallets & bank accounts',
        AccountGroup.individuals => 'Family, friends, individuals',
        AccountGroup.entities => 'Entities, utilities, organisations',
      };

  void _delete() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete account?'),
        content:
            const Text('This account will be removed permanently.'),
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
    final cs = Theme.of(context).colorScheme;
    final isEdit = widget.account != null;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(isEdit ? 'Edit Account' : 'New Account',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              SegmentedButton<AccountGroup>(
                segments: const [
                  ButtonSegment(
                    value: AccountGroup.personal,
                    icon: Icon(Icons.account_balance_wallet_outlined,
                        size: 16),
                    label: Text('Personal'),
                  ),
                  ButtonSegment(
                    value: AccountGroup.individuals,
                    icon: Icon(Icons.person_outline_rounded, size: 16),
                    label: Text('Individual'),
                  ),
                  ButtonSegment(
                    value: AccountGroup.entities,
                    icon: Icon(Icons.business_outlined, size: 16),
                    label: Text('Entity'),
                  ),
                ],
                selected: {_group},
                onSelectionChanged: (s) =>
                    setState(() => _group = s.first),
              ),
              const SizedBox(height: 6),
              Text(
                _groupDescription,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: !isEdit,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Account name',
                  prefixIcon:
                      Icon(Icons.account_balance_wallet_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Current balance',
                  prefixText: 'KM ',
                  prefixIcon: Icon(Icons.currency_exchange_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                child: SwitchListTile.adaptive(
                  value: _includeInBalance,
                  onChanged: (v) =>
                      setState(() => _includeInBalance = v),
                  title: const Text('Include in net worth',
                      style: TextStyle(fontSize: 14)),
                  subtitle: Text(
                    'Toggle off for credit cards or excluded accounts',
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isEdit ? 'Save Changes' : 'Add Account',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              if (isEdit) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18),
                  label: const Text('Delete Account'),
                  style: TextButton.styleFrom(
                    foregroundColor: cs.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
