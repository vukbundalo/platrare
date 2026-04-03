import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/locale_prefs.dart';
import 'l10n/app_localizations.dart' show AppLocalizations;
import 'screens/track_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/review_screen.dart';
import 'utils/fx.dart' as fx;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppLocale();
  // Run multi-currency logic test in debug mode (Rules 3, 4, 5).
  assert(() {
    debugPrint('[FX Test] ${fx.runFxLogicTest()}');
    return true;
  }());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(const PlatrareApp());
}

class PlatrareApp extends StatelessWidget {
  const PlatrareApp({super.key});

  /// Match [deviceLocale] to a supported locale, or null if no match.
  static Locale? _tryMatchLocale(
      Locale deviceLocale, Iterable<Locale> supported) {
    if (deviceLocale.languageCode == 'sr') {
      return const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn');
    }
    for (final supportedLocale in supported) {
      final deviceScript = deviceLocale.scriptCode;
      final supportedScript = supportedLocale.scriptCode;
      if (supportedLocale.languageCode == deviceLocale.languageCode &&
          ((deviceScript == null || deviceScript.isEmpty) ||
              supportedScript == deviceScript)) {
        return supportedLocale;
      }
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
    return ValueListenableBuilder<AppLocalePreference>(
      valueListenable: appLocalePreference,
      builder: (context, pref, _) {
        return MaterialApp(
          title: 'Platrare',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: ThemeMode.system,
          locale: localeForMaterialApp(pref),
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
          home: const HomePage(),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    const seed = Color(0xFF5B5BD6);
    final cs = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: cs.outlineVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 68,
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? cs.primary : cs.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? cs.primary : cs.onSurfaceVariant,
          );
        }),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant.withValues(alpha: 0.5),
        space: 0,
        thickness: 0.5,
      ),
      listTileTheme: const ListTileThemeData(
        minVerticalPadding: 12,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PlanScreen(onChanged: () => setState(() {})),
          TrackScreen(onChanged: () => setState(() {})),
          ReviewScreen(onChanged: () => setState(() {})),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.4), width: 0.5),
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
