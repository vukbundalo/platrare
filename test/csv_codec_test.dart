import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/csv/csv_codec.dart';
import 'package:platrare/data/csv/csv_format.dart';

void main() {
  group('parseCsv', () {
    test('splits plain rows', () {
      final rows = parseCsv('a,b,c\r\n1,2,3\r\n', delimiter: ',');
      expect(rows, [
        ['a', 'b', 'c'],
        ['1', '2', '3'],
      ]);
    });

    test('honours quoted delimiters, escaped quotes and embedded newlines', () {
      final rows = parseCsv(
        'a,"b,with comma","say ""hi"""\r\n"line1\nline2",x,y\r\n',
        delimiter: ',',
      );
      expect(rows, [
        ['a', 'b,with comma', 'say "hi"'],
        ['line1\nline2', 'x', 'y'],
      ]);
    });

    test('accepts LF-only and a missing trailing newline', () {
      final rows = parseCsv('a,b\n1,2', delimiter: ',');
      expect(rows, [
        ['a', 'b'],
        ['1', '2'],
      ]);
    });

    test('keeps empty trailing fields', () {
      expect(parseCsv('a,,c\r\n', delimiter: ','), [
        ['a', '', 'c'],
      ]);
    });
  });

  group('sniffCsvDelimiter', () {
    test('detects the semicolons European Excel writes', () {
      expect(sniffCsvDelimiter('date;amount;category\r\n'), ';');
    });

    test('detects tabs', () {
      expect(sniffCsvDelimiter('date\tamount\tcategory\n'), '\t');
    });

    test('ignores delimiters inside quotes', () {
      expect(sniffCsvDelimiter('"a;b;c;d",amount\r\n'), ',');
    });

    test('falls back to comma', () {
      expect(sniffCsvDelimiter('single\r\n'), ',');
    });
  });

  group('decodeCsvBytes', () {
    test('strips a UTF-8 BOM', () {
      final bytes = Uint8List.fromList([
        0xEF, 0xBB, 0xBF,
        ...utf8.encode('date,amount'),
      ]);
      expect(decodeCsvBytes(bytes), 'date,amount');
    });

    test('falls back to Latin-1 for non-UTF-8 payloads', () {
      final bytes = Uint8List.fromList([0x63, 0x61, 0x66, 0xE9]);
      expect(decodeCsvBytes(bytes), 'café');
    });
  });

  group('encodeCsvDocument', () {
    test('writes a BOM and CRLF line endings', () {
      final bytes = encodeCsvDocument([
        ['a', 'b'],
      ]);
      // Checked on the bytes: Dart's UTF-8 decoder silently drops a leading
      // BOM, but Excel needs it to be physically present.
      expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
      expect(utf8.decode(bytes).endsWith('\r\n'), isTrue);
    });

    test('quotes only what RFC 4180 requires', () {
      expect(csvEscapeField('plain'), 'plain');
      expect(csvEscapeField('a,b'), '"a,b"');
      expect(csvEscapeField('say "hi"'), '"say ""hi"""');
      expect(csvEscapeField('two\nlines'), '"two\nlines"');
      expect(csvEscapeField(' padded '), '" padded "');
    });

    test('round-trips values that need quoting', () {
      final original = [
        ['date', 'description'],
        ['2026-01-01', 'Lunch, with "friends"\nand a newline'],
      ];
      final text = decodeCsvBytes(encodeCsvDocument(original));
      expect(parseCsv(text, delimiter: ','), original);
    });
  });

  group('formula injection', () {
    test('neutralises leading formula triggers in text', () {
      expect(csvSanitizeText('=SUM(A1:A9)'), "'=SUM(A1:A9)");
      expect(csvSanitizeText('@import'), "'@import");
      expect(csvSanitizeText('+1 555 0100'), "'+1 555 0100");
      expect(csvSanitizeText('-lead'), "'-lead");
    });

    test('leaves ordinary text alone', () {
      expect(csvSanitizeText('Groceries'), 'Groceries');
      expect(csvSanitizeText(''), '');
    });

    test('unsanitize is the exact inverse', () {
      for (final v in ['=SUM(A1)', '@x', '+7', '-9', 'plain', "it's"]) {
        expect(csvUnsanitizeText(csvSanitizeText(v)), v);
      }
    });
  });

  group('header matching', () {
    test('is case, space and punctuation insensitive', () {
      expect(csvColumnForHeader('From Account'), CsvColumn.fromAccount);
      expect(csvColumnForHeader('  TO_ACCOUNT '), CsvColumn.toAccount);
      expect(csvColumnForHeader('Transaction Date'), CsvColumn.date);
    });

    test('maps common foreign-app aliases', () {
      expect(csvColumnForHeader('Payee'), CsvColumn.description);
      expect(csvColumnForHeader('Memo'), CsvColumn.description);
      expect(csvColumnForHeader('Withdrawal'), CsvColumn.debit);
      expect(csvColumnForHeader('Deposit'), CsvColumn.credit);
    });

    test('returns null for unknown headers', () {
      expect(csvColumnForHeader('sparkle'), isNull);
    });
  });
}
