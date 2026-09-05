import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/local/platrare_database.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/planned_transaction.dart';
import 'package:platrare/models/transaction.dart';

void main() {
  late PlatrareDatabase db;

  setUp(() {
    db = PlatrareDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Transaction tx(String? category, TxType type) => Transaction(
        nativeAmount: 10,
        currencyCode: 'EUR',
        category: category,
        txType: type,
      );

  PlannedTransaction planned(String? category, TxType type) =>
      PlannedTransaction(
        nativeAmount: 10,
        currencyCode: 'EUR',
        category: category,
        date: DateTime(2026, 9),
        txType: type,
      );

  test('kind mapping covers every TxType except transfer', () {
    final income = PlatrareDatabase.txTypeIndexesForCategoryKind('income');
    final expense = PlatrareDatabase.txTypeIndexesForCategoryKind('expense');
    expect(income.toSet().intersection(expense.toSet()), isEmpty);
    expect(
      {...income, ...expense, TxType.transfer.index},
      TxType.values.map((t) => t.index).toSet(),
    );
  });

  test('countCategoryUsage scopes by kind and includes planned', () async {
    // "Other" exists in both seed lists; usage must not bleed across kinds.
    await db.upsertTransaction(tx('Other', TxType.income));
    await db.upsertTransaction(tx('Other', TxType.expense));
    await db.upsertTransaction(tx('Other', TxType.bill));
    await db.upsertTransaction(tx('Groceries', TxType.expense));
    await db.upsertPlanned(planned('Other', TxType.income));

    expect(await db.countCategoryUsage('Other', 'income'), 2);
    expect(await db.countCategoryUsage('Other', 'expense'), 2);
    expect(await db.countCategoryUsage('Groceries', 'expense'), 1);
    expect(await db.countCategoryUsage('Groceries', 'income'), 0);
    expect(await db.countCategoryUsage('Missing', 'expense'), 0);
  });

  test('renameCategoryEverywhere relabels only the matching kind', () async {
    await db.insertCategory(name: 'Other', kind: 'income');
    await db.insertCategory(name: 'Other', kind: 'expense');
    await db.upsertTransaction(tx('Other', TxType.income));
    await db.upsertTransaction(tx('Other', TxType.collection));
    await db.upsertTransaction(tx('Other', TxType.expense));
    await db.upsertPlanned(planned('Other', TxType.income));
    await db.upsertPlanned(planned('Other', TxType.settlement));

    await db.renameCategoryEverywhere(
      oldName: 'Other',
      newName: 'Misc income',
      kind: 'income',
    );

    final cats = await db.loadCategoryRows();
    expect(
      cats.where((c) => c.kind == 'income').map((c) => c.name),
      contains('Misc income'),
    );
    expect(
      cats.where((c) => c.kind == 'expense').map((c) => c.name),
      contains('Other'),
    );

    expect(await db.countCategoryUsage('Misc income', 'income'), 3);
    expect(await db.countCategoryUsage('Other', 'income'), 0);
    // Expense rows untouched.
    expect(await db.countCategoryUsage('Other', 'expense'), 2);
  });

  test('rename keeps sort order of the category row', () async {
    await db.insertCategory(name: 'A', kind: 'expense');
    await db.insertCategory(name: 'B', kind: 'expense');
    await db.insertCategory(name: 'C', kind: 'expense');

    await db.renameCategoryEverywhere(
      oldName: 'B',
      newName: 'B renamed',
      kind: 'expense',
    );

    final names = (await db.loadCategoryRows())
        .where((c) => c.kind == 'expense')
        .map((c) => c.name)
        .toList();
    expect(names, ['A', 'B renamed', 'C']);
  });
}
