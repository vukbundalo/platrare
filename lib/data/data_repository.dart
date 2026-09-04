import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'account_lifecycle.dart' show compareAccountsStorageOrder;
import 'app_data.dart' as data;
import 'backup_export_reminder_prefs.dart';
import 'balance_posting.dart';
import 'local/platrare_database.dart';
import 'planned_normalize.dart';
import 'planned_reminder_service.dart';
import 'transaction_normalize.dart';
import 'widget_snapshot_service.dart';

/// Single entry point for mutating global lists and persisting to SQLite.
class DataRepository {
  DataRepository._();

  static PlatrareDatabase get _db => PlatrareDatabase.instance;

  /// Marks the home-screen widget snapshot dirty. Debounced downstream, and a
  /// no-op until [WidgetSnapshotService.init] has run, so it is safe to call
  /// from every mutation including those during startup hydration.
  static void _touch() => WidgetSnapshotService.instance.requestUpdate();

  // --- Transactions ----------------------------------------------------------

  static Future<void> addTransaction(Transaction t) async {
    final normalized = TransactionNormalizer.normalize(t);
    await _db.transactionUpsertTransactionAndAccounts(normalized);
    data.transactions.insert(0, normalized);
    await recordQualifyingTransactionForBackupReminder(normalized);
    _touch();
  }

  static Future<void> replaceOrInsertTransaction(
    Transaction t, {
    required bool isUpdate,
  }) async {
    final idx = data.transactions.indexWhere((x) => x.id == t.id);
    final Transaction? prior = (isUpdate && idx >= 0) ? data.transactions[idx] : null;

    final normalized = TransactionNormalizer.normalize(
      t,
      isUpdate: isUpdate,
    );

    final additional = <Account>[];
    if (prior != null) {
      if (prior.fromAccount != null) additional.add(prior.fromAccount!);
      if (prior.toAccount != null) additional.add(prior.toAccount!);
    }

    await _db.transactionUpsertTransactionAndAccounts(
      normalized,
      additionalAccounts: additional,
    );
    if (idx >= 0) {
      data.transactions[idx] = normalized;
    } else {
      data.transactions.insert(0, normalized);
      await recordQualifyingTransactionForBackupReminder(normalized);
    }
    _touch();
  }

  static Future<void> removeTransaction(Transaction t) async {
    await _db.transactionDeleteTransactionAndUpsertAccounts(
      t.id,
      t.fromAccount,
      t.toAccount,
    );
    data.transactions.removeWhere((x) => x.id == t.id);
    _touch();
  }

  static Future<void> insertTransactionAt(int index, Transaction t) async {
    final normalized = TransactionNormalizer.normalize(t);
    await _db.transactionUpsertTransactionAndAccounts(normalized);
    final i = index.clamp(0, data.transactions.length);
    data.transactions.insert(i, normalized);
    _touch();
  }

  // --- Accounts --------------------------------------------------------------

  /// Next [Account.sortOrder] for a new or moved row in [g] (max existing + 1).
  static int nextSortOrderInGroup(AccountGroup g, {String? excludeAccountId}) {
    var max = -1;
    for (final x in data.accounts) {
      if (excludeAccountId != null && x.id == excludeAccountId) continue;
      if (x.group == g && x.sortOrder > max) max = x.sortOrder;
    }
    return max + 1;
  }

  static void _sortAccountsInMemory() {
    data.accounts.sort(compareAccountsStorageOrder);
  }

  /// Persists the account and, when [a.balance] is non-zero, inserts an
  /// opening-balance ledger row (from/to null) so verify-ledger replay matches.
  /// Account row and opening row land in one SQLite commit: a failure between
  /// two commits used to leave the account at zero with the entered balance
  /// silently lost.
  static Future<void> addAccount(Account a) async {
    if (!data.accounts.contains(a)) {
      a.sortOrder = nextSortOrderInGroup(a.group);
    }
    final opening = a.balance;
    a.balance = 0;

    Transaction? openingTx;
    if (opening.abs() >= 1e-10) {
      // Builds the row and moves [a.balance] to [opening]; persisted below.
      await applyLedgerBalanceCorrection(
        account: a,
        previousBookBalance: 0,
        newBookBalance: opening,
        description: '__opening_balance__',
        persistTransaction: (t) async => openingTx = t,
      );
    }

    if (openingTx == null) {
      await _db.upsertAccount(a);
    } else {
      final normalized = TransactionNormalizer.normalize(openingTx!);
      // Upserts the account (with its final balance) and the opening row
      // together.
      await _db.transactionUpsertTransactionAndAccounts(normalized);
      data.transactions.insert(0, normalized);
      await recordQualifyingTransactionForBackupReminder(normalized);
    }
    if (!data.accounts.contains(a)) {
      data.accounts.add(a);
    }
    _sortAccountsInMemory();
    _touch();
  }

  /// Persists current field values on an existing in-memory [Account] (same id).
  static Future<void> persistAccountFields(Account a) async {
    await _db.upsertAccount(a);
    _sortAccountsInMemory();
    _touch();
  }

  /// Persists [sortOrder] for each account (callers must set [Account.sortOrder]).
  static Future<void> persistAccountOrders(List<Account> accounts) async {
    await _db.batchUpsertAccounts(accounts);
    _sortAccountsInMemory();
    _touch();
  }

  static Future<void> removeAccount(Account a) async {
    data.accounts.removeWhere((x) => x.id == a.id);
    await _db.deleteAccountRow(a.id);
    _touch();
  }

  // --- Planned ---------------------------------------------------------------

  static Future<void> addPlanned(PlannedTransaction pt) async {
    final normalized = PlannedNormalizer.normalize(pt);
    data.plannedTransactions.add(normalized);
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    await _db.upsertPlanned(normalized);
    PlannedReminderService.instance.resync();
    _touch();
  }

  static Future<void> removePlanned(PlannedTransaction pt) async {
    data.plannedTransactions.removeWhere((x) => x.id == pt.id);
    await _db.deletePlannedRow(pt.id);
    PlannedReminderService.instance.resync();
    _touch();
  }

  /// Replaces [oldPt] with [newPt] (same or different id) in one SQLite
  /// commit. Used by edit, skip-occurrence and its undo.
  static Future<void> replacePlanned(
    PlannedTransaction oldPt,
    PlannedTransaction newPt,
  ) async {
    final normalized = PlannedNormalizer.normalize(newPt);
    await _db.transactionReplacePlanned(
      oldId: oldPt.id,
      replacement: normalized,
    );
    final idx = data.plannedTransactions.indexWhere((t) => t.id == oldPt.id);
    if (idx >= 0) {
      data.plannedTransactions[idx] = normalized;
    } else {
      data.plannedTransactions.add(normalized);
    }
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    PlannedReminderService.instance.resync();
    _touch();
  }

  /// Confirms [planned] in one SQLite commit: posts [realized] (whose account
  /// balances the caller has already adjusted, as for [addTransaction]),
  /// removes the planned row and inserts [next] when the schedule repeats.
  static Future<void> realizePlanned({
    required PlannedTransaction planned,
    required Transaction realized,
    PlannedTransaction? next,
  }) async {
    final normalizedTx = TransactionNormalizer.normalize(realized);
    final normalizedNext = next == null ? null : PlannedNormalizer.normalize(next);
    await _db.transactionRealizePlanned(
      realized: normalizedTx,
      plannedId: planned.id,
      nextPlanned: normalizedNext,
    );
    data.transactions.insert(0, normalizedTx);
    data.plannedTransactions.removeWhere((x) => x.id == planned.id);
    if (normalizedNext != null) {
      data.plannedTransactions.add(normalizedNext);
      data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    }
    await recordQualifyingTransactionForBackupReminder(normalizedTx);
    PlannedReminderService.instance.resync();
    _touch();
  }

  /// Removes planned rows referencing [account] from memory and DB.
  static Future<void> removePlannedReferencingAccount(Account account) async {
    await _db.deletePlannedForAccountId(account.id);
    data.plannedTransactions.removeWhere((p) =>
        p.fromAccount == account ||
        p.toAccount == account ||
        (p.fromAccountId ?? p.fromAccount?.id) == account.id ||
        (p.toAccountId ?? p.toAccount?.id) == account.id);
    PlannedReminderService.instance.resync();
    _touch();
  }

  // --- Categories ------------------------------------------------------------

  /// True when [name] already exists in the income/expense list,
  /// case-insensitively. [exclude] skips one entry (the item being renamed).
  static bool categoryNameExists(
    String name, {
    required bool income,
    String? exclude,
  }) {
    final list = income ? data.incomeCategories : data.expenseCategories;
    final lower = name.toLowerCase();
    return list.any((c) => c != exclude && c.toLowerCase() == lower);
  }

  static Future<void> addCategory(String name, {required bool income}) async {
    final list = income ? data.incomeCategories : data.expenseCategories;
    // No duplicate rows: a second add of the same name would create a second
    // DB row that exports/imports as a duplicate.
    if (categoryNameExists(name, income: income)) return;
    final kind = income ? 'income' : 'expense';
    await _db.insertCategory(name: name, kind: kind);
    list.add(name);
  }

  /// How many transactions + planned transactions currently use [name].
  static Future<int> categoryUsageCount(
    String name, {
    required bool income,
  }) =>
      _db.countCategoryUsage(name, income ? 'income' : 'expense');

  /// Renames a category and relabels its transactions / planned transactions
  /// (same kind only) in one SQLite commit, then mirrors the change in memory.
  /// Callers must validate duplicates via [categoryNameExists] first.
  static Future<void> renameCategory(
    String oldName,
    String newName, {
    required bool income,
  }) async {
    if (oldName == newName) return;
    final kind = income ? 'income' : 'expense';
    await _db.renameCategoryEverywhere(
      oldName: oldName,
      newName: newName,
      kind: kind,
    );

    final list = income ? data.incomeCategories : data.expenseCategories;
    final i = list.indexOf(oldName);
    if (i >= 0) list[i] = newName;

    final wanted = income ? CategoryList.income : CategoryList.expense;
    bool matches(String? category, TxType? t) =>
        category == oldName && t != null && categoryListFor(t) == wanted;
    for (final t in data.transactions) {
      if (matches(t.category, t.txType)) t.category = newName;
    }
    for (final p in data.plannedTransactions) {
      if (matches(p.category, p.txType)) p.category = newName;
    }
    _touch();
  }

  // --- Selective clear -------------------------------------------------------

  /// Permanently clears the selected data categories.
  ///
  /// If [accounts] is true, transactions and planned are always cleared too
  /// (they cannot exist meaningfully without their account references).
  static Future<void> clearSelectiveData({
    bool transactions = false,
    bool planned = false,
    bool accounts = false,
    bool categories = false,
  }) async {
    if (accounts) {
      await _db.deleteAllLedgerData();
      data.transactions.clear();
      data.plannedTransactions.clear();
      data.accounts.clear();
    } else {
      if (transactions) {
        await _db.deleteAllTransactionsAndZeroBalances();
        for (final a in data.accounts) {
          a.balance = 0;
        }
        data.transactions.clear();
      }
      if (planned) {
        await _db.deleteAllPlanned();
        data.plannedTransactions.clear();
      }
    }

    if (accounts || planned) {
      PlannedReminderService.instance.resync();
    }

    if (accounts || transactions) {
      await resetBackupExportReminderState();
    }

    if (categories) {
      await _db.resetCategoriesToDefaults();
      final rows = await _db.loadCategoryRows();
      data.incomeCategories.clear();
      data.expenseCategories.clear();
      for (final c in rows) {
        if (c.kind == 'income') {
          data.incomeCategories.add(c.name);
        } else {
          data.expenseCategories.add(c.name);
        }
      }
    }

    _touch();
  }

  static Future<void> removeCategory(String name, {required bool income}) async {
    final kind = income ? 'income' : 'expense';
    await _db.deleteCategoryByNameAndKind(name, kind);
    if (income) {
      data.incomeCategories.remove(name);
    } else {
      data.expenseCategories.remove(name);
    }
  }
}
