import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/data/app_data.dart' as data;
import 'package:platrare/data/csv/csv_exceptions.dart';
import 'package:platrare/data/csv/csv_export.dart';
import 'package:platrare/data/csv/csv_import.dart';
import 'package:platrare/data/csv/csv_value_parse.dart';
import 'package:platrare/data/ledger_verify.dart';
import 'package:platrare/models/account.dart';
import 'package:platrare/models/transaction.dart';

Uint8List bytesOf(String csv) => Uint8List.fromList(utf8.encode(csv));

/// The accounts as they would stand after [plan] is committed, so
/// [verifyLedger] can be pointed at the simulated outcome.
List<Account> accountsAfter(CsvImportPlan plan) => [
      for (final a in [...data.accounts, ...plan.newAccounts])
        a.copyWith(balance: plan.shadowBalances[a.id] ?? a.balance),
    ];

List<Transaction> transactionsAfter(CsvImportPlan plan) => [
      ...data.transactions,
      for (final r in plan.rows)
        if (!(plan.skipDuplicates && r.isDuplicate)) r.transaction,
    ];

void resetLedger() {
  data.accounts.clear();
  data.transactions.clear();
  data.incomeCategories
    ..clear()
    ..addAll(['Salary', 'Other']);
  data.expenseCategories
    ..clear()
    ..addAll(['Groceries', 'Other']);
}

void main() {
  setUp(resetLedger);

  group('file-level validation', () {
    test('rejects a file with no recognisable header', () {
      expect(
        () => CsvImport.prepare(bytesOf('sparkle,glitter\n1,2\n')),
        throwsA(isA<CsvNoRecognisedColumnsException>()),
      );
    });

    test('rejects a file missing the amount column', () {
      expect(
        () => CsvImport.prepare(bytesOf('date,category\n2026-01-01,Food\n')),
        throwsA(isA<CsvMissingRequiredColumnException>()),
      );
    });

    test('rejects a header-only file', () {
      expect(
        () => CsvImport.prepare(bytesOf('date,amount\n')),
        throwsA(isA<CsvEmptyException>()),
      );
    });

    test('ignores blank lines and # comment rows', () {
      final plan = CsvImport.prepare(bytesOf(
        'date,type,from_account,amount\n'
        '# this is guidance from the template\n'
        '\n'
        '2026-01-01,expense,Checking,10\n',
      ));
      expect(plan.totalDataRows, 1);
      expect(plan.rows, hasLength(1));
    });
  });

  group('import into an empty ledger', () {
    const csv = 'date,type,from_account,to_account,amount,currency,category,description\n'
        '2026-01-02,income,,Checking,2000,BAM,Salary,January\n'
        '2026-01-05,expense,Checking,,150.25,BAM,Groceries,Weekly shop\n'
        '2026-01-06,transfer,Checking,Savings,500,BAM,,Move to savings\n';

    test('creates the accounts the file references', () {
      final plan = CsvImport.prepare(bytesOf(csv));

      expect(plan.issues, isEmpty);
      expect(plan.rows, hasLength(3));
      expect(
        plan.newAccounts.map((a) => a.name),
        containsAll(['Checking', 'Savings']),
      );
      // income/expense/transfer all imply personal accounts.
      expect(
        plan.newAccounts.every((a) => a.group == AccountGroup.personal),
        isTrue,
      );
    });

    test('balances match a full ledger replay', () {
      final plan = CsvImport.prepare(bytesOf(csv));
      expect(
        verifyLedger(
          accounts: accountsAfter(plan),
          transactions: transactionsAfter(plan),
        ),
        isEmpty,
      );

      final checking =
          plan.newAccounts.firstWhere((a) => a.name == 'Checking');
      final savings = plan.newAccounts.firstWhere((a) => a.name == 'Savings');
      expect(plan.shadowBalances[checking.id], closeTo(1349.75, 1e-9));
      expect(plan.shadowBalances[savings.id], closeTo(500, 1e-9));
    });

    test('queues unknown categories for creation, skipping transfers', () {
      final plan = CsvImport.prepare(bytesOf(
        'date,type,from_account,to_account,amount,category\n'
        '2026-01-02,income,,Checking,2000,Consulting\n'
        '2026-01-05,expense,Checking,,10,Groceries\n'
        '2026-01-06,transfer,Checking,Savings,5,Ignored\n',
      ));

      expect(plan.newCategories.map((c) => c.name), ['Consulting']);
      expect(plan.newCategories.single.kind, 'income');
      // The transfer row drops its category rather than inventing one.
      final transfer = plan.rows.firstWhere(
        (r) => r.transaction.txType == TxType.transfer,
      );
      expect(transfer.transaction.category, isNull);
    });
  });

  group('append into an existing ledger', () {
    late Account checking;

    setUp(() {
      checking = Account(
        name: 'Checking',
        balance: 1000,
      );
      data.accounts.add(checking);
      data.transactions.add(Transaction(
        nativeAmount: 1000,
        currencyCode: 'BAM',
        toAccount: checking,
        toAccountId: checking.id,
        date: DateTime(2025, 12),
        txType: TxType.income,
        description: '__opening_balance__',
      ));
    });

    test('matches an existing account by name, case-insensitively', () {
      final plan = CsvImport.prepare(bytesOf(
        'date,type,from_account,amount\n'
        '2026-01-05,expense,checking,250\n',
      ));

      expect(plan.newAccounts, isEmpty);
      expect(plan.touchedAccounts.single.id, checking.id);
      expect(plan.shadowBalances[checking.id], closeTo(750, 1e-9));
    });

    test('leaves the ledger verifiable and existing rows untouched', () {
      final plan = CsvImport.prepare(bytesOf(
        'date,type,from_account,to_account,amount\n'
        '2026-01-05,expense,Checking,,250\n'
        '2026-01-07,income,,Checking,80\n',
      ));

      expect(
        verifyLedger(
          accounts: accountsAfter(plan),
          transactions: transactionsAfter(plan),
        ),
        isEmpty,
      );
      // prepare() must not have mutated live state.
      expect(checking.balance, 1000);
      expect(data.transactions, hasLength(1));
    });

    test('flags rows that already exist and excludes them from balances', () {
      const csv = 'date,type,from_account,amount,description\n'
          '2026-01-05,expense,Checking,250,Rent\n';

      final first = CsvImport.prepare(bytesOf(csv));
      expect(first.duplicateRows, 0);

      // Simulate the file having been imported once already.
      data.transactions.add(first.rows.single.transaction);

      final second = CsvImport.prepare(bytesOf(csv));
      expect(second.duplicateRows, 1);
      expect(second.importableRows, 0);
      expect(second.shadowBalances[checking.id], 1000);

      final kept = CsvImport.prepare(bytesOf(csv), skipDuplicates: false);
      expect(kept.importableRows, 1);
      expect(kept.shadowBalances[checking.id], closeTo(750, 1e-9));
    });
  });

  group('real-world file shapes', () {
    test('semicolon delimiter with comma decimals', () {
      final plan = CsvImport.prepare(bytesOf(
        'Datum;Typ;Von;Betrag;Kategorie\n'
        '05.01.2026;expense;Girokonto;1.234,56;Groceries\n',
      ));

      expect(plan.issues, isEmpty);
      final tx = plan.rows.single.transaction;
      expect(tx.nativeAmount, closeTo(1234.56, 1e-9));
      expect(tx.date, DateTime(2026, 1, 5));
    });

    test('single account column with signed amounts', () {
      final plan = CsvImport.prepare(bytesOf(
        'Date,Account,Amount,Payee\n'
        '2026-01-05,Checking,-42.50,Coffee shop\n'
        '2026-01-06,Checking,2000.00,Employer\n',
      ));

      expect(plan.issues, isEmpty);
      final out = plan.rows[0].transaction;
      final incoming = plan.rows[1].transaction;
      expect(out.txType, TxType.expense);
      expect(out.nativeAmount, closeTo(42.50, 1e-9));
      expect(out.description, 'Coffee shop');
      expect(incoming.txType, TxType.income);
    });

    test('debit and credit columns instead of a signed amount', () {
      final plan = CsvImport.prepare(bytesOf(
        'Date,Account,Withdrawal,Deposit\n'
        '2026-01-05,Checking,42.50,\n'
        '2026-01-06,Checking,,2000.00\n',
      ));

      expect(plan.issues, isEmpty);
      expect(plan.rows[0].transaction.txType, TxType.expense);
      expect(plan.rows[1].transaction.txType, TxType.income);
    });

    test('ambiguous dates are flagged and follow the chosen style', () {
      final bytes = bytesOf(
        'date,type,from_account,amount\n'
        '03/04/2026,expense,Checking,10\n',
      );

      final dayFirst = CsvImport.prepare(bytes);
      expect(dayFirst.dateStyleAmbiguous, isTrue);
      expect(dayFirst.rows.single.transaction.date, DateTime(2026, 4, 3));

      final monthFirst =
          CsvImport.prepare(bytes, dateStyle: CsvDateStyle.monthFirst);
      expect(monthFirst.rows.single.transaction.date, DateTime(2026, 3, 4));
    });
  });

  group('per-row error handling', () {
    test('bad rows are reported by line without sinking the good ones', () {
      final plan = CsvImport.prepare(bytesOf(
        'date,type,from_account,to_account,amount\n'
        '2026-01-02,expense,Checking,,100\n'
        'not-a-date,expense,Checking,,100\n'
        '2026-01-04,expense,Checking,,abc\n'
        '2026-01-05,expense,,,100\n'
        '2026-01-06,teleport,Checking,,100\n'
        '2026-01-07,transfer,Checking,Checking,100\n'
        '2026-01-08,expense,Checking,,0\n'
        '2026-01-09,income,,Checking,25\n',
      ));

      expect(plan.rows, hasLength(2));
      expect(
        plan.issues.map((i) => i.problem),
        [
          CsvRowProblem.badDate,
          CsvRowProblem.badAmount,
          CsvRowProblem.noAccount,
          CsvRowProblem.unknownType,
          CsvRowProblem.sameAccount,
          CsvRowProblem.zeroAmount,
        ],
      );
      // Issues are reported in file order, header included in the count.
      expect(plan.issues.map((i) => i.line), [3, 4, 5, 6, 7, 8]);
    });
  });

  group('type inference from chronological replay', () {
    test('advance then collection, even with the file out of order', () {
      final wallet = Account(name: 'Wallet');
      final ana = Account(
        name: 'Ana',
        group: AccountGroup.individuals,
      );
      data.accounts.addAll([wallet, ana]);

      // No type column: the importer replays chronologically so the February
      // row sees the receivable the January row created, rather than reading
      // both against Ana's current zero balance.
      final plan = CsvImport.prepare(bytesOf(
        'date,from_account,to_account,amount\n'
        '2026-02-01,Ana,Wallet,300\n'
        '2026-01-01,Wallet,Ana,300\n',
      ));

      final chronological = plan.rows.map((r) => r.transaction).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      expect(chronological[0].txType, TxType.advance);
      expect(chronological[1].txType, TxType.collection);
      expect(plan.shadowBalances[ana.id], closeTo(0, 1e-9));
      expect(
        verifyLedger(
          accounts: accountsAfter(plan),
          transactions: transactionsAfter(plan),
        ),
        isEmpty,
      );
    });

    test('an explicit type column overrides inference', () {
      data.accounts.add(Account(name: 'Wallet'));

      final plan = CsvImport.prepare(bytesOf(
        'date,type,from_account,to_account,amount\n'
        '2026-01-01,advance,Wallet,Ana,300\n',
      ));

      expect(plan.rows.single.transaction.txType, TxType.advance);
      // The declared type is what tells us Ana is not a personal account.
      final ana = plan.newAccounts.firstWhere((a) => a.name == 'Ana');
      expect(ana.group, AccountGroup.individuals);
    });

    test('without a type column, unknown counterparties default to personal', () {
      final plan = CsvImport.prepare(bytesOf(
        'date,from_account,to_account,amount\n'
        '2026-01-01,Wallet,Ana,300\n',
      ));

      // Nothing in the row says Ana is a person, so this reads as a transfer
      // between two of the user's own accounts.
      expect(plan.rows.single.transaction.txType, TxType.transfer);
      expect(
        plan.newAccounts.every((a) => a.group == AccountGroup.personal),
        isTrue,
      );
    });
  });

  group('export', () {
    test('round-trips through the importer without moving balances', () {
      final checking = Account(name: 'Checking');
      final savings = Account(name: 'Savings');
      data.accounts.addAll([checking, savings]);

      final source = <Transaction>[
        Transaction(
          nativeAmount: 2000,
          currencyCode: 'BAM',
          toAccount: checking,
          toAccountId: checking.id,
          date: DateTime(2026, 1, 2),
          txType: TxType.income,
          category: 'Salary',
          description: 'January',
        ),
        Transaction(
          nativeAmount: 150.25,
          currencyCode: 'BAM',
          fromAccount: checking,
          fromAccountId: checking.id,
          date: DateTime(2026, 1, 5),
          txType: TxType.expense,
          category: 'Groceries',
          // Text a spreadsheet would otherwise treat as a formula.
          description: '=SUM(A1:A9), "quoted"',
        ),
        Transaction(
          nativeAmount: 500,
          currencyCode: 'BAM',
          fromAccount: checking,
          fromAccountId: checking.id,
          toAccount: savings,
          toAccountId: savings.id,
          date: DateTime(2026, 1, 6),
          txType: TxType.transfer,
        ),
      ];

      final csv = CsvExport.buildTransactionsCsvBytes(source: source);

      // Re-import into a ledger that has the accounts but none of the rows.
      final plan = CsvImport.prepare(csv);
      expect(plan.issues, isEmpty);
      expect(plan.rows, hasLength(3));
      expect(plan.newAccounts, isEmpty);

      expect(plan.shadowBalances[checking.id], closeTo(1349.75, 1e-9));
      expect(plan.shadowBalances[savings.id], closeTo(500, 1e-9));

      final reimported = plan.rows.map((r) => r.transaction).toList();
      expect(
        reimported.map((t) => t.txType),
        containsAll([TxType.income, TxType.expense, TxType.transfer]),
      );
      // The formula guard must not leak the escaping apostrophe back into data.
      expect(
        reimported.any((t) => t.description == '=SUM(A1:A9), "quoted"'),
        isTrue,
      );
    });

    test('template parses as a valid import', () {
      final bytes = CsvExport.buildTemplateCsvBytes(
        instructionLines: const ['Replace these rows, delimiter; test'],
        currencyCode: 'BAM',
      );
      final plan = CsvImport.prepare(bytes);

      expect(plan.issues, isEmpty);
      expect(plan.rows, hasLength(3));
      expect(plan.newAccounts.map((a) => a.name),
          containsAll(['Checking', 'Savings']));
    });
  });
}
