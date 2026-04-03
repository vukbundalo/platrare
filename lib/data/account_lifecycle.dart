import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';

const double _kLifecycleEpsilon = 0.005;

/// Returned from [AccountFormSheet] when the user deletes an account.
final class AccountFormSheetDeleted {
  const AccountFormSheetDeleted();
}

/// Singleton marker for bottom-sheet delete completion.
const AccountFormSheetDeleted kAccountFormSheetDeleted = AccountFormSheetDeleted();

List<Account> activeAccounts(Iterable<Account> all) =>
    all.where((a) => !a.archived).toList();

/// Whether [trimmedName] is already used by another account (case-insensitive).
/// Pass [exceptAccountId] when editing so the current account is ignored.
/// Includes archived accounts in [accounts].
bool isAccountNameTaken(
  String trimmedName,
  List<Account> accounts, {
  String? exceptAccountId,
}) {
  if (trimmedName.isEmpty) return false;
  final key = trimmedName.toLowerCase();
  for (final a in accounts) {
    if (exceptAccountId != null && a.id == exceptAccountId) continue;
    if (a.name.trim().toLowerCase() == key) return true;
  }
  return false;
}

bool _plannedReferencesAccount(PlannedTransaction p, Account a) {
  if (p.fromAccount == a || p.toAccount == a) return true;
  final fid = p.fromAccountId ?? p.fromAccount?.id;
  final tid = p.toAccountId ?? p.toAccount?.id;
  return fid == a.id || tid == a.id;
}

int plannedReferenceCount(Account a, List<PlannedTransaction> planned) {
  var n = 0;
  for (final p in planned) {
    if (_plannedReferencesAccount(p, a)) n++;
  }
  return n;
}

bool _nearZero(double v) => v.abs() < _kLifecycleEpsilon;

bool accountReferencedInTrack(Account a, List<Transaction> txs) {
  for (final t in txs) {
    if (t.fromAccount == a || t.toAccount == a) return true;
  }
  return false;
}

bool accountReferencedInPlanned(Account a, List<PlannedTransaction> planned) {
  for (final p in planned) {
    if (_plannedReferencesAccount(p, a)) return true;
  }
  return false;
}

bool canArchiveAccount(Account a) =>
    _nearZero(a.balance) && _nearZero(a.overdraftLimit);
