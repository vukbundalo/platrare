import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/data_repository.dart';
import 'package:platrare/data/local/platrare_database.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository write paths against an in-memory SQLite database. Each test
/// checks that the rows SQLite holds match the in-memory lists after the
/// operation, which is the invariant the whole app relies on.
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

  tearDown(() async {
    await db.close();
  });

  Future<List<TransactionRow>> txRows() => db.select(db.dbTransactions).get();
  Future<List<PlannedRow>> plannedRows() =>
      db.select(db.dbPlannedTransactions).get();
  Future<AccountRow> accountRow(String id) =>
      (db.select(db.dbAccounts)..where((a) => a.id.equals(id))).getSingle();

  Account personal(String name, {double balance = 0}) => Account(
        name: name,
        group: AccountGroup.personal,
        currencyCode: 'EUR',
        balance: balance,
      );

  group('addAccount', () {
    test('zero opening balance writes only the account row', () async {
      final a = personal('Cash');
      await DataRepository.addAccount(a);

      expect((await accountRow(a.id)).balance, 0);
      expect(await txRows(), isEmpty);
      expect(data.transactions, isEmpty);
      expect(data.accounts, [a]);
    });

    test('non-zero opening balance lands account and opening row together',
        () async {
      final a = personal('Bank', balance: 250);
      await DataRepository.addAccount(a);

      expect((await accountRow(a.id)).balance, 250);
      final rows = await txRows();
      expect(rows, hasLength(1));
      expect(rows.single.description, '__opening_balance__');
      expect(rows.single.toAccountId, a.id);
      expect(rows.single.nativeAmount, 250);
      expect(a.balance, 250);
      expect(data.transactions.single.id, rows.single.id);
    });
  });

  group('realizePlanned', () {
    test('posts transaction, removes planned, inserts next in one step',
        () async {
      final from = personal('Bank', balance: 1000);
      await DataRepository.addAccount(from);

      final planned = PlannedTransaction(
        nativeAmount: 100,
        currencyCode: 'EUR',
        fromAccount: from,
        date: DateTime(2026, 9),
        txType: TxType.expense,
        repeatInterval: RepeatInterval.monthly,
      );
      await DataRepository.addPlanned(planned);
      expect(await plannedRows(), hasLength(1));

      // Caller adjusts balances before persisting, as PlanScreen does.
      from.balance -= 100;
      final realized = Transaction(
        nativeAmount: 100,
        currencyCode: 'EUR',
        baseAmount: 100,
        exchangeRate: 1,
        fromAccount: from,
        date: DateTime(2026, 9),
        txType: TxType.expense,
      );
      final next = PlannedTransaction(
        nativeAmount: 100,
        currencyCode: 'EUR',
        fromAccount: from,
        date: DateTime(2026, 10),
        txType: TxType.expense,
        repeatInterval: RepeatInterval.monthly,
        repeatConfirmedCount: 1,
      );

      await DataRepository.realizePlanned(
        planned: planned,
        realized: realized,
        next: next,
      );

      final tx = await txRows();
      expect(tx.where((t) => t.description != '__opening_balance__'),
          hasLength(1));
      expect((await accountRow(from.id)).balance, 900);
      final remaining = await plannedRows();
      expect(remaining.map((p) => p.id), [next.id]);
      expect(data.plannedTransactions.map((p) => p.id), [next.id]);
      expect(data.transactions.first.id, realized.id);
    });

    test('non-repeating planned row is removed without a successor',
        () async {
      final from = personal('Bank', balance: 50);
      await DataRepository.addAccount(from);
      final planned = PlannedTransaction(
        nativeAmount: 20,
        currencyCode: 'EUR',
        fromAccount: from,
        date: DateTime(2026, 9),
        txType: TxType.expense,
      );
      await DataRepository.addPlanned(planned);

      from.balance -= 20;
      await DataRepository.realizePlanned(
        planned: planned,
        realized: Transaction(
          nativeAmount: 20,
          currencyCode: 'EUR',
          fromAccount: from,
          date: DateTime(2026, 9),
          txType: TxType.expense,
        ),
      );

      expect(await plannedRows(), isEmpty);
      expect(data.plannedTransactions, isEmpty);
      expect((await accountRow(from.id)).balance, 30);
    });
  });

  test('replacePlanned swaps rows atomically when ids differ', () async {
    final from = personal('Bank');
    await DataRepository.addAccount(from);
    final a = PlannedTransaction(
      nativeAmount: 10,
      currencyCode: 'EUR',
      fromAccount: from,
      date: DateTime(2026, 9),
      txType: TxType.expense,
    );
    await DataRepository.addPlanned(a);
    final b = PlannedTransaction(
      nativeAmount: 10,
      currencyCode: 'EUR',
      fromAccount: from,
      date: DateTime(2026, 10),
      txType: TxType.expense,
    );

    await DataRepository.replacePlanned(a, b);
    expect((await plannedRows()).map((p) => p.id), [b.id]);
    expect(data.plannedTransactions.map((p) => p.id), [b.id]);

    await DataRepository.replacePlanned(b, a);
    expect((await plannedRows()).map((p) => p.id), [a.id]);
    expect(data.plannedTransactions.map((p) => p.id), [a.id]);
  });

  test('clearSelectiveData(transactions) zeros balances with the ledger',
      () async {
    final a = personal('Bank', balance: 300);
    await DataRepository.addAccount(a);
    expect(await txRows(), hasLength(1));

    await DataRepository.clearSelectiveData(transactions: true);

    expect(await txRows(), isEmpty);
    expect((await accountRow(a.id)).balance, 0);
    expect(a.balance, 0);
    expect(data.transactions, isEmpty);
  });
}
