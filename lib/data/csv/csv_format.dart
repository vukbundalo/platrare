// The CSV column contract shared by export, import and the template. Export
// writes exactly [kCsvExportColumns]; import accepts any subset in any order,
// matched through [kCsvHeaderAliases].

/// Logical columns the importer understands.
enum CsvColumn {
  date,
  type,
  fromAccount,
  toAccount,

  /// Single-account bank-statement shape: the sign of `amount` decides whether
  /// money left or entered [account].
  account,
  amount,

  /// Bank statements that split direction into two columns instead of signing
  /// the amount.
  debit,
  credit,
  currency,
  destinationAmount,
  category,
  description,
  baseAmount,
  exchangeRate,
}

/// Canonical header text written by the exporter.
const Map<CsvColumn, String> kCsvCanonicalHeader = <CsvColumn, String>{
  CsvColumn.date: 'date',
  CsvColumn.type: 'type',
  CsvColumn.fromAccount: 'from_account',
  CsvColumn.toAccount: 'to_account',
  CsvColumn.account: 'account',
  CsvColumn.amount: 'amount',
  CsvColumn.debit: 'debit',
  CsvColumn.credit: 'credit',
  CsvColumn.currency: 'currency',
  CsvColumn.destinationAmount: 'destination_amount',
  CsvColumn.category: 'category',
  CsvColumn.description: 'description',
  CsvColumn.baseAmount: 'base_amount',
  CsvColumn.exchangeRate: 'exchange_rate',
};

/// Column order of an exported file. `base_amount` and `exchange_rate` are
/// informational — they let a spreadsheet total mixed currencies without
/// re-deriving historical rates — and are optional on the way back in.
const List<CsvColumn> kCsvExportColumns = <CsvColumn>[
  CsvColumn.date,
  CsvColumn.type,
  CsvColumn.fromAccount,
  CsvColumn.toAccount,
  CsvColumn.amount,
  CsvColumn.currency,
  CsvColumn.destinationAmount,
  CsvColumn.category,
  CsvColumn.description,
  CsvColumn.baseAmount,
  CsvColumn.exchangeRate,
];

/// The subset shown in the template, so a first-time user is not asked to fill
/// in FX bookkeeping they do not have.
const List<CsvColumn> kCsvTemplateColumns = <CsvColumn>[
  CsvColumn.date,
  CsvColumn.type,
  CsvColumn.fromAccount,
  CsvColumn.toAccount,
  CsvColumn.amount,
  CsvColumn.currency,
  CsvColumn.category,
  CsvColumn.description,
];

/// Header spellings we accept, keyed by [normalizeCsvHeader] output. Covers the
/// canonical names plus what Mint/YNAB/Money Manager and common bank exports
/// emit.
const Map<String, CsvColumn> kCsvHeaderAliases = <String, CsvColumn>{
  'date': CsvColumn.date,
  'transactiondate': CsvColumn.date,
  'bookingdate': CsvColumn.date,
  'valuedate': CsvColumn.date,
  'posteddate': CsvColumn.date,

  'type': CsvColumn.type,
  'txtype': CsvColumn.type,
  'transactiontype': CsvColumn.type,
  'kind': CsvColumn.type,

  'fromaccount': CsvColumn.fromAccount,
  'from': CsvColumn.fromAccount,
  'source': CsvColumn.fromAccount,
  'sourceaccount': CsvColumn.fromAccount,
  'paidfrom': CsvColumn.fromAccount,

  'toaccount': CsvColumn.toAccount,
  'to': CsvColumn.toAccount,
  'destination': CsvColumn.toAccount,
  'destinationaccount': CsvColumn.toAccount,
  'paidto': CsvColumn.toAccount,

  'account': CsvColumn.account,
  'accountname': CsvColumn.account,

  'amount': CsvColumn.amount,
  'value': CsvColumn.amount,
  'sum': CsvColumn.amount,
  'total': CsvColumn.amount,

  'debit': CsvColumn.debit,
  'withdrawal': CsvColumn.debit,
  'moneyout': CsvColumn.debit,

  'credit': CsvColumn.credit,
  'deposit': CsvColumn.credit,
  'moneyin': CsvColumn.credit,

  'currency': CsvColumn.currency,
  'currencycode': CsvColumn.currency,
  'ccy': CsvColumn.currency,

  'destinationamount': CsvColumn.destinationAmount,
  'receivedamount': CsvColumn.destinationAmount,
  'amountreceived': CsvColumn.destinationAmount,

  'category': CsvColumn.category,
  'categoryname': CsvColumn.category,
  'cat': CsvColumn.category,

  'description': CsvColumn.description,
  'memo': CsvColumn.description,
  'note': CsvColumn.description,
  'notes': CsvColumn.description,
  'payee': CsvColumn.description,
  'details': CsvColumn.description,
  'reference': CsvColumn.description,
  'narrative': CsvColumn.description,

  'baseamount': CsvColumn.baseAmount,
  'exchangerate': CsvColumn.exchangeRate,
  'rate': CsvColumn.exchangeRate,
  'fxrate': CsvColumn.exchangeRate,

  // German and Bosnian/Croatian/Serbian, the app's largest non-English
  // markets, so an untouched bank export usually imports as-is. Every other
  // locale is served by the English template.
  'datum': CsvColumn.date,
  'buchungstag': CsvColumn.date,
  'typ': CsvColumn.type,
  'art': CsvColumn.type,
  'von': CsvColumn.fromAccount,
  'nach': CsvColumn.toAccount,
  'konto': CsvColumn.account,
  'betrag': CsvColumn.amount,
  'kategorie': CsvColumn.category,
  'beschreibung': CsvColumn.description,
  'verwendungszweck': CsvColumn.description,
  'wahrung': CsvColumn.currency,

  'vrsta': CsvColumn.type,
  'od': CsvColumn.fromAccount,
  'za': CsvColumn.toAccount,
  'racun': CsvColumn.account,
  'iznos': CsvColumn.amount,
  'kategorija': CsvColumn.category,
  'opis': CsvColumn.description,
  'valuta': CsvColumn.currency,
};

final RegExp _nonAlphanumeric = RegExp(r'[^a-z0-9]');

/// Diacritics are folded rather than dropped, so `Račun` and `Racun` — or
/// `Betrag` and `Betrÿge` — collapse to the same key instead of losing letters.
const Map<String, String> _diacriticFolds = <String, String>{
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'č': 'c', 'ć': 'c',
  'š': 's', 'ś': 's',
  'ž': 'z', 'ź': 'z', 'ż': 'z',
  'đ': 'd', 'ð': 'd',
  'ñ': 'n', 'ń': 'n',
  'ł': 'l',
  'ý': 'y', 'ÿ': 'y',
  'ß': 'ss',
};

/// Case-, punctuation- and accent-insensitive header key.
String normalizeCsvHeader(String raw) {
  final lower = raw.trim().toLowerCase();
  final folded = StringBuffer();
  for (final ch in lower.split('')) {
    folded.write(_diacriticFolds[ch] ?? ch);
  }
  return folded.toString().replaceAll(_nonAlphanumeric, '');
}

/// Resolves a header cell to a column, or null when we do not recognise it.
CsvColumn? csvColumnForHeader(String raw) =>
    kCsvHeaderAliases[normalizeCsvHeader(raw)];

// ── Formula-injection hardening ────────────────────────────────────────────

const Set<String> _kFormulaTriggers = <String>{'=', '+', '-', '@', '\t', '\r'};

/// Prefixes a `'` when a *text* value would otherwise be interpreted as a
/// formula by Excel/Sheets. Never applied to numeric columns, so signed amounts
/// are left alone.
String csvSanitizeText(String value) {
  if (value.isEmpty) return value;
  if (_kFormulaTriggers.contains(value[0])) return "'$value";
  return value;
}

/// Inverse of [csvSanitizeText], so our own export round-trips exactly.
String csvUnsanitizeText(String value) {
  if (value.length > 1 &&
      value.startsWith("'") &&
      _kFormulaTriggers.contains(value[1])) {
    return value.substring(1);
  }
  return value;
}
