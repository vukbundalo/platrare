import 'package:flutter/material.dart';

import '../data/app_data.dart' as data;
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
