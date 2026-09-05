import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/account_icons.dart';
import '../../data/account_lifecycle.dart';
import '../../data/app_data.dart' as data;
import '../../data/currency_localized_names.dart';
import '../../data/data_repository.dart';
import '../../data/ledger_service.dart';
import '../../data/user_settings.dart' as settings;
import '../../l10n/app_localizations.dart';
import '../../models/account.dart';
import '../../utils/app_format.dart';
import '../../utils/fx.dart' as fx;
import '../../utils/minor_units_amount_formatter.dart';
import '../../utils/persistence_guard.dart';
import '../../widgets/account_avatar.dart';
import '../../widgets/currency_picker_sheet.dart';
import '../../widgets/discard_changes_dialog.dart';

// ─── Account icon / color presets ─────────────────────────────────────────────
// Curated for personal finance, household, business, investing, and major spend.

const List<int> _kAccountPickColorArgb = <int>[
  0xFF1565C0,
  0xFF2E7D32,
  0xFF6A1B9A,
  0xFFC62828,
  0xFFEF6C00,
  0xFF00838F,
  0xFF5D4037,
  0xFF455A64,
  0xFFAD1457,
  0xFF283593,
  0xFFF9A825,
  0xFF00695C,
];

class _AccountIconPickerBottomSheet extends StatefulWidget {
  const _AccountIconPickerBottomSheet({required this.currentCodePoint});

  final int currentCodePoint;

  @override
  State<_AccountIconPickerBottomSheet> createState() =>
      _AccountIconPickerBottomSheetState();
}

class _AccountIconPickerBottomSheetState
    extends State<_AccountIconPickerBottomSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String _) => setState(() {});

  List<AccountPickIconDef> get _filtered {
    final q = _searchController.text;
    return kAccountPickIconDefs
        .where((d) => accountPickIconMatchesQuery(d, q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);
    final filtered = _filtered;
    return Padding(
      padding: EdgeInsets.only(
        bottom: mq.viewPadding.bottom + mq.viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
            child: Text(
              l10n.accountIconSheetTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.text_fields_rounded, color: cs.primary),
            title: Text(l10n.accountUseInitialLetter),
            onTap: () => Navigator.pop(context, 0),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchAccountIcons,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            height: (mq.size.height * 0.5).clamp(300, 480),
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        l10n.accountIconSearchNoMatches,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final def = filtered[i];
                      final icon = def.icon;
                      final cp = icon.codePoint;
                      final sel =
                          widget.currentCodePoint != 0 &&
                              widget.currentCodePoint == cp;
                      return Material(
                        color: sel
                            ? cs.primaryContainer
                            : cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context, cp),
                          child: Icon(icon, color: cs.onSurface),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Future<int?> _pickAccountIconCodePoint(
  BuildContext context, {
  required int current,
}) async {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _AccountIconPickerBottomSheet(currentCodePoint: current),
  );
}

Future<int?> _pickAccountColorArgb(
  BuildContext context, {
  required int? current,
}) async {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final cs = Theme.of(ctx).colorScheme;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewPadding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
              child: Text(
                l10n.accountColorSheetTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.palette_outlined, color: cs.primary),
              title: Text(l10n.accountUseDefaultColor),
              onTap: () => Navigator.pop(ctx, -1),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final argb in _kAccountPickColorArgb)
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx, argb),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(argb),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: current == argb
                                ? cs.primary
                                : cs.outlineVariant,
                            width: current == argb ? 2.5 : 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _accountAppearanceEditorBlock(
  BuildContext context, {
  required Account previewAccount,
  required VoidCallback onPickIcon,
  required VoidCallback onPickColor,
}) {
  final l10n = AppLocalizations.of(context);
  final tt = Theme.of(context).textTheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        l10n.accountAppearanceSection,
        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          AccountAvatar(account: previewAccount, size: 52, borderRadius: 14),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: onPickIcon,
                  child: Text(l10n.accountPickIcon),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: onPickColor,
                  child: Text(l10n.accountPickColor),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

// ─── Account Form Sheet ───────────────────────────────────────────────────────

Future<void> _showBalanceCorrectionDialog(
  BuildContext context, {
  required double previousBook,
  required double newBook,
  required Account account,
  required BalanceCorrectionResult correction,
}) async {
  final sym = fx.currencySymbol(account.currencyCode);
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.balanceAdjustedTitle),
      content: Text(
        l10n.balanceAdjustedBody(
          formatBalanceAmount(previousBook),
          formatBalanceAmount(newBook),
          sym,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}

/// Overdraft / advance limit applies only to personal accounts.
bool _accountGroupAllowsOverdraft(AccountGroup g) =>
    g == AccountGroup.personal;

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  final _balanceMinorFormatter =
      MinorUnitsAmountInputFormatter(allowNegative: true);
  final _overdraftMinorFormatter = MinorUnitsAmountInputFormatter();
  late AccountGroup _group;
  late String _currencyCode;
  late int _iconCodePoint;
  int? _colorArgb;
  bool _forceClose = false;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  /// Value that would be persisted (zero when group ≠ personal).
  double _effectiveOverdraftLimitForForm() =>
      _accountGroupAllowsOverdraft(_group) ? _parseOverdraftLimit() : 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account?.name ?? '');
    _institutionController = TextEditingController(
      text: widget.account?.institution ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
    _overdraftController = TextEditingController(
      text: widget.account != null &&
              widget.account!.overdraftLimit > 0 &&
              _accountGroupAllowsOverdraft(_group)
          ? widget.account!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
    _iconCodePoint = widget.account?.iconCodePoint ?? 0;
    _colorArgb = widget.account?.colorArgb;
    _balanceMinorFormatter.syncFromDisplay(_balanceController.text);
    _overdraftMinorFormatter.syncFromDisplay(_overdraftController.text);
  }

  String _trimmedInstitution() {
    final t = _institutionController.text.trim();
    return t.isEmpty ? '' : t;
  }

  Account _previewAccountForSheet() {
    final name = _nameController.text.trim();
    final inst = _trimmedInstitution();
    return Account(
      id: widget.account?.id ?? 'preview',
      name: name.isEmpty ? '?' : name,
      institution: inst.isEmpty ? null : inst,
      group: _group,
      iconCodePoint: _iconCodePoint,
      colorArgb: _colorArgb,
      currencyCode: _currencyCode,
    );
  }

  Future<void> _pickIconForSheet() async {
    final v =
        await _pickAccountIconCodePoint(context, current: _iconCodePoint);
    if (!mounted || v == null) return;
    setState(() => _iconCodePoint = v);
  }

  Future<void> _pickColorForSheet() async {
    final v = await _pickAccountColorArgb(context, current: _colorArgb);
    if (!mounted || v == null) return;
    setState(() => _colorArgb = v < 0 ? null : v);
  }

  bool get _isDirty {
    final inst = _trimmedInstitution();
    final instExisting = widget.account?.institution?.trim() ?? '';
    final instNorm = inst.isEmpty ? '' : inst;
    if (widget.account != null) {
      return _nameController.text.trim() != widget.account!.name ||
          instNorm != instExisting ||
          _balanceController.text.trim() !=
              widget.account!.balance.toStringAsFixed(2) ||
          _group != widget.account!.group ||
          _effectiveOverdraftLimitForForm() !=
              widget.account!.overdraftLimit ||
          _currencyCode != widget.account!.currencyCode ||
          _iconCodePoint != widget.account!.iconCodePoint ||
          _colorArgb != widget.account!.colorArgb;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        (_accountGroupAllowsOverdraft(_group) &&
            _parseOverdraftLimit() > 0) ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal ||
        instNorm.isNotEmpty ||
        _iconCodePoint != 0 ||
        _colorArgb != null;
  }

  void _showDiscardDialog() {
    unawaited(confirmDiscardChanges(context).then((discard) {
      if (discard && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    }));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => CurrencyPickerSheet(current: _currencyCode),
    );
    if (result != null) setState(() => _currencyCode = result);
  }

  /// Re-entry guard: a double-tap on save while persistence is in flight
  /// could insert a duplicate account or a double balance-correction row.
  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving) return;
    _isSaving = true;
    try {
      await _doSave();
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _doSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final instRaw = _trimmedInstitution();
    final institution = instRaw.isEmpty ? null : instRaw;
    if (isAccountDuplicate(
      name,
      institution,
      data.accounts,
      exceptAccountId: widget.account?.id,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance = double.tryParse(
            _balanceController.text.trim().replaceAll(',', '.')) ??
        0.0;
    final overdraft = _effectiveOverdraftLimitForForm();
    if (widget.account != null) {
      final acc = widget.account!;
      final previousBook = acc.balance;
      final previousGroup = acc.group;
      acc.name = name;
      acc.institution = institution;
      acc.group = _group;
      if (previousGroup != _group) {
        acc.sortOrder = DataRepository.nextSortOrderInGroup(
          acc.group,
          excludeAccountId: acc.id,
        );
      }
      acc.overdraftLimit = overdraft;
      acc.iconCodePoint = _iconCodePoint;
      acc.colorArgb = _colorArgb;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await LedgerService.setBookBalance(acc, balance);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      unawaited(HapticFeedback.lightImpact());
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, acc);
    } else {
      Navigator.pop(
        context,
        Account(
          name: name,
          institution: institution,
          group: _group,
          iconCodePoint: _iconCodePoint,
          colorArgb: _colorArgb,
          balance: balance,
          overdraftLimit: overdraft,
          currencyCode: _currencyCode,
        ),
      );
    }
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _confirmArchiveSheet() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finish() async {
      final wasArchived = acc.archived;
      acc.archived = true;
      if (!await guardPersist(
          context, () => DataRepository.persistAccountFields(acc))) {
        acc.archived = wasArchived;
        if (mounted) setState(() {});
        return;
      }
      if (mounted) Navigator.pop(context, acc);
    }
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final wasArchived = acc.archived;
                final ok = await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  acc.archived = true;
                  await DataRepository.persistAccountFields(acc);
                });
                if (!ok) {
                  acc.archived = wasArchived;
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) Navigator.pop(context, acc);
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finish();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _delete() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(l10n.cannotDeleteBodyHistory),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  await DataRepository.removeAccount(acc);
                })) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!await guardPersist(
                  context, () => DataRepository.removeAccount(acc))) {
                if (mounted) setState(() {});
                return;
              }
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.account != null;

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Padding(
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
              Row(
                children: [
                  Expanded(
                    child: Text(isEdit ? l10n.editAccountTitle : l10n.newAccountTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      if (_isDirty) {
                        _showDiscardDialog();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SegmentedButton<AccountGroup>(
                segments: [
                  ButtonSegment(
                    value: AccountGroup.personal,
                    icon: const Icon(Icons.account_balance_wallet_outlined,
                        size: 16),
                    label: Text(l10n.accountGroupPersonal),
                  ),
                  ButtonSegment(
                    value: AccountGroup.individuals,
                    icon: const Icon(Icons.person_outline_rounded, size: 16),
                    label: Text(l10n.accountGroupIndividual),
                  ),
                  ButtonSegment(
                    value: AccountGroup.entities,
                    icon: const Icon(Icons.business_outlined, size: 16),
                    label: Text(l10n.accountGroupEntity),
                  ),
                ],
                selected: {_group},
                onSelectionChanged: (s) {
                  final ng = s.first;
                  setState(() {
                    _group = ng;
                    if (!_accountGroupAllowsOverdraft(ng)) {
                      _overdraftController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 6),
              Text(
                _groupDescriptionL10n(context),
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: !isEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountName,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _institutionController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountIdentifier,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _accountAppearanceEditorBlock(
                context,
                previewAccount: _previewAccountForSheet(),
                onPickIcon: _pickIconForSheet,
                onPickColor: _pickColorForSheet,
              ),
              const SizedBox(height: 16),

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
                    signed: true),
                inputFormatters: [_balanceMinorFormatter],
                decoration: InputDecoration(
                  labelText: l10n.labelRealBalance,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
                onChanged: (_) => setState(() {}),
              ),
              if (_accountGroupAllowsOverdraft(_group)) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _overdraftController,
                  keyboardType: const TextInputType.numberWithOptions(
                      ),
                  inputFormatters: [_overdraftMinorFormatter],
                  decoration: InputDecoration(
                    labelText: l10n.labelOverdraftLimit,
                    suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              if (isEdit) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed:
                      widget.account!.archived ? null : _confirmArchiveSheet,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(l10n.archiveAction),
                ),
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18),
                  label: Text(l10n.deletePermanently),
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
      ),
    );
  }
}

// ─── Account Form Screen (full-screen push) ──────────────────────────────────

class AccountFormScreen extends StatefulWidget {
  final Account? existing;
  final AccountGroup? initialGroup;
  const AccountFormScreen({super.key, this.existing, this.initialGroup});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  final _balanceMinorFormatter =
      MinorUnitsAmountInputFormatter(allowNegative: true);
  final _overdraftMinorFormatter = MinorUnitsAmountInputFormatter();
  late AccountGroup _group;
  late String _currencyCode;
  late int _iconCodePoint;
  int? _colorArgb;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  double _effectiveOverdraftLimitForForm() =>
      _accountGroupAllowsOverdraft(_group) ? _parseOverdraftLimit() : 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _institutionController = TextEditingController(
      text: widget.existing?.institution ?? '',
    );
    _balanceController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.balance.toStringAsFixed(2)
          : '',
    );
    _group = widget.existing?.group ??
        widget.initialGroup ??
        AccountGroup.personal;
    _overdraftController = TextEditingController(
      text: widget.existing != null &&
              widget.existing!.overdraftLimit > 0 &&
              _accountGroupAllowsOverdraft(_group)
          ? widget.existing!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _currencyCode =
        widget.existing?.currencyCode ?? settings.baseCurrency;
    _iconCodePoint = widget.existing?.iconCodePoint ?? 0;
    _colorArgb = widget.existing?.colorArgb;
    _balanceMinorFormatter.syncFromDisplay(_balanceController.text);
    _overdraftMinorFormatter.syncFromDisplay(_overdraftController.text);
  }

  String _trimmedInstitutionScreen() {
    final t = _institutionController.text.trim();
    return t.isEmpty ? '' : t;
  }

  Account _previewAccountForScreen() {
    final name = _nameController.text.trim();
    final inst = _trimmedInstitutionScreen();
    return Account(
      id: widget.existing?.id ?? 'preview',
      name: name.isEmpty ? '?' : name,
      institution: inst.isEmpty ? null : inst,
      group: _group,
      iconCodePoint: _iconCodePoint,
      colorArgb: _colorArgb,
      currencyCode: _currencyCode,
    );
  }

  Future<void> _pickIconForScreen() async {
    final v =
        await _pickAccountIconCodePoint(context, current: _iconCodePoint);
    if (!mounted || v == null) return;
    setState(() => _iconCodePoint = v);
  }

  Future<void> _pickColorForScreen() async {
    final v = await _pickAccountColorArgb(context, current: _colorArgb);
    if (!mounted || v == null) return;
    setState(() => _colorArgb = v < 0 ? null : v);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final inst = _trimmedInstitutionScreen();
    final instExisting = widget.existing?.institution?.trim() ?? '';
    final instNorm = inst.isEmpty ? '' : inst;
    if (_isEdit) {
      return _nameController.text.trim() != widget.existing!.name ||
          instNorm != instExisting ||
          _balanceController.text.trim() !=
              widget.existing!.balance.toStringAsFixed(2) ||
          _group != widget.existing!.group ||
          _effectiveOverdraftLimitForForm() !=
              widget.existing!.overdraftLimit ||
          _iconCodePoint != widget.existing!.iconCodePoint ||
          _colorArgb != widget.existing!.colorArgb;
    }
    final defaultGroup = widget.initialGroup ?? AccountGroup.personal;
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        (_accountGroupAllowsOverdraft(_group) &&
            _parseOverdraftLimit() > 0) ||
        _currencyCode != settings.baseCurrency ||
        _group != defaultGroup ||
        instNorm.isNotEmpty ||
        _iconCodePoint != 0 ||
        _colorArgb != null;
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _showDiscardDialog() {
    unawaited(confirmDiscardChanges(context).then((discard) {
      if (discard && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    }));
  }

  /// Re-entry guard: a double-tap on save while persistence is in flight
  /// could insert a duplicate account or a double balance-correction row.
  bool _isSaving = false;

  Future<void> _save() async {
    if (_isSaving) return;
    _isSaving = true;
    try {
      await _doSave();
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _doSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final instRaw = _trimmedInstitutionScreen();
    final institution = instRaw.isEmpty ? null : instRaw;
    if (isAccountDuplicate(
      name,
      institution,
      data.accounts,
      exceptAccountId: _isEdit ? widget.existing!.id : null,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance =
        double.tryParse(_balanceController.text.trim().replaceAll(',', '.')) ??
            0.0;
    final overdraft = _effectiveOverdraftLimitForForm();
    if (_isEdit) {
      final acc = widget.existing!;
      final previousBook = acc.balance;
      final previousGroup = acc.group;
      acc.name = name;
      acc.institution = institution;
      acc.group = _group;
      if (previousGroup != _group) {
        acc.sortOrder = DataRepository.nextSortOrderInGroup(
          acc.group,
          excludeAccountId: acc.id,
        );
      }
      acc.overdraftLimit = overdraft;
      acc.iconCodePoint = _iconCodePoint;
      acc.colorArgb = _colorArgb;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await LedgerService.setBookBalance(acc, balance);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      unawaited(HapticFeedback.lightImpact());
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } else {
      final ok = await guardPersist(context, () => DataRepository.addAccount(
            Account(
              name: name,
              institution: institution,
              group: _group,
              iconCodePoint: _iconCodePoint,
              colorArgb: _colorArgb,
              balance: balance,
              overdraftLimit: overdraft,
              currencyCode: _currencyCode,
            ),
          ));
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      unawaited(HapticFeedback.lightImpact());
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _restoreArchived() async {
    final acc = widget.existing!;
    final wasArchived = acc.archived;
    acc.archived = false;
    if (!await guardPersist(context, () => DataRepository.persistAccountFields(acc))) {
      acc.archived = wasArchived;
      if (mounted) setState(() {});
      return;
    }
    setState(() {});
  }

  void _confirmArchive() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBodyAdjust),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finishArchive() async {
      final wasArchived = acc.archived;
      acc.archived = true;
      if (!await guardPersist(
          context, () => DataRepository.persistAccountFields(acc))) {
        acc.archived = wasArchived;
        if (mounted) setState(() {});
        return;
      }
      if (mounted) Navigator.pop(context, true);
    }

    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final wasArchived = acc.archived;
                final ok = await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  acc.archived = true;
                  await DataRepository.persistAccountFields(acc);
                });
                if (!ok) {
                  acc.archived = wasArchived;
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) Navigator.pop(context, true);
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finishArchive();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(
            acc.archived
                ? l10n.cannotDeleteBodyShort
                : l10n.cannotDeleteBodySuggestArchive,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
            if (!acc.archived)
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _confirmArchive();
                },
                child: Text(l10n.archiveInstead),
              ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(context, () async {
                  await DataRepository.removePlannedReferencingAccount(acc);
                  await DataRepository.removeAccount(acc);
                })) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (!await guardPersist(
                  context, () => DataRepository.removeAccount(acc))) {
                if (mounted) setState(() {});
                return;
              }
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => CurrencyPickerSheet(current: _currencyCode),
    );
    if (result != null && mounted) setState(() => _currencyCode = result);
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _showRemoveAccountSheet() {
    HapticFeedback.lightImpact();
    final acc = widget.existing!;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  l10n.removeAccountSheetTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: cs.error),
                title: Text(
                  l10n.deletePermanently,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.error,
                  ),
                ),
                subtitle: Text(l10n.deletePermanentlySubtitle),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete();
                },
              ),
              if (!acc.archived)
                ListTile(
                  leading: Icon(Icons.inventory_2_outlined, color: cs.primary),
                  title: Text(
                    l10n.archiveAction,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.archiveOptionSubtitle),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmArchive();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text(_isEdit ? l10n.editAccountTitle : l10n.newAccountTitle),
          centerTitle: false,
          backgroundColor: cs.surface,
          surfaceTintColor: Colors.transparent,
          actions: _isEdit
              ? [
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                    tooltip: l10n.tooltipRemoveAccount,
                    onPressed: _showRemoveAccountSheet,
                  ),
                ]
              : null,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isEdit && widget.existing!.archived)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Material(
                          color: cs.secondaryContainer
                              .withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 22, color: cs.onSecondaryContainer),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.archivedBannerText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.35,
                                      color: cs.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _restoreArchived,
                                  child: Text(l10n.restore),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SegmentedButton<AccountGroup>(
                      segments: [
                        ButtonSegment(
                          value: AccountGroup.personal,
                          icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16),
                          label: Text(l10n.accountGroupPersonal),
                        ),
                        ButtonSegment(
                          value: AccountGroup.individuals,
                          icon: const Icon(Icons.person_outline_rounded, size: 16),
                          label: Text(l10n.accountGroupIndividual),
                        ),
                        ButtonSegment(
                          value: AccountGroup.entities,
                          icon: const Icon(Icons.business_outlined, size: 16),
                          label: Text(l10n.accountGroupEntity),
                        ),
                      ],
                      selected: {_group},
                      onSelectionChanged: (s) {
                        final ng = s.first;
                        setState(() {
                          _group = ng;
                          if (!_accountGroupAllowsOverdraft(ng)) {
                            _overdraftController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _groupDescriptionL10n(context),
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      autofocus: !_isEdit,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          InputDecoration(labelText: l10n.labelAccountName),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _institutionController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: l10n.labelAccountIdentifier,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _accountAppearanceEditorBlock(
                      context,
                      previewAccount: _previewAccountForScreen(),
                      onPickIcon: _pickIconForScreen,
                      onPickColor: _pickColorForScreen,
                    ),
                    const SizedBox(height: 16),
                    if (!_isEdit)
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: _pickCurrency)
                    else
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: null),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true),
                      inputFormatters: [_balanceMinorFormatter],
                      decoration: InputDecoration(
                        labelText: l10n.labelRealBalance,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_accountGroupAllowsOverdraft(_group)) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _overdraftController,
                        keyboardType: const TextInputType.numberWithOptions(
                            ),
                        inputFormatters: [_overdraftMinorFormatter],
                        decoration: InputDecoration(
                          labelText: l10n.labelOverdraftLimit,
                          suffixText:
                              '  ${fx.currencySymbol(_currencyCode)}',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
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
                onPressed: _canSave ? _save : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
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
    final l10n = AppLocalizations.of(context);
    final name =
        currencyDisplayName(currencyCode, Localizations.localeOf(context));
    final symbol = fx.currencySymbol(currencyCode);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.labelCurrency,
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

