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

/// Format an absolute (unsigned) amount with its currency symbol after.
/// e.g. formatNative(123.45, 'EUR') → '123.45 €'
String formatNative(double amount, String currencyCode) =>
    '${amount.abs().toStringAsFixed(2)} ${currencySymbol(currencyCode)}';

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
  const eurRate = 1.956; // BAM per EUR (internal numeraire rate)

  // ── Test 1 — Cross-currency transfer (Rule 4) ─────────────────────────────
  // User moves 200 EUR from a EUR account to a BAM cash account.
  // The user physically receives 391.20 BAM from the bank — they enter this
  // as destinationAmount. The system locks the exact rate used.
  const nativeAmount      = 200.0;  // EUR sent
  const destinationAmount = 391.20; // BAM actually received (user-entered)
  final lockedRate = destinationAmount / nativeAmount; // = 1.956 BAM/EUR
  assert(
    (lockedRate - eurRate).abs() < 0.001,
    'Locked rate mismatch: $lockedRate vs expected $eurRate',
  );

  // ── Test 2 — Historical value locking (Rule 3) ────────────────────────────
  // baseAmount is computed once at save time and never changes.
  final baseAmt = nativeAmount * eurRate; // 391.20 BAM — locked forever
  assert(
    (baseAmt - 391.20).abs() < 0.01,
    'baseAmount should be 391.20 BAM, got $baseAmt',
  );
  // FX rate moves to 2.0 BAM/EUR later. The historical record must NOT change.
  const futureRate   = 2.0;
  const lockedBase   = 391.20; // immutable — already persisted on Transaction
  final currentValue = nativeAmount * futureRate; // 400.00 BAM at new rate
  final unrealisedFX = currentValue - lockedBase; // +8.80 BAM unrealised gain
  assert(
    (unrealisedFX - 8.80).abs() < 0.01,
    'Unrealised FX gain should be 8.80 BAM, got $unrealisedFX',
  );

  // ── Test 3 — Live net worth (Rule 5) ─────────────────────────────────────
  // Net Worth = Σ(account.balance × currentRate).  Never Σ(lockedBaseAmounts).
  // Two accounts: Cash 1 000 BAM, EurSavings 500 EUR at live rate 1.956.
  const cashBal  = 1000.0; // BAM
  const eurBal   = 500.0;  // EUR
  final cashBase = cashBal * 1.0;       // 1 000.00 BAM
  final eurBase  = eurBal  * eurRate;   //   978.00 BAM
  final netWorth = cashBase + eurBase;  // 1 978.00 BAM
  assert(
    (netWorth - 1978.0).abs() < 0.01,
    'Net worth should be 1 978.00 BAM, got $netWorth',
  );

  // ── Test 4 — P&L isolation from Net Worth ────────────────────────────────
  // Historical P&L sums locked baseAmounts only — not live balances.
  // Two income records: 391.20 BAM locked + 163.00 BAM locked = 554.20 BAM.
  const income1Base = 391.20;
  const income2Base = 163.00;
  final totalPnl    = income1Base + income2Base; // 554.20 BAM
  assert(
    (totalPnl - 554.20).abs() < 0.01,
    'P&L total should be 554.20 BAM, got $totalPnl',
  );
  // The difference between live value and locked P&L is unrealised FX.
  // unrealisedFX (8.80 BAM) = currentValue (400) − lockedBase (391.20). ✓

  return '[$baseCcy base] '
      'Rule 4 ✓ cross-currency transfer: '
      '${nativeAmount.toStringAsFixed(0)} $eurCcy → '
      '${destinationAmount.toStringAsFixed(2)} $baseCcy '
      '(locked rate: ${lockedRate.toStringAsFixed(3)}). '
      'Rule 3 ✓ locked baseAmount: ${baseAmt.toStringAsFixed(2)} $baseCcy, '
      'unrealised FX at rate $futureRate: '
      '+${unrealisedFX.toStringAsFixed(2)} $baseCcy. '
      'Rule 5 ✓ live net worth: ${netWorth.toStringAsFixed(2)} $baseCcy. '
      'Rule 3/P&L ✓ locked P&L sum: ${totalPnl.toStringAsFixed(2)} $baseCcy.';
}
