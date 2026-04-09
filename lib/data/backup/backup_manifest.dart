import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'backup_exceptions.dart';
import 'backup_format.dart';

class BackupFileEntry {
  const BackupFileEntry({required this.path, required this.sha256Hex});

  final String path;
  final String sha256Hex;

  static BackupFileEntry fromJson(Map<String, dynamic> j) {
    final p = j['path'] as String?;
    final h = j['sha256'] as String?;
    if (p == null || h == null) throw const BackupCorruptFileException();
    return BackupFileEntry(path: p, sha256Hex: h);
  }

  Map<String, dynamic> toJson() => {'path': path, 'sha256': sha256Hex};
}

class BackupManifest {
  const BackupManifest({
    required this.schemaVersion,
    required this.exportedAt,
    required this.appVersion,
    required this.accountsCount,
    required this.transactionsCount,
    required this.plannedTransactionsCount,
    required this.incomeCategoriesCount,
    required this.expenseCategoriesCount,
    required this.attachmentFilesCount,
    required this.files,
  });

  final int schemaVersion;
  final String exportedAt;
  final String appVersion;
  final int accountsCount;
  final int transactionsCount;
  final int plannedTransactionsCount;
  final int incomeCategoriesCount;
  final int expenseCategoriesCount;
  final int attachmentFilesCount;
  final List<BackupFileEntry> files;

  static BackupManifest parseJsonString(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        throw const BackupCorruptFileException();
      }
      return BackupManifest.fromJson(decoded);
    } catch (e) {
      if (e is BackupException) rethrow;
      throw const BackupCorruptFileException();
    }
  }

  factory BackupManifest.fromJson(Map<String, dynamic> j) {
    final sv = j['schemaVersion'];
    if (sv is! int) throw const BackupCorruptFileException();
    final exportedAt = j['exportedAt'] as String?;
    final appVersion = j['appVersion'] as String?;
    if (exportedAt == null || appVersion == null) {
      throw const BackupCorruptFileException();
    }
    final filesRaw = j['files'];
    if (filesRaw is! List) throw const BackupCorruptFileException();
    final files = filesRaw
        .map((e) => BackupFileEntry.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    return BackupManifest(
      schemaVersion: sv,
      exportedAt: exportedAt,
      appVersion: appVersion,
      accountsCount: (j['accountsCount'] as num?)?.toInt() ?? 0,
      transactionsCount: (j['transactionsCount'] as num?)?.toInt() ?? 0,
      plannedTransactionsCount:
          (j['plannedTransactionsCount'] as num?)?.toInt() ?? 0,
      incomeCategoriesCount: (j['incomeCategoriesCount'] as num?)?.toInt() ?? 0,
      expenseCategoriesCount:
          (j['expenseCategoriesCount'] as num?)?.toInt() ?? 0,
      attachmentFilesCount: (j['attachmentFilesCount'] as num?)?.toInt() ?? 0,
      files: files,
    );
  }

  String toJsonString() => const JsonEncoder.withIndent('  ').convert({
        'schemaVersion': schemaVersion,
        'exportedAt': exportedAt,
        'appVersion': appVersion,
        'accountsCount': accountsCount,
        'transactionsCount': transactionsCount,
        'plannedTransactionsCount': plannedTransactionsCount,
        'incomeCategoriesCount': incomeCategoriesCount,
        'expenseCategoriesCount': expenseCategoriesCount,
        'attachmentFilesCount': attachmentFilesCount,
        'files': files.map((e) => e.toJson()).toList(growable: false),
      });

  void assertMatchesInnerSchema() {
    if (schemaVersion > kInnerSchemaVersion) {
      throw BackupUnsupportedSchemaException(
        'Backup schema version is $schemaVersion; only up to '
        '$kInnerSchemaVersion is supported.',
      );
    }
  }
}

String sha256HexOfBytes(List<int> bytes) =>
    crypto.sha256.convert(bytes).toString();

/// Verifies every [BackupFileEntry] against bytes in [archive].
void verifyArchiveHashes(Archive archive, BackupManifest manifest) {
  for (final entry in manifest.files) {
    final name = entry.path.replaceAll('\\', '/').trim();
    final file = archive.findFile(name);
    if (file == null) {
      throw BackupCorruptFileException('Missing file in archive: $name');
    }
    final data = file.content as List<int>?;
    if (data == null) {
      throw BackupCorruptFileException('Could not read: $name');
    }
    final hex = sha256HexOfBytes(data);
    if (hex != entry.sha256Hex) {
      throw BackupChecksumMismatchException(
        'SHA-256 mismatch for $name',
      );
    }
  }
}
