import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemePrefKey = 'app_theme_mode';

enum AppThemePreference { system, light, dark }

ThemeMode themeModeFor(AppThemePreference pref) => switch (pref) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };

final ValueNotifier<AppThemePreference> appThemePreference =
    ValueNotifier(AppThemePreference.system);

Future<void> initAppTheme() async {
  appThemePreference.value = await _load();
}

void setAppThemePreference(AppThemePreference pref) {
  appThemePreference.value = pref;
  _save(pref);
}

Future<AppThemePreference> _load() async {
  final p = await SharedPreferences.getInstance();
  final v = p.getString(_kThemePrefKey);
  return switch (v) {
    'light' => AppThemePreference.light,
    'dark' => AppThemePreference.dark,
    _ => AppThemePreference.system,
  };
}

Future<void> _save(AppThemePreference pref) async {
  final p = await SharedPreferences.getInstance();
  switch (pref) {
    case AppThemePreference.system:
      await p.remove(_kThemePrefKey);
    case AppThemePreference.light:
      await p.setString(_kThemePrefKey, 'light');
    case AppThemePreference.dark:
      await p.setString(_kThemePrefKey, 'dark');
  }
}
