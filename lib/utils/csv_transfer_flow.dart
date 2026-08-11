import 'package:flutter/material.dart';

import '../data/csv/csv_exceptions.dart';
import '../data/csv/csv_export.dart';
import '../data/csv/csv_import.dart';
import '../data/user_settings.dart' as settings;
import '../l10n/app_localizations.dart';
import '../widgets/csv_import_preview_dialog.dart';

/// Share-sheet anchor for iPad popovers, matching `runManualBackupExportFlow`.
Rect _shareOrigin(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return Rect.fromCenter(
    center: Offset(size.width / 2, size.height - 120),
    width: 200,
    height: 56,
  );
}

/// Exports the ledger as CSV and opens the share sheet.
Future<void> runCsvExportFlow({
  required BuildContext context,
  required AppLocalizations l10n,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final origin = _shareOrigin(context);
  try {
    await CsvExport.shareTransactionsCsv(sharePositionOrigin: origin);
  } catch (e) {
    debugPrint('[CSV:Export] Failed: $e');
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsCsvExportFailed)),
    );
  }
}

/// Shares the example file users paste their old data into.
Future<void> runCsvTemplateFlow({
  required BuildContext context,
  required AppLocalizations l10n,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final origin = _shareOrigin(context);
  try {
    await CsvExport.shareTemplateCsv(
      instructionLines: [
        l10n.csvTemplateInstruction1,
        l10n.csvTemplateInstruction2,
        l10n.csvTemplateInstruction3,
        l10n.csvTemplateInstruction4,
      ],
      currencyCode: settings.baseCurrency,
      sharePositionOrigin: origin,
    );
  } catch (e) {
    debugPrint('[CSV:Template] Failed: $e');
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsCsvExportFailed)),
    );
  }
}

String _importErrorMessage(Object error, AppLocalizations l10n) =>
    switch (error) {
      CsvNoRecognisedColumnsException() => l10n.csvImportFailedNoColumns,
      CsvMissingRequiredColumnException(:final column) =>
        l10n.csvImportFailedMissingColumn(column),
      CsvEmptyException() => l10n.csvImportFailedEmpty,
      CsvTooManyRowsException(:final rows, :final maxRows) =>
        l10n.csvImportFailedTooManyRows(rows, maxRows),
      _ => l10n.csvImportFailed,
    };

/// Picks a CSV, previews what it will do, then appends it. Returns true when
/// rows were written.
///
/// No destructive confirmation step: the import only ever adds.
Future<bool> runCsvImportFlow({
  required BuildContext context,
  required AppLocalizations l10n,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  final bytes = await CsvImport.pickCsvBytes();
  if (bytes == null || !context.mounted) return false;

  final CsvImportPlan initialPlan;
  try {
    initialPlan = CsvImport.prepare(bytes);
  } catch (e) {
    debugPrint('[CSV:Import] Prepare failed: $e');
    messenger.showSnackBar(
      SnackBar(content: Text(_importErrorMessage(e, l10n))),
    );
    return false;
  }

  if (!context.mounted) return false;
  final confirmed = await showDialog<CsvImportPlan>(
    context: context,
    builder: (_) => CsvImportPreviewDialog(
      bytes: bytes,
      initialPlan: initialPlan,
      l10n: l10n,
    ),
  );
  if (confirmed == null || !context.mounted) return false;

  try {
    final result = await CsvImport.apply(confirmed);
    // Deferred so it does not compete with the dialog route teardown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.csvImportDone(result.imported))),
      );
    });
    return result.imported > 0;
  } catch (e) {
    debugPrint('[CSV:Import] Apply failed: $e');
    messenger.showSnackBar(SnackBar(content: Text(l10n.csvImportFailed)));
    return false;
  }
}
