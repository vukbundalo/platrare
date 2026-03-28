// Global user preferences — currency settings.
// In a production app these would be persisted to SharedPreferences.

/// The user's home currency. All high-level dashboard summaries (Balance,
/// Net Worth, monthly stats) are expressed in this currency.
String baseCurrency = 'BAM';

/// Live exchange rates expressed as:
///   1 unit of [key] = [value] units of BAM (the internal numeraire).
///
/// To convert any foreign amount to [baseCurrency] the system multiplies by
/// rates[foreignCcy] / rates[baseCurrency].  Because BAM is the internal
/// numeraire, rates['BAM'] is always 1.0.
///
/// In a production app these values would be fetched from a live FX feed.
final Map<String, double> exchangeRates = {
  'BAM': 1.000,
  'EUR': 1.956,
  'USD': 1.820,
  'GBP': 2.280,
  'CHF': 2.020,
};

/// Every currency the app can assign to an account.
const List<String> supportedCurrencies = ['BAM', 'EUR', 'USD', 'GBP', 'CHF'];
