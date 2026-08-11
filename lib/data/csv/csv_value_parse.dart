// Number and date parsing tolerant enough for CSVs exported by banks and
// other budgeting apps, which vary by locale far more than by standard.

/// How to read a `dd/mm/yyyy`-shaped date whose day and month are both ≤ 12.
enum CsvDateStyle {
  /// Infer from the file: any row with a first component > 12 proves day-first,
  /// any row with a second component > 12 proves month-first. Falls back to
  /// day-first, which matches the majority of the app's locales.
  auto,
  dayFirst,
  monthFirst,
}

final RegExp _keptNumberChars = RegExp(r'[0-9.,\-+]');

/// Moves the *last* [sep] to a `.` decimal point and drops the rest.
String _decimalOnLast(String s, String sep) {
  final i = s.lastIndexOf(sep);
  if (i < 0) return s;
  final head = s.substring(0, i).replaceAll(sep, '');
  return '$head.${s.substring(i + 1)}';
}

/// Parses an amount written in any of the common spreadsheet conventions:
/// `1234.56`, `1,234.56`, `1.234,56`, `1 234,56`, `12,34`, `€42.50`, `-42.50`,
/// `(42.50)` (accounting negative), `+42.50`.
///
/// Returns null when no number can be read.
///
/// Separator resolution: when both `.` and `,` are present the one that appears
/// last is the decimal point. A lone `,` followed by exactly three digits is
/// read as a thousands separator (`1,234` → 1234); any other lone `,` is a
/// decimal point (`12,34` → 12.34). A lone `.` is always a decimal point, so a
/// European file writing `1.234` for 1234 without cents is the one shape that
/// reads wrong — the exporter never emits it and the template documents it.
double? parseCsvNumber(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return null;

  var negative = false;
  if (s.startsWith('(') && s.endsWith(')')) {
    negative = true;
    s = s.substring(1, s.length - 1);
  }

  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final ch = s[i];
    if (_keptNumberChars.hasMatch(ch)) buf.write(ch);
  }
  s = buf.toString();
  if (s.contains('-')) negative = !negative;
  s = s.replaceAll('-', '').replaceAll('+', '');
  if (s.isEmpty) return null;

  final lastComma = s.lastIndexOf(',');
  final lastDot = s.lastIndexOf('.');

  String normalized;
  if (lastComma >= 0 && lastDot >= 0) {
    if (lastComma > lastDot) {
      normalized = _decimalOnLast(s.replaceAll('.', ''), ',');
    } else {
      normalized = _decimalOnLast(s.replaceAll(',', ''), '.');
    }
  } else if (lastComma >= 0) {
    final onlyOne = s.indexOf(',') == lastComma;
    final digitsAfter = s.length - lastComma - 1;
    final digitsBefore = lastComma;
    if (onlyOne && digitsAfter == 3 && digitsBefore > 0) {
      normalized = s.replaceAll(',', '');
    } else {
      normalized = _decimalOnLast(s, ',');
    }
  } else if (lastDot >= 0) {
    normalized = _decimalOnLast(s, '.');
  } else {
    normalized = s;
  }

  final value = double.tryParse(normalized);
  if (value == null) return null;
  return negative ? -value : value;
}

final RegExp _isoDate = RegExp(r'^(\d{4})[-/](\d{1,2})[-/](\d{1,2})');
final RegExp _pairDate = RegExp(r'^(\d{1,2})([./-])(\d{1,2})\2(\d{2}|\d{4})$');

/// True when [raw] is a `d/m/y`-shaped date whose first two components are both
/// ≤ 12, i.e. the file cannot tell us whether it means day-first or month-first.
/// Dot-separated dates are excluded: `03.04.2026` is day-first everywhere it is
/// used.
bool csvDateIsAmbiguous(String raw) {
  final s = raw.trim();
  if (_isoDate.hasMatch(s)) return false;
  final m = _pairDate.firstMatch(s);
  if (m == null) return false;
  if (m.group(2) == '.') return false;
  final a = int.parse(m.group(1)!);
  final b = int.parse(m.group(3)!);
  return a <= 12 && b <= 12;
}

/// True when [raw] proves the file is day-first (first component > 12).
bool csvDateProvesDayFirst(String raw) {
  final m = _pairDate.firstMatch(raw.trim());
  if (m == null || _isoDate.hasMatch(raw.trim())) return false;
  return int.parse(m.group(1)!) > 12;
}

/// True when [raw] proves the file is month-first (second component > 12).
bool csvDateProvesMonthFirst(String raw) {
  final m = _pairDate.firstMatch(raw.trim());
  if (m == null || _isoDate.hasMatch(raw.trim())) return false;
  if (m.group(2) == '.') return false;
  return int.parse(m.group(3)!) > 12;
}

int _expandYear(int y) {
  if (y >= 100) return y;
  return y <= 68 ? 2000 + y : 1900 + y;
}

DateTime? _build(int year, int month, int day) {
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;
  final d = DateTime(year, month, day);
  // DateTime rolls over (Feb 31 → Mar 3); reject rather than silently shift.
  if (d.year != year || d.month != month || d.day != day) return null;
  return d;
}

/// Parses a date cell. Accepts ISO `yyyy-MM-dd` (with an optional time suffix,
/// which is discarded), `yyyy/MM/dd`, and two-component-first forms separated
/// by `.`, `/` or `-` with a 2- or 4-digit year.
DateTime? parseCsvDate(String raw, {CsvDateStyle style = CsvDateStyle.auto}) {
  final s = raw.trim();
  if (s.isEmpty) return null;

  final iso = _isoDate.firstMatch(s);
  if (iso != null) {
    return _build(
      int.parse(iso.group(1)!),
      int.parse(iso.group(2)!),
      int.parse(iso.group(3)!),
    );
  }

  final m = _pairDate.firstMatch(s);
  if (m == null) return null;

  final a = int.parse(m.group(1)!);
  final b = int.parse(m.group(3)!);
  final year = _expandYear(int.parse(m.group(4)!));

  if (a > 12) return _build(year, b, a);
  if (b > 12 && m.group(2) != '.') return _build(year, a, b);

  // Dot-separated dates are day-first by universal convention, whatever the
  // caller inferred from the rest of the file.
  final dayFirst = m.group(2) == '.' || style != CsvDateStyle.monthFirst;
  return dayFirst ? _build(year, b, a) : _build(year, a, b);
}

/// Scans every date cell in a file and resolves [CsvDateStyle.auto] to a
/// concrete style, so all rows are read consistently.
CsvDateStyle inferCsvDateStyle(Iterable<String> dateCells) {
  for (final cell in dateCells) {
    if (csvDateProvesDayFirst(cell)) return CsvDateStyle.dayFirst;
    if (csvDateProvesMonthFirst(cell)) return CsvDateStyle.monthFirst;
  }
  return CsvDateStyle.dayFirst;
}

/// True when the file contains at least one ambiguous date and nothing that
/// resolves it — the only case where we must ask the user.
bool csvDateStyleNeedsUserChoice(Iterable<String> dateCells) {
  var sawAmbiguous = false;
  for (final cell in dateCells) {
    if (csvDateProvesDayFirst(cell) || csvDateProvesMonthFirst(cell)) {
      return false;
    }
    if (csvDateIsAmbiguous(cell)) sawAmbiguous = true;
  }
  return sawAmbiguous;
}
