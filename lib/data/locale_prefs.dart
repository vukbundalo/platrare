import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/supported_languages.dart';

const _kLocalePrefKey = 'app_locale_override';

/// Loads persisted override: [kLocaleTagSystem] or a tag from [kSelectableLocaleTags].
Future<String> loadLocalePreference() async {
  final p = await SharedPreferences.getInstance();
  final v = p.getString(_kLocalePrefKey);
  if (v == null || v.isEmpty) return kLocaleTagSystem;
  if (v == kLocaleTagSystem) return kLocaleTagSystem;
  // Migrate legacy storage from the old enum-based prefs.
  if (v == 'en') return 'en';
  if (v == 'sr_Latn') return 'sr_Latn';
  if (kSelectableLocaleTags.contains(v)) return v;
  return kLocaleTagSystem;
}

Future<void> saveLocalePreference(String tag) async {
  final p = await SharedPreferences.getInstance();
  if (tag == kLocaleTagSystem) {
    await p.remove(_kLocalePrefKey);
  } else {
    await p.setString(_kLocalePrefKey, tag);
  }
}

/// `null` means MaterialApp should use device resolution.
Locale? localeForMaterialApp(String tag) =>
    tag == kLocaleTagSystem ? null : localeFromStoredTag(tag);

/// Notifies [MaterialApp] when the user changes language in Settings.
final ValueNotifier<String> appLocaleTag = ValueNotifier(kLocaleTagSystem);

Future<void> initAppLocale() async {
  appLocaleTag.value = await loadLocalePreference();
}

void setAppLocaleTag(String tag) {
  appLocaleTag.value = tag;
  saveLocalePreference(tag);
}
