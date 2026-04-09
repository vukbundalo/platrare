import 'backup_manifest.dart';

/// Summary for import preview dialog (from manifest + optional parsed date).
class BackupPreview {
  const BackupPreview({
    required this.schemaVersion,
    required this.exportedAtIso,
    required this.appVersion,
    required this.accountsCount,
    required this.transactionsCount,
    required this.plannedTransactionsCount,
    required this.incomeCategoriesCount,
    required this.expenseCategoriesCount,
    required this.attachmentFilesCount,
  });

  factory BackupPreview.fromManifest(BackupManifest m) {
    return BackupPreview(
      schemaVersion: m.schemaVersion,
      exportedAtIso: m.exportedAt,
      appVersion: m.appVersion,
      accountsCount: m.accountsCount,
      transactionsCount: m.transactionsCount,
      plannedTransactionsCount: m.plannedTransactionsCount,
      incomeCategoriesCount: m.incomeCategoriesCount,
      expenseCategoriesCount: m.expenseCategoriesCount,
      attachmentFilesCount: m.attachmentFilesCount,
    );
  }

  final int schemaVersion;
  final String exportedAtIso;
  final String appVersion;
  final int accountsCount;
  final int transactionsCount;
  final int plannedTransactionsCount;
  final int incomeCategoriesCount;
  final int expenseCategoriesCount;
  final int attachmentFilesCount;
}
