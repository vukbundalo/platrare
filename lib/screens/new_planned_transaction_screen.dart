import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';
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
  final _destinationAmountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Account? _fromAccount;
  Account? _toAccount;
  String? _category;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  bool _showProjection = false;

  @override
  void dispose() {
    _amountController.dispose();
    _destinationAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isCrossCurrency =>
      _fromAccount != null &&
      _toAccount != null &&
      _fromAccount!.currencyCode != _toAccount!.currencyCode;

  double? get _parsedAmount {
    final text = _amountController.text.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    final v = double.tryParse(text);
    if (v == null || v == 0) return null;
    return v;
  }

  double? get _parsedDestination {
    if (!_isCrossCurrency) return null;
    final text = _destinationAmountController.text.trim().replaceAll(',', '.');
    final v = double.tryParse(text);
    if (v == null || v <= 0) return null;
    return v;
  }

  bool get _canSave {
    final hasAmount = _parsedAmount != null;
    final hasAccount = _fromAccount != null || _toAccount != null;
    if (!hasAmount || !hasAccount) return false;
    if (_isCrossCurrency && _parsedDestination == null) return false;
    return true;
  }

  void _save() {
    HapticFeedback.mediumImpact();
    final type = _txType;
    final ccy = _fromAccount?.currencyCode ??
        _toAccount?.currencyCode ?? 'BAM';
    Navigator.pop(
      context,
      PlannedTransaction(
        nativeAmount: _parsedAmount,
        currencyCode: ccy,
        destinationAmount: _parsedDestination,
        fromAccount: _fromAccount,
        toAccount: _toAccount,
        category: _category,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: _date,
        txType: type,
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

  String get _dateLabel {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final selected = DateUtils.dateOnly(_date);
    if (selected == today) return 'Today';
    if (selected == tomorrow) return 'Tomorrow';
    return DateFormat('d MMM yyyy').format(_date);
  }

  TxType get _txType =>
      classifyTransaction(from: _fromAccount, to: _toAccount);

  String get _txLabel {
    if (_fromAccount == null && _toAccount == null) return 'TRANSACTION';
    return txLabel(_txType);
  }

  Color get _amountColor {
    if (_fromAccount == null && _toAccount == null) {
      return Theme.of(context).colorScheme.primary;
    }
    return txColor(_txType);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _amountColor;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Plan Transaction'),
        actions: [
          TextButton.icon(
            onPressed: _pickDate,
            icon: Icon(Icons.calendar_today_rounded,
                size: 15, color: cs.primary),
            label: Text(_dateLabel,
                style: TextStyle(
                    color: cs.primary, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Amount field (hero)
                  Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withValues(alpha: 0.25)),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _txLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('KM',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: color.withValues(alpha: 0.6))),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                autofocus: true,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                  letterSpacing: -1,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    color: color.withValues(alpha: 0.3),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // From account
                  _AccountPickerTile(
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

                  // To account
                  _AccountPickerTile(
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
                  Builder(builder: (ctx) {
                    final catList = (_fromAccount == null && _toAccount == null)
                        ? null
                        : categoryListFor(_txType);
                    final cats = catList == CategoryList.income
                        ? data.incomeCategories
                        : catList == CategoryList.expense
                            ? data.expenseCategories
                            : <String>[];
                    if (_category != null && !cats.contains(_category)) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => setState(() => _category = null));
                    }
                    if (catList == null || cats.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Category',
                            style: Theme.of(ctx)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: cats.map((cat) {
                            final selected = _category == cat;
                            return FilterChip(
                              label: Text(cat),
                              selected: selected,
                              onSelected: (_) => setState(
                                  () => _category = selected ? null : cat),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),

                  // Destination amount (cross-currency only, Rule 4)
                  if (_isCrossCurrency) ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: _destinationAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        labelText:
                            '${_toAccount!.name} receives (${_toAccount!.currencyCode})',
                        prefixText:
                            '${fx.currencySymbol(_toAccount!.currencyCode)}  ',
                        hintText: '0.00',
                        helperText:
                            'Estimated destination amount. Exact rate is locked at confirmation.',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Description
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      prefixIcon: Icon(Icons.notes_rounded, size: 18),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // Projected balances (collapsible)
                  _ProjectedBalancesCard(
                    date: _date,
                    dateLabel: _dateLabel,
                    onPickDate: _pickDate,
                    expanded: _showProjection,
                    onToggle: () =>
                        setState(() => _showProjection = !_showProjection),
                  ),
                ],
              ),
            ),
          ),

          // Save bar
          _SaveBar(
            canSave: _canSave,
            amount: _parsedAmount,
            dateLabel: _dateLabel,
            onSave: _save,
          ),
        ],
      ),
    );
  }
}

class _AccountPickerTile extends StatelessWidget {
  final String label;
  final Account? account;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _AccountPickerTile({
    required this.label,
    required this.account,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasAccount = account != null;
    final isPersonal =
        hasAccount ? account!.group == AccountGroup.personal : true;
    final isEntities = hasAccount && account!.group == AccountGroup.entities;
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

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      hasAccount ? avatarBg : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    hasAccount ? account!.name[0].toUpperCase() : label[0],
                    style: TextStyle(
                      color: hasAccount ? avatarFg : cs.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                    Text(
                      hasAccount ? account!.name : 'Tap to select',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            hasAccount ? cs.onSurface : cs.onSurfaceVariant,
                      ),
                    ),
                    if (hasAccount)
                      Text(
                        '${account!.balance >= 0 ? '+' : ''}${fx.currencySymbol(account!.currencyCode)}${account!.balance.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: account!.balance >= 0
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              onClear != null
                  ? IconButton(
                      icon: Icon(Icons.close_rounded,
                          size: 18, color: cs.error),
                      onPressed: onClear,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : Icon(Icons.chevron_right_rounded,
                      size: 18, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectedBalancesCard extends StatelessWidget {
  final DateTime date;
  final String dateLabel;
  final VoidCallback onPickDate;
  final bool expanded;
  final VoidCallback onToggle;

  const _ProjectedBalancesCard({
    required this.date,
    required this.dateLabel,
    required this.onPickDate,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final balances = proj.projectBalances(date);
    final personal =
        data.accounts.where((a) => a.group == AccountGroup.personal).toList();
    final individuals =
        data.accounts.where((a) => a.group == AccountGroup.individuals).toList();
    final entities =
        data.accounts.where((a) => a.group == AccountGroup.entities).toList();
    final totalPersonal = proj.personalTotal(balances);
    final pos = totalPersonal >= 0;
    final totColor =
        pos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: expanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.account_balance_outlined,
                      size: 16, color: cs.primary),
                  const SizedBox(width: 8),
                  Text('Snapshot on $dateLabel',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: cs.primary)),
                  const Spacer(),
                  Text(
                    '${pos ? '+' : ''}KM${totalPersonal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: totColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            Divider(
                height: 1,
                color: cs.outlineVariant.withValues(alpha: 0.4)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (personal.isNotEmpty) ...[
                    Text('PERSONAL',
                        style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: cs.primary)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: personal
                            .map((a) => _BalChip(
                                  name: a.name,
                                  balance: balances[a.id] ?? a.balance,
                                  currencyCode: a.currencyCode,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  if (individuals.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('INDIVIDUALS',
                        style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: cs.tertiary)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: individuals
                            .map((a) => _BalChip(
                                  name: a.name,
                                  balance: balances[a.id] ?? a.balance,
                                  currencyCode: a.currencyCode,
                                  isPartner: true,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  if (entities.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('ENTITIES',
                        style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                            color: cs.secondary)),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: entities
                            .map((a) => _BalChip(
                                  name: a.name,
                                  balance: balances[a.id] ?? a.balance,
                                  currencyCode: a.currencyCode,
                                  isPartner: true,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: onPickDate,
                    icon: const Icon(Icons.calendar_today_rounded, size: 14),
                    label: const Text('Change date'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BalChip extends StatelessWidget {
  final String name;
  final double balance;
  final String currencyCode;
  final bool isPartner;

  const _BalChip({
    required this.name,
    required this.balance,
    required this.currencyCode,
    this.isPartner = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pos = balance >= 0;
    final color =
        pos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: TextStyle(
                  fontSize: 10,
                  color: isPartner ? cs.tertiary : cs.primary,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            '${pos ? '+' : ''}${fx.currencySymbol(currencyCode)}${balance.abs().toStringAsFixed(2)}',
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final bool canSave;
  final double? amount;
  final String dateLabel;
  final VoidCallback onSave;

  const _SaveBar({
    required this.canSave,
    required this.amount,
    required this.dateLabel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
            top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.4),
                width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          if (amount != null) ...[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_note_rounded,
                      size: 14, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    'KM${amount!.toStringAsFixed(2)} · $dateLabel',
                    style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: FilledButton(
              onPressed: canSave ? onSave : null,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add to Plan',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Account Picker Sheet ────────────────────────────────────────────────────

class _AccountPickerSheet extends StatelessWidget {
  final Account? exclude;
  const _AccountPickerSheet({this.exclude});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal && a != exclude)
        .toList();
    final individuals = data.accounts
        .where((a) => a.group == AccountGroup.individuals && a != exclude)
        .toList();
    final entities = data.accounts
        .where((a) => a.group == AccountGroup.entities && a != exclude)
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (ctx, ctrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text('Select Account',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              controller: ctrl,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (personal.isNotEmpty) ...[
                  _SheetHeader('Personal'),
                  ...personal.map(
                    (a) => _AccountListTile(
                      account: a,
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (individuals.isNotEmpty) ...[
                  _SheetHeader('Individuals'),
                  ...individuals.map(
                    (a) => _AccountListTile(
                      account: a,
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (entities.isNotEmpty) ...[
                  _SheetHeader('Entities'),
                  ...entities.map(
                    (a) => _AccountListTile(
                      account: a,
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (personal.isEmpty && individuals.isEmpty && entities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text('No accounts available',
                          style:
                              TextStyle(color: cs.onSurfaceVariant)),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  const _SheetHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _AccountListTile extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;
  const _AccountListTile({required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPersonal = account.group == AccountGroup.personal;
    final isEntities = account.group == AccountGroup.entities;
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
    final balPos = account.balance >= 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: avatarBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      account.name[0].toUpperCase(),
                      style: TextStyle(
                        color: avatarFg,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(account.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Text(
                  '${balPos ? '+' : ''}${fx.currencySymbol(account.currencyCode)}${account.balance.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: balPos
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFDC2626),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
