import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';

void main() {
  group('applyWeekendAdjustment', () {
    test('previousFriday: Saturday -> Friday', () {
      final sat = DateTime(2026, 3, 14); // Saturday
      expect(
        applyWeekendAdjustment(sat, WeekendAdjustment.previousFriday),
        DateTime(2026, 3, 13),
      );
    });
    test('previousFriday: Sunday -> Friday', () {
      final sun = DateTime(2026, 3, 15); // Sunday
      expect(
        applyWeekendAdjustment(sun, WeekendAdjustment.previousFriday),
        DateTime(2026, 3, 13),
      );
    });
    test('nextMonday: Saturday -> Monday', () {
      final sat = DateTime(2026, 3, 14);
      expect(
        applyWeekendAdjustment(sat, WeekendAdjustment.nextMonday),
        DateTime(2026, 3, 16),
      );
    });
    test('ignore leaves weekday unchanged', () {
      final wed = DateTime(2026, 3, 18);
      expect(
        applyWeekendAdjustment(wed, WeekendAdjustment.previousFriday),
        wed,
      );
    });
  });

  group('nextPlannedEffectiveDate monthly + repeatDayOfMonth', () {
    final acc = Account(
      name: 'A',
      group: AccountGroup.personal,
      currencyCode: 'BAM',
    );

    test('15th on weekend shifts; next month uses 15th again', () {
      // March 2026: 15th is Sunday -> previous Friday Mar 13
      final pt = PlannedTransaction(
        nativeAmount: 100,
        fromAccount: acc,
        date: DateTime(2026, 3, 13),
        repeatInterval: RepeatInterval.monthly,
        repeatDayOfMonth: 15,
        weekendAdjustment: WeekendAdjustment.previousFriday,
      );
      final next = nextPlannedEffectiveDate(pt, pt.date);
      // April 15 2026 is Wednesday
      expect(next, DateTime(2026, 4, 15));
    });
  });
}
