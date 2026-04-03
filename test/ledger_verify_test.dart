import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/ledger_verify.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction.dart';

void main() {
  test('verifyLedger: two-account transfer sequence matches', () {
    final a = Account(name: 'A', currencyCode: 'EUR');
    final b = Account(name: 'B', currencyCode: 'EUR');
    final d1 = DateTime(2024, 1, 1);
    final d2 = DateTime(2024, 1, 2);
    final txs = <Transaction>[
      Transaction(
        nativeAmount: 100,
        currencyCode: 'EUR',
        fromAccount: a,
        toAccount: b,
        date: d1,
        createdAt: d1,
      ),
      Transaction(
        nativeAmount: 50,
        currencyCode: 'EUR',
        fromAccount: b,
        toAccount: a,
        date: d2,
        createdAt: d2,
      ),
    ];
    a.balance = -50;
    b.balance = 50;
    expect(verifyLedger(accounts: [a, b], transactions: txs), isEmpty);
  });

  test('verifyLedger: cross-currency credit uses destinationAmount', () {
    final usd = Account(name: 'USD', currencyCode: 'USD');
    final eur = Account(name: 'EUR', currencyCode: 'EUR');
    final d = DateTime(2024, 6, 1);
    final txs = <Transaction>[
      Transaction(
        nativeAmount: 100,
        currencyCode: 'USD',
        destinationAmount: 85,
        fromAccount: usd,
        toAccount: eur,
        date: d,
        createdAt: d,
      ),
    ];
    usd.balance = -100;
    eur.balance = 85;
    expect(verifyLedger(accounts: [usd, eur], transactions: txs), isEmpty);
  });

  test('verifyLedger: wrong stored balance yields one mismatch', () {
    final a = Account(name: 'A', currencyCode: 'EUR', balance: 999);
    final d = DateTime(2024, 1, 1);
    final txs = <Transaction>[
      Transaction(
        nativeAmount: 10,
        currencyCode: 'EUR',
        fromAccount: a,
        date: d,
        createdAt: d,
      ),
    ];
    final mm = verifyLedger(accounts: [a], transactions: txs);
    expect(mm, hasLength(1));
    expect(mm.first.storedBalance, 999);
    expect(mm.first.recomputedBalance, closeTo(-10, 1e-9));
  });
}
