import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/auto_backup_service.dart';
import 'data/balance_privacy_prefs.dart';
import 'data/currency_prefs.dart';
import 'data/local/platrare_database.dart';
import 'data/fx_service.dart';
import 'data/locale_prefs.dart';
import 'data/security_prefs.dart';
import 'data/theme_prefs.dart';
import 'l10n/app_localizations.dart' show AppLocalizations;
import 'l10n/supported_languages.dart';
import 'screens/track_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/review_screen.dart';
import 'theme/platrare_surfaces.dart';
import 'theme/platrare_theme.dart';
import 'utils/fx.dart' as fx;
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
  ]);
  await loadCurrencyPreferences();
  await _initDateFormattingForLocales();
  await FxService.instance.init();
  await AutoBackupService.instance.init();
  assert(() {
    debugPrint('[FX Test] ${fx.runFxLogicTest()}');
    return true;
  }());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const PlatrareApp());
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
  const PlatrareApp({super.key});

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
                if (locales != null && locales.isNotEmpty) {
                  for (final deviceLocale in locales) {
                    final match = _tryMatchLocale(deviceLocale, supported);
                    if (match != null) return match;
                  }
                }
                return _resolveLocale(null, supported);
              },
              home: const AppLockGate(child: HomePage()),
            );
          },
        );
      },
    );
  }

}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  /// 0 = Plan, 1 = Track, 2 = Review — default Plan on cold start.
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Run backup check on cold start (data is already loaded).
    _runAutoBackup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runAutoBackup();
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
            PlanScreen(onChanged: () => setState(() {})),
            TrackScreen(onChanged: () => setState(() {})),
            ReviewScreen(onChanged: () => setState(() {})),
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
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
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
