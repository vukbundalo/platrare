import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/balance_privacy_prefs.dart';
import 'package:platrare/data/security_prefs.dart';
import 'package:platrare/data/widget_link_router.dart';
import 'package:platrare/data/widget_prefs.dart';
import 'package:platrare/data/widget_snapshot_service.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/utils/fx.dart' as fx;
import 'package:platrare/utils/money_format.dart';
import 'package:platrare/utils/projections.dart';

Account acc(
  String name, {
  String ccy = 'BAM',
  double balance = 0,
  double overdraft = 0,
  bool archived = false,
  AccountGroup group = AccountGroup.personal,
}) =>
    Account(
      name: name,
      group: group,
      currencyCode: ccy,
      balance: balance,
      overdraftLimit: overdraft,
      archived: archived,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // The snapshot formats day labels with DateFormat; main() does this at
    // startup for every selectable locale.
    await initializeDateFormatting();
  });

  setUp(() {
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
    balancePrivacyHideByDefault.value = false;
    heroBalancesTemporarilyRevealed.value = false;
    appSecurityEnabled.value = false;
    widgetShowAmounts.value = false;
  });

  Map<String, dynamic> build() =>
      WidgetSnapshotService.instance.buildForTest();

  group('snapshot payload', () {
    test('headline figures match the in-app hero formulas exactly', () {
      final a = acc('Main', balance: 1200, overdraft: 500);
      final b = acc('Cash', balance: 300);
      data.accounts.addAll([a, b]);

      final snap = build();
      final today = DateTime.now();
      final expected = projectBalances(today);

      final day0 = (snap['series'] as Map)['days'][0] as Map;
      expect(day0['sp'], closeTo(personalTotal(expected), 1e-3));
      expect(day0['nw'], closeTo(netWorthInBase(expected), 1e-3));
      // personalTotal includes overdraft headroom; netWorth does not.
      expect(day0['sp'], closeTo(2000, 1e-3));
      expect(day0['nw'], closeTo(1500, 1e-3));
    });

    test('aggregates include archived accounts, the accounts list does not',
        () {
      data.accounts.addAll([
        acc('Live', balance: 400),
        acc('Old', balance: 250, archived: true),
      ]);

      final snap = build();
      // Matches the Review hero, which folds over every account.
      expect((snap['series'] as Map)['days'][0]['nw'], closeTo(650, 1e-3));
      // The picker must not offer archived accounts.
      expect((snap['accounts'] as List).length, 1);
      expect((snap['accounts'] as List).first['name'], 'Live');
    });

    test('series has 35 days and is ordered from today', () {
      data.accounts.add(acc('Cash', balance: 100));
      final snap = build();
      final days = (snap['series'] as Map)['days'] as List;
      expect(days.length, WidgetSnapshotService.kDayCount);
      expect(days.first['d'], snap['generatedDay']);
      final parsed = days.map((d) => DateTime.parse(d['d'] as String)).toList();
      for (var i = 1; i < parsed.length; i++) {
        expect(parsed[i].difference(parsed[i - 1]).inHours, inInclusiveRange(23, 25));
      }
    });

    test('lowest point finds the trough and its date', () {
      final a = acc('Main', balance: 1000);
      data.accounts.add(a);
      final today = DateTime.now();
      // Big outflow in 3 days, big inflow in 10 — trough is days 3..9.
      data.plannedTransactions.addAll([
        PlannedTransaction(
          nativeAmount: 800,
          currencyCode: 'BAM',
          fromAccount: a,
          date: DateTime(today.year, today.month, today.day + 3),
        ),
        PlannedTransaction(
          nativeAmount: 2000,
          currencyCode: 'BAM',
          toAccount: a,
          date: DateTime(today.year, today.month, today.day + 10),
        ),
      ]);

      final snap = build();
      final lowest = (snap['derived'] as Map)['lowestSpendable'] as Map;
      final eomIndex = (snap['derived'] as Map)['endOfMonthIndex'] as int;

      // Only assert the trough when the window actually reaches the outflow.
      if (eomIndex >= 3) {
        expect(lowest['v'], closeTo(200, 1e-3));
        expect(lowest['index'], 3);
      }
      expect(lowest['index'], lessThanOrEqualTo(eomIndex));
    });

    test('formatSample matches fx.formatNative arithmetic', () {
      data.accounts.add(acc('Cash', balance: 10));
      final snap = build();
      final sample = snap['formatSample'] as Map;
      final fmt = snap['format'] as Map;
      final digits = fmt['digits'] as int;
      final symbol = fmt['symbol'] as String;
      final v = sample['v'] as double;
      // Swift reproduces exactly this: "%.<digits>f" + " " + symbol.
      expect(sample['text'], '${v.toStringAsFixed(digits)} $symbol');
      // The app's own formatter is locale-aware (grouping); the widget
      // deliberately stays ungrouped so Dart and Swift agree.
      expect(fx.formatNative(v, snap['baseCurrency'] as String),
          '${formatMoneyDigits(v.abs(), decimals: digits)} $symbol');
    });

    test('day-0 balances keep the minus sign that formatNative drops', () {
      data.accounts.add(acc('Overdrawn', balance: -250));
      final snap = build();
      final day0 = (snap['series'] as Map)['days'][0] as Map;
      expect(day0['nwText'], startsWith('-'));
    });
  });

  group('masking policy', () {
    test('not masked by default', () {
      data.accounts.add(acc('Cash', balance: 10));
      expect(build()['maskAmounts'], isFalse);
    });

    test('masked when hero balances are hidden', () {
      data.accounts.add(acc('Cash', balance: 10));
      balancePrivacyHideByDefault.value = true;
      expect(build()['maskAmounts'], isTrue);
    });

    test('session-only reveal never unmasks the widget', () {
      data.accounts.add(acc('Cash', balance: 10));
      balancePrivacyHideByDefault.value = true;
      // In-app the user tapped the eye icon. That is scoped to the foreground
      // session and must not leak onto the home screen.
      heroBalancesTemporarilyRevealed.value = true;
      expect(build()['maskAmounts'], isTrue);
    });

    test('app lock masks unless the user explicitly opts in', () {
      data.accounts.add(acc('Cash', balance: 10));
      appSecurityEnabled.value = true;
      expect(build()['maskAmounts'], isTrue);

      widgetShowAmounts.value = true;
      expect(build()['maskAmounts'], isFalse);
    });
  });

  group('deep link parsing', () {
    test('add links', () {
      expect(parseWidgetLink('platrare://add/tracked?src=widget&n=abc'),
          isA<AddTrackedAction>());
      expect(parseWidgetLink('platrare://add/planned?src=widget&n=abc'),
          isA<AddPlannedAction>());
    });

    test('tab links map to the right index', () {
      expect((parseWidgetLink('platrare://open?tab=plan&n=1') as OpenTabAction)
          .tabIndex, 0);
      expect((parseWidgetLink('platrare://open?tab=track&n=2') as OpenTabAction)
          .tabIndex, 1);
      expect((parseWidgetLink('platrare://open?tab=review&n=3') as OpenTabAction)
          .tabIndex, 2);
    });

    test('account link carries the id', () {
      final a = parseWidgetLink('platrare://account/abc-123?n=4')
          as OpenAccountAction;
      expect(a.accountId, 'abc-123');
      expect(a.nonce, '4');
    });

    test('nonce and source are captured', () {
      final a = parseWidgetLink('platrare://add/tracked?src=quickaction&n=xyz')!;
      expect(a.nonce, 'xyz');
      expect(a.source, 'quickaction');
    });

    test('malformed and foreign links are ignored, never thrown', () {
      expect(parseWidgetLink('https://example.com'), isNull);
      expect(parseWidgetLink('platrare://add/nonsense'), isNull);
      expect(parseWidgetLink('platrare://open?tab=bogus'), isNull);
      expect(parseWidgetLink('platrare://account/'), isNull);
      expect(parseWidgetLink('not a url at all'), isNull);
      expect(parseWidgetLink(''), isNull);
    });
  });

  group('planned due today', () {
    test('includes overdue and today, excludes future', () {
      final a = acc('Main', balance: 1000);
      data.accounts.add(a);
      final today = DateTime.now();
      data.plannedTransactions.addAll([
        PlannedTransaction(
          nativeAmount: 50,
          currencyCode: 'BAM',
          fromAccount: a,
          description: 'Overdue rent',
          date: DateTime(today.year, today.month, today.day - 2),
        ),
        PlannedTransaction(
          nativeAmount: 20,
          currencyCode: 'BAM',
          fromAccount: a,
          description: 'Due today',
          date: DateTime(today.year, today.month, today.day),
        ),
        PlannedTransaction(
          nativeAmount: 90,
          currencyCode: 'BAM',
          fromAccount: a,
          description: 'Next week',
          date: DateTime(today.year, today.month, today.day + 7),
        ),
      ]);

      final due = build()['plannedDueToday'] as List;
      expect(due.length, 2);
      expect(due.map((d) => d['title']), ['Overdue rent', 'Due today']);
      expect(due.first['overdue'], isTrue);
      expect(due.last['overdue'], isFalse);
    });
  });

  group('empty ledger', () {
    test('hasData is false but the payload is still well formed', () {
      final snap = build();
      expect(snap['hasData'], isFalse);
      expect((snap['accounts'] as List), isEmpty);
      expect((snap['series'] as Map)['days'], hasLength(35));
      expect(snap['schemaVersion'], 1);
      // Strings must always be present — the widget renders them before any
      // account exists.
      expect((snap['strings'] as Map)['emptyBody'], isNotEmpty);
    });
  });

  group('localization', () {
    test('strings follow the resolved locale, not the system sentinel', () {
      data.accounts.add(acc('Cash', balance: 10));
      final snap = build();
      expect(snap['localeTag'], isNot('system'));
      expect(snap['textDirection'], anyOf('ltr', 'rtl'));
      final strings = snap['strings'] as Map;
      for (final key in [
        'spendableNow', 'netWorth', 'lowestPoint', 'projected',
        'addTracked', 'addPlanned', 'emptyBody', 'stale',
      ]) {
        expect(strings[key], isNotEmpty, reason: 'missing string "$key"');
      }
    });
  });
}
