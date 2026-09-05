import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/local/platrare_database.dart';
import 'package:sqlite3/sqlite3.dart';

/// Opens a database that still has the v1 schema and real rows, lets drift run
/// onUpgrade 1 -> 3, and checks nothing was lost. The v1 DDL is derived from
/// the current schema minus the columns the migrations add, so this test
/// keeps following the table definitions.
void main() {
  const addedInV2 = ['updated_at'];
  const addedInV3 = ['institution', 'icon_code_point', 'color_argb'];

  Future<Map<String, String>> currentDdl() async {
    final db = PlatrareDatabase(NativeDatabase.memory());
    final rows = await db
        .customSelect(
            "SELECT name, sql FROM sqlite_master WHERE type = 'table' AND name LIKE 'db_%'")
        .get();
    final ddl = {
      for (final r in rows) r.read<String>('name'): r.read<String>('sql'),
    };
    await db.close();
    return ddl;
  }

  String withoutColumns(String ddl, List<String> columns) {
    var out = ddl;
    for (final c in columns) {
      final before = out;
      out = out.replaceFirst(RegExp(', "$c" [^,]*'), '');
      expect(out, isNot(before), reason: 'column $c not found in: $ddl');
    }
    return out;
  }

  test('v1 database migrates to v3 and keeps its rows', () async {
    final ddl = await currentDdl();
    expect(ddl.keys, containsAll(['db_accounts', 'db_transactions',
        'db_planned_transactions', 'db_categories']));

    final raw = sqlite3.openInMemory();
    raw.execute(withoutColumns(ddl['db_accounts']!, [...addedInV2, ...addedInV3]));
    raw.execute(ddl['db_transactions']!);
    raw.execute(ddl['db_planned_transactions']!);
    raw.execute(ddl['db_categories']!);
    raw.execute('PRAGMA user_version = 1');

    const created = 1700000000; // drift stores DateTime as unix seconds
    raw.execute('''
      INSERT INTO db_accounts (id, name, group_index, balance, currency_code,
        overdraft_limit, archived, created_at, sort_order)
      VALUES ('acc-1', 'Bank', 0, 1234.5, 'EUR', 0, 0, $created, 0)''');
    raw.execute('''
      INSERT INTO db_transactions (id, native_amount, currency_code,
        base_amount, exchange_rate, from_account_id, category, description,
        date, tx_type_index, attachments_json, created_at)
      VALUES ('tx-1', 20, 'EUR', 20, 1, 'acc-1', 'Groceries', 'milk',
        $created, 1, '[]', $created)''');
    raw.execute('''
      INSERT INTO db_planned_transactions (id, native_amount, currency_code,
        from_account_id, date, tx_type_index, repeat_interval_index,
        repeat_every, created_at)
      VALUES ('pl-1', 50, 'EUR', 'acc-1', $created, 1, 3, 1, $created)''');
    raw.execute('''
      INSERT INTO db_categories (id, name, kind, sort_order)
      VALUES ('cat-1', 'Groceries', 'expense', 0)''');

    final db = PlatrareDatabase(NativeDatabase.opened(raw));
    addTearDown(db.close);

    // First statement triggers the migration.
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 3);

    final account = await db.select(db.dbAccounts).getSingle();
    expect(account.name, 'Bank');
    expect(account.balance, 1234.5);
    expect(account.institution, isNull);
    expect(account.iconCodePoint, 0);
    expect(account.colorArgb, isNull);
    expect(account.updatedAt, account.createdAt,
        reason: 'v2 backfills updated_at from created_at');

    expect((await db.select(db.dbTransactions).get()).single.description, 'milk');
    expect((await db.select(db.dbPlannedTransactions).get()).single.nativeAmount, 50);
    expect((await db.select(db.dbCategories).get()).single.name, 'Groceries');

    // The in-memory hydration path also reads the migrated rows.
    data.accounts.clear();
    data.transactions.clear();
    data.plannedTransactions.clear();
    await db.loadIntoMemory();
    expect(data.accounts.single.id, 'acc-1');
    expect(data.transactions.single.fromAccount?.id, 'acc-1');
    expect(data.plannedTransactions.single.id, 'pl-1');
  });
}
