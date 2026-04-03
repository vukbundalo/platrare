import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
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
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. They will be lost if you leave now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Discard'),
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

  Color _deriveColor(ColorScheme cs) {
    if (_fromAccount == null && _toAccount == null) return cs.primary;
    return txColor(_txType);
  }

  String _deriveLabel() {
    if (_fromAccount == null && _toAccount == null) return 'TRANSACTION';
    return txLabel(_txType);
  }

  void _save() {
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
    );

    if (_isEdit) {
      final idx =
          data.transactions.indexWhere((t) => t.id == widget.existing!.id);
      if (idx >= 0) {
        data.transactions[idx] = newTx;
      } else {
        data.transactions.insert(0, newTx);
      }
    } else {
      data.transactions.insert(0, newTx);
    }

    HapticFeedback.lightImpact();

    final savedColor = txColor(type);
    final savedLabel = txLabel(type);

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit
              ? 'Transaction updated'
              : '${savedLabel[0]}${savedLabel.substring(1).toLowerCase()} saved  •  ${fx.formatNative(nativeAmt, ccy)}'),
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
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _pickAttachments() async {
    final choice = await showModalBottomSheet<_AttachSource>(
      context: context,
      builder: (ctx) => _AttachSourceSheet(),
    );
    if (choice == null || !mounted) return;

    switch (choice) {
      case _AttachSource.camera:
        final img = await ImagePicker().pickImage(source: ImageSource.camera);
        if (img != null && mounted) {
          setState(() {
            if (!_attachments.contains(img.path)) _attachments.add(img.path);
          });
        }
      case _AttachSource.gallery:
        final imgs = await ImagePicker().pickMultiImage();
        if (mounted) {
          setState(() {
            for (final img in imgs) {
              if (!_attachments.contains(img.path)) _attachments.add(img.path);
            }
          });
        }
      case _AttachSource.files:
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );
        if (result != null && mounted) {
          setState(() {
            for (final f in result.files) {
              if (f.path != null && !_attachments.contains(f.path)) {
                _attachments.add(f.path!);
              }
            }
          });
        }
    }
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
    final today = DateUtils.dateOnly(DateTime.now());
    final sel = DateUtils.dateOnly(_date);
    final dateLabel = sel == today
        ? 'Today'
        : sel == today.subtract(const Duration(days: 1))
            ? 'Yesterday'
            : DateFormat('MMM d').format(_date);

    final tc = _deriveColor(cs);
    final label = _deriveLabel();

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Transaction' : 'New Transaction'),
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
                  // ── Amount ────────────────────────────────────────────
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
                                autofocus: !_isEdit,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              fx.currencySymbol(
                                _fromAccount?.currencyCode ??
                                _toAccount?.currencyCode ?? settings.baseCurrency,
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

                  const SizedBox(height: 24),

                  // ── Accounts ─────────────────────────────────────────
                  _SectionLabel('Accounts'),
                  const SizedBox(height: 8),

                  _AccountTile(
                    label: 'From',
                    account: _fromAccount,
                    accentColor: const Color(0xFFDC2626),
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
                    label: 'To',
                    account: _toAccount,
                    accentColor: const Color(0xFF16A34A),
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
                        _SectionLabel('Category'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: cats.map((cat) {
                            final sel = _category == cat;
                            return FilterChip(
                              label: Text(cat),
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
                    _SectionLabel(
                        'Amount received by ${_toAccount!.name} (${_toAccount!.currencyCode})'),
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
                            'Enter the exact amount the destination account receives. '
                            'This locks the real exchange rate used.',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ── Note ─────────────────────────────────────────────
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      hintText: 'Optional description',
                      prefixIcon: Icon(Icons.notes_rounded,
                          color: cs.onSurfaceVariant, size: 20),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                  ),

                  // ── Attachments ───────────────────────────────────────
                  const SizedBox(height: 20),
                  _SectionLabel('Attachments'),
                  const SizedBox(height: 8),
                  _AttachmentsSection(
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
            onSave: _save,
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
  final VoidCallback onSave;

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
        onPressed: enabled ? onSave : null,
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
            Text(isEdit ? 'Update Transaction' : 'Save Transaction',
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
    final has = account != null;
    final isPersonal = has && account!.group == AccountGroup.personal;
    final isEntities = has && account!.group == AccountGroup.entities;
    final avatarColor = isPersonal
        ? cs.primaryContainer
        : isEntities
            ? cs.secondaryContainer
            : cs.tertiaryContainer;
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: has ? avatarColor : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: has ? accentColor : cs.onSurfaceVariant,
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
                    has ? account!.name : 'Select account',
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
                      '${headroom > 0 ? '+' : ''}${headroom.toStringAsFixed(2)} ${fx.currencySymbol(account!.currencyCode)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: headroom >= 0
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
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
    return '${h > 0 ? '+' : ''}${h.toStringAsFixed(2)} ${fx.currencySymbol(a.currencyCode)}';
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
              child: Text('Select Account',
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
                    _sheetHeader(context, 'Personal', cs.primary),
                    const SizedBox(height: 6),
                    ...personal.map((a) =>
                        _sheetTile(context, account: a, isPersonal: true)),
                  ],
                  if (individuals.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _sheetHeader(context, 'Individuals', cs.tertiary),
                    const SizedBox(height: 6),
                    ...individuals.map((a) =>
                        _sheetTile(context, account: a, isPersonal: false)),
                  ],
                  if (entities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _sheetHeader(context, 'Entities', cs.secondary),
                    const SizedBox(height: 6),
                    ...entities.map((a) =>
                        _sheetTile(context, account: a, isPersonal: false)),
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

  Widget _sheetTile(BuildContext ctx,
      {required Account account, required bool isPersonal}) {
    final cs = Theme.of(ctx).colorScheme;
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
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isPersonal
                    ? cs.primaryContainer
                    : cs.tertiaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  account.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isPersonal ? cs.primary : cs.tertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                account.name,
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
                    ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                    : const Color(0xFFDC2626).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _fmt(account),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: pos
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Attach source picker ─────────────────────────────────────────────────────

enum _AttachSource { camera, gallery, files }

class _AttachSourceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _SourceTile(
              icon: Icons.camera_alt_rounded,
              label: 'Take photo',
              subtitle: 'Use camera to capture a receipt',
              onTap: () => Navigator.pop(context, _AttachSource.camera),
            ),
            const SizedBox(height: 8),
            _SourceTile(
              icon: Icons.photo_library_rounded,
              label: 'Choose from gallery',
              subtitle: 'Select photos from your library',
              onTap: () => Navigator.pop(context, _AttachSource.gallery),
            ),
            const SizedBox(height: 8),
            _SourceTile(
              icon: Icons.folder_open_rounded,
              label: 'Browse files',
              subtitle: 'Attach PDFs, documents or other files',
              onTap: () => Navigator.pop(context, _AttachSource.files),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: cs.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ─── Attachments section ──────────────────────────────────────────────────────

class _AttachmentsSection extends StatelessWidget {
  final List<String> attachments;
  final VoidCallback onAdd;
  final void Function(String path) onRemove;

  const _AttachmentsSection({
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
  });

  static const _imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'};

  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return _imageExts.contains(ext);
  }

  String _filename(String path) => path.split('/').last;

  IconData _fileIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    if (ext == 'doc' || ext == 'docx') return Icons.description_rounded;
    if (ext == 'xls' || ext == 'xlsx') return Icons.table_chart_rounded;
    return Icons.insert_drive_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...attachments.map((path) {
          final isImg = _isImage(path);
          return GestureDetector(
            onTap: () => OpenFilex.open(path),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: isImg ? 80 : null,
                  height: isImg ? 80 : null,
                  padding: isImg
                      ? null
                      : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.6)),
                  ),
                  child: isImg
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (ctx, err, trace) => Icon(
                              Icons.broken_image_rounded,
                              size: 32,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_fileIcon(path), size: 18, color: cs.primary),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: Text(
                                _filename(path),
                                style: TextStyle(
                                    fontSize: 12, color: cs.onSurface),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: GestureDetector(
                    onTap: () => onRemove(path),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: cs.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Icon(Icons.close_rounded,
                          size: 12, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.attach_file_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  'Attach',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
