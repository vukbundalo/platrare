import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/utils/projections.dart';

Account acc(String name, {String ccy = 'BAM', double balance = 0}) => Account(
      name: name,
      group: AccountGroup.personal,
      currencyCode: ccy,
      balance: balance,
    );

void main() {
  setUp(() {
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
  });

  group('nextPlannedEffectiveDate series', () {
    test('dom=1 previousFriday does not stall when effective date was shifted '
        'into the previous month', () {
      final a = acc('A');
      // Aug 1 2026 is a Saturday → effective Jul 31 (Friday).
      final pt = PlannedTransaction(
        nativeAmount: 100,
        fromAccount: a,
        date: DateTime(2026, 7, 31),
        repeatInterval: RepeatInterval.monthly,
        repeatDayOfMonth: 1,
        weekendAdjustment: WeekendAdjustment.previousFriday,
      );
      final next = nextPlannedEffectiveDate(pt, pt.date);
      // Must skip past the stalled Jul 31 and land on Sep 1 (Tuesday).
      expect(next, DateTime(2026, 9));
    });

    test('12 monthly steps produce strictly increasing distinct dates', () {
      final a = acc('A');
      final pt = PlannedTransaction(
        nativeAmount: 100,
        fromAccount: a,
        date: DateTime(2026),
        repeatInterval: RepeatInterval.monthly,
        repeatDayOfMonth: 1,
        weekendAdjustment: WeekendAdjustment.previousFriday,
      );
      var current = pt.date;
      final seen = <DateTime>{current};
      for (var i = 0; i < 12; i++) {
        final next = nextPlannedEffectiveDate(pt, current);
        expect(next.isAfter(current), isTrue,
            reason: 'step $i: $next after $current');
        expect(seen.add(next), isTrue, reason: 'step $i repeated $next');
        current = next;
      }
    });
  });

  group('projectBalances', () {
    test('repeatEndAfter caps the number of projected occurrences', () {
      final a = acc('Cash', balance: 100);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 10,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 7, 20),
        repeatInterval: RepeatInterval.daily,
        repeatEndAfter: 3,
      ));

      // 30 days out: only 3 occurrences may apply (100 - 3×10 = 70).
      final balances = projectBalances(DateTime(2026, 8, 19));
      expect(balances[a.id], closeTo(70, 1e-9));
    });

    test('already-confirmed count reduces remaining occurrences', () {
      final a = acc('Cash', balance: 100);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 10,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 7, 20),
        repeatInterval: RepeatInterval.daily,
        repeatEndAfter: 3,
        repeatConfirmedCount: 2,
      ));

      final balances = projectBalances(DateTime(2026, 8, 19));
      expect(balances[a.id], closeTo(90, 1e-9));
    });

    test('repeatEndDate stops the series inclusively', () {
      final a = acc('Cash');
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 5,
        currencyCode: 'BAM',
        toAccount: a,
        date: DateTime(2026, 7, 20),
        repeatInterval: RepeatInterval.daily,
        repeatEndDate: DateTime(2026, 7, 22),
      ));

      final balances = projectBalances(DateTime(2026, 7, 31));
      // Jul 20, 21, 22 → three credits.
      expect(balances[a.id], closeTo(15, 1e-9));
    });

    test('cross-currency planned transfer credits destinationAmount', () {
      final eur = acc('EUR acct', ccy: 'EUR', balance: 500);
      final bam = acc('BAM acct');
      data.accounts.addAll([eur, bam]);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 100,
        currencyCode: 'EUR',
        destinationAmount: 195.58,
        fromAccount: eur,
        toAccount: bam,
        date: DateTime(2026, 7, 20),
      ));

      final balances = projectBalances(DateTime(2026, 7, 20));
      expect(balances[eur.id], closeTo(400, 1e-9));
      expect(balances[bam.id], closeTo(195.58, 1e-9));
    });

    test('single-currency income with null destination credits nativeAmount',
        () {
      final a = acc('Cash');
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 250,
        currencyCode: 'BAM',
        toAccount: a,
        date: DateTime(2026, 7, 20),
      ));

      final balances = projectBalances(DateTime(2026, 7, 20));
      expect(balances[a.id], closeTo(250, 1e-9));
    });

    test('planned dated after the projection horizon is not applied', () {
      final a = acc('Cash', balance: 50);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 10,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 7, 25),
      ));

      final balances = projectBalances(DateTime(2026, 7, 24));
      expect(balances[a.id], closeTo(50, 1e-9));
    });
  });
}
