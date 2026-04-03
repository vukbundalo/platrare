import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_format.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';
import '../utils/projections.dart' as proj;

class NewPlannedTransactionScreen extends StatefulWidget {
  final PlannedTransaction? existing;
  const NewPlannedTransactionScreen({super.key, this.existing});

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
  RepeatInterval _repeatInterval = RepeatInterval.none;
  WeekendAdjustment _weekendAdjustment = WeekendAdjustment.ignore;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

  bool get _isDirty {
    if (_isEdit) {
      final e = widget.existing!;
      final origAmt = e.nativeAmount != null ? e.nativeAmount!.toStringAsFixed(2) : '';
      if (_amountController.text.trim() != origAmt) return true;
      if (_fromAccount != e.fromAccount) return true;
      if (_toAccount != e.toAccount) return true;
      if (_category != e.category) return true;
      if (_descriptionController.text.trim() != (e.description ?? '')) return true;
      if (_repeatInterval == RepeatInterval.monthly ||
          _repeatInterval == RepeatInterval.yearly) {
        final newEff = applyWeekendAdjustment(
            DateUtils.dateOnly(_date), _weekendAdjustment);
        if (!DateUtils.dateOnly(newEff)
            .isAtSameMomentAs(DateUtils.dateOnly(e.date))) {
          return true;
        }
        if ((e.repeatDayOfMonth ?? e.date.day) != _date.day) return true;
      } else {
        if (!DateUtils.dateOnly(_date)
            .isAtSameMomentAs(DateUtils.dateOnly(e.date))) {
          return true;
        }
      }
      if (_repeatInterval != e.repeatInterval) return true;
      if (_weekendAdjustment != e.weekendAdjustment) return true;
      return false;
    }
    return _amountController.text.trim().isNotEmpty ||
        _fromAccount != null ||
        _toAccount != null ||
        _category != null ||
        _descriptionController.text.trim().isNotEmpty;
  }

  void _showDiscardDialog() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(ctx).discardTitle),
        content: Text(AppLocalizations.of(ctx).discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(ctx).keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(ctx).discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      if (e.nativeAmount != null) {
        _amountController.text = e.nativeAmount!.toStringAsFixed(2);
      }
      if (e.destinationAmount != null) {
        _destinationAmountController.text =
            e.destinationAmount!.toStringAsFixed(2);
      }
      if (e.description != null) _descriptionController.text = e.description!;
      _fromAccount = e.fromAccount;
      _toAccount = e.toAccount;
      _category = e.category;
      _repeatInterval = e.repeatInterval;
      _weekendAdjustment = e.weekendAdjustment;
      if (e.repeatInterval == RepeatInterval.monthly ||
          e.repeatInterval == RepeatInterval.yearly) {
        final dom = e.repeatDayOfMonth ?? e.date.day;
        var nominal =
            dateWithDayInMonth(e.date.year, e.date.month, dom);
        final expected = DateUtils.dateOnly(
            applyWeekendAdjustment(nominal, e.weekendAdjustment));
        if (expected != DateUtils.dateOnly(e.date)) {
          nominal = DateUtils.dateOnly(e.date);
        }
        _date = nominal;
      } else {
        _date = e.date;
      }
    }
  }

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
        _toAccount?.currencyCode ?? settings.baseCurrency;
    final nominal = DateUtils.dateOnly(_date);
    final isMonthYear = _repeatInterval == RepeatInterval.monthly ||
        _repeatInterval == RepeatInterval.yearly;
    final effectiveDate = isMonthYear
        ? applyWeekendAdjustment(nominal, _weekendAdjustment)
        : nominal;
    Navigator.pop(
      context,
      PlannedTransaction(
        id: widget.existing?.id,
        nativeAmount: _parsedAmount,
        currencyCode: ccy,
        destinationAmount: _parsedDestination,
        fromAccount: _fromAccount,
        toAccount: _toAccount,
        category: _category,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        date: effectiveDate,
        txType: type,
        repeatInterval: _repeatInterval,
        repeatDayOfMonth: isMonthYear ? nominal.day : null,
        weekendAdjustment:
            isMonthYear ? _weekendAdjustment : WeekendAdjustment.ignore,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _isEdit ? DateTime(2020) : DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      helpText: AppLocalizations.of(context).selectPlannedDate,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<Account?> _showAccountPicker({Account? exclude}) {
    return showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) =>
          _AccountPickerSheet(exclude: exclude, date: _projectionDateForAccounts),
    );
  }

  /// Date used for projected balances (effective date, not nominal).
  DateTime get _projectionDateForAccounts {
    if (_repeatInterval == RepeatInterval.monthly ||
        _repeatInterval == RepeatInterval.yearly) {
      return applyWeekendAdjustment(
          DateUtils.dateOnly(_date), _weekendAdjustment);
    }
    return _date;
  }

  String _dateLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final selected = DateUtils.dateOnly(_projectionDateForAccounts);
    if (selected == today) return l10n.dateToday;
    if (selected == tomorrow) return l10n.dateTomorrow;
    return formatAppDate(context, 'd MMM yyyy', selected);
  }

  TxType get _txType =>
      classifyTransaction(from: _fromAccount, to: _toAccount);

  String _txLabelText(BuildContext context) {
    if (_fromAccount == null && _toAccount == null) {
      return AppLocalizations.of(context).txLabelTransaction;
    }
    return l10nTxLabel(context, _txType);
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
    final projected = proj.projectBalances(_projectionDateForAccounts);
    final fromHeadroom = _fromAccount?.personalHeadroomNative(
        projected[_fromAccount!.id] ?? _fromAccount!.balance);
    final toHeadroom = _toAccount?.personalHeadroomNative(
        projected[_toAccount!.id] ?? _toAccount!.balance);

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(_isEdit
            ? AppLocalizations.of(context).editPlanTitle
            : AppLocalizations.of(context).planTransactionTitle),
        actions: [
          TextButton.icon(
            onPressed: _pickDate,
            icon: Icon(Icons.calendar_today_rounded,
                size: 15, color: cs.primary),
            label: Text(_dateLabel(context),
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
                          _txLabelText(context),
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
                            const SizedBox(width: 8),
                            Text(
                                fx.currencySymbol(
                                  _fromAccount?.currencyCode ??
                                  _toAccount?.currencyCode ?? settings.baseCurrency,
                                ),
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: color.withValues(alpha: 0.6))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // From account
                  _AccountPickerTile(
                    label: AppLocalizations.of(context).labelFrom,
                    account: _fromAccount,
                    leadingIcon: Icons.arrow_upward_rounded,
                    leadingIconAccent: const Color(0xFFDC2626),
                    projectedBalance: fromHeadroom,
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
                    label: AppLocalizations.of(context).labelTo,
                    account: _toAccount,
                    leadingIcon: Icons.arrow_downward_rounded,
                    leadingIconAccent: const Color(0xFF16A34A),
                    projectedBalance: toHeadroom,
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
                        Text(AppLocalizations.of(ctx).sectionCategory,
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
                              label: Text(l10nCategoryName(ctx, cat)),
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
                        labelText: AppLocalizations.of(context)
                            .destReceivesLabel(
                                _toAccount!.name, _toAccount!.currencyCode),
                        suffixText:
                            '  ${fx.currencySymbol(_toAccount!.currencyCode)}',
                        hintText: '0.00',
                        helperText: AppLocalizations.of(context).destHelper,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Description
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).descriptionOptional,
                      prefixIcon: Icon(Icons.notes_rounded, size: 18),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  // Repeat interval
                  _RepeatPicker(
                    value: _repeatInterval,
                    onChanged: (v) => setState(() {
                      _repeatInterval = v;
                      if (v != RepeatInterval.monthly &&
                          v != RepeatInterval.yearly) {
                        _weekendAdjustment = WeekendAdjustment.ignore;
                      }
                    }),
                  ),
                  if (_repeatInterval == RepeatInterval.monthly ||
                      _repeatInterval == RepeatInterval.yearly) ...[
                    const SizedBox(height: 12),
                    _WeekendAdjustmentPicker(
                      nominalDate: DateUtils.dateOnly(_date),
                      value: _weekendAdjustment,
                      onChanged: (v) =>
                          setState(() => _weekendAdjustment = v),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Save bar
          _SaveBar(
            canSave: _canSave,
            amount: _parsedAmount,
            currencySymbol: fx.currencySymbol(
              _fromAccount?.currencyCode ??
              _toAccount?.currencyCode ?? settings.baseCurrency,
            ),
            dateLabel: _dateLabel(context),
            isEdit: _isEdit,
            onSave: _save,
          ),
        ],
      ),
      ),
    );
  }
}

class _AccountPickerTile extends StatelessWidget {
  final String label;
  final Account? account;
  final IconData leadingIcon;
  final Color leadingIconAccent;
  final double? projectedBalance;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _AccountPickerTile({
    required this.label,
    required this.account,
    required this.leadingIcon,
    required this.leadingIconAccent,
    required this.onTap,
    this.projectedBalance,
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
                  child: Icon(
                    leadingIcon,
                    size: 22,
                    color: hasAccount
                        ? leadingIconAccent
                        : cs.onSurfaceVariant,
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
                      hasAccount
                          ? account!.name
                          : AppLocalizations.of(context).tapToSelect,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            hasAccount ? cs.onSurface : cs.onSurfaceVariant,
                      ),
                    ),
                    if (hasAccount)
                      Text(
                        '${(projectedBalance ?? account!.balance) > 0 ? '+' : ''}${(projectedBalance ?? account!.balance).toStringAsFixed(2)} ${fx.currencySymbol(account!.currencyCode)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: (projectedBalance ?? account!.balance) >= 0
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

class _SaveBar extends StatelessWidget {
  final bool canSave;
  final double? amount;
  final String currencySymbol;
  final String dateLabel;
  final bool isEdit;
  final VoidCallback onSave;

  const _SaveBar({
    required this.canSave,
    required this.amount,
    required this.currencySymbol,
    required this.dateLabel,
    required this.isEdit,
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
                    '${amount!.toStringAsFixed(2)} $currencySymbol · $dateLabel',
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
              child: Text(
                  isEdit
                      ? AppLocalizations.of(context).updatePlan
                      : AppLocalizations.of(context).addToPlan,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Repeat Picker ───────────────────────────────────────────────────────────

class _RepeatPicker extends StatelessWidget {
  final RepeatInterval value;
  final ValueChanged<RepeatInterval> onChanged;

  const _RepeatPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.repeat_rounded, size: 16, color: cs.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).labelRepeat,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: RepeatInterval.values.map((r) {
            final selected = value == r;
            return FilterChip(
              label: Text(l10nRepeatLabel(context, r)),
              selected: selected,
              onSelected: (_) => onChanged(r),
              avatar: r == RepeatInterval.none
                  ? null
                  : Icon(Icons.repeat_rounded, size: 14),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _WeekendAdjustmentPicker extends StatelessWidget {
  final DateTime nominalDate;
  final WeekendAdjustment value;
  final ValueChanged<WeekendAdjustment> onChanged;

  const _WeekendAdjustmentPicker({
    required this.nominalDate,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final day = nominalDate.day;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).weekendQuestion(day.toString()),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: WeekendAdjustment.values.map((w) {
            final selected = value == w;
            return FilterChip(
              label: Text(l10nWeekendLabel(context, w)),
              selected: selected,
              onSelected: (_) => onChanged(w),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Account Picker Sheet ────────────────────────────────────────────────────

class _AccountPickerSheet extends StatelessWidget {
  final Account? exclude;
  final DateTime date;
  const _AccountPickerSheet({this.exclude, required this.date});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final balances = proj.projectBalances(date);
    final personal = data.accounts
        .where((a) =>
            !a.archived &&
            a.group == AccountGroup.personal &&
            a != exclude)
        .toList();
    final individuals = data.accounts
        .where((a) =>
            !a.archived &&
            a.group == AccountGroup.individuals &&
            a != exclude)
        .toList();
    final entities = data.accounts
        .where((a) =>
            !a.archived &&
            a.group == AccountGroup.entities &&
            a != exclude)
        .toList();

    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDate = DateUtils.dateOnly(date);
    final String dateNote;
    if (selectedDate == today) {
      dateNote = AppLocalizations.of(context).balancesAsOfToday;
    } else if (selectedDate == today.add(const Duration(days: 1))) {
      dateNote =
          AppLocalizations.of(context).projectedBalancesForTomorrow;
    } else {
      dateNote = AppLocalizations.of(context).projectedBalancesForDate(
          formatAppDate(context, 'd MMM yyyy', date));
    }

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
          Text(AppLocalizations.of(context).selectAccountTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(dateNote,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              controller: ctrl,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (personal.isNotEmpty) ...[
                  _SheetHeader(
                      l10nAccountSectionTitle(context, AccountGroup.personal)),
                  ...personal.map(
                    (a) => _AccountListTile(
                      account: a,
                      projectedBalance: a.personalHeadroomNative(
                          balances[a.id] ?? a.balance),
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (individuals.isNotEmpty) ...[
                  _SheetHeader(
                      l10nAccountSectionTitle(context, AccountGroup.individuals)),
                  ...individuals.map(
                    (a) => _AccountListTile(
                      account: a,
                      projectedBalance: a.personalHeadroomNative(
                          balances[a.id] ?? a.balance),
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (entities.isNotEmpty) ...[
                  _SheetHeader(
                      l10nAccountSectionTitle(context, AccountGroup.entities)),
                  ...entities.map(
                    (a) => _AccountListTile(
                      account: a,
                      projectedBalance: a.personalHeadroomNative(
                          balances[a.id] ?? a.balance),
                      onTap: () => Navigator.pop(ctx, a),
                    ),
                  ),
                ],
                if (personal.isEmpty && individuals.isEmpty && entities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                          AppLocalizations.of(context).noAccountsAvailable,
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
  final double projectedBalance;
  final VoidCallback onTap;
  const _AccountListTile({
    required this.account,
    required this.projectedBalance,
    required this.onTap,
  });

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
    final balPos = projectedBalance >= 0;

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
                  '${projectedBalance > 0 ? '+' : ''}${projectedBalance.toStringAsFixed(2)} ${fx.currencySymbol(account.currencyCode)}',
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
