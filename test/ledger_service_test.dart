import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/data_repository.dart';
import 'package:platrare/data/ledger_service.dart';
import 'package:platrare/data/ledger_verify.dart';
import 'package:platrare/data/local/platrare_database.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Every operation must leave memory, SQLite and a from-zero ledger replay in
/// agreement. verifyLedger is the invariant the whole app rests on.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PlatrareDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = PlatrareDatabase(NativeDatabase.memory());
    PlatrareDatabase.useForTesting(db);
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
  });
  tearDown(() => db.close());

  Future<double> storedBalance(String id) async =>
      (await (db.select(db.dbAccounts)..where((a) => a.id.equals(id)))
              .getSingle())
          .balance;

  Future<void> expectConsistent() async {
    expect(
      verifyLedger(accounts: data.accounts, transactions: data.transactions),
      isEmpty,
      reason: 'replayed ledger must match stored balances',
    );
    for (final a in data.accounts) {
      expect(await storedBalance(a.id), closeTo(a.balance, 1e-9),
          reason: 'SQLite balance for ${a.name} must match memory');
    }
  }

  Future<Account> account(String name,
      {AccountGroup group = AccountGroup.personal,
      String ccy = 'EUR',
      double balance = 0}) async {
    final a = Account(name: name, group: group, currencyCode: ccy, balance: balance);
    await DataRepository.addAccount(a);
    return a;
  }

  Transaction expense(Account from, double amount, {String? id}) => Transaction(
        id: id,
        nativeAmount: amount,
        currencyCode: from.currencyCode,
        baseAmount: amount,
        exchangeRate: 1,
        fromAccount: from,
        date: DateTime(2026, 9, 5),
        txType: TxType.expense,
      );

  test('post, remove and restore keep memory, SQLite and replay aligned',
      () async {
    final bank = await account('Bank', balance: 500);
    final tx = expense(bank, 120);

    await LedgerService.post(tx);
    expect(bank.balance, 380);
    await expectConsistent();

    final index = data.transactions.indexOf(tx);
    await LedgerService.remove(tx);
    expect(bank.balance, 500);
    expect(data.transactions.where((t) => t.id == tx.id), isEmpty);
    await expectConsistent();

    await LedgerService.restoreAt(index, tx);
    expect(bank.balance, 380);
    expect(data.transactions.first.id, tx.id);
    await expectConsistent();
  });

  test('replace reverses the old row, classifies on prior balances, retargets',
      () async {
    final bank = await account('Bank', balance: 1000);
    final ana = await account('Ana', group: AccountGroup.individuals);
    final wallet = await account('Wallet', balance: 50);

    // 100 from bank to Ana: Ana's prior balance is 0 → advance.
    final original = Transaction(
      nativeAmount: 100,
      currencyCode: 'EUR',
      baseAmount: 100,
      exchangeRate: 1,
      fromAccount: bank,
      toAccount: ana,
      date: DateTime(2026, 9),
      txType: classifyTransaction(from: bank, to: ana),
    );
    await LedgerService.post(original);
    expect(original.txType, TxType.advance);
    expect(bank.balance, 900);
    expect(ana.balance, 100);

    // Edit: 60 from wallet to Ana instead. Classification must see Ana back
    // at 0 (old row reversed) and bank must return to 1000.
    late TxType seen;
    final updated = await LedgerService.replace(original, () {
      seen = classifyTransaction(from: wallet, to: ana);
      return Transaction(
        id: original.id,
        nativeAmount: 60,
        currencyCode: 'EUR',
        baseAmount: 60,
        exchangeRate: 1,
        fromAccount: wallet,
        toAccount: ana,
        date: original.date,
        txType: seen,
        createdAt: original.createdAt,
      );
    });
    expect(seen, TxType.advance);
    expect(bank.balance, 1000);
    expect(wallet.balance, -10);
    expect(ana.balance, 60);
    expect(data.transactions.where((t) => t.id == updated.id), hasLength(1));
    await expectConsistent();
  });

  test('realizePlanned posts cross-currency credit and spawns the next row',
      () async {
    final bank = await account('Bank', balance: 1000);
    final ana = await account('Ana', group: AccountGroup.individuals, ccy: 'USD');
    final planned = PlannedTransaction(
      nativeAmount: 100,
      currencyCode: 'EUR',
      destinationAmount: 108.4,
      fromAccount: bank,
      toAccount: ana,
      date: DateTime(2026, 9),
      txType: TxType.advance,
      repeatInterval: RepeatInterval.monthly,
    );
    await DataRepository.addPlanned(planned);

    final realized = await LedgerService.realizePlanned(planned,
        realizationDate: DateTime(2026, 9, 5));
    expect(realized.destinationAmount, 108.4);
    expect(bank.balance, 900);
    expect(ana.balance, closeTo(108.4, 1e-9));
    expect(data.plannedTransactions.map((p) => p.id), isNot(contains(planned.id)));
    final next = data.plannedTransactions.single;
    expect(next.date, DateTime(2026, 10));
    expect(next.repeatConfirmedCount, 1);
    expect(next.destinationAmount, 108.4);
    expect((await db.select(db.dbPlannedTransactions).get()).single.id, next.id);
    await expectConsistent();
  });

  test('rebalanceFromLog repairs a tampered stored balance from the log',
      () async {
    final bank = await account('Bank', balance: 500);
    await LedgerService.post(expense(bank, 120));
    expect(bank.balance, 380);

    // Simulate a stale cache (e.g. an interrupted write on an old build).
    bank.balance = 999;
    await DataRepository.persistAccountFields(bank);
    expect(verifyLedger(accounts: data.accounts, transactions: data.transactions),
        hasLength(1));

    final changed = await LedgerService.rebalanceFromLog();
    expect(changed.map((a) => a.id), [bank.id]);
    expect(bank.balance, 380);
    await expectConsistent();

    expect(await LedgerService.rebalanceFromLog(), isEmpty);
  });

  test('setBookBalance writes a correction row and keeps replay valid',
      () async {
    final bank = await account('Bank', balance: 200);
    final result = await LedgerService.setBookBalance(bank, 350);
    expect(result.inserted, isTrue);
    expect(result.amount, 150);
    expect(bank.balance, 350);
    await expectConsistent();

    final none = await LedgerService.setBookBalance(bank, 350);
    expect(none.inserted, isFalse);
    await expectConsistent();
  });
}
