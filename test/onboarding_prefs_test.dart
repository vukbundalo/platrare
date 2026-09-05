import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/onboarding_prefs.dart';

void main() {
  test('suggests the locale default currency when supported', () {
    expect(suggestedBaseCurrency(const Locale('de')), 'EUR');
    expect(suggestedBaseCurrency(const Locale('en', 'US')), 'USD');
    expect(suggestedBaseCurrency(const Locale('en', 'GB')), 'GBP');
    expect(suggestedBaseCurrency(const Locale('bs')), 'BAM');
    expect(suggestedBaseCurrency(const Locale('ja')), 'JPY');
    expect(suggestedBaseCurrency(const Locale('pt', 'BR')), 'BRL');
  });

  test('falls back for unknown locales or unsupported currencies', () {
    expect(suggestedBaseCurrency(const Locale('xx')), 'EUR');
    expect(suggestedBaseCurrency(const Locale('xx'), fallback: 'USD'), 'USD');
  });
}
