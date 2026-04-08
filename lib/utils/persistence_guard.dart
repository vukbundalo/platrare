import 'package:flutter/material.dart';

import '../data/account_lifecycle.dart' show compareAccountsStorageOrder;
import '../data/app_data.dart' as data;
import '../data/data_repository.dart';
import '../data/local/platrare_database.dart';
import '../l10n/app_localizations.dart';
import '../models/account.dart';

/// After [PlatrareDatabase.loadIntoMemory], [Account] instances from before the
/// reload may be detached from [data.accounts]. Returns the current row or null.
Account? refreshedAccount(Account? account) {
  if (account == null) return null;
  for (final a in data.accounts) {
    if (a.id == account.id) return a;
  }
  return null;
}

/// Runs [op] against SQLite. On failure, reloads in-memory state from the DB
/// and shows a snackbar. Callers should `setState` / `onChanged` when `false`
/// is returned so lists and filters refresh.
Future<bool> guardPersist(BuildContext context, Future<void> Function() op) async {
  try {
    await op();
    return true;
  } catch (e, st) {
    assert(() {
      debugPrint('Persistence error: $e\n$st');
      return true;
    }());
    try {
      await PlatrareDatabase.instance.loadIntoMemory();
    } catch (e2, st2) {
      assert(() {
        debugPrint('Reload after persistence error failed: $e2\n$st2');
        return true;
      }());
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).persistenceErrorReloaded),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        ),
      );
    }
    return false;
  }
}

/// Updates [Account.sortOrder] for accounts in [groupList] and sorts
/// [data.accounts] so the next frame matches the new order (same comparator as
/// SQLite load). Returns the reordered group list for persistence.
///
/// Call [setState] (or equivalent) immediately after this, **before** awaiting
/// persistence, so [SliverReorderableList] does not briefly rebuild from stale
/// list order.
List<Account> applyAccountGroupReorder(
  List<Account> groupList,
  int oldIndex,
  int newIndex,
) {
  if (newIndex > oldIndex) newIndex -= 1;
  final ordered = List<Account>.from(groupList);
  final item = ordered.removeAt(oldIndex);
  ordered.insert(newIndex, item);
  for (var i = 0; i < ordered.length; i++) {
    ordered[i].sortOrder = i;
  }
  data.accounts.sort(compareAccountsStorageOrder);
  return ordered;
}

/// Persists [sortOrder] for [ordered] (typically the return value of
/// [applyAccountGroupReorder]).
Future<bool> persistAccountOrdersAfterReorder(
  BuildContext context,
  List<Account> ordered,
) {
  return guardPersist(
    context,
    () => DataRepository.persistAccountOrders(ordered),
  );
}
