import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../utils/fx.dart' as fx;
import 'account_transactions_screen.dart';
import 'settings_screen.dart';

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
      builder: (ctx) => const AccountFormSheet(),
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
      builder: (ctx) => AccountFormSheet(account: account),
    );
    if (deleted == true) {
      setState(() => data.accounts.remove(account));
    } else {
      setState(() {});
    }
    widget.onChanged?.call();
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
      floatingActionButton: data.accounts.isEmpty
          ? null
          : FloatingActionButton(
              heroTag: 'review_fab',
              onPressed: _addAccount,
              tooltip: 'Add account',
              child: const Icon(Icons.add_rounded),
            ),
      body: CustomScrollView(
        slivers: [
          // ── App bar with net worth ────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: const Text('Review'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _NetWorthHero(
                      personal: _personalTotal,
                      net: _netTotal,
                      thisMonth: _spendingThisMonth,
                      onToggle: () => setState(
                          () => _spendingThisMonth = !_spendingThisMonth),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (data.accounts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyAccountsHint(onAdd: _addAccount),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Accounts ────────────────────────────────────────────
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

                  // ── Spending by category ─────────────────────────────────
                  if (data.transactions.isNotEmpty)
                    _SpendingSection(
                      spending: _categorySpending,
                      thisMonth: _spendingThisMonth,
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
  final bool thisMonth;
  final VoidCallback onToggle;
  const _NetWorthHero({
    required this.personal,
    required this.net,
    required this.thisMonth,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final netPos = net >= 0;
    final netColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final balanceColor = personal >= 0
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);
    final sym = fx.currencySymbol(settings.baseCurrency);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: balanceColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: balanceColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                    const SizedBox(height: 2),
                    Text(
                      '${personal > 0 ? '+' : ''}${personal.toStringAsFixed(2)} $sym',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: balanceColor,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
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
                  const SizedBox(height: 2),
                  Text(
                    '${net > 0 ? '+' : ''}${net.toStringAsFixed(2)} $sym',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: netColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pie_chart_outline_rounded,
                          size: 12, color: cs.primary),
                      const SizedBox(width: 5),
                      Text(
                        thisMonth
                            ? DateFormat('MMMM').format(DateTime.now())
                            : 'All time',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.swap_horiz_rounded,
                          size: 16, color: cs.primary),
                    ],
                  ),
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

  const _SpendingSection({
    required this.spending,
    required this.thisMonth,
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 6),
          child: Text('SPENDING',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                  letterSpacing: 0.8)),
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
                      '${totalSpent > 0 ? '-' : ''}${totalSpent.toStringAsFixed(2)} KM',
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
                    '${total > 0 ? '-' : ''}${total.toStringAsFixed(2)} KM',
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
                      '${account.balance > 0 ? '+' : ''}${account.balance.toStringAsFixed(2)} ${fx.currencySymbol(account.currencyCode)}',
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
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet_rounded,
                size: 44, color: cs.primary),
          ),
          const SizedBox(height: 24),
          Text('No accounts yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Add your first account to start tracking your finances.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add account'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Account Form Sheet ───────────────────────────────────────────────────────

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountGroup _group;
  late bool _includeInBalance;
  late String _currencyCode;

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
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null) setState(() => _currencyCode = result);
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
          currencyCode: _currencyCode,
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
                ),
              ),
              const SizedBox(height: 12),

              // Currency — editable only when creating
              if (!isEdit)
                _CurrencyTile(
                  currencyCode: _currencyCode,
                  onTap: _pickCurrency,
                )
              else
                _CurrencyTile(currencyCode: _currencyCode, onTap: null),
              const SizedBox(height: 12),

              TextField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: InputDecoration(
                  labelText: 'Current balance',
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
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
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AccountTransactionsScreen(
                          account: widget.account!),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long_outlined, size: 18),
                  label: const Text('See all transactions'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
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

// ─── Currency picker tile ────────────────────────────────────────────────────

class _CurrencyTile extends StatelessWidget {
  final String currencyCode;
  final VoidCallback? onTap;

  const _CurrencyTile({required this.currencyCode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = settings.currencyNames[currencyCode] ?? currencyCode;
    final symbol = fx.currencySymbol(currencyCode);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Currency',
          suffixIcon: enabled
              ? const Icon(Icons.arrow_drop_down_rounded)
              : Icon(Icons.lock_outline_rounded,
                  size: 16, color: cs.onSurfaceVariant),
          enabled: enabled,
        ),
        child: Text(
          '$currencyCode  ·  $symbol  ·  $name',
          style: TextStyle(
            fontSize: 14,
            color: enabled ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── Currency picker bottom sheet ───────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selected;
  const _CurrencyPickerSheet({required this.selected});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  List<String> _filtered = settings.supportedCurrencies;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _filtered = q.isEmpty
          ? settings.supportedCurrencies
          : settings.supportedCurrencies.where((code) {
              final name =
                  (settings.currencyNames[code] ?? '').toLowerCase();
              return code.toLowerCase().contains(q) || name.contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search currency…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final code = _filtered[i];
                  final name = settings.currencyNames[code] ?? code;
                  final symbol = fx.currencySymbol(code);
                  final isSelected = code == widget.selected;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected
                          ? cs.primaryContainer
                          : cs.surfaceContainerHighest,
                      child: Text(
                        symbol.length <= 2 ? symbol : code.substring(0, 1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? cs.onPrimaryContainer
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      '$code  —  $name',
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      symbol,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
