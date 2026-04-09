import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:platrare/data/backup/backup_crypto.dart';
import 'package:platrare/data/backup/backup_format.dart';
import 'package:platrare/data/backup/backup_zip.dart';
import 'package:platrare/data/data_transfer.dart';

/// Minimal fake so [DataTransfer.prepareImport] can materialize attachment paths.
final class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this._root);
  final String _root;

  @override
  Future<String?> getApplicationDocumentsPath() async => _root;

  @override
  Future<String?> getTemporaryPath() async => _root;
}

String _minimalDataJson() => '''
{
  "version": 1,
  "exportedAt": "2026-04-08T12:00:00.000Z",
  "attachmentLayout": "$kAttachmentLayoutBundled",
  "preferences": { "baseCurrency": "EUR", "secondaryCurrency": "USD" },
  "accounts": [],
  "transactions": [],
  "plannedTransactions": [],
  "categories": { "income": [], "expense": [] }
}
''';

Uint8List _minimalInnerZip() {
  return buildInnerZipBytes(
    dataJson: _minimalDataJson(),
    relativeAttachmentBytes: {},
    exportedAtIso: '2026-04-08T12:00:00.000Z',
    appVersion: '1.0.0+1',
    accountsCount: 0,
    transactionsCount: 0,
    plannedTransactionsCount: 0,
    incomeCategoriesCount: 0,
    expenseCategoriesCount: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String tempDocPath;
  late PathProviderPlatform originalPathProvider;

  setUpAll(() async {
    tempDocPath =
        Directory.systemTemp.createTempSync('platrare_backup_test').path;
    originalPathProvider = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _TestPathProvider(tempDocPath);
  });

  tearDownAll(() {
    PathProviderPlatform.instance = originalPathProvider;
  });

  test('plain inner zip round-trips through DataTransfer.prepareImport', () async {
    final inner = _minimalInnerZip();
    final prepared = await DataTransfer.prepareImport(inner);
    expect(prepared.data.accounts, isEmpty);
    expect(prepared.data.transactions, isEmpty);
    expect(prepared.data.plannedTransactions, isEmpty);
    expect(prepared.data.baseCurrency, 'EUR');
    expect(prepared.data.secondaryCurrency, 'USD');
    expect(prepared.preview.accountsCount, 0);
  });

  test('encrypted .platrare round-trips with password', () async {
    final inner = _minimalInnerZip();
    final encrypted = await encryptInnerZip(
      innerZip: inner,
      password: 'test-backup-password-99',
    );
    expect(looksLikeEncryptedPlatrare(encrypted), isTrue);

    final prepared = await DataTransfer.prepareImport(
      encrypted,
      password: 'test-backup-password-99',
    );
    expect(prepared.data.baseCurrency, 'EUR');
    expect(prepared.data.secondaryCurrency, 'USD');
  });

  test('encrypted backup rejects wrong password', () async {
    final inner = _minimalInnerZip();
    final encrypted = await encryptInnerZip(
      innerZip: inner,
      password: 'right-password',
    );
    await expectLater(
      DataTransfer.prepareImport(encrypted, password: 'wrong-password'),
      throwsA(isA<BackupWrongPasswordException>()),
    );
  });
}
