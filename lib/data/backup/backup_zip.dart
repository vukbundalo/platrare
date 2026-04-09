import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'backup_format.dart';
import 'backup_manifest.dart';

/// Builds the canonical inner ZIP: [kManifestFileName], [kDataJsonFileName], [kAttachmentsFolder]/*.
Uint8List buildInnerZipBytes({
  required String dataJson,
  required Map<String, Uint8List> relativeAttachmentBytes,
  required String exportedAtIso,
  required String appVersion,
  required int accountsCount,
  required int transactionsCount,
  required int plannedTransactionsCount,
  required int incomeCategoriesCount,
  required int expenseCategoriesCount,
}) {
  final dataBytes = Uint8List.fromList(utf8.encode(dataJson));

  final dataEntry = BackupFileEntry(
    path: kDataJsonFileName,
    sha256Hex: sha256HexOfBytes(dataBytes),
  );

  final attEntries = <BackupFileEntry>[];
  final sortedPaths = relativeAttachmentBytes.keys.toList()..sort();
  for (final path in sortedPaths) {
    final bytes = relativeAttachmentBytes[path]!;
    attEntries.add(
      BackupFileEntry(path: path, sha256Hex: sha256HexOfBytes(bytes)),
    );
  }

  final manifest = BackupManifest(
    schemaVersion: kInnerSchemaVersion,
    exportedAt: exportedAtIso,
    appVersion: appVersion,
    accountsCount: accountsCount,
    transactionsCount: transactionsCount,
    plannedTransactionsCount: plannedTransactionsCount,
    incomeCategoriesCount: incomeCategoriesCount,
    expenseCategoriesCount: expenseCategoriesCount,
    attachmentFilesCount: attEntries.length,
    files: [dataEntry, ...attEntries],
  );

  final manifestBytes =
      Uint8List.fromList(utf8.encode(manifest.toJsonString()));

  final archive = Archive();
  archive.addFile(ArchiveFile.bytes(kManifestFileName, manifestBytes));
  archive.addFile(ArchiveFile.bytes(kDataJsonFileName, dataBytes));
  for (final path in sortedPaths) {
    final b = relativeAttachmentBytes[path]!;
    archive.addFile(ArchiveFile.bytes(path, b));
  }

  return Uint8List.fromList(ZipEncoder().encode(archive));
}
