import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'app_data.dart' as data;
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
    data.transactions.insert(0, normalized);
    await _db.upsertTransaction(normalized);
    if (normalized.fromAccount != null) {
      await _db.upsertAccount(normalized.fromAccount!);
    }
    if (normalized.toAccount != null) {
      await _db.upsertAccount(normalized.toAccount!);
    }
  }

  static Future<void> replaceOrInsertTransaction(
    Transaction t, {
    required bool isUpdate,
  }) async {
    final normalized = TransactionNormalizer.normalize(
      t,
      isUpdate: isUpdate,
    );
    final idx = data.transactions.indexWhere((x) => x.id == normalized.id);
    if (idx >= 0) {
      data.transactions[idx] = normalized;
    } else {
      data.transactions.insert(0, normalized);
    }
    await _db.upsertTransaction(normalized);
    if (normalized.fromAccount != null) {
      await _db.upsertAccount(normalized.fromAccount!);
    }
    if (normalized.toAccount != null) {
      await _db.upsertAccount(normalized.toAccount!);
    }
  }

  static Future<void> removeTransaction(Transaction t) async {
    data.transactions.removeWhere((x) => x.id == t.id);
    await _db.deleteTransactionRow(t.id);
    if (t.fromAccount != null) await _db.upsertAccount(t.fromAccount!);
    if (t.toAccount != null) await _db.upsertAccount(t.toAccount!);
  }

  static Future<void> insertTransactionAt(int index, Transaction t) async {
    final normalized = TransactionNormalizer.normalize(t);
    final i = index.clamp(0, data.transactions.length);
    data.transactions.insert(i, normalized);
    await _db.upsertTransaction(normalized);
    if (normalized.fromAccount != null) {
      await _db.upsertAccount(normalized.fromAccount!);
    }
    if (normalized.toAccount != null) {
      await _db.upsertAccount(normalized.toAccount!);
    }
  }

  // --- Accounts --------------------------------------------------------------

  static Future<void> addAccount(Account a) async {
    if (!data.accounts.contains(a)) {
      data.accounts.add(a);
    }
    await _db.upsertAccount(a);
  }

  /// Persists current field values on an existing in-memory [Account] (same id).
  static Future<void> persistAccountFields(Account a) async {
    await _db.upsertAccount(a);
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
