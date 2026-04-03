import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocalePrefKey = 'app_locale_override';

/// How the app picks [Locale] for MaterialApp.
enum AppLocalePreference {
  /// Follow the device; [resolvedLocaleForMaterialApp] returns null.
  system,

  /// Force English.
  english,

  /// Serbian, Latin script.
  serbianLatin,
}

/// Loads persisted override (defaults to [AppLocalePreference.system]).
Future<AppLocalePreference> loadLocalePreference() async {
  final p = await SharedPreferences.getInstance();
  final v = p.getString(_kLocalePrefKey);
  return switch (v) {
    'en' => AppLocalePreference.english,
    'sr_Latn' => AppLocalePreference.serbianLatin,
    _ => AppLocalePreference.system,
  };
}

Future<void> saveLocalePreference(AppLocalePreference pref) async {
  final p = await SharedPreferences.getInstance();
  switch (pref) {
    case AppLocalePreference.system:
      await p.remove(_kLocalePrefKey);
      break;
    case AppLocalePreference.english:
      await p.setString(_kLocalePrefKey, 'en');
      break;
    case AppLocalePreference.serbianLatin:
      await p.setString(_kLocalePrefKey, 'sr_Latn');
      break;
  }
}

/// `null` means MaterialApp should use device resolution.
Locale? localeForMaterialApp(AppLocalePreference pref) => switch (pref) {
      AppLocalePreference.system => null,
      AppLocalePreference.english => const Locale('en'),
      AppLocalePreference.serbianLatin => const Locale.fromSubtags(
          languageCode: 'sr',
          scriptCode: 'Latn',
        ),
    };

/// Notifies [MaterialApp] when the user changes language in Settings.
final ValueNotifier<AppLocalePreference> appLocalePreference =
    ValueNotifier(AppLocalePreference.system);

Future<void> initAppLocale() async {
  appLocalePreference.value = await loadLocalePreference();
}

void setAppLocalePreference(AppLocalePreference pref) {
  appLocalePreference.value = pref;
  saveLocalePreference(pref);
}
