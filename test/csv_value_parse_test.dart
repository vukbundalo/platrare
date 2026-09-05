import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/csv/csv_value_parse.dart';

void main() {
  group('parseCsvNumber', () {
    test('plain decimals', () {
      expect(parseCsvNumber('1234.56'), 1234.56);
      expect(parseCsvNumber('42'), 42.0);
      expect(parseCsvNumber('0.5'), 0.5);
    });

    test('comma thousands with dot decimal', () {
      expect(parseCsvNumber('1,234.56'), 1234.56);
      expect(parseCsvNumber('1,234,567.89'), 1234567.89);
    });

    test('dot thousands with comma decimal', () {
      expect(parseCsvNumber('1.234,56'), 1234.56);
      expect(parseCsvNumber('1.234.567,89'), 1234567.89);
    });

    test('space-grouped European amounts', () {
      expect(parseCsvNumber('1 234,56'), 1234.56);
      expect(parseCsvNumber('1 234,56'), 1234.56);
    });

    test('lone comma', () {
      expect(parseCsvNumber('12,34'), 12.34);
      expect(parseCsvNumber('1,5'), 1.5);
      // Exactly three digits after a lone comma reads as a thousands group.
      expect(parseCsvNumber('1,234'), 1234.0);
    });

    test('signs, parentheses and currency symbols', () {
      expect(parseCsvNumber('-42.50'), -42.50);
      expect(parseCsvNumber('+42.50'), 42.50);
      expect(parseCsvNumber('(42.50)'), -42.50);
      expect(parseCsvNumber(r'$42.50'), 42.50);
      expect(parseCsvNumber('42,50 €'), 42.50);
      expect(parseCsvNumber('EUR 1.000,00'), 1000.0);
    });

    test('rejects non-numbers', () {
      expect(parseCsvNumber(''), isNull);
      expect(parseCsvNumber('   '), isNull);
      expect(parseCsvNumber('n/a'), isNull);
    });
  });

  group('parseCsvDate', () {
    test('ISO forms, with or without a time suffix', () {
      expect(parseCsvDate('2026-07-01'), DateTime(2026, 7));
      expect(parseCsvDate('2026/07/01'), DateTime(2026, 7));
      expect(parseCsvDate('2026-07-01T10:30:00'), DateTime(2026, 7));
    });

    test('resolves by magnitude when one component exceeds 12', () {
      expect(parseCsvDate('31/12/2026'), DateTime(2026, 12, 31));
      expect(
        parseCsvDate('12/31/2026', style: CsvDateStyle.monthFirst),
        DateTime(2026, 12, 31),
      );
    });

    test('dot-separated dates are day-first regardless of style', () {
      expect(
        parseCsvDate('03.04.2026', style: CsvDateStyle.monthFirst),
        DateTime(2026, 4, 3),
      );
    });

    test('ambiguous slash dates follow the chosen style', () {
      expect(
        parseCsvDate('03/04/2026', style: CsvDateStyle.dayFirst),
        DateTime(2026, 4, 3),
      );
      expect(
        parseCsvDate('03/04/2026', style: CsvDateStyle.monthFirst),
        DateTime(2026, 3, 4),
      );
    });

    test('expands two-digit years', () {
      expect(parseCsvDate('01/02/99'), DateTime(1999, 2));
      expect(parseCsvDate('01/02/26'), DateTime(2026, 2));
    });

    test('rejects impossible dates instead of rolling over', () {
      expect(parseCsvDate('31/02/2026'), isNull);
      expect(parseCsvDate('not a date'), isNull);
      expect(parseCsvDate(''), isNull);
    });
  });

  group('date style inference', () {
    test('a day > 12 anywhere proves day-first', () {
      expect(
        inferCsvDateStyle(['03/04/2026', '31/01/2026']),
        CsvDateStyle.dayFirst,
      );
    });

    test('a month-position value > 12 proves month-first', () {
      expect(
        inferCsvDateStyle(['03/04/2026', '01/31/2026']),
        CsvDateStyle.monthFirst,
      );
    });

    test('asks the user only when nothing in the file resolves it', () {
      expect(csvDateStyleNeedsUserChoice(['03/04/2026', '05/06/2026']), isTrue);
      expect(csvDateStyleNeedsUserChoice(['03/04/2026', '31/01/2026']), isFalse);
      expect(csvDateStyleNeedsUserChoice(['2026-07-01']), isFalse);
    });
  });
}
