import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/utils/period_filter.dart';

void main() {
  final anchor = DateTime(2026, 9, 5); // Saturday

  test('cycle order and re-anchoring', () {
    var f = PeriodFilter.allTime();
    final units = <PeriodUnit?>[];
    for (var i = 0; i < 5; i++) {
      f = f.cycled();
      units.add(f.unit);
    }
    expect(units, [PeriodUnit.day, PeriodUnit.week, PeriodUnit.month, PeriodUnit.year, null]);
  });

  test('ranges are inclusive start, exclusive end', () {
    expect(PeriodFilter(unit: PeriodUnit.day, anchor: anchor).range,
        (DateTime(2026, 9, 5), DateTime(2026, 9, 6)));
    expect(PeriodFilter(unit: PeriodUnit.week, anchor: anchor).range,
        (DateTime(2026, 8, 31), DateTime(2026, 9, 7)));
    expect(PeriodFilter(unit: PeriodUnit.month, anchor: anchor).range,
        (DateTime(2026, 9), DateTime(2026, 10)));
    expect(PeriodFilter(unit: PeriodUnit.year, anchor: anchor).range,
        (DateTime(2026), DateTime(2027)));
    expect(PeriodFilter(anchor: anchor).range, (DateTime(0), DateTime(9999)));
  });

  test('forward navigation stops at the latest allowed window', () {
    final today = DateTime(2026, 9, 5);
    final day = PeriodFilter(unit: PeriodUnit.day, anchor: today);
    expect(day.canNavigateForward(latest: today), isFalse);
    expect(day.navigated(1, latest: today), day);
    expect(day.navigated(-1, latest: today).anchor, DateTime(2026, 9, 4));

    final lastWeek = PeriodFilter(unit: PeriodUnit.week, anchor: DateTime(2026, 8, 27));
    expect(lastWeek.canNavigateForward(latest: today), isTrue);
    expect(lastWeek.navigated(1, latest: today).range.$1, DateTime(2026, 8, 31));

    final month = PeriodFilter(unit: PeriodUnit.month, anchor: DateTime(2026, 9, 30));
    expect(month.canNavigateForward(latest: today), isFalse);
    // Plan-style horizon far ahead: allowed.
    expect(month.canNavigateForward(latest: DateTime(2031, 9, 5)), isTrue);
    expect(month.navigated(1, latest: DateTime(2031)).anchor, DateTime(2026, 10, 30));
  });

  test('chip letters', () {
    expect(PeriodFilter.allTime().chipLetter, '∞');
    expect(PeriodFilter(unit: PeriodUnit.week, anchor: anchor).chipLetter, 'W');
  });
}
