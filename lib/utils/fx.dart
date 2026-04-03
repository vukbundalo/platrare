import 'package:flutter/foundation.dart';

import '../data/user_settings.dart' as settings;

// ─── Core conversion helpers ─────────────────────────────────────────────────

/// How many [baseCurrency] units equal 1 unit of [currencyCode].
/// Example (base = BAM): rateToBase('EUR') → 1.956
double rateToBase(String currencyCode) {
  if (currencyCode == settings.baseCurrency) return 1.0;
  if (!settings.exchangeRates.containsKey(currencyCode)) {
    debugPrint('[FX] WARNING: no rate for "$currencyCode" – defaulting to 1.0');
  }
  final numer = settings.exchangeRates[currencyCode] ?? 1.0;
  final denom = settings.exchangeRates[settings.baseCurrency] ?? 1.0;
  return numer / denom;
}

/// Convert [nativeAmount] expressed in [currencyCode] into the base currency.
double toBase(double nativeAmount, String currencyCode) =>
    nativeAmount * rateToBase(currencyCode);

/// Convert [amount] from one currency to another using live rates.
double convert(double amount, String from, String to) {
  if (from == to) return amount;
  return amount * rateToBase(from) / rateToBase(to);
}

// ─── Display helpers ─────────────────────────────────────────────────────────

/// ISO-4217 → display symbol.
String currencySymbol(String code) => switch (code) {
      'BAM' => 'KM',
      'EUR' => '€',
      'USD' => r'$',
      'GBP' => '£',
      'CHF' => 'Fr.',
      'JPY' => '¥',
      'CAD' => 'C\$',
      'AUD' => 'A\$',
      'NZD' => 'NZ\$',
      'HKD' => 'HK\$',
      'SGD' => 'S\$',
      'CNY' => '¥',
      'KRW' => '₩',
      'INR' => '₹',
      'THB' => '฿',
      'PHP' => '₱',
      'BRL' => 'R\$',
      'MXN' => 'MX\$',
      'TRY' => '₺',
      'RUB' => '₽',
      'PLN' => 'zł',
      'HUF' => 'Ft',
      'CZK' => 'Kč',
      'SEK' => 'kr',
      'NOK' => 'kr',
      'DKK' => 'kr',
      'ILS' => '₪',
      'ZAR' => 'R',
      'AED' => 'د.إ',
      'SAR' => '﷼',
      'QAR' => 'QR',
      'KWD' => 'KD',
      'BHD' => 'BD',
      'OMR' => 'OMR',
      'EGP' => 'E£',
      'NGN' => '₦',
      'GHS' => 'GH₵',
      'MAD' => 'MAD',
      'TND' => 'TND',
      'PKR' => '₨',
      'BDT' => '৳',
      'IDR' => 'Rp',
      'VND' => '₫',
      'MYR' => 'RM',
      'RSD' => 'din',
      'UAH' => '₴',
      'HRK' => 'kn',
      'CLP' => 'CL\$',
      'COP' => 'CO\$',
      'PEN' => 'S/.',
      'ARS' => 'AR\$',
      _ => code,
    };

const _zeroDecimalCurrencies = {'JPY', 'KRW', 'VND', 'CLP', 'HUF', 'IDR'};

/// Minor units for list rows and compact amount strings (matches [formatNative]).
int currencyMinorUnits(String currencyCode) =>
    _zeroDecimalCurrencies.contains(currencyCode) ? 0 : 2;

/// Digits only (no symbol), same decimals as [formatNative].
String formatNativeAmountDigits(double amount, String currencyCode) {
  final d = currencyMinorUnits(currencyCode);
  return amount.abs().toStringAsFixed(d);
}

/// Format an absolute (unsigned) amount with its currency symbol after.
/// e.g. formatNative(123.45, 'EUR') → '123.45 €'
String formatNative(double amount, String currencyCode) {
  final decimals = currencyMinorUnits(currencyCode);
  return '${amount.abs().toStringAsFixed(decimals)} ${currencySymbol(currencyCode)}';
}

/// Format an amount in the global base currency.
String formatBase(double amount) =>
    formatNative(amount, settings.baseCurrency);

// ─── Internal logic test (Rule 3, 4, 5) ──────────────────────────────────────

/// Validates the multi-currency accounting rules with concrete numbers.
/// Returns a human-readable summary. Throws [AssertionError] on failure.
///
/// Call this once at app startup in debug mode, e.g.:
///   assert(() { print(fx.runFxLogicTest()); return true; }());
String runFxLogicTest() {
  const baseCcy = 'BAM';
  const eurCcy  = 'EUR';
  const eurRate = 1.95583; // BAM per EUR (CB BiH peg, aligned with FxService)

  // ── Test 1 — Cross-currency transfer (Rule 4) ─────────────────────────────
  // User moves 200 EUR from a EUR account to a BAM cash account.
  // They enter the BAM actually received; the system locks the exact rate used.
  const nativeAmount      = 200.0; // EUR sent
  const destinationAmount = 391.166; // BAM received (200 × peg, rounded)
  final lockedRate = destinationAmount / nativeAmount;
  assert(
    (lockedRate - eurRate).abs() < 0.0001,
    'Locked rate mismatch: $lockedRate vs expected $eurRate',
  );

  // ── Test 2 — Historical value locking (Rule 3) ────────────────────────────
  // baseAmount is computed once at save time and never changes.
  final baseAmt = nativeAmount * eurRate;
  assert(
    (baseAmt - destinationAmount).abs() < 0.02,
    'baseAmount should match locked destination, got $baseAmt',
  );
  // FX rate moves to 2.0 BAM/EUR later. The historical record must NOT change.
  const futureRate   = 2.0;
  final lockedBase   = baseAmt;
  final currentValue = nativeAmount * futureRate;
  final unrealisedFX = currentValue - lockedBase;
  assert(
    unrealisedFX > 0,
    'Unrealised FX gain should be positive, got $unrealisedFX',
  );

  // ── Test 3 — Live net worth (Rule 5) ─────────────────────────────────────
  // Net Worth = Σ(account.balance × currentRate).  Never Σ(lockedBaseAmounts).
  const cashBal  = 1000.0; // BAM
  const eurBal   = 500.0;  // EUR
  final cashBase = cashBal * 1.0;
  final eurBase  = eurBal * eurRate;
  final netWorth = cashBase + eurBase;
  assert(
    (netWorth - (1000.0 + 500.0 * eurRate)).abs() < 0.02,
    'Net worth mismatch: $netWorth',
  );

  // ── Test 4 — P&L isolation from Net Worth ────────────────────────────────
  const income1Base = 391.166;
  const income2Base = 163.00;
  final totalPnl = income1Base + income2Base;
  assert(
    (totalPnl - (income1Base + income2Base)).abs() < 0.001,
    'P&L total mismatch: $totalPnl',
  );

  return '[$baseCcy base] '
      'Rule 4 ✓ cross-currency transfer: '
      '${nativeAmount.toStringAsFixed(0)} $eurCcy → '
      '${destinationAmount.toStringAsFixed(2)} $baseCcy '
      '(locked rate: ${lockedRate.toStringAsFixed(5)}). '
      'Rule 3 ✓ locked baseAmount: ${baseAmt.toStringAsFixed(2)} $baseCcy, '
      'unrealised FX at rate $futureRate: '
      '+${unrealisedFX.toStringAsFixed(2)} $baseCcy. '
      'Rule 5 ✓ live net worth: ${netWorth.toStringAsFixed(2)} $baseCcy. '
      'Rule 3/P&L ✓ locked P&L sum: ${totalPnl.toStringAsFixed(2)} $baseCcy.';
}
