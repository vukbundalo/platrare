import 'dart:ui' show Locale;

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_settings.dart' as settings;

const _kOnboardingDoneKey = 'onboarding_done_v1';

/// True once the first-run screen was completed, or once an existing install
/// was recognised (see [markOnboardingDone] in `main`).
Future<bool> isOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  return p.getBool(_kOnboardingDoneKey) ?? false;
}

Future<void> markOnboardingDone() async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kOnboardingDoneKey, true);
}

/// Base currency to propose on first run, from the device locale's default
/// currency (intl's per-locale data: `de` → EUR, `en_US` → USD, `bs` → BAM,
/// `en_GB` → GBP). Falls back to [fallback] when the locale is unknown or its
/// currency is not one the app supports.
String suggestedBaseCurrency(Locale locale, {String fallback = 'EUR'}) {
  String? code;
  try {
    code = NumberFormat.simpleCurrency(
      locale: Intl.canonicalizedLocale(locale.toLanguageTag()),
    ).currencyName;
  } catch (_) {
    code = null;
  }
  if (code != null && settings.supportedCurrencies.contains(code)) return code;
  return fallback;
}
