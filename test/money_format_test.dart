import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/utils/app_format.dart';
import 'package:platrare/utils/fx.dart' as fx;
import 'package:platrare/utils/money_format.dart';

void main() {
  tearDown(() => setAppNumberLocale(const Locale('en')));

  test('English grouping and decimal point', () {
    setAppNumberLocale(const Locale('en'));
    expect(formatMoneyDigits(1234.5), '1,234.50');
    expect(formatMoneyDigits(-1234.5), '-1,234.50');
    expect(formatBalanceAmount(0.004), '0.00'); // no "-0.00"
    expect(formatBalanceAmount(-0.004), '0.00');
  });

  test('German grouping and decimal comma', () {
    setAppNumberLocale(const Locale('de'));
    expect(formatMoneyDigits(1234.5), '1.234,50');
    expect(fx.formatNative(1234.5, 'EUR'), '1.234,50 €');
  });

  test('Serbian Latin and Bosnian use dot grouping and comma decimals', () {
    setAppNumberLocale(
        const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'));
    expect(formatMoneyDigits(98765.4), '98.765,40');
    setAppNumberLocale(const Locale('bs'));
    expect(formatMoneyDigits(98765.4), '98.765,40');
  });

  test('zero-decimal currencies drop the fraction', () {
    setAppNumberLocale(const Locale('en'));
    expect(fx.formatNativeAmountDigits(1000, 'JPY'), '1,000');
    expect(fx.formatNativeAmountDigits(1000.4, 'KRW'), '1,000');
    expect(fx.formatNativeAmountDigits(-12.345, 'EUR'), '12.35');
  });

  test('unknown locale tag falls back instead of throwing', () {
    setAppNumberLocale(const Locale('xx'));
    expect(formatMoneyDigits(1000), '1,000.00');
  });
}
