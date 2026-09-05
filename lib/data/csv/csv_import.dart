import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../models/account.dart';
import '../../models/transaction.dart';
import '../../utils/account_display.dart';
import '../../utils/fx.dart' as fx;
import '../account_lifecycle.dart' show compareAccountsStorageOrder;
import '../app_data.dart' as data;
import '../app_signals.dart';
import '../local/platrare_database.dart';
import '../planned_reminder_service.dart';
import '../transaction_normalize.dart';
import '../user_settings.dart' as settings;
import 'csv_codec.dart';
import 'csv_exceptions.dart';
import 'csv_format.dart';
import 'csv_value_parse.dart';

/// Ceiling on data rows, so a mistakenly picked multi-megabyte file fails fast
/// instead of locking up the UI thread.
const int kCsvMaxImportRows = 20000;

/// Why a row could not be turned into a transaction.
enum CsvRowProblem {
  missingDate,
  badDate,
  missingAmount,
  badAmount,
  zeroAmount,
  noAccount,
  sameAccount,
  unknownType,
}

/// A single rejected row, reported per-row so one bad line does not sink the
/// whole file.
class CsvRowIssue {
  const CsvRowIssue({
    required this.line,
    required this.problem,
    this.value,
  });

  /// 1-based line number in the source file, header included.
  final int line;
  final CsvRowProblem problem;

  /// The offending cell, when showing it helps the user fix the file.
  final String? value;
}

/// One row that will be written, fully resolved against the current ledger.
class CsvPreparedRow {
  CsvPreparedRow({
    required this.line,
    required this.transaction,
    required this.isDuplicate,
  });

  final int line;
  final Transaction transaction;
  final bool isDuplicate;
}

/// Everything the preview dialog needs, and everything [CsvImport.apply] needs
/// to write. Building it mutates nothing: balances are simulated in a shadow
/// map so the preview is exactly what will be committed.
class CsvImportPlan {
  CsvImportPlan({
    required this.rows,
    required this.issues,
    required this.totalDataRows,
    required this.duplicateRows,
    required this.newAccounts,
    required this.newCategories,
    required this.touchedAccounts,
    required this.shadowBalances,
    required this.dateStyle,
    required this.dateStyleAmbiguous,
    required this.skipDuplicates,
  });

  /// Rows that parsed cleanly. Duplicates are included but flagged; whether
  /// they are written is decided by [skipDuplicates], which is fixed at
  /// prepare time so the simulated balances always match what gets committed.
  final List<CsvPreparedRow> rows;
  final List<CsvRowIssue> issues;
  final int totalDataRows;
  final int duplicateRows;

  /// Accounts the file referenced that do not exist yet, already constructed
  /// (balance 0) and referenced by [rows].
  final List<Account> newAccounts;

  /// `(name, kind)` pairs to insert into the category table.
  final List<({String name, String kind})> newCategories;

  /// Existing accounts whose balance changes.
  final List<Account> touchedAccounts;

  /// Final balance per account id after replaying [rows].
  final Map<String, double> shadowBalances;

  final CsvDateStyle dateStyle;

  /// True when the file's dates are `d/m/y`-shaped with nothing to disambiguate
  /// them — the preview offers a day-first/month-first choice.
  final bool dateStyleAmbiguous;

  final bool skipDuplicates;

  int get importableRows => rows.length - (skipDuplicates ? duplicateRows : 0);
}

/// Outcome of a committed import.
class CsvImportResult {
  const CsvImportResult({
    required this.imported,
    required this.skippedDuplicates,
    required this.accountsCreated,
    required this.categoriesCreated,
    required this.failedRows,
  });

  final int imported;
  final int skippedDuplicates;
  final int accountsCreated;
  final int categoriesCreated;
  final int failedRows;
}

/// Appends transactions from a user-supplied CSV.
///
/// Never destructive: existing rows are untouched, missing accounts and
/// categories are created, and account balances are advanced by exactly the
/// same rules `verifyLedger` replays, so the ledger stays consistent.
class CsvImport {
  CsvImport._();

  /// Picks a file and reads its bytes. Returns null when cancelled.
  ///
  /// Uses [FileType.any] for the same reason `DataTransfer.pickBackupFileBytes`
  /// does — iOS resolves extensions to UTIs and over-restricts the picker.
  /// [prepare] validates the content regardless of what was picked.
  static Future<Uint8List?> pickCsvBytes() async {
    final result = await FilePicker.pickFiles(
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.single;
    final bytes = file.bytes;
    final path = file.path;
    if (bytes == null && path != null) return File(path).readAsBytes();
    return bytes;
  }

  /// Parses and simulates the import without touching any state.
  ///
  /// Throws a [CsvImportException] when the file is unusable as a whole; single
  /// unusable rows are collected into [CsvImportPlan.issues] instead.
  static CsvImportPlan prepare(
    Uint8List bytes, {
    CsvDateStyle dateStyle = CsvDateStyle.auto,
    bool skipDuplicates = true,
  }) {
    final text = decodeCsvBytes(bytes);
    final delimiter = sniffCsvDelimiter(text);
    final table = parseCsv(text, delimiter: delimiter);

    final dataRows = <({int line, List<String> cells})>[];
    Map<CsvColumn, int>? columnIndex;
    for (var i = 0; i < table.length; i++) {
      final row = table[i];
      if (csvRowIsBlank(row)) continue;
      if (row.first.trimLeft().startsWith('#')) continue;

      if (columnIndex == null) {
        // Bank exports often lead with a title or account-summary line. Keep
        // looking until a row names at least one column we understand.
        final mapped = _mapHeader(row);
        if (mapped.isNotEmpty) columnIndex = mapped;
        continue;
      }
      dataRows.add((line: i + 1, cells: row));
    }

    if (columnIndex == null) throw const CsvNoRecognisedColumnsException();
    if (!columnIndex.containsKey(CsvColumn.date)) {
      throw const CsvMissingRequiredColumnException('date');
    }
    final hasAmount = columnIndex.containsKey(CsvColumn.amount) ||
        columnIndex.containsKey(CsvColumn.debit) ||
        columnIndex.containsKey(CsvColumn.credit);
    if (!hasAmount) {
      throw const CsvMissingRequiredColumnException('amount');
    }
    if (dataRows.isEmpty) throw const CsvEmptyException();
    if (dataRows.length > kCsvMaxImportRows) {
      throw CsvTooManyRowsException(dataRows.length, kCsvMaxImportRows);
    }

    final dateCol = columnIndex[CsvColumn.date]!;
    final rawDates = [
      for (final r in dataRows) _cell(r.cells, dateCol),
    ];
    final ambiguous = csvDateStyleNeedsUserChoice(rawDates);
    final resolvedStyle = dateStyle == CsvDateStyle.auto
        ? inferCsvDateStyle(rawDates)
        : dateStyle;

    return _simulate(
      dataRows: dataRows,
      columnIndex: columnIndex,
      dateStyle: resolvedStyle,
      dateStyleAmbiguous: ambiguous,
      skipDuplicates: skipDuplicates,
    );
  }

  static Map<CsvColumn, int> _mapHeader(List<String> row) {
    final map = <CsvColumn, int>{};
    for (var i = 0; i < row.length; i++) {
      final col = csvColumnForHeader(row[i]);
      // First occurrence wins, so a stray duplicate header does not shadow the
      // real column.
      if (col != null && !map.containsKey(col)) map[col] = i;
    }
    return map;
  }

  static String _cell(List<String> cells, int? index) {
    if (index == null || index < 0 || index >= cells.length) return '';
    return csvUnsanitizeText(cells[index].trim());
  }

  // ── Simulation ───────────────────────────────────────────────────────────

  static CsvImportPlan _simulate({
    required List<({int line, List<String> cells})> dataRows,
    required Map<CsvColumn, int> columnIndex,
    required CsvDateStyle dateStyle,
    required bool dateStyleAmbiguous,
    required bool skipDuplicates,
  }) {
    final issues = <CsvRowIssue>[];

    // ── Pass 1: parse cells into intermediate rows ─────────────────────────
    final parsed = <_ParsedRow>[];
    for (final entry in dataRows) {
      final cells = entry.cells;
      final line = entry.line;

      final rawDate = _cell(cells, columnIndex[CsvColumn.date]);
      if (rawDate.isEmpty) {
        issues.add(CsvRowIssue(line: line, problem: CsvRowProblem.missingDate));
        continue;
      }
      final date = parseCsvDate(rawDate, style: dateStyle);
      if (date == null) {
        issues.add(CsvRowIssue(
          line: line,
          problem: CsvRowProblem.badDate,
          value: rawDate,
        ));
        continue;
      }

      final rawAmount = _cell(cells, columnIndex[CsvColumn.amount]);
      final rawDebit = _cell(cells, columnIndex[CsvColumn.debit]);
      final rawCredit = _cell(cells, columnIndex[CsvColumn.credit]);

      double? signed;
      if (rawAmount.isNotEmpty) {
        signed = parseCsvNumber(rawAmount);
        if (signed == null) {
          issues.add(CsvRowIssue(
            line: line,
            problem: CsvRowProblem.badAmount,
            value: rawAmount,
          ));
          continue;
        }
      } else if (rawDebit.isNotEmpty || rawCredit.isNotEmpty) {
        // Statement shape: credit is money in, debit is money out.
        final debit = parseCsvNumber(rawDebit)?.abs() ?? 0;
        final credit = parseCsvNumber(rawCredit)?.abs() ?? 0;
        signed = credit - debit;
      } else {
        issues.add(
          CsvRowIssue(line: line, problem: CsvRowProblem.missingAmount),
        );
        continue;
      }

      if (signed.abs() < 1e-10) {
        issues.add(CsvRowIssue(line: line, problem: CsvRowProblem.zeroAmount));
        continue;
      }

      var fromName = _cell(cells, columnIndex[CsvColumn.fromAccount]);
      var toName = _cell(cells, columnIndex[CsvColumn.toAccount]);
      final singleAccount = _cell(cells, columnIndex[CsvColumn.account]);
      if (fromName.isEmpty && toName.isEmpty && singleAccount.isNotEmpty) {
        // Bank-statement shape: the sign says which side the account is on.
        if (signed < 0) {
          fromName = singleAccount;
        } else {
          toName = singleAccount;
        }
      }
      if (fromName.isEmpty && toName.isEmpty) {
        issues.add(CsvRowIssue(line: line, problem: CsvRowProblem.noAccount));
        continue;
      }
      if (fromName.isNotEmpty &&
          toName.isNotEmpty &&
          fromName.toLowerCase() == toName.toLowerCase()) {
        issues.add(CsvRowIssue(line: line, problem: CsvRowProblem.sameAccount));
        continue;
      }

      final rawType = _cell(cells, columnIndex[CsvColumn.type]);
      TxType? declaredType;
      if (rawType.isNotEmpty) {
        declaredType = _txTypeByName(rawType);
        if (declaredType == null) {
          issues.add(CsvRowIssue(
            line: line,
            problem: CsvRowProblem.unknownType,
            value: rawType,
          ));
          continue;
        }
      }

      parsed.add(_ParsedRow(
        line: line,
        date: date,
        amount: signed.abs(),
        fromName: fromName,
        toName: toName,
        declaredType: declaredType,
        currency: _cell(cells, columnIndex[CsvColumn.currency]).toUpperCase(),
        destinationAmount:
            parseCsvNumber(_cell(cells, columnIndex[CsvColumn.destinationAmount]))
                ?.abs(),
        baseAmount:
            parseCsvNumber(_cell(cells, columnIndex[CsvColumn.baseAmount]))
                ?.abs(),
        exchangeRate:
            parseCsvNumber(_cell(cells, columnIndex[CsvColumn.exchangeRate])),
        category: _cell(cells, columnIndex[CsvColumn.category]),
        description: _cell(cells, columnIndex[CsvColumn.description]),
      ));
    }

    // Chronological order matters: [classifyTransaction] reads the
    // counterparty's balance *before* the row is applied, so advance vs
    // settlement and loan vs collection only come out right if we replay in the
    // order the transactions actually happened. Ties keep file order.
    for (var i = 0; i < parsed.length; i++) {
      parsed[i].order = i;
    }
    parsed.sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      return byDate != 0 ? byDate : a.order.compareTo(b.order);
    });

    // ── Pass 2: resolve accounts, classify, replay balances ────────────────
    final resolver = _AccountResolver();
    final shadow = <String, double>{
      for (final a in data.accounts) a.id: a.balance,
    };
    final touched = <String, Account>{};
    final newCategories = <({String name, String kind})>[];
    final seenNewCategories = <String>{};
    final existingFingerprints = <String>{
      for (final t in data.transactions) _fingerprint(t),
    };

    final rows = <CsvPreparedRow>[];
    var duplicates = 0;
    // createdAt keeps replay order stable for same-day rows in verifyLedger.
    var createdAtCursor = DateTime.now();

    for (final row in parsed) {
      final type = row.declaredType;

      final from = row.fromName.isEmpty
          ? null
          : resolver.resolve(
              row.fromName,
              currency: row.currency,
              group: _groupHint(type, isFrom: true),
            );
      final to = row.toName.isEmpty
          ? null
          : resolver.resolve(
              row.toName,
              currency: row.currency,
              group: _groupHint(type, isFrom: false),
            );

      if (from != null) shadow.putIfAbsent(from.id, () => 0);
      if (to != null) shadow.putIfAbsent(to.id, () => 0);

      // Derive the type from the *shadow* balances, which reflect every row
      // already replayed, rather than the accounts' live values.
      final resolvedType = type ??
          classifyTransaction(
            from: from?.copyWith(balance: shadow[from.id] ?? 0),
            to: to?.copyWith(balance: shadow[to.id] ?? 0),
          );

      final srcCcy = from?.currencyCode ??
          to?.currencyCode ??
          (row.currency.isNotEmpty ? row.currency : settings.baseCurrency);

      double? destAmount = row.destinationAmount;
      if (to != null && to.currencyCode != srcCcy) {
        // Cross-currency move with no explicit received amount: convert at
        // today's rate. Historical rates for foreign data are unknowable, and
        // leaving it null would credit the wrong currency's units.
        destAmount ??= fx.convert(row.amount, srcCcy, to.currencyCode);
      } else if (to != null) {
        destAmount = null;
      }

      final rate = row.exchangeRate ?? fx.rateToBase(srcCcy);
      final baseAmount = row.baseAmount ?? row.amount * rate;

      String? category = row.category.isEmpty ? null : row.category;
      final kindList = categoryListFor(resolvedType);
      if (kindList == null) {
        // Transfers are uncategorized by design.
        category = null;
      } else if (category != null) {
        final income = kindList == CategoryList.income;
        final kind = income ? 'income' : 'expense';
        final existing =
            income ? data.incomeCategories : data.expenseCategories;
        final key = '$kind|${category.toLowerCase()}';
        final known =
            existing.any((c) => c.toLowerCase() == category!.toLowerCase());
        if (!known && seenNewCategories.add(key)) {
          newCategories.add((name: category, kind: kind));
        }
      }

      createdAtCursor = createdAtCursor.add(const Duration(microseconds: 1));
      final tx = TransactionNormalizer.normalize(
        Transaction(
          nativeAmount: row.amount,
          currencyCode: srcCcy,
          baseAmount: baseAmount,
          exchangeRate: rate,
          destinationAmount: destAmount,
          fromAccount: from,
          toAccount: to,
          category: category,
          description: row.description.isEmpty ? null : row.description,
          date: row.date,
          txType: resolvedType,
          createdAt: createdAtCursor,
        ),
      );

      final isDuplicate = existingFingerprints.contains(_fingerprint(tx));
      if (isDuplicate) duplicates++;

      // A skipped duplicate must not move balances either.
      if (!(skipDuplicates && isDuplicate)) {
        if (from != null) {
          shadow[from.id] = (shadow[from.id] ?? 0) - row.amount;
          touched[from.id] = from;
        }
        if (to != null) {
          shadow[to.id] = (shadow[to.id] ?? 0) + (destAmount ?? row.amount);
          touched[to.id] = to;
        }
      }

      rows.add(CsvPreparedRow(
        line: row.line,
        transaction: tx,
        isDuplicate: isDuplicate,
      ));
    }

    final newAccounts = resolver.created;
    for (final a in newAccounts) {
      touched[a.id] = a;
    }
    // Report issues in file order, not the chronological order we replayed in.
    issues.sort((a, b) => a.line.compareTo(b.line));

    return CsvImportPlan(
      rows: rows,
      issues: issues,
      totalDataRows: dataRows.length,
      duplicateRows: duplicates,
      newAccounts: newAccounts,
      newCategories: newCategories,
      touchedAccounts: [
        for (final a in touched.values)
          if (!newAccounts.contains(a)) a,
      ],
      shadowBalances: shadow,
      dateStyle: dateStyle,
      dateStyleAmbiguous: dateStyleAmbiguous,
      skipDuplicates: skipDuplicates,
    );
  }

  // ── Commit ───────────────────────────────────────────────────────────────

  /// Writes [plan] in a single SQLite transaction, then patches the in-memory
  /// lists. All-or-nothing: a failure part-way leaves the ledger untouched.
  static Future<CsvImportResult> apply(CsvImportPlan plan) async {
    final toWrite = <Transaction>[
      for (final r in plan.rows)
        if (!(plan.skipDuplicates && r.isDuplicate)) r.transaction,
    ];

    final accountsToPersist = <Account>[
      ...plan.newAccounts,
      ...plan.touchedAccounts,
    ];

    // Balances only move once the write is about to happen, so a thrown
    // exception above leaves the in-memory accounts as they were.
    final previousBalances = <String, double>{
      for (final a in accountsToPersist) a.id: a.balance,
    };
    for (final a in accountsToPersist) {
      a.balance = plan.shadowBalances[a.id] ?? a.balance;
    }

    try {
      await PlatrareDatabase.instance.appendImportedData(
        accounts: accountsToPersist,
        transactions: toWrite,
        categories: plan.newCategories,
      );
      ledgerRevision.value++;
    } catch (_) {
      for (final a in accountsToPersist) {
        a.balance = previousBalances[a.id] ?? a.balance;
      }
      rethrow;
    }

    for (final a in plan.newAccounts) {
      if (!data.accounts.contains(a)) data.accounts.add(a);
    }
    data.accounts.sort(compareAccountsStorageOrder);

    data.transactions.addAll(toWrite);
    data.transactions.sort((a, b) {
      final byDate = b.date.compareTo(a.date);
      return byDate != 0 ? byDate : b.createdAt.compareTo(a.createdAt);
    });

    for (final c in plan.newCategories) {
      final list =
          c.kind == 'income' ? data.incomeCategories : data.expenseCategories;
      if (!list.contains(c.name)) list.add(c.name);
    }

    PlannedReminderService.instance.resync();

    if (kDebugMode) {
      debugPrint(
        '[CSV:Import] Committed ${toWrite.length} transactions, '
        '${plan.newAccounts.length} new accounts, '
        '${plan.newCategories.length} new categories',
      );
    }

    return CsvImportResult(
      imported: toWrite.length,
      skippedDuplicates: plan.skipDuplicates ? plan.duplicateRows : 0,
      accountsCreated: plan.newAccounts.length,
      categoriesCreated: plan.newCategories.length,
      failedRows: plan.issues.length,
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static TxType? _txTypeByName(String raw) {
    final key = raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    for (final t in TxType.values) {
      if (t.name == key) return t;
    }
    return null;
  }

  /// Which group an auto-created account should land in, inferred from the
  /// declared type. Non-personal sides default to `individuals`; the user can
  /// move an account to `entities` afterwards.
  static AccountGroup? _groupHint(TxType? type, {required bool isFrom}) {
    if (type == null) return null;
    return switch (type) {
      TxType.income => isFrom ? null : AccountGroup.personal,
      TxType.expense => isFrom ? AccountGroup.personal : null,
      TxType.invoice => isFrom ? null : AccountGroup.individuals,
      TxType.bill => isFrom ? AccountGroup.individuals : null,
      TxType.transfer => AccountGroup.personal,
      TxType.advance || TxType.settlement =>
        isFrom ? AccountGroup.personal : AccountGroup.individuals,
      TxType.loan || TxType.collection =>
        isFrom ? AccountGroup.individuals : AccountGroup.personal,
      TxType.offset => AccountGroup.individuals,
    };
  }

  /// Identity of a transaction for duplicate detection. Deliberately coarse —
  /// date, direction, amount and label — so re-importing the same file is a
  /// no-op without needing ids the source system never had.
  static String _fingerprint(Transaction t) {
    final d = t.date;
    final from = t.fromAccountId ?? t.fromAccount?.id ?? '';
    final to = t.toAccountId ?? t.toAccount?.id ?? '';
    final amt = (t.nativeAmount ?? 0).toStringAsFixed(4);
    final cat = (t.category ?? '').trim().toLowerCase();
    final desc = (t.description ?? '').trim().toLowerCase();
    return '${d.year}-${d.month}-${d.day}|$from|$to|$amt|$cat|$desc';
  }
}

/// Matches account names in the file to live accounts, creating what is
/// missing. Matching is case-insensitive and accepts both the bare name and the
/// `Name (Institution)` form the app displays and exports.
class _AccountResolver {
  final Map<String, Account> _byKey = {};
  final List<Account> created = [];

  _AccountResolver() {
    for (final a in data.accounts) {
      _byKey.putIfAbsent(a.name.trim().toLowerCase(), () => a);
      _byKey.putIfAbsent(accountDisplayName(a).trim().toLowerCase(), () => a);
    }
  }

  Account resolve(
    String rawName, {
    required String currency,
    required AccountGroup? group,
  }) {
    final key = rawName.trim().toLowerCase();
    final existing = _byKey[key];
    if (existing != null) return existing;

    // Created at balance 0 so the replayed transactions alone determine the
    // balance — the same invariant `DataRepository.addAccount` maintains via an
    // opening-balance row.
    final account = Account(
      name: rawName.trim(),
      group: group ?? AccountGroup.personal,
      currencyCode: currency.isEmpty ? settings.baseCurrency : currency,
      sortOrder: _nextSortOrder(group ?? AccountGroup.personal),
    );
    _byKey[key] = account;
    created.add(account);
    return account;
  }

  int _nextSortOrder(AccountGroup g) {
    var max = -1;
    for (final a in data.accounts) {
      if (a.group == g && a.sortOrder > max) max = a.sortOrder;
    }
    for (final a in created) {
      if (a.group == g && a.sortOrder > max) max = a.sortOrder;
    }
    return max + 1;
  }
}

class _ParsedRow {
  _ParsedRow({
    required this.line,
    required this.date,
    required this.amount,
    required this.fromName,
    required this.toName,
    required this.declaredType,
    required this.currency,
    required this.destinationAmount,
    required this.baseAmount,
    required this.exchangeRate,
    required this.category,
    required this.description,
  });

  final int line;
  final DateTime date;
  final double amount;
  final String fromName;
  final String toName;
  final TxType? declaredType;
  final String currency;
  final double? destinationAmount;
  final double? baseAmount;
  final double? exchangeRate;
  final String category;
  final String description;

  /// File order, used to break date ties during the chronological replay.
  int order = 0;
}
