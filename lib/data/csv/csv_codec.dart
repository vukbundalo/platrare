import 'dart:convert';
import 'dart:typed_data';

// RFC 4180 reader/writer plus the encoding and delimiter sniffing real-world
// spreadsheet exports need. Kept dependency-free so the CSV feature does not
// pull a package into pubspec.yaml.

/// Byte-order mark. Excel needs it to open a UTF-8 CSV without mangling
/// accented characters, so [encodeCsvDocument] always writes it.
const String kCsvBom = '﻿';

/// RFC 4180 mandates CRLF; Numbers/Excel/Sheets all accept it.
const String kCsvEol = '\r\n';

/// Delimiters we sniff for. Excel running in a locale where `,` is the decimal
/// separator writes `;` instead, and that is by far the most common surprise
/// in user-supplied files.
const List<String> kCsvCandidateDelimiters = <String>[',', ';', '\t', '|'];

const int _kQuote = 0x22;
const int _kCr = 0x0D;
const int _kLf = 0x0A;

/// Decodes CSV bytes, stripping a UTF-8 BOM if present.
///
/// Falls back to Latin-1 when the payload is not valid UTF-8: legacy Excel on
/// Windows still writes single-byte encodings, and a mojibake description is a
/// far better outcome for the user than a failed import.
String decodeCsvBytes(Uint8List bytes) {
  var data = bytes;
  if (data.length >= 3 && data[0] == 0xEF && data[1] == 0xBB && data[2] == 0xBF) {
    data = Uint8List.sublistView(data, 3);
  }
  try {
    return utf8.decode(data);
  } on FormatException {
    return latin1.decode(data, allowInvalid: true);
  }
}

/// Picks the delimiter that occurs most often outside quotes on the header
/// line. Ties and empty input fall back to `,`.
String sniffCsvDelimiter(String text) {
  var best = ',';
  var bestCount = 0;
  for (final d in kCsvCandidateDelimiters) {
    final target = d.codeUnitAt(0);
    var count = 0;
    var inQuotes = false;
    for (var i = 0; i < text.length; i++) {
      final c = text.codeUnitAt(i);
      if (c == _kQuote) {
        inQuotes = !inQuotes;
        continue;
      }
      if (inQuotes) continue;
      if (c == _kCr || c == _kLf) break;
      if (c == target) count++;
    }
    if (count > bestCount) {
      bestCount = count;
      best = d;
    }
  }
  return best;
}

/// Parses an RFC 4180 document into rows of raw field strings.
///
/// Handles quoted fields containing the delimiter, escaped quotes (`""`) and
/// embedded newlines. Bare quotes in the middle of an unquoted field are kept
/// literally rather than treated as an error — spreadsheets emit them and
/// rejecting the file would be unhelpful.
List<List<String>> parseCsv(String text, {required String delimiter}) {
  final rows = <List<String>>[];
  final delim = delimiter.codeUnitAt(0);

  var field = StringBuffer();
  var row = <String>[];
  var inQuotes = false;
  var pendingRow = false;

  void endField() {
    row.add(field.toString());
    field = StringBuffer();
  }

  void endRow() {
    endField();
    rows.add(row);
    row = <String>[];
    pendingRow = false;
  }

  var i = 0;
  final n = text.length;
  while (i < n) {
    final c = text.codeUnitAt(i);

    if (inQuotes) {
      if (c == _kQuote) {
        if (i + 1 < n && text.codeUnitAt(i + 1) == _kQuote) {
          field.writeCharCode(_kQuote);
          i += 2;
          continue;
        }
        inQuotes = false;
        i++;
        continue;
      }
      field.writeCharCode(c);
      i++;
      continue;
    }

    if (c == _kQuote && field.isEmpty) {
      inQuotes = true;
      pendingRow = true;
      i++;
      continue;
    }
    if (c == delim) {
      endField();
      pendingRow = true;
      i++;
      continue;
    }
    if (c == _kCr) {
      if (i + 1 < n && text.codeUnitAt(i + 1) == _kLf) i++;
      endRow();
      i++;
      continue;
    }
    if (c == _kLf) {
      endRow();
      i++;
      continue;
    }

    field.writeCharCode(c);
    pendingRow = true;
    i++;
  }

  if (pendingRow || field.isNotEmpty) endRow();
  return rows;
}

/// Quotes [value] when RFC 4180 requires it. Leading/trailing whitespace is
/// also quoted so it survives a round trip.
String csvEscapeField(String value, {String delimiter = ','}) {
  final needsQuotes = value.contains(delimiter) ||
      value.contains('"') ||
      value.contains('\n') ||
      value.contains('\r') ||
      value.trim().length != value.length;
  if (!needsQuotes) return value;
  return '"${value.replaceAll('"', '""')}"';
}

/// Serializes [rows] to a BOM-prefixed, CRLF-terminated UTF-8 document.
Uint8List encodeCsvDocument(
  List<List<String>> rows, {
  String delimiter = ',',
}) {
  final buf = StringBuffer(kCsvBom);
  for (final row in rows) {
    buf.write(
      row.map((f) => csvEscapeField(f, delimiter: delimiter)).join(delimiter),
    );
    buf.write(kCsvEol);
  }
  return Uint8List.fromList(utf8.encode(buf.toString()));
}

/// True when [row] carries no data at all (a blank line, or a line of empty
/// cells left behind by a spreadsheet).
bool csvRowIsBlank(List<String> row) =>
    row.every((f) => f.trim().isEmpty);
