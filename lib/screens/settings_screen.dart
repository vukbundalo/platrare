import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../data/app_data.dart' as data;
import '../theme/ledger_colors.dart';
import '../data/data_repository.dart';
import '../data/data_transfer.dart';
import '../data/ledger_verify.dart';
import '../data/currency_localized_names.dart';
import '../data/currency_prefs.dart';
import '../data/fx_service.dart';
import '../data/locale_prefs.dart';
import '../data/security_prefs.dart';
import '../data/theme_prefs.dart';
import '../data/user_settings.dart' as settings;
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import '../l10n/app_localizations.dart';
import '../models/account.dart';
import '../utils/fx.dart' as fx;
import '../utils/persistence_guard.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _showExportDoneSnack(AppLocalizations l10n, String? path) async {
    if (!mounted || path == null) return;
    final openNow = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.settingsDataExportDoneTitle),
            content: Text(l10n.settingsDataExportDoneBody(path)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.close),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.settingsDataOpenExportFile),
              ),
            ],
          ),
        ) ??
        false;
    if (!mounted) return;
    if (openNow) {
      await OpenFilex.open(path);
    }
  }

  Future<void> _exportBackup(AppLocalizations l10n) async {
    final pwd1 = TextEditingController();
    final pwd2 = TextEditingController();
    try {
      final choice = await showDialog<String?>(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setLocal) {
              String? fieldError;
              return AlertDialog(
                title: Text(l10n.backupExportDialogTitle),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.backupExportDialogBody),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pwd1,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.backupExportPasswordLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: pwd2,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.backupExportPasswordConfirmLabel,
                          errorText: fieldError,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, null),
                    child: Text(l10n.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, ''),
                    child: Text(l10n.backupExportWithoutEncryption),
                  ),
                  FilledButton(
                    onPressed: () {
                      final a = pwd1.text.trim();
                      final b = pwd2.text.trim();
                      if (a.isEmpty || b.isEmpty) {
                        setLocal(
                          () => fieldError = l10n.backupExportPasswordEmpty,
                        );
                        return;
                      }
                      if (a != b) {
                        setLocal(
                          () => fieldError = l10n.backupExportPasswordMismatch,
                        );
                        return;
                      }
                      Navigator.pop(ctx, a);
                    },
                    child: Text(l10n.confirm),
                  ),
                ],
              );
            },
          );
        },
      );
      if (!mounted) return;
      if (choice == null) return;

      if (choice.isEmpty) {
        final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l10n.backupExportSkipWarningTitle),
                content: Text(l10n.backupExportSkipWarningBody),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(l10n.backupExportSkipWarningConfirm),
                  ),
                ],
              ),
            ) ??
            false;
        if (!mounted || !ok) return;
        final path = await DataTransfer.exportToPickedPath(encrypt: false);
        await _showExportDoneSnack(l10n, path);
        return;
      }

      final path = await DataTransfer.exportToPickedPath(
        encrypt: true,
        password: choice,
      );
      await _showExportDoneSnack(l10n, path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDataExportFailed)),
      );
    } finally {
      pwd1.dispose();
      pwd2.dispose();
    }
  }

  String _formatBackupExportedAt(BuildContext context, String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return formatAppDate(context, 'y-MM-dd HH:mm', d.toLocal());
  }

  Future<String?> _promptImportPassword(AppLocalizations l10n) async {
    final c = TextEditingController();
    try {
      return showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.backupImportPasswordTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.backupImportPasswordBody),
              const SizedBox(height: 12),
              TextField(
                controller: c,
                obscureText: true,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.backupImportPasswordLabel,
                ),
                onSubmitted: (_) {
                  final v = c.text.trim();
                  if (v.isNotEmpty) Navigator.pop(ctx, v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final v = c.text.trim();
                if (v.isEmpty) return;
                Navigator.pop(ctx, v);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      );
    } finally {
      c.dispose();
    }
  }

  Future<void> _importBackup(AppLocalizations l10n) async {
    try {
      final bytes = await DataTransfer.pickBackupFileBytes();
      if (!mounted || bytes == null) return;

      String? password;
      if (looksLikeEncryptedPlatrare(bytes)) {
        password = await _promptImportPassword(l10n);
        if (!mounted || password == null || password.isEmpty) return;
      }

      BackupImportPrepared? prepared;
      while (mounted) {
        try {
          prepared = await DataTransfer.prepareImport(bytes, password: password);
          break;
        } on BackupWrongPasswordException {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.settingsBackupWrongPassword)),
          );
          password = await _promptImportPassword(l10n);
          if (!mounted || password == null || password.isEmpty) return;
        }
      }
      if (prepared == null || !mounted) return;
      final importReady = prepared;

      final continueImport = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.backupImportPreviewTitle),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.backupImportPreviewVersion(importReady.preview.appVersion),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.backupImportPreviewExported(
                        _formatBackupExportedAt(
                          context,
                          importReady.preview.exportedAtIso,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.backupImportPreviewCounts(
                        importReady.preview.accountsCount,
                        importReady.preview.transactionsCount,
                        importReady.preview.plannedTransactionsCount,
                        importReady.preview.attachmentFilesCount,
                        importReady.preview.incomeCategoriesCount,
                        importReady.preview.expenseCategoriesCount,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l10n.backupImportPreviewContinue),
                ),
              ],
            ),
          ) ??
          false;

      if (!continueImport || !mounted) return;

      final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.settingsDataImportConfirmTitle),
              content: Text(l10n.settingsDataImportConfirmBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l10n.settingsDataImportConfirmAction),
                ),
              ],
            ),
          ) ??
          false;

      if (!confirmed) return;

      await DataTransfer.applyImport(importReady.data);
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDataImportDone)),
      );
    } on BackupChecksumMismatchException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupChecksumMismatch)),
      );
    } on BackupCorruptFileException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupCorruptFile)),
      );
    } on BackupUnsupportedSchemaException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsBackupUnsupportedVersion)),
      );
    } on FormatException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDataImportInvalidFile)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsDataImportFailed)),
      );
    }
  }

  Future<void> _toggleAppSecurity(bool enabled, AppLocalizations l10n) async {
    if (enabled) {
      await _showSetPinDialog(l10n);
      if (!mounted) return;
      setState(() {});
      return;
    }
    await setSecurityEnabled(false);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _showSetPinDialog(AppLocalizations l10n) async {
    final pinCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return AlertDialog(
              title: Text(l10n.securitySetPinTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: pinCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 8,
                    decoration: InputDecoration(
                      labelText: l10n.securityPinLabel,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 8,
                    decoration: InputDecoration(
                      labelText: l10n.securityConfirmPinLabel,
                      errorText: error,
                      counterText: '',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final pin = pinCtrl.text.trim();
                    final confirm = confirmCtrl.text.trim();
                    if (pin.length < 4) {
                      setLocalState(
                        () => error = l10n.securityPinMustBe4Digits,
                      );
                      return;
                    }
                    if (pin != confirm) {
                      setLocalState(() => error = l10n.securityPinMismatch);
                      return;
                    }
                    Navigator.pop(ctx, true);
                  },
                  child: Text(l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
    if (result == true) {
      await saveSecurityPin(pinCtrl.text.trim());
      await setSecurityEnabled(true);
    }
    pinCtrl.dispose();
    confirmCtrl.dispose();
  }

  Future<void> _removePin(AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.securityRemovePinTitle),
            content: Text(l10n.securityRemovePinBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await clearSecurityPin();
    if (!mounted) return;
    setState(() {});
  }

  String _languageSubtitle(AppLocalePreference p, AppLocalizations l10n) {
    return switch (p) {
      AppLocalePreference.system => l10n.settingsLanguageSubtitleSystem,
      AppLocalePreference.english => l10n.settingsLanguageSubtitleEnglish,
      AppLocalePreference.serbianLatin =>
        l10n.settingsLanguageSubtitleSerbianLatin,
    };
  }

  String _languageBadge(AppLocalePreference p) => switch (p) {
        AppLocalePreference.system => '···',
        AppLocalePreference.english => 'EN',
        AppLocalePreference.serbianLatin => 'SR',
      };

  String _themeSubtitle(AppThemePreference p, AppLocalizations l10n) =>
      switch (p) {
        AppThemePreference.system => l10n.settingsThemeSubtitleSystem,
        AppThemePreference.light => l10n.settingsThemeSubtitleLight,
        AppThemePreference.dark => l10n.settingsThemeSubtitleDark,
      };

  IconData _themeIcon(AppThemePreference p) => switch (p) {
        AppThemePreference.system => Icons.brightness_auto_rounded,
        AppThemePreference.light => Icons.light_mode_rounded,
        AppThemePreference.dark => Icons.dark_mode_rounded,
      };

  void _openThemePicker(BuildContext context, AppLocalizations l10n) {
    final current = appThemePreference.value;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        final sheetCs = Theme.of(ctx).colorScheme;
        Widget option({
          required String title,
          required IconData icon,
          required AppThemePreference value,
        }) {
          final selected = current == value;
          return ListTile(
            leading: Icon(icon,
                size: 20,
                color: selected ? sheetCs.primary : sheetCs.onSurfaceVariant),
            title: Text(title),
            trailing: selected
                ? Icon(Icons.check_rounded, color: sheetCs.primary)
                : null,
            onTap: () {
              setAppThemePreference(value);
              Navigator.pop(ctx);
              setState(() {});
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Text(
                  l10n.settingsThemePickerTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              option(
                title: l10n.settingsThemeOptionSystem,
                icon: Icons.brightness_auto_rounded,
                value: AppThemePreference.system,
              ),
              option(
                title: l10n.settingsThemeOptionLight,
                icon: Icons.light_mode_rounded,
                value: AppThemePreference.light,
              ),
              option(
                title: l10n.settingsThemeOptionDark,
                icon: Icons.dark_mode_rounded,
                value: AppThemePreference.dark,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLedgerVerify(BuildContext context, AppLocalizations l10n) {
    final mismatches = verifyLedger(
      accounts: data.accounts,
      transactions: data.transactions,
    );
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) {
        String fmt(double x) => x.toStringAsFixed(2);
        return AlertDialog(
          title: Text(l10n.ledgerVerifyDialogTitle),
          content: SingleChildScrollView(
            child: mismatches.isEmpty
                ? Text(l10n.ledgerVerifyAllMatch)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.ledgerVerifyMismatchesTitle,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...mismatches.map((m) {
                        var name = m.accountId;
                        for (final a in data.accounts) {
                          if (a.id == m.accountId) {
                            name = accountDisplayName(a);
                            break;
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            l10n.ledgerVerifyMismatchDetails(
                              name,
                              fmt(m.storedBalance),
                              fmt(m.recomputedBalance),
                              fmt(m.delta),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  void _openLanguagePicker(BuildContext context, AppLocalizations l10n) {
    final current = appLocalePreference.value;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        final sheetCs = Theme.of(ctx).colorScheme;
        Widget option({
          required String title,
          required AppLocalePreference value,
        }) {
          final selected = current == value;
          return ListTile(
            title: Text(title),
            trailing: selected
                ? Icon(Icons.check_rounded, color: sheetCs.primary)
                : null,
            onTap: () {
              setAppLocalePreference(value);
              Navigator.pop(ctx);
              setState(() {});
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Text(
                  l10n.settingsLanguagePickerTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              option(
                title: l10n.settingsLanguageOptionSystem,
                value: AppLocalePreference.system,
              ),
              option(
                title: l10n.settingsLanguageOptionEnglish,
                value: AppLocalePreference.english,
              ),
              option(
                title: l10n.settingsLanguageOptionSerbianLatin,
                value: AppLocalePreference.serbianLatin,
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
    final archivedCount = data.accounts.where((a) => a.archived).length;

    Widget currencyCard({
      required IconData icon,
      required String title,
      required String subtitle,
      String? badge,
      required VoidCallback onTap,
    }) {
      return Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: cs.primary),
                    ),
                  ),
                if (badge != null) const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: cs.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _SectionLabel(l10n.settingsSectionDisplay),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.home_rounded,
            title: l10n.settingsBaseCurrency,
            subtitle:
                '${settings.baseCurrency} · ${currencyDisplayName(settings.baseCurrency, Localizations.localeOf(context))}',
            badge: fx.currencySymbol(settings.baseCurrency),
            onTap: () async {
              final picked = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) =>
                    _CurrencyPickerSheet(current: settings.baseCurrency),
              );
              if (picked != null) {
                setState(() => settings.baseCurrency = picked);
                await saveCurrencyPreferences();
              }
            },
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.currency_exchange_rounded,
            title: l10n.settingsSecondaryCurrency,
            subtitle:
                '${settings.secondaryCurrency} · ${currencyDisplayName(settings.secondaryCurrency, Localizations.localeOf(context))}',
            badge: fx.currencySymbol(settings.secondaryCurrency),
            onTap: () async {
              final picked = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) =>
                    _CurrencyPickerSheet(current: settings.secondaryCurrency),
              );
              if (picked != null) {
                setState(() => settings.secondaryCurrency = picked);
                await saveCurrencyPreferences();
              }
            },
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.update_rounded,
            title: l10n.settingsExchangeRatesTitle,
            subtitle: FxService.instance.lastUpdated != null
                ? l10n.settingsExchangeRatesUpdated(formatAppDate(
                    context,
                    'y-MM-dd HH:mm',
                    FxService.instance.lastUpdated!.toLocal(),
                  ))
                : l10n.settingsExchangeRatesNeverUpdated,
            badge: l10n.settingsExchangeRatesSource,
            onTap: () async {
              await FxService.instance.refreshRates();
              if (context.mounted) setState(() {});
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsSectionAppearance),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: appThemePreference,
            builder: (context, _) {
              final pref = appThemePreference.value;
              return currencyCard(
                icon: _themeIcon(pref),
                title: l10n.settingsTheme,
                subtitle: _themeSubtitle(pref, l10n),
                badge: switch (pref) {
                  AppThemePreference.system => '···',
                  AppThemePreference.light => '☀',
                  AppThemePreference.dark => '☾',
                },
                onTap: () => _openThemePicker(context, l10n),
              );
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsSectionLanguage),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: appLocalePreference,
            builder: (context, _) {
              final pref = appLocalePreference.value;
              return currencyCard(
                icon: Icons.language_rounded,
                title: l10n.settingsLanguage,
                subtitle: _languageSubtitle(pref, l10n),
                badge: _languageBadge(pref),
                onTap: () => _openLanguagePicker(context, l10n),
              );
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsSectionSecurity),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ValueListenableBuilder<bool>(
                valueListenable: appSecurityEnabled,
                builder: (context, enabled, _) {
                  return Column(
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.settingsSecurityEnableLock),
                        subtitle: Text(l10n.settingsSecurityEnableLockSubtitle),
                        value: enabled,
                        onChanged: (v) => _toggleAppSecurity(v, l10n),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<bool>(
                        future: hasSecurityPin(),
                        builder: (context, snap) {
                          final hasPin = snap.data ?? false;
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.pin_rounded, size: 20),
                                title: Text(
                                  hasPin
                                      ? l10n.settingsSecurityChangePin
                                      : l10n.settingsSecuritySetPin,
                                ),
                                subtitle: Text(l10n.settingsSecurityPinSubtitle),
                                enabled: enabled,
                                onTap: enabled
                                    ? () async {
                                        await _showSetPinDialog(l10n);
                                        if (mounted) setState(() {});
                                      }
                                    : null,
                              ),
                              if (hasPin)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading:
                                      const Icon(Icons.delete_outline_rounded),
                                  title: Text(l10n.settingsSecurityRemovePin),
                                  enabled: enabled,
                                  onTap: enabled
                                      ? () => _removePin(l10n)
                                      : null,
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsSectionCategories),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.label_outline_rounded,
            title: l10n.settingsCategories,
            subtitle: l10n.settingsCategoriesSubtitle(
              data.incomeCategories.length,
              data.expenseCategories.length,
            ),
            badge:
                '${data.incomeCategories.length + data.expenseCategories.length}',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CategoriesScreen()),
              );
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsSectionAccounts),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.inventory_2_outlined,
            title: l10n.settingsArchivedAccounts,
            subtitle: archivedCount == 0
                ? l10n.settingsArchivedAccountsSubtitleZero
                : l10n.settingsArchivedAccountsSubtitleCount(archivedCount),
            badge: '$archivedCount',
            onTap: () async {
              await Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => const ArchivedAccountsScreen(),
                ),
              );
              if (mounted) setState(() {});
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsSectionData),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.fact_check_outlined,
            title: l10n.settingsVerifyLedger,
            subtitle: l10n.settingsVerifyLedgerSubtitle,
            onTap: () => _showLedgerVerify(context, l10n),
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.ios_share_rounded,
            title: l10n.settingsDataExportTitle,
            subtitle: l10n.settingsDataExportSubtitle,
            onTap: () => _exportBackup(l10n),
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.upload_file_rounded,
            title: l10n.settingsDataImportTitle,
            subtitle: l10n.settingsDataImportSubtitle,
            onTap: () => _importBackup(l10n),
          ),
        ],
      ),
    );
  }
}

// ─── Archived accounts screen ─────────────────────────────────────────────────

class ArchivedAccountsScreen extends StatefulWidget {
  const ArchivedAccountsScreen({super.key});

  @override
  State<ArchivedAccountsScreen> createState() => _ArchivedAccountsScreenState();
}

class _ArchivedAccountsScreenState extends State<ArchivedAccountsScreen> {
  String _groupLabel(AccountGroup g, AppLocalizations l10n) => switch (g) {
        AccountGroup.personal => l10n.accountGroupPersonal,
        AccountGroup.individuals => l10n.accountGroupIndividual,
        AccountGroup.entities => l10n.accountGroupEntity,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final archived =
        data.accounts.where((a) => a.archived).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.archivedAccountsTitle),
        backgroundColor: cs.surface,
      ),
      body: archived.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 56,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.archivedAccountsEmptyTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.archivedAccountsEmptyBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              itemCount: archived.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final a = archived[i];
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(accountDisplayName(a)),
                    subtitle: Text(_groupLabel(a.group, l10n)),
                    trailing: TextButton(
                      onPressed: () {
                        setState(() => a.archived = false);
                      },
                      child: Text(l10n.restore),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ─── Categories screen ────────────────────────────────────────────────────────

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void _addCategory(List<String> targetList) async {
    final controller = TextEditingController();
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final l = AppLocalizations.of(ctx);
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text(l.newCategoryTitle),
            content: TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.categoryNameLabel),
              onSubmitted: (v) =>
                  Navigator.pop(ctx, v.trim().isEmpty ? null : v.trim()),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: () {
                  final v = controller.text.trim();
                  Navigator.pop(ctx, v.isEmpty ? null : v);
                },
                child: Text(l.categoryAdd),
              ),
            ],
          );
        },
      );
      if (result != null && !targetList.contains(result)) {
        if (!mounted) return;
        if (!await guardPersist(
          context,
          () => DataRepository.addCategory(
            result,
            income: identical(targetList, data.incomeCategories),
          ),
        )) {
          if (mounted) setState(() {});
          return;
        }
        if (mounted) setState(() {});
      }
    } finally {
      controller.dispose();
    }
  }

  void _deleteCategory(String category, List<String> targetList) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx);
        final displayName = l10nCategoryName(ctx, category);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l.deleteCategoryTitle),
          content: Text(l.deleteCategoryBody(displayName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (!await guardPersist(
                  context,
                  () => DataRepository.removeCategory(
                    category,
                    income: identical(targetList, data.incomeCategories),
                  ),
                )) {
                  if (mounted) setState(() {});
                  return;
                }
                if (mounted) setState(() {});
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoriesTitle),
        backgroundColor: cs.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SubSection(
                    label: l10n.categoryIncome,
                    addLabel: l10n.categoryAdd,
                    color: lc.positive,
                    categories: data.incomeCategories,
                    onAdd: () => _addCategory(data.incomeCategories),
                    onDelete: (c) =>
                        _deleteCategory(c, data.incomeCategories),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                      height: 1,
                      color: cs.outlineVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  _SubSection(
                    label: l10n.categoryExpense,
                    addLabel: l10n.categoryAdd,
                    color: lc.negative,
                    categories: data.expenseCategories,
                    onAdd: () => _addCategory(data.expenseCategories),
                    onDelete: (c) =>
                        _deleteCategory(c, data.expenseCategories),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ─── Currency Picker Sheet ─────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String current;
  const _CurrencyPickerSheet({required this.current});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final filtered = settings.supportedCurrencies
        .where((c) {
          if (_query.isEmpty) return true;
          final q = _query.toLowerCase();
          final name = currencyDisplayName(c, locale).toLowerCase();
          return c.toLowerCase().contains(q) || name.contains(q);
        })
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.searchCurrencies,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => setState(() {
                          _searchController.clear();
                          _query = '';
                        }),
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: ctrl,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final code = filtered[i];
                final name =
                    currencyDisplayName(code, Localizations.localeOf(context));
                final isSelected = code == widget.current;
                return ListTile(
                  leading: Container(
                    width: 44,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primaryContainer
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        fx.currencySymbol(code),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color:
                              isSelected ? cs.primary : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  title: Text(code,
                      style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 14)),
                  subtitle: Text(name,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant)),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded,
                          color: cs.primary, size: 18)
                      : null,
                  onTap: () => Navigator.pop(ctx, code),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SubSection extends StatelessWidget {
  final String label;
  final String addLabel;
  final Color color;
  final List<String> categories;
  final VoidCallback onAdd;
  final void Function(String) onDelete;

  const _SubSection({
    required this.label,
    required this.addLabel,
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
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ...categories.map(
              (cat) => Chip(
                label: Text(
                  l10nCategoryName(context, cat),
                  style: const TextStyle(fontSize: 12),
                ),
                onDeleted: () => onDelete(cat),
                deleteIcon: const Icon(Icons.close_rounded, size: 13),
                visualDensity: VisualDensity.compact,
              ),
            ),
            ActionChip(
              avatar: Icon(Icons.add_rounded, size: 14, color: color),
              label: Text(
                addLabel,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              onPressed: onAdd,
              side: BorderSide(color: color.withValues(alpha: 0.35)),
              backgroundColor: color.withValues(alpha: 0.08),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }
}
