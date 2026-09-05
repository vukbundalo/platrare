import 'dart:ui' show Locale;

import 'package:intl/intl.dart';

/// Locale-aware money digits for every user-facing amount.
///
/// One place decides grouping and the decimal separator ("1.234,56" for a
/// German user, "1,234.56" for an English one) so screens never call
/// `toStringAsFixed` on money themselves. The currency symbol stays outside:
/// callers keep the app's "digits, space, symbol" convention.
///
/// CSV export and the backup format must stay locale-invariant and do NOT use
/// this; they keep `toStringAsFixed`.

String _numberLocale = 'en';

/// Intl-style tag ("de", "sr_Latn", "pt_BR") of the locale amounts use.
String get appNumberLocale => _numberLocale;

/// Called from the MaterialApp locale resolution so amounts follow the app
/// language even where no BuildContext is at hand (notifications, snackbars
/// built outside the tree).
void setAppNumberLocale(Locale locale) {
  final tag = Intl.canonicalizedLocale(locale.toLanguageTag());
  _numberLocale = tag;
  Intl.defaultLocale = tag;
}

final Map<String, NumberFormat> _cache = {};

NumberFormat _formatter(int decimals, String locale) {
  final key = '$locale/$decimals';
  return _cache.putIfAbsent(key, () {
    try {
      return NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: decimals,
      );
    } catch (_) {
      // intl has no symbols for this tag: fall back rather than crash a
      // balance row.
      return NumberFormat.decimalPatternDigits(
        locale: 'en',
        decimalDigits: decimals,
      );
    }
  });
}

/// Signed digits with locale grouping and separator, fixed [decimals].
/// `formatMoneyDigits(-1234.5)` → "-1,234.50" (en) / "-1.234,50" (de).
String formatMoneyDigits(double value, {int decimals = 2, String? locale}) {
  // Normalise -0.00 so a rounded-away negative never shows a stray sign.
  final v = value.abs() < 5 * _pow10(-(decimals + 1)) ? 0.0 : value;
  return _formatter(decimals, locale ?? _numberLocale).format(v);
}

double _pow10(int exp) {
  var r = 1.0;
  if (exp >= 0) {
    for (var i = 0; i < exp; i++) {
      r *= 10;
    }
  } else {
    for (var i = 0; i < -exp; i++) {
      r /= 10;
    }
  }
  return r;
}
