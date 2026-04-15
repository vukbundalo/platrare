import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../l10n/app_localizations.dart';
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import '../utils/fx.dart' as fx;
import '../widgets/account_avatar.dart';
import '../widgets/attachments_editor.dart';
import '../widgets/app_hero_layout.dart';
import '../theme/ledger_colors.dart';
import '../utils/tx_display.dart';
import '../utils/minor_units_amount_formatter.dart';
import '../utils/projections.dart' as proj;

class NewPlannedTransactionScreen extends StatefulWidget {
  final PlannedTransaction? existing;
  /// When creating (not editing), pre-fill schedule date from Plan’s visible period.
  final DateTime? defaultDateForNew;
  const NewPlannedTransactionScreen({
    super.key,
    this.existing,
    this.defaultDateForNew,
  });

  @override
  State<NewPlannedTransactionScreen> createState() =>
      _NewPlannedTransactionScreenState();
}

class _NewPlannedTransactionScreenState
    extends State<NewPlannedTransactionScreen> {
  final _amountController = TextEditingController();
  final _destinationAmountController = TextEditingController();
  final _amountMinorFormatter = MinorUnitsAmountInputFormatter();
  final _destinationMinorFormatter = MinorUnitsAmountInputFormatter();
  final _descriptionController = TextEditingController();

  Account? _fromAccount;
  Account? _toAccount;
  String? _category;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  RepeatInterval _repeatInterval = RepeatInterval.none;
  int _repeatEvery = 1;
  WeekendAdjustment _weekendAdjustment = WeekendAdjustment.ignore;
  DateTime? _repeatEndDate;
  int? _repeatEndAfter;
  bool _forceClose = false;
  List<String> _attachments = [];

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
      if (_repeatEvery != e.repeatEvery) return true;
      if (_weekendAdjustment != e.weekendAdjustment) return true;
      if (_repeatEndDate != e.repeatEndDate) return true;
      if (_repeatEndAfter != e.repeatEndAfter) return true;
      if (_attachments.length != e.attachments.length ||
          !_attachments.every((p) => e.attachments.contains(p))) {
        return true;
      }
      return false;
    }
    return _amountController.text.trim().isNotEmpty ||
        _fromAccount != null ||
        _toAccount != null ||
        _category != null ||
        _descriptionController.text.trim().isNotEmpty ||
        _attachments.isNotEmpty;
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
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
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
      _repeatEvery = e.repeatEvery;
      _weekendAdjustment = e.weekendAdjustment;
      _repeatEndDate = e.repeatEndDate;
      _repeatEndAfter = e.repeatEndAfter;
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
      _attachments = List.from(e.attachments);
      _amountMinorFormatter.syncFromDisplay(_amountController.text);
      _destinationMinorFormatter.syncFromDisplay(
          _destinationAmountController.text);
    } else if (widget.defaultDateForNew != null) {
      _date = DateUtils.dateOnly(widget.defaultDateForNew!);
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
    if (v == null || v <= 0) return null;
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
        repeatEvery: _repeatEvery,
        repeatDayOfMonth: isMonthYear ? nominal.day : null,
        weekendAdjustment:
            isMonthYear ? _weekendAdjustment : WeekendAdjustment.ignore,
        repeatEndDate: _repeatInterval != RepeatInterval.none
            ? _repeatEndDate
            : null,
        repeatEndAfter: _repeatInterval != RepeatInterval.none
            ? _repeatEndAfter
            : null,
        repeatConfirmedCount: widget.existing?.repeatConfirmedCount ?? 0,
        createdAt: widget.existing?.createdAt,
        updatedAt: widget.existing != null ? DateTime.now() : null,
        attachments: List<String>.from(_attachments),
      ),
    );
  }

  Future<void> _pickAttachments() async {
    final paths = await pickNewAttachmentPaths(context);
    if (!mounted || paths.isEmpty) return;
    setState(() {
      for (final p in paths) {
        if (!_attachments.contains(p)) _attachments.add(p);
      }
    });
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

  Color _amountColor(BuildContext context) {
    if (_fromAccount == null && _toAccount == null) {
      return Theme.of(context).colorScheme.primary;
    }
    return txColor(context, _txType);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _amountColor(context);
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
                  // From account
                  _AccountPickerTile(
                    label: AppLocalizations.of(context).labelFrom,
                    account: _fromAccount,
                    leadingIcon: Icons.arrow_upward_rounded,
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

                  // Amount field (hero; currency: from if set, else to)
                  Container(
                    decoration: AppHeroChrome.cardDecoration(
                      cs,
                      Theme.of(context).brightness,
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
                                        decimal: false),
                                inputFormatters: [_amountMinorFormatter],
                                autofocus: !_isEdit &&
                                    (_fromAccount != null ||
                                        _toAccount != null),
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
                            if (_fromAccount != null || _toAccount != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                  fx.currencySymbol(
                                    _fromAccount?.currencyCode ??
                                        _toAccount?.currencyCode ??
                                        settings.baseCurrency,
                                  ),
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: color.withValues(alpha: 0.6))),
                            ],
                          ],
                        ),
                      ],
                    ),
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
                          decimal: false),
                      inputFormatters: [_destinationMinorFormatter],
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .destReceivesLabel(
                                accountDisplayName(_toAccount!),
                                _toAccount!.currencyCode),
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
                  Text(
                    AppLocalizations.of(context).sectionAttachments,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  AttachmentsEditorSection(
                    attachments: _attachments,
                    onAdd: _pickAttachments,
                    onRemove: (path) =>
                        setState(() => _attachments.remove(path)),
                  ),
                  const SizedBox(height: 16),

                  // Repeat interval
                  _RepeatPicker(
                    value: _repeatInterval,
                    onChanged: (v) => setState(() {
                      _repeatInterval = v;
                      if (v == RepeatInterval.none) {
                        _repeatEvery = 1;
                        _repeatEndDate = null;
                        _repeatEndAfter = null;
                      }
                      if (v != RepeatInterval.monthly &&
                          v != RepeatInterval.yearly) {
                        _weekendAdjustment = WeekendAdjustment.ignore;
                      }
                    }),
                  ),
                  if (_repeatInterval != RepeatInterval.none) ...[
                    const SizedBox(height: 12),
                    _EveryNPicker(
                      interval: _repeatInterval,
                      value: _repeatEvery,
                      onChanged: (v) =>
                          setState(() => _repeatEvery = v),
                    ),
                    const SizedBox(height: 12),
                    _EndConditionPicker(
                      endDate: _repeatEndDate,
                      endAfter: _repeatEndAfter,
                      firstDate: _date,
                      onEndDateChanged: (d) => setState(() {
                        _repeatEndDate = d;
                        _repeatEndAfter = null;
                      }),
                      onEndAfterChanged: (n) => setState(() {
                        _repeatEndAfter = n;
                        _repeatEndDate = null;
                      }),
                      onClear: () => setState(() {
                        _repeatEndDate = null;
                        _repeatEndAfter = null;
                      }),
                    ),
                  ],
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
            currencySymbol: (_fromAccount != null || _toAccount != null)
                ? fx.currencySymbol(
                    _fromAccount?.currencyCode ??
                        _toAccount?.currencyCode ??
                        settings.baseCurrency,
                  )
                : '',
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
  final double? projectedBalance;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _AccountPickerTile({
    required this.label,
    required this.account,
    required this.leadingIcon,
    required this.onTap,
    this.projectedBalance,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
    final hasAccount = account != null;

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
              if (hasAccount)
                AccountAvatar(
                  account: account!,
                  size: 40,
                  borderRadius: 10,
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      leadingIcon,
                      size: 22,
                      color: cs.onSurfaceVariant,
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
                          ? accountDisplayName(account!)
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
                        '${formatBalanceAmount(projectedBalance ?? account!.balance)} ${fx.currencySymbol(account!.currencyCode)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: (projectedBalance ?? account!.balance) >= 0
                              ? lc.positive
                              : lc.negative,
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
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
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
                    '${amount!.toStringAsFixed(2)}'
                    '${currencySymbol.isNotEmpty ? ' $currencySymbol' : ''} · $dateLabel',
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

class _EveryNPicker extends StatelessWidget {
  final RepeatInterval interval;
  final int value;
  final ValueChanged<int> onChanged;

  const _EveryNPicker({
    required this.interval,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final unit = l10nRepeatPickerSuffix(context, interval, value);
    return Row(
      children: [
        Text(l10n.repeatEveryLabel,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                enabled: value > 1,
                onTap: () => onChanged((value - 1).clamp(1, 999)),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                enabled: value < 99,
                onTap: () => onChanged((value + 1).clamp(1, 999)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(unit,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant)),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon,
              size: 18,
              color: enabled ? cs.primary : cs.onSurface.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}

class _EndConditionPicker extends StatelessWidget {
  final DateTime? endDate;
  final int? endAfter;
  final DateTime firstDate;
  final ValueChanged<DateTime> onEndDateChanged;
  final ValueChanged<int> onEndAfterChanged;
  final VoidCallback onClear;

  const _EndConditionPicker({
    required this.endDate,
    required this.endAfter,
    required this.firstDate,
    required this.onEndDateChanged,
    required this.onEndAfterChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isNever = endDate == null && endAfter == null;
    final isDate = endDate != null;
    final isCount = endAfter != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.repeatEndLabel,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            FilterChip(
              label: Text(l10n.repeatEndNever),
              selected: isNever,
              onSelected: (_) => onClear(),
            ),
            FilterChip(
              label: Text(l10n.repeatEndOnDate),
              selected: isDate,
              onSelected: (_) async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? firstDate.add(const Duration(days: 30)),
                  firstDate: firstDate,
                  lastDate: firstDate.add(const Duration(days: 3650)),
                  helpText: l10n.repeatEndPickDate,
                );
                if (picked != null) onEndDateChanged(picked);
              },
            ),
            FilterChip(
              label: Text(endAfter != null
                  ? l10n.repeatEndAfterCount(endAfter!)
                  : l10n.repeatEndAfterChoice),
              selected: isCount,
              onSelected: (_) {
                if (!isCount) {
                  onEndAfterChanged(3);
                }
              },
            ),
          ],
        ),
        if (isDate && endDate != null) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: endDate!,
                firstDate: firstDate,
                lastDate: firstDate.add(const Duration(days: 3650)),
                helpText: l10n.repeatEndPickDate,
              );
              if (picked != null) onEndDateChanged(picked);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 14, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    formatAppDate(context, 'd MMM yyyy', endDate!),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (isCount) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepButton(
                      icon: Icons.remove_rounded,
                      enabled: (endAfter ?? 2) > 2,
                      onTap: () =>
                          onEndAfterChanged(((endAfter ?? 2) - 1).clamp(2, 999)),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${endAfter ?? 2}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    _StepButton(
                      icon: Icons.add_rounded,
                      enabled: (endAfter ?? 2) < 999,
                      onTap: () =>
                          onEndAfterChanged(((endAfter ?? 2) + 1).clamp(2, 999)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(l10n.repeatEndTimes,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant)),
            ],
          ),
        ],
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
    final lc = context.ledgerColors;
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
                AccountAvatar(
                  account: account,
                  size: 38,
                  borderRadius: 10,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(accountDisplayName(account),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Text(
                  '${formatBalanceAmount(projectedBalance)} ${fx.currencySymbol(account.currencyCode)}',
                  style: TextStyle(
                    color: balPos ? lc.positive : lc.negative,
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
