import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/utils/projections.dart';

/// [projectBalancesSeries] replaces `dayCount` separate [projectBalances] calls
/// with a single occurrence-walk per planned row. These tests pin the two
/// implementations together: if the fast path ever diverges, the widget
/// snapshot silently starts showing numbers that disagree with the in-app
/// hero, which is the worst possible failure mode for this feature.
Account acc(String name, {String ccy = 'BAM', double balance = 0}) => Account(
      name: name,
      group: AccountGroup.personal,
      currencyCode: ccy,
      balance: balance,
    );

void expectSeriesMatchesPerDay(DateTime start, int dayCount) {
  final series = projectBalancesSeries(start, dayCount);
  expect(series.length, dayCount);
  for (var i = 0; i < dayCount; i++) {
    final day = DateTime(start.year, start.month, start.day + i);
    final expected = projectBalances(day);
    for (final a in data.accounts) {
      expect(
        series[i][a.id],
        closeTo(expected[a.id]!, 1e-9),
        reason: 'day index $i (${day.toIso8601String()}), account ${a.name}',
      );
    }
    // Aggregates must agree too — this is what the widget actually renders.
    expect(personalTotal(series[i]), closeTo(personalTotal(expected), 1e-9),
        reason: 'personalTotal at day index $i');
    expect(netWorthInBase(series[i]), closeTo(netWorthInBase(expected), 1e-9),
        reason: 'netWorthInBase at day index $i');
  }
}

void main() {
  setUp(() {
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
  });

  group('projectBalancesSeries == projectBalances per day', () {
    test('no planned rows', () {
      data.accounts.add(acc('Cash', balance: 120.50));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
    });

    test('single one-off inside the window', () {
      final a = acc('Cash', balance: 500);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 90,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 8, 12),
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
    });

    test('overdue row before the window start is applied on day 0', () {
      final a = acc('Cash', balance: 500);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 90,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 7, 21), // two weeks overdue
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
      final series = projectBalancesSeries(DateTime(2026, 8, 3), 35);
      expect(series[0][a.id], closeTo(410, 1e-9));
    });

    test('daily recurrence', () {
      final a = acc('Cash', balance: 1000);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 5,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 8, 3),
        repeatInterval: RepeatInterval.daily,
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
    });

    test('weekly + monthly recurrences together', () {
      final a = acc('Main', balance: 2400);
      final b = acc('Savings', balance: 800);
      data.accounts.addAll([a, b]);
      data.plannedTransactions.addAll([
        PlannedTransaction(
          nativeAmount: 60,
          currencyCode: 'BAM',
          fromAccount: a,
          date: DateTime(2026, 8, 5),
          repeatInterval: RepeatInterval.weekly,
        ),
        PlannedTransaction(
          nativeAmount: 900,
          currencyCode: 'BAM',
          fromAccount: a,
          date: DateTime(2026, 8, 15),
          repeatInterval: RepeatInterval.monthly,
          repeatDayOfMonth: 15,
        ),
        PlannedTransaction(
          nativeAmount: 200,
          currencyCode: 'BAM',
          toAccount: b,
          date: DateTime(2026, 8),
          repeatInterval: RepeatInterval.monthly,
          repeatDayOfMonth: 1,
        ),
      ]);
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
    });

    test('repeatEndAfter cap with a nonzero repeatConfirmedCount', () {
      final a = acc('Cash', balance: 1000);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 25,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 8, 4),
        repeatInterval: RepeatInterval.daily,
        repeatEndAfter: 6,
        repeatConfirmedCount: 4, // only two occurrences remain
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
      final series = projectBalancesSeries(DateTime(2026, 8, 3), 35);
      expect(series[34][a.id], closeTo(950, 1e-9)); // 1000 - 2 * 25
    });

    test('repeatEndDate truncation', () {
      final a = acc('Cash', balance: 300);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 10,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 8, 4),
        repeatInterval: RepeatInterval.daily,
        repeatEndDate: DateTime(2026, 8, 8),
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
    });

    test('weekend adjustment on a monthly row', () {
      final a = acc('Cash', balance: 5000);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 300,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 8),
        repeatInterval: RepeatInterval.monthly,
        repeatDayOfMonth: 1,
        weekendAdjustment: WeekendAdjustment.previousFriday,
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 7, 28), 35);
    });

    test('cross-currency transfer credits destinationAmount', () {
      final eur = acc('EUR', ccy: 'EUR', balance: 900);
      final bam = acc('BAM', balance: 100);
      data.accounts.addAll([eur, bam]);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 100,
        currencyCode: 'EUR',
        destinationAmount: 195.58,
        fromAccount: eur,
        toAccount: bam,
        date: DateTime(2026, 8, 10),
        repeatInterval: RepeatInterval.monthly,
        repeatDayOfMonth: 10,
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 35);
    });

    test('window crossing a month boundary and a DST transition', () {
      final a = acc('Cash', balance: 1500);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 12,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 10, 20),
        repeatInterval: RepeatInterval.daily,
      ));
      // European DST ends 2026-10-25; the window straddles it.
      expectSeriesMatchesPerDay(DateTime(2026, 10, 15), 35);
    });

    test('archived accounts stay in the aggregates', () {
      final live = acc('Live', balance: 400);
      final gone = Account(
        name: 'Old',
        group: AccountGroup.personal,
        balance: 250,
        archived: true,
      );
      data.accounts.addAll([live, gone]);
      // personalTotal / netWorthInBase deliberately fold over ALL accounts,
      // matching the in-app hero. The series must not quietly filter.
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 10);
    });

    test('dayCount of 1 degenerates to projectBalances(today)', () {
      final a = acc('Cash', balance: 77);
      data.accounts.add(a);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: 7,
        currencyCode: 'BAM',
        fromAccount: a,
        date: DateTime(2026, 8, 3),
      ));
      expectSeriesMatchesPerDay(DateTime(2026, 8, 3), 1);
    });
  });
}
