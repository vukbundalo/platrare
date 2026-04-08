import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/account.dart';
import '../../models/planned_transaction.dart';
import '../../models/transaction.dart';
import '../app_data.dart' as data;

part 'platrare_database.g.dart';

// ─── Tables ─────────────────────────────────────────────────────────────────

@DataClassName('AccountRow')
class DbAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get institution => text().nullable()();
  IntColumn get groupIndex => integer()();
  IntColumn get iconCodePoint => integer().withDefault(const Constant(0))();
  IntColumn get colorArgb => integer().nullable()();
  RealColumn get balance => real().withDefault(const Constant(0))();
  TextColumn get currencyCode => text().withDefault(const Constant('BAM'))();
  RealColumn get overdraftLimit => real().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionRow')
class DbTransactions extends Table {
  TextColumn get id => text()();
  RealColumn get nativeAmount => real().nullable()();
  TextColumn get currencyCode => text().nullable()();
  RealColumn get baseAmount => real().nullable()();
  RealColumn get exchangeRate => real().nullable()();
  RealColumn get destinationAmount => real().nullable()();
  TextColumn get fromAccountId => text().nullable()();
  TextColumn get toAccountId => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get txTypeIndex => integer().nullable()();
  TextColumn get attachmentsJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get fromSnapshotName => text().nullable()();
  TextColumn get fromSnapshotCurrency => text().nullable()();
  TextColumn get toSnapshotName => text().nullable()();
  TextColumn get toSnapshotCurrency => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlannedRow')
class DbPlannedTransactions extends Table {
  TextColumn get id => text()();
  RealColumn get nativeAmount => real().nullable()();
  TextColumn get currencyCode => text().nullable()();
  RealColumn get destinationAmount => real().nullable()();
  TextColumn get fromAccountId => text().nullable()();
  TextColumn get toAccountId => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get txTypeIndex => integer().nullable()();
  IntColumn get repeatIntervalIndex => integer().withDefault(const Constant(0))();
  IntColumn get repeatEvery => integer().withDefault(const Constant(1))();
  IntColumn get repeatDayOfMonth => integer().nullable()();
  IntColumn get weekendAdjustmentIndex =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get repeatEndDate => dateTime().nullable()();
  IntColumn get repeatEndAfter => integer().nullable()();
  IntColumn get repeatConfirmedCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get attachmentsJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class DbCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()(); // 'income' | 'expense'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Database ───────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  DbAccounts,
  DbTransactions,
  DbPlannedTransactions,
  DbCategories,
])
class PlatrareDatabase extends _$PlatrareDatabase {
  PlatrareDatabase(super.executor);

  static PlatrareDatabase? _instance;

  static PlatrareDatabase get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('PlatrareDatabase not initialized. Call openPlatrareDatabase() first.');
    }
    return i;
  }

  static Future<PlatrareDatabase> openPlatrareDatabase() async {
    if (_instance != null) return _instance!;
    final executor = await _openExecutor();
    _instance = PlatrareDatabase(executor);
    await _instance!._ensureSeedCategories();
    return _instance!;
  }

  static Future<QueryExecutor> _openExecutor() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'platrare.sqlite'));
    if (Platform.isAndroid || Platform.isIOS) {
      return NativeDatabase.createInBackground(file);
    }
    return NativeDatabase(file);
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(dbAccounts, dbAccounts.updatedAt);
            await customStatement(
              'UPDATE db_accounts SET updated_at = created_at WHERE updated_at IS NULL',
            );
          }
          if (from < 3) {
            await m.addColumn(dbAccounts, dbAccounts.institution);
            await m.addColumn(dbAccounts, dbAccounts.iconCodePoint);
            await m.addColumn(dbAccounts, dbAccounts.colorArgb);
          }
        },
      );

  static const List<String> _seedIncome = [
    'Salary',
    'Freelance',
    'Gift',
    'Refund',
    'Investment',
    'Other',
  ];

  static const List<String> _seedExpense = [
    'Groceries',
    'Transport',
    'Housing',
    'Utilities',
    'Healthcare',
    'Dining',
    'Shopping',
    'Other',
  ];

  Future<void> _ensureSeedCategories() async {
    final n = await (select(dbCategories)..limit(1)).get();
    if (n.isNotEmpty) return;
    await batch((b) {
      var order = 0;
      for (final name in _seedIncome) {
        b.insert(
          dbCategories,
          DbCategoriesCompanion.insert(
            id: 'seed_income_${name.toLowerCase().replaceAll(' ', '_')}',
            name: name,
            kind: 'income',
            sortOrder: Value(order++),
          ),
        );
      }
      order = 0;
      for (final name in _seedExpense) {
        b.insert(
          dbCategories,
          DbCategoriesCompanion.insert(
            id: 'seed_expense_${name.toLowerCase().replaceAll(' ', '_')}',
            name: name,
            kind: 'expense',
            sortOrder: Value(order++),
          ),
        );
      }
    });
  }

  // ─── Hydrate in-memory app_data ─────────────────────────────────────────

  Future<void> loadIntoMemory() async {
    final accountRows = await (select(dbAccounts)
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
    final accountById = <String, Account>{};
    data.accounts
      ..clear()
      ..addAll(accountRows.map((r) {
        final a = _accountFromRow(r);
        accountById[a.id] = a;
        return a;
      }));

    final txRows = await (select(dbTransactions)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
    data.transactions
      ..clear()
      ..addAll(txRows.map((r) => _transactionFromRow(r, accountById)));

    final pRows = await (select(dbPlannedTransactions)
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .get();
    data.plannedTransactions
      ..clear()
      ..addAll(pRows.map((r) => _plannedFromRow(r, accountById)));

    final catRows = await (select(dbCategories)
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
    data.incomeCategories.clear();
    data.expenseCategories.clear();
    for (final c in catRows) {
      if (c.kind == 'income') {
        data.incomeCategories.add(c.name);
      } else {
        data.expenseCategories.add(c.name);
      }
    }
  }

  Account _accountFromRow(AccountRow r) => Account(
        id: r.id,
        name: r.name,
        institution: r.institution,
        group: AccountGroup.values[r.groupIndex.clamp(0, 2)],
        iconCodePoint: r.iconCodePoint,
        colorArgb: r.colorArgb,
        balance: r.balance,
        currencyCode: r.currencyCode,
        overdraftLimit: r.overdraftLimit,
        archived: r.archived,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
        sortOrder: r.sortOrder,
      );

  Transaction _transactionFromRow(
    TransactionRow r,
    Map<String, Account> accountById,
  ) {
    final attachments =
        (jsonDecode(r.attachmentsJson) as List<dynamic>).cast<String>();
    TxType? txType;
    final ti = r.txTypeIndex;
    if (ti != null && ti >= 0 && ti < TxType.values.length) {
      txType = TxType.values[ti];
    }
    return Transaction(
      id: r.id,
      nativeAmount: r.nativeAmount,
      currencyCode: r.currencyCode,
      baseAmount: r.baseAmount,
      exchangeRate: r.exchangeRate,
      destinationAmount: r.destinationAmount,
      fromAccount:
          r.fromAccountId != null ? accountById[r.fromAccountId!] : null,
      toAccount: r.toAccountId != null ? accountById[r.toAccountId!] : null,
      category: r.category,
      description: r.description,
      date: r.date,
      txType: txType,
      attachments: attachments,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      fromAccountId: r.fromAccountId,
      toAccountId: r.toAccountId,
      fromSnapshotName: r.fromSnapshotName,
      fromSnapshotCurrency: r.fromSnapshotCurrency,
      toSnapshotName: r.toSnapshotName,
      toSnapshotCurrency: r.toSnapshotCurrency,
    );
  }

  PlannedTransaction _plannedFromRow(
    PlannedRow r,
    Map<String, Account> accountById,
  ) {
    final attachments =
        (jsonDecode(r.attachmentsJson) as List<dynamic>).cast<String>();
    TxType? txType;
    final ti = r.txTypeIndex;
    if (ti != null && ti >= 0 && ti < TxType.values.length) {
      txType = TxType.values[ti];
    }
    final ri = r.repeatIntervalIndex.clamp(0, RepeatInterval.values.length - 1);
    final wi =
        r.weekendAdjustmentIndex.clamp(0, WeekendAdjustment.values.length - 1);
    return PlannedTransaction(
      id: r.id,
      nativeAmount: r.nativeAmount,
      currencyCode: r.currencyCode,
      destinationAmount: r.destinationAmount,
      fromAccount:
          r.fromAccountId != null ? accountById[r.fromAccountId!] : null,
      toAccount: r.toAccountId != null ? accountById[r.toAccountId!] : null,
      fromAccountId: r.fromAccountId,
      toAccountId: r.toAccountId,
      category: r.category,
      description: r.description,
      date: r.date,
      txType: txType,
      repeatInterval: RepeatInterval.values[ri],
      repeatEvery: r.repeatEvery,
      repeatDayOfMonth: r.repeatDayOfMonth,
      weekendAdjustment: WeekendAdjustment.values[wi],
      repeatEndDate: r.repeatEndDate,
      repeatEndAfter: r.repeatEndAfter,
      repeatConfirmedCount: r.repeatConfirmedCount,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      attachments: attachments,
    );
  }

  DbAccountsCompanion _accountCompanionForPersist(Account a) {
    final now = DateTime.now();
    return DbAccountsCompanion(
      id: Value(a.id),
      name: Value(a.name),
      institution: Value(a.institution),
      groupIndex: Value(a.group.index),
      iconCodePoint: Value(a.iconCodePoint),
      colorArgb: Value(a.colorArgb),
      balance: Value(a.balance),
      currencyCode: Value(a.currencyCode),
      overdraftLimit: Value(a.overdraftLimit),
      archived: Value(a.archived),
      createdAt: Value(a.createdAt),
      updatedAt: Value(now),
      sortOrder: Value(a.sortOrder),
    );
  }

  DbTransactionsCompanion _transactionCompanion(Transaction t) =>
      DbTransactionsCompanion(
        id: Value(t.id),
        nativeAmount: Value(t.nativeAmount),
        currencyCode: Value(t.currencyCode),
        baseAmount: Value(t.baseAmount),
        exchangeRate: Value(t.exchangeRate),
        destinationAmount: Value(t.destinationAmount),
        fromAccountId: Value(t.fromAccountId),
        toAccountId: Value(t.toAccountId),
        category: Value(t.category),
        description: Value(t.description),
        date: Value(t.date),
        txTypeIndex: Value(t.txType?.index),
        attachmentsJson: Value(jsonEncode(t.attachments)),
        createdAt: Value(t.createdAt),
        updatedAt: Value(t.updatedAt),
        fromSnapshotName: Value(t.fromSnapshotName),
        fromSnapshotCurrency: Value(t.fromSnapshotCurrency),
        toSnapshotName: Value(t.toSnapshotName),
        toSnapshotCurrency: Value(t.toSnapshotCurrency),
      );

  DbPlannedTransactionsCompanion _plannedCompanion(PlannedTransaction p) =>
      DbPlannedTransactionsCompanion(
        id: Value(p.id),
        nativeAmount: Value(p.nativeAmount),
        currencyCode: Value(p.currencyCode),
        destinationAmount: Value(p.destinationAmount),
        fromAccountId: Value(p.fromAccountId ?? p.fromAccount?.id),
        toAccountId: Value(p.toAccountId ?? p.toAccount?.id),
        category: Value(p.category),
        description: Value(p.description),
        date: Value(p.date),
        txTypeIndex: Value(p.txType?.index),
        repeatIntervalIndex: Value(p.repeatInterval.index),
        repeatEvery: Value(p.repeatEvery),
        repeatDayOfMonth: Value(p.repeatDayOfMonth),
        weekendAdjustmentIndex: Value(p.weekendAdjustment.index),
        repeatEndDate: Value(p.repeatEndDate),
        repeatEndAfter: Value(p.repeatEndAfter),
        repeatConfirmedCount: Value(p.repeatConfirmedCount),
        createdAt: Value(p.createdAt),
        updatedAt: Value(p.updatedAt),
        attachmentsJson: Value(jsonEncode(p.attachments)),
      );

  Future<void> upsertAccount(Account a) => into(dbAccounts).insertOnConflictUpdate(
        _accountCompanionForPersist(a),
      );

  Future<void> deleteAccountRow(String id) =>
      (delete(dbAccounts)..where((t) => t.id.equals(id))).go();

  Future<void> upsertTransaction(Transaction t) =>
      into(dbTransactions).insertOnConflictUpdate(_transactionCompanion(t));

  Future<void> deleteTransactionRow(String id) =>
      (delete(dbTransactions)..where((t) => t.id.equals(id))).go();

  /// Single SQLite commit: transaction row + affected account rows.
  Future<void> transactionUpsertTransactionAndAccounts(Transaction t) async {
    await transaction(() async {
      await into(dbTransactions).insertOnConflictUpdate(_transactionCompanion(t));
      if (t.fromAccount != null) {
        await into(dbAccounts)
            .insertOnConflictUpdate(_accountCompanionForPersist(t.fromAccount!));
      }
      if (t.toAccount != null) {
        await into(dbAccounts)
            .insertOnConflictUpdate(_accountCompanionForPersist(t.toAccount!));
      }
    });
  }

  /// Single SQLite commit: remove transaction row + persist adjusted accounts.
  Future<void> transactionDeleteTransactionAndUpsertAccounts(
    String transactionId,
    Account? fromAccount,
    Account? toAccount,
  ) async {
    await transaction(() async {
      await (delete(dbTransactions)..where((x) => x.id.equals(transactionId)))
          .go();
      if (fromAccount != null) {
        await into(dbAccounts)
            .insertOnConflictUpdate(_accountCompanionForPersist(fromAccount));
      }
      if (toAccount != null) {
        await into(dbAccounts)
            .insertOnConflictUpdate(_accountCompanionForPersist(toAccount));
      }
    });
  }

  Future<void> upsertPlanned(PlannedTransaction p) => into(dbPlannedTransactions)
      .insertOnConflictUpdate(_plannedCompanion(p));

  Future<void> deletePlannedRow(String id) =>
      (delete(dbPlannedTransactions)..where((t) => t.id.equals(id))).go();

  Future<void> deletePlannedForAccountId(String accountId) async {
    await (delete(dbPlannedTransactions)
          ..where((t) =>
              t.fromAccountId.equals(accountId) |
              t.toAccountId.equals(accountId)))
        .go();
  }

  Future<String> insertCategory({
    required String name,
    required String kind,
  }) async {
    final id = '${kind}_${DateTime.now().microsecondsSinceEpoch}';
    final order = await _nextCategorySortOrder(kind);
    await into(dbCategories).insert(
      DbCategoriesCompanion.insert(
        id: id,
        name: name,
        kind: kind,
        sortOrder: Value(order),
      ),
    );
    return id;
  }

  Future<int> _nextCategorySortOrder(String kind) async {
    final rows = await (select(dbCategories)
          ..where((t) => t.kind.equals(kind))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder, mode: OrderingMode.desc)])
          ..limit(1))
        .get();
    if (rows.isEmpty) return 0;
    return rows.first.sortOrder + 1;
  }

  Future<void> deleteCategoryByNameAndKind(String name, String kind) async {
    await (delete(dbCategories)
          ..where((t) => t.name.equals(name) & t.kind.equals(kind)))
        .go();
  }
}
