import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/account_lifecycle.dart';
import '../../data/app_data.dart' as data;
import '../../data/currency_localized_names.dart';
import '../../data/data_repository.dart';
import '../../data/user_settings.dart' as settings;
import '../../l10n/app_localizations.dart';
import '../../models/account.dart';
import '../../utils/balance_correction.dart';
import '../../utils/fx.dart' as fx;
import '../../utils/persistence_guard.dart';

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
          previousBook.toStringAsFixed(2),
          newBook.toStringAsFixed(2),
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

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  late AccountGroup _group;
  late String _currencyCode;
  bool _forceClose = false;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

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
    _overdraftController = TextEditingController(
      text: widget.account != null && widget.account!.overdraftLimit > 0
          ? widget.account!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
  }

  bool get _isDirty {
    if (widget.account != null) {
      return _nameController.text.trim() != widget.account!.name ||
          _balanceController.text.trim() !=
              widget.account!.balance.toStringAsFixed(2) ||
          _group != widget.account!.group ||
          _parseOverdraftLimit() != widget.account!.overdraftLimit ||
          _currencyCode != widget.account!.currencyCode;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        _parseOverdraftLimit() > 0 ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal;
  }

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.discard),
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
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
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

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    if (isAccountNameTaken(
      name,
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
    final overdraft = _parseOverdraftLimit();
    if (widget.account != null) {
      final acc = widget.account!;
      final previousBook = acc.balance;
      acc.name = name;
      acc.group = _group;
      acc.overdraftLimit = overdraft;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await applyLedgerBalanceCorrection(
          account: acc,
          previousBookBalance: previousBook,
          newBookBalance: balance,
        );
        if (!correction.inserted) {
          acc.balance = balance;
        }
        await DataRepository.persistAccountFields(acc);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
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
          group: _group,
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
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
                onSelectionChanged: (s) =>
                    setState(() => _group = s.first),
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
                  labelText: l10n.labelRealBalance,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _overdraftController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(
                  labelText: l10n.labelOverdraftLimit,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _save(),
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
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  late AccountGroup _group;
  late String _currencyCode;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.balance.toStringAsFixed(2)
          : '',
    );
    _overdraftController = TextEditingController(
      text: widget.existing != null && widget.existing!.overdraftLimit > 0
          ? widget.existing!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _group = widget.existing?.group ?? widget.initialGroup ?? AccountGroup.personal;
    _currencyCode =
        widget.existing?.currencyCode ?? settings.baseCurrency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    if (_isEdit) {
      return _nameController.text.trim() != widget.existing!.name ||
          _balanceController.text.trim() !=
              widget.existing!.balance.toStringAsFixed(2) ||
          _group != widget.existing!.group ||
          _parseOverdraftLimit() != widget.existing!.overdraftLimit;
    }
    final defaultGroup = widget.initialGroup ?? AccountGroup.personal;
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        _parseOverdraftLimit() > 0 ||
        _currencyCode != settings.baseCurrency ||
        _group != defaultGroup;
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.discard),
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

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    if (isAccountNameTaken(
      name,
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
    final overdraft = _parseOverdraftLimit();
    if (_isEdit) {
      final acc = widget.existing!;
      final previousBook = acc.balance;
      acc.name = name;
      acc.group = _group;
      acc.overdraftLimit = overdraft;

      late BalanceCorrectionResult correction;
      final ok = await guardPersist(context, () async {
        correction = await applyLedgerBalanceCorrection(
          account: acc,
          previousBookBalance: previousBook,
          newBookBalance: balance,
        );
        if (!correction.inserted) {
          acc.balance = balance;
        }
        await DataRepository.persistAccountFields(acc);
      });
      if (!mounted) return;
      if (!ok) {
        setState(() {});
        return;
      }
      HapticFeedback.lightImpact();
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
              group: _group,
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
      HapticFeedback.lightImpact();
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
                if (mounted) Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
              if (mounted) Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
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
                                  onPressed: () => _restoreArchived(),
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
                      onSelectionChanged: (s) =>
                          setState(() => _group = s.first),
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
                          decimal: true, signed: true),
                      decoration: InputDecoration(
                        labelText: l10n.labelRealBalance,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _overdraftController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: InputDecoration(
                        labelText: l10n.labelOverdraftLimit,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
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
                onPressed: _canSave ? () => _save() : null,
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
    final locale = Localizations.localeOf(context);
    setState(() {
      _filtered = q.isEmpty
          ? settings.supportedCurrencies
          : settings.supportedCurrencies.where((code) {
              final name = currencyDisplayName(code, locale).toLowerCase();
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
                  hintText: AppLocalizations.of(context).searchCurrencies,
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
                  final name = currencyDisplayName(
                      code, Localizations.localeOf(ctx));
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
