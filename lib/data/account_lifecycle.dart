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

/// Case-insensitive trimmed name key for sorting and duplicate checks.
String normalizedAccountNameKey(String name) => name.trim().toLowerCase();

/// Case-insensitive identifier key; empty when [institution] is null/blank.
String normalizedAccountIdentifierKey(String? institution) {
  final t = institution?.trim() ?? '';
  return t.isEmpty ? '' : t.toLowerCase();
}

/// Compare two accounts for list ordering: name, then identifier.
int compareAccountsByIdentity(Account a, Account b) {
  final c = normalizedAccountNameKey(a.name)
      .compareTo(normalizedAccountNameKey(b.name));
  if (c != 0) return c;
  return normalizedAccountIdentifierKey(a.institution)
      .compareTo(normalizedAccountIdentifierKey(b.institution));
}

/// Storage / Review order: group, then [Account.sortOrder], then [Account.createdAt].
int compareAccountsStorageOrder(Account a, Account b) {
  final g = a.group.index.compareTo(b.group.index);
  if (g != 0) return g;
  final s = a.sortOrder.compareTo(b.sortOrder);
  if (s != 0) return s;
  return a.createdAt.compareTo(b.createdAt);
}

/// Whether another account already has the same [trimmedName] and [institution]
/// (case-insensitive; blank identifier matches only accounts with no identifier).
/// Pass [exceptAccountId] when editing so the current row is ignored.
/// Includes archived accounts in [accounts].
bool isAccountDuplicate(
  String trimmedName,
  String? institution,
  List<Account> accounts, {
  String? exceptAccountId,
}) {
  if (trimmedName.trim().isEmpty) return false;
  final nameKey = normalizedAccountNameKey(trimmedName);
  final idKey = normalizedAccountIdentifierKey(institution);
  for (final a in accounts) {
    if (exceptAccountId != null && a.id == exceptAccountId) continue;
    if (normalizedAccountNameKey(a.name) != nameKey) continue;
    if (normalizedAccountIdentifierKey(a.institution) != idKey) continue;
    return true;
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

bool canArchiveAccount(Account a) {
  if (!_nearZero(a.balance)) return false;
  // Overdraft applies only to personal accounts; ignore stored limit for others.
  if (a.group == AccountGroup.personal) {
    return _nearZero(a.overdraftLimit);
  }
  return true;
}
