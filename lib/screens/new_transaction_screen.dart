import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_data.dart' as data;
import '../data/data_repository.dart';
import '../data/user_settings.dart' as settings;
import '../l10n/app_localizations.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import '../utils/fx.dart' as fx;
import '../widgets/account_avatar.dart';
import '../widgets/attachments_editor.dart';
import '../utils/persistence_guard.dart';
import '../theme/ledger_colors.dart';
import '../utils/tx_display.dart';

class NewTransactionScreen extends StatefulWidget {
  final Transaction? existing;
  const NewTransactionScreen({super.key, this.existing});

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  final _amountController = TextEditingController();
  final _destinationAmountController = TextEditingController();
  final _noteController = TextEditingController();
  Account? _fromAccount;
  Account? _toAccount;
  String? _category;
  DateTime _date = DateTime.now();
  List<String> _attachments = [];
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
      if (_noteController.text.trim() != (e.description ?? '')) return true;
      if (!DateUtils.dateOnly(_date).isAtSameMomentAs(DateUtils.dateOnly(e.date))) return true;
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
        _noteController.text.trim().isNotEmpty ||
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
      if (e.description != null) _noteController.text = e.description!;
      _fromAccount = e.fromAccount;
      _toAccount = e.toAccount;
      _category = e.category;
      _date = e.date;
      _attachments = List.from(e.attachments);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _destinationAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  /// True when [_fromAccount] and [_toAccount] use different currencies.
  bool get _isCrossCurrency =>
      _fromAccount != null &&
      _toAccount != null &&
      _fromAccount!.currencyCode != _toAccount!.currencyCode;

  double? get _parsedAmount {
    final text = _amountController.text.trim().replaceAll(',', '.');
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
    if (_parsedAmount == null) return false;
    if (_fromAccount == null && _toAccount == null) return false;
    // Rule 4: cross-currency moves require an explicit destination amount.
    if (_isCrossCurrency && _parsedDestination == null) return false;
    return true;
  }

  TxType get _txType =>
      classifyTransaction(from: _fromAccount, to: _toAccount);

  Color _deriveColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_fromAccount == null && _toAccount == null) return cs.primary;
    return txColor(context, _txType);
  }

  String _deriveLabel(BuildContext context) {
    if (_fromAccount == null && _toAccount == null) {
      return AppLocalizations.of(context).txLabelTransaction;
    }
    return l10nTxLabel(context, _txType);
  }

  Future<void> _save() async {
    final nativeAmt = _parsedAmount!;

    // When editing, reverse the old transaction's balance changes first so that
    // prior-balance classification uses restored (pre-original-tx) balances.
    if (_isEdit) {
      final old = widget.existing!;
      if (old.nativeAmount != null) {
        if (old.fromAccount != null) {
          old.fromAccount!.balance += old.nativeAmount!;
        }
        if (old.toAccount != null) {
          old.toAccount!.balance -= (old.destinationAmount ?? old.nativeAmount!);
        }
      }
    }

    // Classify BEFORE new balances change so prior-balance rules are correct.
    final type = _txType;

    // ── Rule 2 / 3: determine currency and lock base value ─────────────────
    final ccy = _fromAccount?.currencyCode ??
        _toAccount?.currencyCode ?? settings.baseCurrency;
    final rate    = fx.rateToBase(ccy);
    final baseAmt = nativeAmt * rate;

    // ── Rule 4: cross-currency balance update ─────────────────────────────
    final destAmt = _parsedDestination; // null when same-currency
    if (_fromAccount != null) _fromAccount!.balance -= nativeAmt;
    if (_toAccount != null) {
      _toAccount!.balance += destAmt ?? nativeAmt;
    }

    final note = _noteController.text.trim();
    final newTx = Transaction(
      id: widget.existing?.id,
      nativeAmount: nativeAmt,
      currencyCode: ccy,
      baseAmount: baseAmt,
      exchangeRate: rate,
      destinationAmount: destAmt,
      fromAccount: _fromAccount,
      toAccount: _toAccount,
      category: _category,
      description: note.isEmpty ? null : note,
      date: _date,
      txType: type,
      attachments: List.from(_attachments),
      createdAt: widget.existing?.createdAt,
    );

    final persisted = await guardPersist(context, () async {
      await DataRepository.replaceOrInsertTransaction(
        newTx,
        isUpdate: _isEdit,
      );
    });
    if (!mounted) return;
    if (!persisted) {
      setState(() {
        _fromAccount = refreshedAccount(_fromAccount);
        _toAccount = refreshedAccount(_toAccount);
      });
      return;
    }

    HapticFeedback.lightImpact();

    final savedColor = txColor(context, type);
    final rawLabel = l10nTxLabel(context, type);
    final titleLabel = '${rawLabel[0]}${rawLabel.substring(1).toLowerCase()}';

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit
              ? AppLocalizations.of(context).transactionUpdated
              : AppLocalizations.of(context).transactionSavedMessage(titleLabel, fx.formatNative(nativeAmt, ccy))),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          backgroundColor: savedColor,
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null && mounted) setState(() => _date = picked);
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

  Future<Account?> _pickAccount({Account? exclude}) {
    return showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AccountPickerSheet(exclude: exclude),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final sel = DateUtils.dateOnly(_date);
    final dateLabel = sel == today
        ? l10n.dateToday
        : sel == today.subtract(const Duration(days: 1))
            ? l10n.dateYesterday
            : formatAppDate(context, 'MMM d', _date);

    final tc = _deriveColor(context);
    final label = _deriveLabel(context);

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editTransactionTitle : l10n.newTransactionTitle),
        actions: [
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: cs.primary),
                  const SizedBox(width: 5),
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Accounts ─────────────────────────────────────────
                  _SectionLabel(AppLocalizations.of(context).sectionAccounts),
                  const SizedBox(height: 8),

                  _AccountTile(
                    label: AppLocalizations.of(context).labelFrom,
                    account: _fromAccount,
                    accentColor: context.ledgerColors.negative,
                    icon: Icons.arrow_upward_rounded,
                    onTap: () async {
                      final a = await _pickAccount(exclude: _toAccount);
                      if (a != null && mounted) {
                        setState(() => _fromAccount = a);
                      }
                    },
                    onClear: _fromAccount != null
                        ? () => setState(() => _fromAccount = null)
                        : null,
                  ),
                  const SizedBox(height: 8),

                  _AccountTile(
                    label: AppLocalizations.of(context).labelTo,
                    account: _toAccount,
                    accentColor: context.ledgerColors.positive,
                    icon: Icons.arrow_downward_rounded,
                    onTap: () async {
                      final a = await _pickAccount(exclude: _fromAccount);
                      if (a != null && mounted) {
                        setState(() => _toAccount = a);
                      }
                    },
                    onClear: _toAccount != null
                        ? () => setState(() => _toAccount = null)
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // ── Amount (currency: from if set, else to, else base) ─
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                    decoration: BoxDecoration(
                      color: tc.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: tc.withValues(alpha: 0.25), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: tc,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: tc,
                                  height: 1.1,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    color: tc.withValues(alpha: 0.25),
                                    height: 1.1,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                autofocus: !_isEdit &&
                                    (_fromAccount != null ||
                                        _toAccount != null),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              fx.currencySymbol(
                                _fromAccount?.currencyCode ??
                                    _toAccount?.currencyCode ??
                                    settings.baseCurrency,
                              ),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: tc.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Category ──────────────────────────────────────────
                  Builder(builder: (_) {
                    final catList = (_fromAccount == null && _toAccount == null)
                        ? null
                        : categoryListFor(_txType);
                    final cats = catList == CategoryList.income
                        ? data.incomeCategories
                        : catList == CategoryList.expense
                            ? data.expenseCategories
                            : <String>[];
                    // Clear stale selection if it's not in the visible list.
                    if (_category != null && !cats.contains(_category)) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => setState(() => _category = null));
                    }
                    if (catList == null || cats.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        _SectionLabel(AppLocalizations.of(context).sectionCategory),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: cats.map((cat) {
                            final sel = _category == cat;
                            return FilterChip(
                              label: Text(l10nCategoryName(context, cat)),
                              selected: sel,
                              selectedColor: cs.primaryContainer,
                              checkmarkColor: cs.primary,
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    sel ? FontWeight.w600 : FontWeight.w400,
                                color: sel ? cs.primary : cs.onSurfaceVariant,
                              ),
                              side: BorderSide(
                                color: sel
                                    ? cs.primary.withValues(alpha: 0.4)
                                    : cs.outlineVariant,
                                width: sel ? 1.5 : 1,
                              ),
                              onSelected: (_) =>
                                  setState(() => _category = sel ? null : cat),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),

                  // ── Destination amount (cross-currency only, Rule 4) ──
                  if (_isCrossCurrency) ...[
                    const SizedBox(height: 20),
                    _SectionLabel(AppLocalizations.of(context)
                        .amountReceivedBy(
                            accountDisplayName(_toAccount!),
                            _toAccount!.currencyCode)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _destinationAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: InputDecoration(
                        suffixText:
                            '  ${fx.currencySymbol(_toAccount!.currencyCode)}',
                        hintText: '0.00',
                        helperText:
                            AppLocalizations.of(context).amountReceivedHelper,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ── Note ─────────────────────────────────────────────
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).labelNote,
                      hintText:
                          AppLocalizations.of(context).hintOptionalDescription,
                      prefixIcon: Icon(Icons.notes_rounded,
                          color: cs.onSurfaceVariant, size: 20),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                  ),

                  // ── Attachments ───────────────────────────────────────
                  const SizedBox(height: 20),
                  _SectionLabel(AppLocalizations.of(context).sectionAttachments),
                  const SizedBox(height: 8),
                  AttachmentsEditorSection(
                    attachments: _attachments,
                    onAdd: _pickAttachments,
                    onRemove: (path) => setState(() => _attachments.remove(path)),
                  ),
                ],
              ),
            ),
          ),

          // ── Pinned save button ────────────────────────────────────────────
          _SaveBar(
            color: tc,
            amount: _parsedAmount,
            currencySymbol: fx.currencySymbol(
              _fromAccount?.currencyCode ??
              _toAccount?.currencyCode ?? settings.baseCurrency,
            ),
            enabled: _canSave,
            isEdit: _isEdit,
            onSave: () => _save(),
          ),
        ],
      ),
      ),
    );
  }
}

// ─── Save bar ────────────────────────────────────────────────────────────────

class _SaveBar extends StatelessWidget {
  final Color color;
  final double? amount;
  final String currencySymbol;
  final bool enabled;
  final bool isEdit;
  final Future<void> Function() onSave;

  const _SaveBar({
    required this.color,
    required this.amount,
    required this.currencySymbol,
    required this.enabled,
    required this.isEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
            top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.4),
                width: 0.5)),
      ),
      child: FilledButton(
        onPressed: enabled ? () async => onSave() : null,
        style: FilledButton.styleFrom(
          backgroundColor: enabled ? color : null,
          foregroundColor: Colors.white,
          disabledBackgroundColor: cs.surfaceContainerHighest,
          disabledForegroundColor: cs.onSurfaceVariant,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size(double.infinity, 52),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                isEdit
                    ? AppLocalizations.of(context).updateTransaction
                    : AppLocalizations.of(context).saveTransaction,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            if (amount != null) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${amount!.toStringAsFixed(2)} $currencySymbol',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// ─── Account tile ──────────────────────────────────────────────────────────────

class _AccountTile extends StatelessWidget {
  final String label;
  final Account? account;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _AccountTile({
    required this.label,
    required this.account,
    required this.accentColor,
    required this.icon,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
    final has = account != null;
    final headroom =
        has ? account!.personalHeadroomNative(account!.balance) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: has
              ? accentColor.withValues(alpha: 0.06)
              : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: has
                ? accentColor.withValues(alpha: 0.3)
                : cs.outlineVariant,
            width: has ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (has)
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
                    icon,
                    size: 22,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    has
                        ? accountDisplayName(account!)
                        : AppLocalizations.of(context).selectAccount,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          has ? FontWeight.w600 : FontWeight.w400,
                      color: has
                          ? cs.onSurface
                          : cs.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                  if (has) ...[
                    const SizedBox(height: 1),
                    Text(
                      '${formatBalanceAmount(headroom)} ${fx.currencySymbol(account!.currencyCode)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: headroom >= 0 ? lc.positive : lc.negative,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onClear != null && has)
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded,
                      size: 18, color: cs.onSurfaceVariant),
                ),
              )
            else
              Icon(Icons.chevron_right_rounded,
                  size: 20,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}

// ─── Account picker sheet ──────────────────────────────────────────────────────

class _AccountPickerSheet extends StatelessWidget {
  final Account? exclude;

  const _AccountPickerSheet({this.exclude});

  String _fmt(Account a) {
    final h = a.personalHeadroomNative(a.balance);
    return '${formatBalanceAmount(h)} ${fx.currencySymbol(a.currencyCode)}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (_, ctrl) => Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(AppLocalizations.of(context).selectAccountTitle,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  if (personal.isNotEmpty) ...[
                    _sheetHeader(
                        context,
                        l10nAccountSectionTitle(context, AccountGroup.personal),
                        cs.primary),
                    const SizedBox(height: 6),
                    ...personal.map((a) =>
                        _sheetTile(context, account: a)),
                  ],
                  if (individuals.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _sheetHeader(
                        context,
                        l10nAccountSectionTitle(
                            context, AccountGroup.individuals),
                        cs.tertiary),
                    const SizedBox(height: 6),
                    ...individuals.map((a) =>
                        _sheetTile(context, account: a)),
                  ],
                  if (entities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _sheetHeader(
                        context,
                        l10nAccountSectionTitle(context, AccountGroup.entities),
                        cs.secondary),
                    const SizedBox(height: 6),
                    ...entities.map((a) =>
                        _sheetTile(context, account: a)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetHeader(BuildContext ctx, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: color,
        ),
      ),
    );
  }

  Widget _sheetTile(BuildContext ctx, {required Account account}) {
    final cs = Theme.of(ctx).colorScheme;
    final lc = ctx.ledgerColors;
    final headroom = account.personalHeadroomNative(account.balance);
    final pos = headroom >= 0;

    return GestureDetector(
      onTap: () => Navigator.pop(ctx, account),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            AccountAvatar(
              account: account,
              size: 38,
              borderRadius: 10,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                accountDisplayName(account),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: pos
                    ? lc.positive.withValues(alpha: 0.1)
                    : lc.negative.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _fmt(account),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: pos ? lc.positive : lc.negative,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

