import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// "Discard changes?" confirmation shared by every editor form.
/// Resolves true when the user chose to discard.
Future<bool> confirmDiscardChanges(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      final cs = Theme.of(ctx).colorScheme;
      return AlertDialog(
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            child: Text(l10n.discard),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
