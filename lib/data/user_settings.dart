// Global user preferences — currency settings.
// [baseCurrency] / [secondaryCurrency] are loaded and saved via [currency_prefs.dart].

/// The user's home currency. All high-level dashboard summaries (Balance,
/// Net Worth, monthly stats) are expressed in this currency.
String baseCurrency = 'BAM';

/// The secondary display currency shown as an alternative on the Review screen.
String secondaryCurrency = 'EUR';

/// Exchange rates: 1 unit of [key] = [value] units of BAM.
///
/// On startup, [FxService] overwrites these with cached / live ECB rates.
/// The values below are **hardcoded fallbacks** used only when no cached or
/// live data is available (first-ever launch with no network).
final Map<String, double> exchangeRates = {
  'BAM': 1.0000,
  'EUR': 1.95583, // CB BiH peg (must match [FxService] peg)
  'USD': 1.8200,
  'GBP': 2.2800,
  'CHF': 2.0200,
  'JPY': 0.0125,
  'CAD': 1.3500,
  'AUD': 1.1800,
  'NZD': 1.0950,
  'SEK': 0.1750,
  'NOK': 0.1720,
  'DKK': 0.2620,
  'HKD': 0.2340,
  'SGD': 1.3700,
  'CNY': 0.2560,
  'KRW': 0.00138,
  'INR': 0.0220,
  'BRL': 0.3700,
  'MXN': 0.1040,
  'ZAR': 0.0990,
  'AED': 0.4960,
  'SAR': 0.4850,
  'THB': 0.0520,
  'MYR': 0.4130,
  'PLN': 0.4560,
  'CZK': 0.0790,
  'HUF': 0.0051,
  'TRY': 0.0570,
  'RUB': 0.0197,
  'ILS': 0.4940,
  'QAR': 0.4990,
  'KWD': 5.9300,
  'BHD': 4.8300,
  'OMR': 4.7300,
  'PKR': 0.0065,
  'BDT': 0.0166,
  'IDR': 0.000115,
  'PHP': 0.0320,
  'VND': 0.0000740,
  'EGP': 0.0375,
  'MAD': 0.1830,
  'NGN': 0.00126,
  'GHS': 0.1240,
  'TND': 0.5840,
  'CLP': 0.00194,
  'COP': 0.000440,
  'PEN': 0.4840,
  'ARS': 0.00205,
  'UAH': 0.0440,
  'RSD': 0.0167,
};

/// Every currency the app can assign to an account.
const List<String> supportedCurrencies = [
  'BAM', 'EUR', 'USD', 'GBP', 'CHF',
  'JPY', 'CAD', 'AUD', 'NZD',
  'SEK', 'NOK', 'DKK',
  'HKD', 'SGD', 'CNY', 'KRW',
  'INR', 'BDT', 'PKR',
  'THB', 'MYR', 'IDR', 'PHP', 'VND',
  'BRL', 'MXN', 'CLP', 'COP', 'PEN', 'ARS',
  'ZAR', 'NGN', 'GHS', 'EGP', 'MAD', 'TND',
  'RUB', 'TRY', 'PLN', 'CZK', 'HUF', 'RSD',
  'UAH',
  'AED', 'SAR', 'QAR', 'KWD', 'BHD', 'OMR',
  'ILS',
];
