import 'package:flutter_test/flutter_test.dart';

import 'package:platrare/data/balance_posting.dart';
import 'package:platrare/data/fx_service.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction.dart';

void main() {
  group('FxService.parseFrankfurterV2', () {
    test('merges quotes and reports newest date as-of', () {
      DateTime? asOf;
      final decoded = <dynamic>[
        {'date': '2026-01-01', 'quote': 'USD', 'rate': 1.1},
        {'date': '2026-01-03', 'quote': 'USD', 'rate': 1.2},
        {'date': '2026-01-02', 'quote': 'GBP', 'rate': 0.85},
      ];
      final m = FxService.parseFrankfurterV2(
        decoded,
        outDataAsOf: (d) => asOf = d,
      );
      expect(m['USD'], closeTo(1.2, 1e-9));
      expect(m['GBP'], closeTo(0.85, 1e-9));
      expect(asOf, isNotNull);
      expect(asOf!.isAfter(DateTime.utc(2026, 1, 2)), isTrue);
    });

    test('skips EUR quote rows', () {
      final m = FxService.parseFrankfurterV2(<dynamic>[
        {'date': '2026-01-01', 'quote': 'EUR', 'rate': 1.0},
        {'date': '2026-01-01', 'quote': 'CHF', 'rate': 0.94},
      ]);
      expect(m.containsKey('EUR'), isFalse);
      expect(m['CHF'], closeTo(0.94, 1e-9));
    });
  });

  group('applyLedgerBalanceCorrection', () {
    test('does not persist when delta is zero', () async {
      var calls = 0;
      final acc = Account(name: 'A', balance: 5, currencyCode: 'BAM');
      final r = await applyLedgerBalanceCorrection(
        account: acc,
        previousBookBalance: 5,
        newBookBalance: 5,
        persistTransaction: (_) async {
          calls++;
        },
      );
      expect(calls, 0);
      expect(r.inserted, isFalse);
    });

    test('positive delta credits account and passes one transaction to persist',
        () async {
      Transaction? captured;
      final acc = Account(
        name: 'A',
        balance: 0,
        group: AccountGroup.personal,
        currencyCode: 'BAM',
      );
      final r = await applyLedgerBalanceCorrection(
        account: acc,
        previousBookBalance: 0,
        newBookBalance: 50,
        persistTransaction: (t) async {
          captured = t;
        },
      );
      expect(r.inserted, isTrue);
      expect(acc.balance, closeTo(50, 1e-9));
      expect(captured, isNotNull);
      expect(captured!.nativeAmount, closeTo(50, 1e-9));
      expect(captured!.toAccount, same(acc));
    });
  });
}
