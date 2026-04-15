import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../data/app_data.dart' as data;
import '../theme/ledger_colors.dart';
import '../data/auto_backup_service.dart';
import '../data/backup_export_reminder_prefs.dart';
import '../data/balance_privacy_prefs.dart';
import '../data/data_repository.dart';
import '../data/data_transfer.dart';
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
import '../l10n/supported_languages.dart';
import '../models/account.dart';
import '../utils/fx.dart' as fx;
import '../utils/manual_backup_export_flow.dart';
import '../widgets/ledger_verify_dialog.dart';
import '../utils/persistence_guard.dart';
import 'app_about_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final Future<PackageInfo> _packageInfoFuture = PackageInfo.fromPlatform();
  bool _refreshingRates = false;
  bool _exportingBackup = false;

  Future<void> _exportBackup(AppLocalizations l10n) async {
    if (!mounted) return;
    setState(() => _exportingBackup = true);
    try {
      await runManualBackupExportFlow(context: context, l10n: l10n);
    } finally {
      if (mounted) setState(() => _exportingBackup = false);
    }
  }

  Future<void> _pickBackupReminderThreshold(AppLocalizations l10n) async {
    final ctrl = TextEditingController(
      text: '${backupExportReminderThreshold.value}',
    );
    try {
      final picked = await showDialog<int>(
        context: context,
        builder: (ctx) {
          String? err;
          return StatefulBuilder(
            builder: (ctx, setLocal) {
              return AlertDialog(
                title: Text(l10n.settingsBackupReminderThresholdTitle),
                content: TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.settingsBackupReminderThresholdTitle,
                    errorText: err,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () {
                      final v = int.tryParse(ctrl.text.trim());
                      if (v == null ||
                          v < kBackupReminderThresholdMin ||
                          v > kBackupReminderThresholdMax) {
                        setLocal(() =>
                            err = l10n.settingsBackupReminderThresholdInvalid);
                        return;
                      }
                      Navigator.pop(ctx, v);
                    },
                    child: Text(l10n.confirm),
                  ),
                ],
              );
            },
          );
        },
      );
      if (picked != null && mounted) {
        await setBackupExportReminderThreshold(picked);
        setState(() {});
      }
    } finally {
      ctrl.dispose();
    }
  }

  String _formatBackupExportedAt(BuildContext context, String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return formatAppDate(context, 'y-MM-dd HH:mm', d.toLocal());
  }

  Future<String?> _promptImportPassword(AppLocalizations l10n) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => _BackupImportPasswordDialog(l10n: l10n),
    );
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
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                    foregroundColor: Theme.of(ctx).colorScheme.onError,
                  ),
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
      // Avoid competing with dialog route teardown (SnackBar + overlay).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsDataImportDone)),
        );
      });
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

  String _lockGraceOptionLabel(AppLocalizations l10n, int seconds) {
    return switch (seconds) {
      0 => l10n.settingsSecurityLockDelayImmediate,
      30 => l10n.settingsSecurityLockDelay30s,
      60 => l10n.settingsSecurityLockDelay1m,
      300 => l10n.settingsSecurityLockDelay5m,
      _ => l10n.settingsSecurityLockDelayImmediate,
    };
  }

  Future<void> _toggleAppSecurity(bool enabled, AppLocalizations l10n) async {
    if (enabled) {
      await _showSetPinDialog(l10n);
      if (!mounted) return;
      setState(() {});
      return;
    }
    await setSecurityEnabled(false);
    await clearLockGracePreference();
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

  void _openPrivacyPolicy() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  }

  String _languageSubtitle(String tag, AppLocalizations l10n) {
    if (tag == kLocaleTagSystem) {
      return l10n.settingsLanguageSubtitleSystem;
    }
    return localeEndonym(tag);
  }

  String _languageBadge(String tag) =>
      tag == kLocaleTagSystem ? '···' : localeBadge(tag);

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
    showLedgerVerifyReadOnlyDialog(context, l10n);
  }

  void _openLanguagePicker(BuildContext context, AppLocalizations l10n) {
    final current = appLocaleTag.value;
    final h = MediaQuery.sizeOf(context).height;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) {
        final sheetCs = Theme.of(ctx).colorScheme;
        Widget option({
          required String title,
          required String tag,
        }) {
          final selected = current == tag;
          return ListTile(
            title: Text(title),
            trailing: selected
                ? Icon(Icons.check_rounded, color: sheetCs.primary)
                : null,
            onTap: () {
              setAppLocaleTag(tag);
              Navigator.pop(ctx);
              setState(() {});
            },
          );
        }

        return SizedBox(
          height: h * 0.88,
          child: Column(
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    option(
                      title: l10n.settingsLanguageOptionSystem,
                      tag: kLocaleTagSystem,
                    ),
                    for (final tag in kSelectableLocaleTags)
                      option(
                        title: localeEndonym(tag),
                        tag: tag,
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
      bool loadingBadge = false,
      String? semanticsLabel,
      VoidCallback? onTap,
    }) {
      final card = Card(
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
                if (loadingBadge) ...[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else if (badge != null) ...[
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
                  const SizedBox(width: 4),
                ],
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      );
      if (semanticsLabel == null) return card;
      return Semantics(
        button: true,
        label: semanticsLabel,
        child: card,
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
          // ── 1. Security ──────────────────────────────────
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
                      if (enabled) ...[
                        const SizedBox(height: 8),
                        ValueListenableBuilder<int>(
                          valueListenable: appLockGraceSeconds,
                          builder: (context, graceSeconds, _) {
                            final cs = Theme.of(context).colorScheme;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.settingsSecurityLockDelayTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.settingsSecurityLockDelaySubtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: cs.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButton<int>(
                                  isExpanded: true,
                                  value: graceSeconds,
                                  borderRadius: BorderRadius.circular(12),
                                  items: [
                                    for (final sec in kAppLockGraceOptions)
                                      DropdownMenuItem<int>(
                                        value: sec,
                                        child: Text(
                                          _lockGraceOptionLabel(l10n, sec),
                                        ),
                                      ),
                                  ],
                                  onChanged: (v) async {
                                    if (v == null) return;
                                    await setLockGraceSeconds(v);
                                    if (mounted) setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 4),
                      FutureBuilder<bool>(
                        future: hasSecurityPin(),
                        builder: (context, snap) {
                          final hasPin = snap.data ?? false;
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading:
                                    const Icon(Icons.pin_rounded, size: 20),
                                title: Text(
                                  hasPin
                                      ? l10n.settingsSecurityChangePin
                                      : l10n.settingsSecuritySetPin,
                                ),
                                subtitle:
                                    Text(l10n.settingsSecurityPinSubtitle),
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
                                  leading: const Icon(
                                      Icons.delete_outline_rounded),
                                  title:
                                      Text(l10n.settingsSecurityRemovePin),
                                  enabled: enabled,
                                  onTap:
                                      enabled ? () => _removePin(l10n) : null,
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
          // ── 2. Preferences ───────────────────────────────
          _SectionLabel(l10n.settingsSectionPreferences),
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
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: appLocaleTag,
            builder: (context, _) {
              final tag = appLocaleTag.value;
              return currencyCard(
                icon: Icons.language_rounded,
                title: l10n.settingsLanguage,
                subtitle: _languageSubtitle(tag, l10n),
                badge: _languageBadge(tag),
                onTap: () => _openLanguagePicker(context, l10n),
              );
            },
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ValueListenableBuilder<bool>(
                valueListenable: balancePrivacyHideByDefault,
                builder: (context, hide, _) {
                  return SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(
                      Icons.visibility_off_outlined,
                      size: 20,
                      color: cs.primary,
                    ),
                    title: Text(
                      l10n.settingsHideHeroBalancesTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      l10n.settingsHideHeroBalancesSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    value: hide,
                    onChanged: (v) async {
                      await setBalancePrivacyHideByDefault(v);
                      if (mounted) setState(() {});
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ── 3. Data ──────────────────────────────────────
          _SectionLabel(l10n.settingsSectionData),
          const SizedBox(height: 8),
          // Auto-backup toggle
          StatefulBuilder(
            builder: (context, setLocal) {
              final svc = AutoBackupService.instance;
              final lastAt = svc.lastBackupAt;
              final subtitle = lastAt != null
                  ? l10n.autoBackupLastAt(
                      formatAppDate(context, 'y-MM-dd HH:mm', lastAt.toLocal()),
                    )
                  : l10n.autoBackupNeverRun;
              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(Icons.backup_outlined,
                        size: 20, color: cs.primary),
                    title: Text(l10n.autoBackupTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: cs.onSurfaceVariant)),
                    value: svc.enabled,
                    onChanged: (v) async {
                      await svc.setEnabled(v);
                      setLocal(() {});
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: backupExportReminderListenable,
            builder: (context, _) {
              final enabled = backupExportReminderEnabled.value;
              final threshold = backupExportReminderThreshold.value;
              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        secondary: Icon(
                          Icons.notification_important_outlined,
                          size: 20,
                          color: cs.primary,
                        ),
                        title: Text(
                          l10n.settingsBackupReminderTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          enabled
                              ? '${l10n.settingsBackupReminderSubtitle}\n${l10n.settingsBackupReminderSnoozeHint(backupExportReminderThreshold.value)}'
                              : l10n.settingsBackupReminderSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        value: enabled,
                        onChanged: (v) async {
                          await setBackupExportReminderEnabled(v);
                        },
                      ),
                      if (enabled)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.tag_outlined,
                            size: 20,
                            color: cs.primary,
                          ),
                          title: Text(
                            l10n.settingsBackupReminderThresholdTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            l10n.settingsBackupReminderThresholdSubtitle(
                              threshold,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _pickBackupReminderThreshold(l10n),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.ios_share_rounded,
            title: l10n.settingsDataExportTitle,
            subtitle: l10n.settingsDataExportSubtitle,
            loadingBadge: _exportingBackup,
            semanticsLabel:
                '${l10n.settingsDataExportTitle}. ${l10n.settingsDataExportSubtitle}',
            onTap: _exportingBackup ? null : () => _exportBackup(l10n),
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.restore_rounded,
            title: l10n.settingsDataImportTitle,
            subtitle: l10n.settingsDataImportSubtitle,
            semanticsLabel:
                '${l10n.settingsDataImportTitle}. ${l10n.settingsDataImportSubtitle}',
            onTap: () => _importBackup(l10n),
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
            badge: _refreshingRates ? null : l10n.settingsExchangeRatesSource,
            loadingBadge: _refreshingRates,
            onTap: _refreshingRates
                ? null
                : () async {
                    setState(() => _refreshingRates = true);
                    try {
                      await FxService.instance.refreshRates();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsExchangeRatesUpdatedSnack),
                        ),
                      );
                    } catch (_) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsExchangeRatesUpdateFailed),
                        ),
                      );
                    } finally {
                      if (mounted) setState(() => _refreshingRates = false);
                    }
                  },
          ),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.fact_check_outlined,
            title: l10n.settingsVerifyLedger,
            subtitle: l10n.settingsVerifyLedgerSubtitle,
            onTap: () => _showLedgerVerify(context, l10n),
          ),
          const SizedBox(height: 24),
          // ── 4. Manage ────────────────────────────────────
          _SectionLabel(l10n.settingsSectionManage),
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
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.delete_sweep_outlined,
            title: l10n.settingsClearData,
            subtitle: l10n.settingsClearDataSubtitle,
            onTap: () async {
              final cleared = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _ClearDataSheet(l10n: l10n),
              );
              if (cleared == true && mounted) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.clearDataDone)),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          // ── 5. About ─────────────────────────────────────
          _SectionLabel(l10n.settingsSectionPrivacy),
          const SizedBox(height: 8),
          currencyCard(
            icon: Icons.policy_outlined,
            title: l10n.settingsPrivacyPolicyTitle,
            subtitle: l10n.settingsPrivacyPolicySubtitle,
            semanticsLabel:
                '${l10n.settingsPrivacyPolicyTitle}. ${l10n.settingsPrivacyPolicySubtitle}',
            onTap: _openPrivacyPolicy,
          ),
          const SizedBox(height: 8),
          FutureBuilder<PackageInfo>(
            future: _packageInfoFuture,
            builder: (context, snap) {
              final subtitle = snap.hasData
                  ? '${snap.data!.version} · ${l10n.aboutBuildLabel} ${snap.data!.buildNumber}'
                  : l10n.settingsSoftwareVersionSubtitle;
              final semanticsLabel = snap.hasData
                  ? '${l10n.settingsSoftwareVersionTitle}. $subtitle'
                  : '${l10n.settingsSoftwareVersionTitle}. ${l10n.settingsSoftwareVersionSubtitle}';
              return currencyCard(
                icon: Icons.layers_outlined,
                title: l10n.settingsSoftwareVersionTitle,
                subtitle: subtitle,
                semanticsLabel: semanticsLabel,
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const AppAboutScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Backup dialogs (controllers owned by dialog State; avoids dispose races) ─

class _BackupImportPasswordDialog extends StatefulWidget {
  const _BackupImportPasswordDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_BackupImportPasswordDialog> createState() =>
      _BackupImportPasswordDialogState();
}

class _BackupImportPasswordDialogState extends State<_BackupImportPasswordDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return AlertDialog(
      title: Text(l10n.backupImportPasswordTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.backupImportPasswordBody),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.backupImportPasswordLabel,
              ),
              onSubmitted: (_) {
                final v = _controller.text.trim();
                if (v.isNotEmpty) Navigator.pop(context, v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final v = _controller.text.trim();
            if (v.isEmpty) return;
            Navigator.pop(context, v);
          },
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}

/// PIN confirmation for clear-data. Controller is disposed in [State.dispose]
/// after the route is torn down (unlike disposing in `showDialog`'s `finally`,
/// which can race the overlay and trigger framework assertions).
class _ClearDataPinDialog extends StatefulWidget {
  const _ClearDataPinDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_ClearDataPinDialog> createState() => _ClearDataPinDialogState();
}

class _ClearDataPinDialogState extends State<_ClearDataPinDialog> {
  late final TextEditingController _ctrl;
  String? _error;

  AppLocalizations get l10n => widget.l10n;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final ok = await verifySecurityPin(_ctrl.text.trim());
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      setState(() => _error = l10n.clearDataPinIncorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(l10n.clearDataPinTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.clearDataPinBody),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.securityPinLabel,
                errorText: _error,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: cs.error,
            foregroundColor: cs.onError,
          ),
          onPressed: _onConfirm,
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}

/// Type-DELETE confirmation for clear-data.
class _ClearDataTypeDeleteDialog extends StatefulWidget {
  const _ClearDataTypeDeleteDialog({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_ClearDataTypeDeleteDialog> createState() =>
      _ClearDataTypeDeleteDialogState();
}

class _ClearDataTypeDeleteDialogState extends State<_ClearDataTypeDeleteDialog> {
  late final TextEditingController _ctrl;
  String? _error;

  AppLocalizations get l10n => widget.l10n;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(l10n.clearDataConfirmTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.clearDataConfirmBody),
            const SizedBox(height: 16),
            TextField(
              controller: _ctrl,
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l10n.clearDataTypeConfirm,
                hintText: 'DELETE',
                errorText: _error,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: cs.error,
            foregroundColor: cs.onError,
          ),
          onPressed: () {
            if (_ctrl.text.trim() == 'DELETE') {
              Navigator.pop(context, true);
            } else {
              setState(() => _error = l10n.clearDataTypeConfirmError);
            }
          },
          child: Text(l10n.clearDataConfirmButton),
        ),
      ],
    );
  }
}

// ─── Clear data sheet ─────────────────────────────────────────────────────────

class _ClearDataSheet extends StatefulWidget {
  const _ClearDataSheet({required this.l10n});
  final AppLocalizations l10n;

  @override
  State<_ClearDataSheet> createState() => _ClearDataSheetState();
}

class _ClearDataSheetState extends State<_ClearDataSheet> {
  bool _transactions = false;
  bool _planned = false;
  bool _accounts = false;
  bool _categories = false;
  bool _preferences = false;
  bool _security = false;
  bool _processing = false;

  AppLocalizations get l10n => widget.l10n;

  bool get _hasSelection =>
      _transactions || _planned || _accounts || _categories ||
      _preferences || _security;

  void _setAccounts(bool v) {
    setState(() {
      _accounts = v;
      if (v) {
        _transactions = true;
        _planned = true;
      }
    });
  }

  Future<void> _confirmAndClear() async {
    final hasPin = appSecurityEnabled.value && await hasSecurityPin();
    if (!mounted) return;

    final confirmed = hasPin
        ? await _showPinDialog()
        : await _showTypeDeleteDialog();
    if (confirmed != true || !mounted) return;

    setState(() => _processing = true);
    try {
      await DataRepository.clearSelectiveData(
        transactions: _transactions || _accounts,
        planned: _planned || _accounts,
        accounts: _accounts,
        categories: _categories,
      );

      if (_preferences && mounted) {
        settings.baseCurrency = 'BAM';
        settings.secondaryCurrency = 'EUR';
        await saveCurrencyPreferences();
        setAppThemePreference(AppThemePreference.system);
        setAppLocaleTag(kLocaleTagSystem);
        await FxService.instance.clearCache();
      }

      if (_security && mounted) {
        await setSecurityEnabled(false);
        await clearSecurityPin();
        await clearLockGracePreference();
      }

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<bool?> _showPinDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ClearDataPinDialog(l10n: l10n),
    );
  }

  Future<bool?> _showTypeDeleteDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ClearDataTypeDeleteDialog(l10n: l10n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final txCount = data.transactions.length;
    final plannedCount = data.plannedTransactions.length;
    final accountCount = data.accounts.length;
    final catCount = data.incomeCategories.length + data.expenseCategories.length;

    Widget item({
      required bool value,
      required ValueChanged<bool?>? onChanged,
      required String title,
      required String subtitle,
      bool danger = false,
    }) {
      return CheckboxListTile(
        value: value,
        onChanged: _processing ? null : onChanged,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: danger ? cs.error : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
        ),
        activeColor: danger ? cs.error : cs.primary,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              l10n.clearDataTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          item(
            value: _transactions,
            onChanged: _accounts ? null : (v) => setState(() => _transactions = v ?? false),
            title: l10n.clearDataTransactions,
            subtitle: l10n.clearDataTransactionsSubtitle(txCount),
          ),
          item(
            value: _planned,
            onChanged: _accounts ? null : (v) => setState(() => _planned = v ?? false),
            title: l10n.clearDataPlanned,
            subtitle: l10n.clearDataPlannedSubtitle(plannedCount),
          ),
          item(
            value: _accounts,
            onChanged: (v) => _setAccounts(v ?? false),
            title: l10n.clearDataAccounts,
            subtitle: l10n.clearDataAccountsSubtitle(accountCount),
            danger: true,
          ),
          item(
            value: _categories,
            onChanged: (v) => setState(() => _categories = v ?? false),
            title: l10n.clearDataCategories,
            subtitle: l10n.clearDataCategoriesSubtitle(catCount),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
          item(
            value: _preferences,
            onChanged: (v) => setState(() => _preferences = v ?? false),
            title: l10n.clearDataPreferences,
            subtitle: l10n.clearDataPreferencesSubtitle,
          ),
          item(
            value: _security,
            onChanged: (v) => setState(() => _security = v ?? false),
            title: l10n.clearDataSecurity,
            subtitle: l10n.clearDataSecuritySubtitle,
            danger: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _hasSelection ? cs.error : null,
                foregroundColor: _hasSelection ? cs.onError : null,
              ),
              onPressed: _hasSelection && !_processing ? _confirmAndClear : null,
              child: _processing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onError,
                      ),
                    )
                  : Text(l10n.clearDataConfirmButton),
            ),
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
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
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
