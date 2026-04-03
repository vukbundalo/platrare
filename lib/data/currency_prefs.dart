import 'package:shared_preferences/shared_preferences.dart';

import 'user_settings.dart' as settings;

const _kBaseCurrencyKey = 'prefs_base_currency';
const _kSecondaryCurrencyKey = 'prefs_secondary_currency';

Future<void> loadCurrencyPreferences() async {
  final p = await SharedPreferences.getInstance();
  final b = p.getString(_kBaseCurrencyKey);
  final s = p.getString(_kSecondaryCurrencyKey);
  if (b != null && settings.supportedCurrencies.contains(b)) {
    settings.baseCurrency = b;
  }
  if (s != null && settings.supportedCurrencies.contains(s)) {
    settings.secondaryCurrency = s;
  }
}

Future<void> saveCurrencyPreferences() async {
  final p = await SharedPreferences.getInstance();
  await p.setString(_kBaseCurrencyKey, settings.baseCurrency);
  await p.setString(_kSecondaryCurrencyKey, settings.secondaryCurrency);
}
