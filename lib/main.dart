import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/app_signals.dart';
import 'data/auto_backup_service.dart';
import 'data/backup_export_reminder_prefs.dart';
import 'data/balance_privacy_prefs.dart';
import 'data/currency_prefs.dart';
import 'data/data_repository.dart';
import 'data/data_transfer.dart';
import 'data/local/platrare_database.dart';
import 'data/fx_service.dart';
import 'data/locale_prefs.dart';
import 'data/navigation_prefs.dart';
import 'data/onboarding_prefs.dart';
import 'data/planned_reminder_prefs.dart';
import 'data/planned_reminder_service.dart';
import 'data/security_prefs.dart';
import 'data/theme_prefs.dart';
import 'data/widget_link_router.dart';
import 'data/widget_prefs.dart';
import 'data/widget_snapshot_service.dart';
import 'l10n/app_localizations.dart' show AppLocalizations;
import 'l10n/supported_languages.dart';
import 'utils/manual_backup_export_flow.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/account_transactions_screen.dart';
import 'screens/new_planned_transaction_screen.dart';
import 'screens/new_transaction_screen.dart';
import 'screens/track_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/review_screen.dart';
import 'theme/platrare_surfaces.dart';
import 'theme/platrare_theme.dart';
import 'data/app_data.dart' as data;
import 'models/planned_transaction.dart';
import 'utils/fx.dart' as fx;
import 'utils/money_format.dart';
import 'utils/persistence_guard.dart';
import 'widgets/app_lock_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await PlatrareDatabase.openPlatrareDatabase();
  await PlatrareDatabase.instance.loadIntoMemory();
  await Future.wait([
    initAppLocale(),
    initAppTheme(),
    initSecurityPrefs(),
    initBalancePrivacyPrefs(),
    initBackupExportReminderPrefs(),
    initPlannedReminderPrefs(),
    initWidgetPrefs(),
    DataTransfer.warmAttachmentsLibrary(),
  ]);
  // After prefs + data are in memory: schedules the pending reminders.
  await PlannedReminderService.instance.init();
  await loadCurrencyPreferences();
  await _initDateFormattingForLocales();
  await FxService.instance.init();
  // After data + prefs + rates: writes the first home-screen widget snapshot
  // and registers the localized app-icon quick actions.
  await WidgetSnapshotService.instance.init();
  await AutoBackupService.instance.init();
  assert(() {
    debugPrint('[FX Test] ${fx.runFxLogicTest()}');
    return true;
  }());
  // Native buffers any link that arrived before now (cold-start widget taps
  // fire long before Dart is ready), then flushes on this call.
  await initWidgetLinks();
  final initialMainTabIndex = await loadLastMainTabIndex();
  // First run only: an install that already has accounts or a lock predates
  // the onboarding screen and is marked done without ever seeing it.
  var showOnboarding = !await isOnboardingDone();
  if (showOnboarding &&
      (data.accounts.isNotEmpty || appSecurityEnabled.value)) {
    await markOnboardingDone();
    showOnboarding = false;
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(PlatrareApp(
    initialMainTabIndex: initialMainTabIndex,
    showOnboarding: showOnboarding,
  ));
}

Future<void> _initDateFormattingForLocales() async {
  final tags = <String>{
    'en',
    'sr',
    'sr_Latn',
    'pt',
    'pt_BR',
    'zh',
    'zh_Hans',
    for (final t in kSelectableLocaleTags) dateFormattingInitTag(t),
  };
  for (final tag in tags) {
    try {
      await initializeDateFormatting(tag);
    } catch (_) {
      // intl may not ship data for every tag; ignore.
    }
  }
}

class PlatrareApp extends StatelessWidget {
  const PlatrareApp({
    super.key,
    this.initialMainTabIndex = 0,
    this.showOnboarding = false,
  });

  /// Restored from [loadLastMainTabIndex] before [runApp].
  final int initialMainTabIndex;

  /// First run: show [OnboardingScreen] above Home once the splash clears.
  final bool showOnboarding;

  /// Match [deviceLocale] to a supported locale, or null if no match.
  static Locale? _tryMatchLocale(
      Locale deviceLocale, Iterable<Locale> supported) {
    final lang = deviceLocale.languageCode;

    if (lang == 'sr') {
      if (deviceLocale.scriptCode == 'Cyrl') {
        return const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Cyrl');
      }
      return const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn');
    }

    if (lang == 'zh') {
      if (deviceLocale.scriptCode == 'Hant') {
        return null;
      }
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    }

    if (lang == 'pt') {
      return const Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR');
    }

    for (final s in supported) {
      if (s.languageCode != lang) continue;
      final ds = deviceLocale.scriptCode;
      final ss = s.scriptCode;
      if (ss != null && ss.isNotEmpty) {
        if (ds != ss) continue;
      }
      final dc = deviceLocale.countryCode;
      final sc = s.countryCode;
      if (sc != null &&
          sc.isNotEmpty &&
          dc != null &&
          dc.isNotEmpty &&
          sc != dc) {
        continue;
      }
      return s;
    }
    return null;
  }

  static Locale _resolveLocale(Locale? locale, Iterable<Locale> supported) {
    if (locale != null) {
      final m = _tryMatchLocale(locale, supported);
      if (m != null) return m;
    }
    for (final s in supported) {
      if (s.languageCode == 'en') return s;
    }
    return supported.first;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLocaleTag,
      builder: (context, localeTag, _) {
        return ValueListenableBuilder<AppThemePreference>(
          valueListenable: appThemePreference,
          builder: (context, themePref, _) {
            return MaterialApp(
              title: 'Platrare',
              debugShowCheckedModeBanner: false,
              theme: buildPlatrareTheme(Brightness.light),
              darkTheme: buildPlatrareTheme(Brightness.dark),
              themeMode: themeModeFor(themePref),
              locale: localeForMaterialApp(localeTag),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              localeListResolutionCallback: (locales, supported) {
                Locale resolved = _resolveLocale(null, supported);
                if (locales != null && locales.isNotEmpty) {
                  for (final deviceLocale in locales) {
                    final match = _tryMatchLocale(deviceLocale, supported);
                    if (match != null) {
                      resolved = match;
                      break;
                    }
                  }
                }
                // Amounts (grouping, decimal separator) follow the UI locale.
                setAppNumberLocale(resolved);
                return resolved;
              },
              home: _SplashRoot(
                initialTabIndex: initialMainTabIndex,
                showOnboarding: showOnboarding,
              ),
            );
          },
        );
      },
    );
  }

}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialTabIndex = 0});

  /// 0 = Plan, 1 = Track, 2 = Review (from [loadLastMainTabIndex] on cold start).
  final int initialTabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

// ---------------------------------------------------------------------------
// Splash root — shows SplashScreen once on cold start, then fades to home
// ---------------------------------------------------------------------------

class _SplashRoot extends StatefulWidget {
  const _SplashRoot({
    required this.initialTabIndex,
    this.showOnboarding = false,
  });

  final int initialTabIndex;
  final bool showOnboarding;

  @override
  State<_SplashRoot> createState() => _SplashRootState();
}

class _SplashRootState extends State<_SplashRoot> {
  bool _splashDone = false;
  late bool _onboardingPending = widget.showOnboarding;

  @override
  Widget build(BuildContext context) {
    // Home is always in the tree so it's visible the moment the splash fades
    // to transparent — no flash between splash exit and home entry.
    return Stack(
      children: [
        AppLockGate(
          child: HomePage(initialTabIndex: widget.initialTabIndex),
        ),
        if (_onboardingPending)
          Positioned.fill(
            child: OnboardingScreen(
              suggestedCurrency: suggestedBaseCurrency(
                WidgetsBinding.instance.platformDispatcher.locale,
              ),
              onDone: (startTour) {
                if (!mounted) return;
                setState(() => _onboardingPending = false);
                if (startTour) {
                  // Plan is tab 0 on a fresh install; the tour targets it.
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => requestPlanHelpTour.value++,
                  );
                }
              },
            ),
          ),
        if (!_splashDone)
          Positioned.fill(
            child: SplashScreen(
              onComplete: () {
                splashCompleted.value = true;
                if (mounted) setState(() => _splashDone = true);
              },
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  /// 0 = Plan, 1 = Track, 2 = Review.
  late int _currentIndex;

  bool _backupMaterialBannerVisible = false;
  bool _backupExportFromBannerBusy = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex.clamp(0, 2);
    WidgetsBinding.instance.addObserver(this);
    backupExportReminderListenable.addListener(_onBackupExportReminderListenable);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncBackupExportMaterialBanner();
    });
    // Run backup check on cold start (data is already loaded).
    _runAutoBackup();

    // Deep links from widgets / quick actions / Siri. Dispatch lives here
    // because this State already sits under MaterialApp's Navigator, already
    // owns the tab index, and already drives the tabs' onChanged — so no
    // global navigatorKey is needed.
    pendingWidgetAction.addListener(_maybeDispatchWidgetAction);
    splashCompleted.addListener(_maybeDispatchWidgetAction);
    appUnlocked.addListener(_maybeDispatchWidgetAction);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _maybeDispatchWidgetAction());
  }

  @override
  void dispose() {
    backupExportReminderListenable.removeListener(_onBackupExportReminderListenable);
    pendingWidgetAction.removeListener(_maybeDispatchWidgetAction);
    splashCompleted.removeListener(_maybeDispatchWidgetAction);
    appUnlocked.removeListener(_maybeDispatchWidgetAction);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ─── Widget / quick-action deep links ──────────────────────────────────────

  /// Nonces already handled. Cold start can deliver the same URL twice (via
  /// `willConnectTo` and again through `openURLContexts`).
  final Set<String> _handledLinkNonces = {};
  bool _dispatchingLink = false;

  void _maybeDispatchWidgetAction() {
    final action = pendingWidgetAction.value;
    if (action == null || _dispatchingLink || !mounted) return;

    // Wait for the splash to clear, then for authentication. The action sits
    // in the notifier, so an arbitrarily long lock wait is fine.
    if (!splashCompleted.value) return;
    if (appSecurityEnabled.value && !appUnlocked.value) return;

    if (!_handledLinkNonces.add(action.nonce)) {
      pendingWidgetAction.value = null;
      return;
    }
    // Keep the set bounded across a long-lived session.
    if (_handledLinkNonces.length > 64) {
      _handledLinkNonces.remove(_handledLinkNonces.first);
    }
    pendingWidgetAction.value = null;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _dispatchWidgetAction(action));
  }

  Future<void> _dispatchWidgetAction(PendingWidgetAction action) async {
    if (!mounted) return;
    _dispatchingLink = true;
    try {
      switch (action) {
        case OpenTabAction(:final tabIndex):
          _selectTab(tabIndex);

        case AddTrackedAction():
          _selectTab(1); // Track
          final saved = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const NewTransactionScreen()),
          );
          // NewTransactionScreen persists internally and pops true — do not
          // persist again here.
          if (saved == true && mounted) setState(() {});

        case AddPlannedAction():
          _selectTab(0); // Plan
          final created = await Navigator.of(context).push<PlannedTransaction>(
            MaterialPageRoute(
                builder: (_) => const NewPlannedTransactionScreen()),
          );
          if (created == null || !mounted) return;
          // NewPlannedTransactionScreen returns the model and the CALLER
          // persists (mirrors PlanScreen._addPlanned). guardPersist so a
          // failure triggers the same loadIntoMemory recovery as elsewhere.
          await guardPersist(
              context, () => DataRepository.addPlanned(created));
          if (mounted) setState(() {});

        case OpenAccountAction(:final accountId):
          final account =
              data.accounts.where((a) => a.id == accountId).firstOrNull;
          _selectTab(1);
          if (account == null || !mounted) return;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AccountTransactionsScreen(account: account),
            ),
          );
          if (mounted) setState(() {});
      }
    } finally {
      _dispatchingLink = false;
      // A second link may have landed while the first screen was open.
      if (mounted) _maybeDispatchWidgetAction();
    }
  }

  void _selectTab(int index) {
    final i = index.clamp(0, 2);
    if (mounted) setState(() => _currentIndex = i);
    saveLastMainTabIndex(i);
  }

  void _onBackupExportReminderListenable() {
    if (!mounted) return;
    // Defer: notifier updates run synchronously (e.g. from Settings while this
    // route is under a dialog). Showing MaterialBanner / setState during that
    // stack can trip framework.dart _dependents assertions.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncBackupExportMaterialBanner();
    });
  }

  void _syncBackupExportMaterialBanner() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null || !mounted) return;

    final show = shouldShowBackupExportReminderBanner();
    if (show && !_backupMaterialBannerVisible) {
      final l10n = AppLocalizations.of(context);
      final count = backupExportReminderSinceExportCount.value;
      messenger.clearMaterialBanners();
      messenger.showMaterialBanner(
        MaterialBanner(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.backupReminderBannerTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(l10n.backupReminderBannerBody(count)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _backupExportFromBannerBusy
                  ? null
                  : () async {
                      await remindLaterBackupExportReminder();
                      if (!mounted) return;
                      messenger.clearMaterialBanners();
                      setState(() => _backupMaterialBannerVisible = false);
                    },
              child: Text(l10n.backupReminderRemindLater),
            ),
            TextButton(
              onPressed: _backupExportFromBannerBusy
                  ? null
                  : () async {
                      setState(() => _backupExportFromBannerBusy = true);
                      try {
                        await runManualBackupExportFlow(
                          context: context,
                          l10n: l10n,
                        );
                      } finally {
                        if (mounted) {
                          setState(() => _backupExportFromBannerBusy = false);
                          _syncBackupExportMaterialBanner();
                        }
                      }
                    },
              child: Text(l10n.settingsDataExportTitle),
            ),
          ],
        ),
      );
      setState(() => _backupMaterialBannerVisible = true);
    } else if (!show && _backupMaterialBannerVisible) {
      messenger.clearMaterialBanners();
      setState(() => _backupMaterialBannerVisible = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runAutoBackup();
      // Re-anchor schedules (day may have rolled over, timezone may have
      // changed, notifications may have fired while backgrounded).
      PlannedReminderService.instance.resync();
      // The day may have rolled over while backgrounded, which shifts every
      // projected figure by one index.
      WidgetSnapshotService.instance.requestUpdate();
    } else if (state == AppLifecycleState.paused) {
      saveLastMainTabIndex(_currentIndex);
      // Last moment before the widget becomes the only visible surface.
      WidgetSnapshotService.instance.flush();
    }
  }

  Future<void> _runAutoBackup() async {
    await AutoBackupService.instance.runIfDue();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: PlatrareSurfaces.scaffoldShell(cs, brightness),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            // Tabs listen to ledgerRevision themselves.
            const PlanScreen(),
            const TrackScreen(),
            const ReviewScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: PlatrareSurfaces.bottomBarDecoration(
          cs,
          brightness,
          topBorder: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            setState(() => _currentIndex = i);
            saveLastMainTabIndex(i);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.event_note_outlined),
              selectedIcon: const Icon(Icons.event_note_rounded),
              label: AppLocalizations.of(context).navPlan,
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: AppLocalizations.of(context).navTrack,
            ),
            NavigationDestination(
              icon: const Icon(Icons.analytics_outlined),
              selectedIcon: const Icon(Icons.analytics_rounded),
              label: AppLocalizations.of(context).navReview,
            ),
          ],
        ),
      ),
    );
  }
}
