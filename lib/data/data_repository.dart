import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'account_lifecycle.dart' show compareAccountsStorageOrder;
import 'app_data.dart' as data;
import 'backup_export_reminder_prefs.dart';
import 'balance_posting.dart';
import 'local/platrare_database.dart';
import 'planned_normalize.dart';
import 'transaction_normalize.dart';

/// Single entry point for mutating global lists and persisting to SQLite.
class DataRepository {
  DataRepository._();

  static PlatrareDatabase get _db => PlatrareDatabase.instance;

  // --- Transactions ----------------------------------------------------------

  static Future<void> addTransaction(Transaction t) async {
    final normalized = TransactionNormalizer.normalize(t);
    await _db.transactionUpsertTransactionAndAccounts(normalized);
    data.transactions.insert(0, normalized);
    await recordQualifyingTransactionForBackupReminder(normalized);
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
  }

  static Future<void> removeTransaction(Transaction t) async {
    await _db.transactionDeleteTransactionAndUpsertAccounts(
      t.id,
      t.fromAccount,
      t.toAccount,
    );
    data.transactions.removeWhere((x) => x.id == t.id);
  }

  static Future<void> insertTransactionAt(int index, Transaction t) async {
    final normalized = TransactionNormalizer.normalize(t);
    await _db.transactionUpsertTransactionAndAccounts(normalized);
    final i = index.clamp(0, data.transactions.length);
    data.transactions.insert(i, normalized);
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
  static Future<void> addAccount(Account a) async {
    if (!data.accounts.contains(a)) {
      a.sortOrder = nextSortOrderInGroup(a.group);
    }
    final opening = a.balance;
    if (opening.abs() < 1e-10) {
      await _db.upsertAccount(a);
      if (!data.accounts.contains(a)) {
        data.accounts.add(a);
      }
      _sortAccountsInMemory();
      return;
    }

    a.balance = 0;
    await _db.upsertAccount(a);
    if (!data.accounts.contains(a)) {
      data.accounts.add(a);
    }

    await applyLedgerBalanceCorrection(
      account: a,
      previousBookBalance: 0,
      newBookBalance: opening,
      description: '__opening_balance__',
      persistTransaction: addTransaction,
    );
    _sortAccountsInMemory();
  }

  /// Persists current field values on an existing in-memory [Account] (same id).
  static Future<void> persistAccountFields(Account a) async {
    await _db.upsertAccount(a);
    _sortAccountsInMemory();
  }

  /// Persists [sortOrder] for each account (callers must set [Account.sortOrder]).
  static Future<void> persistAccountOrders(List<Account> accounts) async {
    await _db.batchUpsertAccounts(accounts);
    _sortAccountsInMemory();
  }

  static Future<void> removeAccount(Account a) async {
    data.accounts.removeWhere((x) => x.id == a.id);
    await _db.deleteAccountRow(a.id);
  }

  // --- Planned ---------------------------------------------------------------

  static Future<void> addPlanned(PlannedTransaction pt) async {
    final normalized = PlannedNormalizer.normalize(pt);
    data.plannedTransactions.add(normalized);
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    await _db.upsertPlanned(normalized);
  }

  static Future<void> removePlanned(PlannedTransaction pt) async {
    data.plannedTransactions.removeWhere((x) => x.id == pt.id);
    await _db.deletePlannedRow(pt.id);
  }

  static Future<void> replacePlanned(
    PlannedTransaction oldPt,
    PlannedTransaction newPt,
  ) async {
    final normalized = PlannedNormalizer.normalize(newPt);
    final idx = data.plannedTransactions.indexWhere((t) => t.id == oldPt.id);
    if (idx >= 0) {
      data.plannedTransactions[idx] = normalized;
    } else {
      data.plannedTransactions.add(normalized);
    }
    if (oldPt.id != newPt.id) {
      await _db.deletePlannedRow(oldPt.id);
    }
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    await _db.upsertPlanned(normalized);
  }

  /// Removes planned rows referencing [account] from memory and DB.
  static Future<void> removePlannedReferencingAccount(Account account) async {
    await _db.deletePlannedForAccountId(account.id);
    data.plannedTransactions.removeWhere((p) =>
        p.fromAccount == account ||
        p.toAccount == account ||
        (p.fromAccountId ?? p.fromAccount?.id) == account.id ||
        (p.toAccountId ?? p.toAccount?.id) == account.id);
  }

  // --- Categories ------------------------------------------------------------

  static Future<void> addCategory(String name, {required bool income}) async {
    final kind = income ? 'income' : 'expense';
    await _db.insertCategory(name: name, kind: kind);
    if (income) {
      data.incomeCategories.add(name);
    } else {
      data.expenseCategories.add(name);
    }
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
        await _db.deleteAllTransactions();
        await _db.zeroAllAccountBalances();
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
