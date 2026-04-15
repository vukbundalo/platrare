import 'package:flutter/material.dart';

import '../data/app_data.dart' as data;
import '../data/ledger_verify.dart';
import '../l10n/app_localizations.dart';
import '../utils/account_display.dart';

String _fmtBalance(double x) => x.toStringAsFixed(2);

/// Scrollable body: all-match message or mismatch list (same copy as Settings).
Widget buildLedgerVerifyResultBody(
  AppLocalizations l10n,
  List<LedgerMismatch> mismatches,
) {
  if (mismatches.isEmpty) {
    return Text(l10n.ledgerVerifyAllMatch);
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        l10n.ledgerVerifyMismatchesTitle,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      ...mismatches.map((m) {
        var name = m.accountId;
        for (final a in data.accounts) {
          if (a.id == m.accountId) {
            name = accountDisplayName(a);
            break;
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            l10n.ledgerVerifyMismatchDetails(
              name,
              _fmtBalance(m.storedBalance),
              _fmtBalance(m.recomputedBalance),
              _fmtBalance(m.delta),
            ),
          ),
        );
      }),
    ],
  );
}

/// Settings → Data → Verify ledger (read-only, Close only).
Future<void> showLedgerVerifyReadOnlyDialog(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final mismatches = verifyLedger(
    accounts: data.accounts,
    transactions: data.transactions,
  );
  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.ledgerVerifyDialogTitle),
        content: SingleChildScrollView(
          child: buildLedgerVerifyResultBody(l10n, mismatches),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close),
          ),
        ],
      );
    },
  );
}

/// Shown before manual backup; `true` = continue to password/share flow.
Future<bool> showLedgerVerifyBeforeExportDialog(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final mismatches = verifyLedger(
    accounts: data.accounts,
    transactions: data.transactions,
  );
  if (!context.mounted) return false;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.backupExportLedgerVerifyTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.backupExportLedgerVerifyInfo),
              const SizedBox(height: 16),
              buildLedgerVerifyResultBody(l10n, mismatches),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.backupExportLedgerVerifyContinue),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
