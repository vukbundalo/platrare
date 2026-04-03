import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'app_data.dart' as data;
import 'transaction_normalize.dart';

/// Single entry point for mutating global lists. Swap implementations later
/// for Drift-backed persistence without changing screen call sites.
class DataRepository {
  DataRepository._();

  // --- Transactions ----------------------------------------------------------

  static void addTransaction(Transaction t) {
    data.transactions.insert(0, TransactionNormalizer.normalize(t));
  }

  static void replaceOrInsertTransaction(Transaction t, {required bool isUpdate}) {
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
  }

  static void removeTransaction(Transaction t) {
    data.transactions.remove(t);
  }

  static void insertTransactionAt(int index, Transaction t) {
    final i = index.clamp(0, data.transactions.length);
    data.transactions.insert(i, TransactionNormalizer.normalize(t));
  }

  // --- Accounts --------------------------------------------------------------

  static void addAccount(Account a) {
    if (!data.accounts.contains(a)) {
      data.accounts.add(a);
    }
  }

  static void removeAccount(Account a) {
    data.accounts.remove(a);
  }

  // --- Planned ---------------------------------------------------------------

  static void addPlanned(PlannedTransaction pt) {
    data.plannedTransactions.add(pt);
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
  }

  static void removePlanned(PlannedTransaction pt) {
    data.plannedTransactions.remove(pt);
  }

  static void replacePlanned(PlannedTransaction oldPt, PlannedTransaction newPt) {
    final idx = data.plannedTransactions.indexWhere((t) => t.id == oldPt.id);
    if (idx >= 0) {
      data.plannedTransactions[idx] = newPt;
    } else {
      data.plannedTransactions.add(newPt);
    }
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
  }

  static void sortPlanned() {
    data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
  }
}
