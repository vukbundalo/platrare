import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'account_lifecycle.dart' show compareAccountsStorageOrder;
import 'app_data.dart' as data;
import 'backup/backup_crypto.dart';
import 'backup/backup_exceptions.dart';
import 'backup/backup_format.dart';
import 'backup/backup_manifest.dart';
import 'backup/backup_preview.dart';
import 'backup/backup_zip.dart';
import 'currency_prefs.dart';
import 'local/platrare_database.dart';
import 'user_settings.dart' as settings;

export 'backup/backup_exceptions.dart';
export 'backup/backup_format.dart'
    show kAttachmentsFolder, looksLikeEncryptedPlatrare;
export 'backup/backup_preview.dart' show BackupPreview;

/// Logical JSON inside [kDataJsonFileName] (inner ZIP).
const int _dataJsonVersion = 1;

class BackupData {
  final List<Account> accounts;
  final List<Transaction> transactions;
  final List<PlannedTransaction> plannedTransactions;
  final List<String> incomeCategories;
  final List<String> expenseCategories;
  final String baseCurrency;
  final String secondaryCurrency;

  const BackupData({
    required this.accounts,
    required this.transactions,
    required this.plannedTransactions,
    required this.incomeCategories,
    required this.expenseCategories,
    required this.baseCurrency,
    required this.secondaryCurrency,
  });
}

/// Result of a successful import parse (preview + data for apply).
class BackupImportPrepared {
  const BackupImportPrepared({
    required this.preview,
    required this.data,
  });

  final BackupPreview preview;
  final BackupData data;
}

class DataTransfer {
  DataTransfer._();

  static String defaultExportFileName({required bool encrypt}) {
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return encrypt
        ? 'platrare_backup_$stamp.platrare'
        : 'platrare_backup_$stamp.zip';
  }

  /// Builds inner ZIP, optionally encrypts, then writes via file picker.
  static Future<String?> exportToPickedPath({
    required bool encrypt,
    String? password,
  }) async {
    if (encrypt) {
      final p = password?.trim();
      if (p == null || p.isEmpty) {
        throw ArgumentError('Password is required for encrypted export.');
      }
    }

    final inner = await _buildInnerZipBytes();
    final Uint8List outBytes;
    if (encrypt) {
      outBytes = await encryptInnerZip(
        innerZip: inner,
        password: password!.trim(),
      );
    } else {
      outBytes = inner;
    }

    final name = defaultExportFileName(encrypt: encrypt);

    if (Platform.isAndroid || Platform.isIOS) {
      return FilePicker.platform.saveFile(
        dialogTitle: 'Export backup',
        fileName: name,
        type: FileType.custom,
        allowedExtensions: [encrypt ? 'platrare' : 'zip'],
        bytes: outBytes,
      );
    }

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export backup',
      fileName: name,
      type: FileType.custom,
      allowedExtensions: [encrypt ? 'platrare' : 'zip'],
    );
    if (path == null) return null;

    var outPath = path;
    final suffix = encrypt ? '.platrare' : '.zip';
    if (!outPath.toLowerCase().endsWith(suffix)) {
      outPath = '$outPath$suffix';
    }
    await File(outPath).writeAsBytes(outBytes);
    return outPath;
  }

  static Future<Uint8List> _buildInnerZipBytes() async {
    final pathToArchive = await _buildAttachmentPathMap();
    final json = _encodeDataJson(attachmentPathMap: pathToArchive);
    final pkg = await PackageInfo.fromPlatform();
    final exportedAt = DateTime.now().toUtc().toIso8601String();

    final attBytes = <String, Uint8List>{};
    for (final e in pathToArchive.entries) {
      final file = File(e.key);
      if (!await file.exists()) continue;
      attBytes[e.value] = Uint8List.fromList(await file.readAsBytes());
    }

    return buildInnerZipBytes(
      dataJson: json,
      relativeAttachmentBytes: attBytes,
      exportedAtIso: exportedAt,
      appVersion: '${pkg.version}+${pkg.buildNumber}',
      accountsCount: data.accounts.length,
      transactionsCount: data.transactions.length,
      plannedTransactionsCount: data.plannedTransactions.length,
      incomeCategoriesCount: data.incomeCategories.length,
      expenseCategoriesCount: data.expenseCategories.length,
    );
  }

  /// Picks `.zip` or `.platrare`, reads bytes. Returns null if cancelled.
  static Future<Uint8List?> pickBackupFileBytes() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const ['zip', 'platrare'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final platformFile = result.files.single;
    Uint8List? bytes = platformFile.bytes;
    final path = platformFile.path;
    if (bytes == null && path != null) {
      bytes = await File(path).readAsBytes();
    }
    return bytes;
  }

  /// Unwraps encrypted/plain outer layer → inner ZIP, parses manifest, verifies
  /// hashes, decodes [BackupData]. Single pass.
  static Future<BackupImportPrepared> prepareImport(
    Uint8List raw, {
    String? password,
  }) async {
    final innerZip = await _unwrapToInnerZip(raw, password: password);
    final archive = ZipDecoder().decodeBytes(innerZip);
    try {
      final manifestFile = archive.findFile(kManifestFileName);
      if (manifestFile == null) {
        throw const BackupCorruptFileException('Missing manifest.json.');
      }
      final manifestBytes = manifestFile.readBytes();
      if (manifestBytes == null) {
        throw const BackupCorruptFileException('Could not read manifest.');
      }
      final manifest =
          BackupManifest.parseJsonString(utf8.decode(manifestBytes));
      manifest.assertMatchesInnerSchema();

      verifyArchiveHashes(archive, manifest);

      final dataFile = archive.findFile(kDataJsonFileName);
      if (dataFile == null) {
        throw const BackupCorruptFileException('Missing data.json.');
      }
      final dataBytes = dataFile.readBytes();
      if (dataBytes == null) {
        throw const BackupCorruptFileException('Could not read data.json.');
      }
      final backup = _decodeDataJson(utf8.decode(dataBytes));

      final attachmentBytes = <String, Uint8List>{};
      for (final f in archive.files) {
        if (!f.isFile) continue;
        if (!_isSafeBundledAttachmentPath(f.name)) continue;
        final b = f.readBytes();
        if (b != null) attachmentBytes[f.name] = b;
      }

      final materialized =
          await _materializeBundledAttachments(backup, attachmentBytes);
      final preview = BackupPreview.fromManifest(manifest);
      return BackupImportPrepared(preview: preview, data: materialized);
    } finally {
      await archive.clear();
    }
  }

  static Future<Uint8List> _unwrapToInnerZip(
    Uint8List raw, {
    String? password,
  }) async {
    if (looksLikeEncryptedPlatrare(raw)) {
      final p = password?.trim();
      if (p == null || p.isEmpty) {
        throw const BackupPasswordRequiredException();
      }
      return decryptToInnerZip(fileBytes: raw, password: p);
    }
    if (looksLikeZip(raw)) {
      return raw;
    }
    throw const BackupCorruptFileException('Not a Platrare backup file.');
  }

  /// Prevents zip-slip / absolute paths in archive entry names.
  static bool _isSafeBundledAttachmentPath(String name) {
    if (name.isEmpty) return false;
    final n = p.normalize(name.replaceAll('\\', '/'));
    if (p.isAbsolute(n) || n.startsWith('..')) return false;
    return n.startsWith('$kAttachmentsFolder/');
  }

  static Future<BackupData> _materializeBundledAttachments(
    BackupData backup,
    Map<String, Uint8List> bytesByPath,
  ) async {
    final destDir = await _attachmentsLibraryDir();

    Future<String?> materializePath(String ref) async {
      if (ref.startsWith('$kAttachmentsFolder/')) {
        final data = bytesByPath[ref];
        if (data == null) return null;
        final fileName =
            '${const Uuid().v4()}_${_sanitizeFileName(p.basename(ref))}';
        final out = File(p.join(destDir.path, fileName));
        await out.writeAsBytes(data);
        return out.path;
      }
      final f = File(ref);
      if (await f.exists()) return ref;
      return null;
    }

    final newTx = <Transaction>[];
    for (final t in backup.transactions) {
      final att = <String>[];
      for (final r in t.attachments) {
        final m = await materializePath(r);
        if (m != null) att.add(m);
      }
      newTx.add(_transactionWithAttachments(t, att));
    }

    final newPlanned = <PlannedTransaction>[];
    for (final pt in backup.plannedTransactions) {
      final att = <String>[];
      for (final r in pt.attachments) {
        final m = await materializePath(r);
        if (m != null) att.add(m);
      }
      newPlanned.add(_plannedWithAttachments(pt, att));
    }

    return BackupData(
      accounts: backup.accounts,
      transactions: newTx,
      plannedTransactions: newPlanned,
      incomeCategories: backup.incomeCategories,
      expenseCategories: backup.expenseCategories,
      baseCurrency: backup.baseCurrency,
      secondaryCurrency: backup.secondaryCurrency,
    );
  }

  static Future<Directory> _attachmentsLibraryDir() async {
    final root = await getApplicationDocumentsDirectory();
    final d = Directory(p.join(root.path, 'platrare_attachments'));
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  static Transaction _transactionWithAttachments(
    Transaction t,
    List<String> attachments,
  ) =>
      Transaction(
        id: t.id,
        nativeAmount: t.nativeAmount,
        currencyCode: t.currencyCode,
        baseAmount: t.baseAmount,
        exchangeRate: t.exchangeRate,
        destinationAmount: t.destinationAmount,
        fromAccount: t.fromAccount,
        toAccount: t.toAccount,
        category: t.category,
        description: t.description,
        date: t.date,
        txType: t.txType,
        attachments: attachments,
        createdAt: t.createdAt,
        updatedAt: t.updatedAt,
        fromAccountId: t.fromAccountId,
        toAccountId: t.toAccountId,
        fromSnapshotName: t.fromSnapshotName,
        fromSnapshotCurrency: t.fromSnapshotCurrency,
        toSnapshotName: t.toSnapshotName,
        toSnapshotCurrency: t.toSnapshotCurrency,
      );

  static PlannedTransaction _plannedWithAttachments(
    PlannedTransaction pt,
    List<String> attachments,
  ) =>
      PlannedTransaction(
        id: pt.id,
        nativeAmount: pt.nativeAmount,
        currencyCode: pt.currencyCode,
        destinationAmount: pt.destinationAmount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        fromAccountId: pt.fromAccountId,
        toAccountId: pt.toAccountId,
        category: pt.category,
        description: pt.description,
        date: pt.date,
        txType: pt.txType,
        repeatInterval: pt.repeatInterval,
        repeatEvery: pt.repeatEvery,
        repeatDayOfMonth: pt.repeatDayOfMonth,
        weekendAdjustment: pt.weekendAdjustment,
        repeatEndDate: pt.repeatEndDate,
        repeatEndAfter: pt.repeatEndAfter,
        repeatConfirmedCount: pt.repeatConfirmedCount,
        createdAt: pt.createdAt,
        updatedAt: pt.updatedAt,
        attachments: attachments,
      );

  static Future<void> applyImport(BackupData backup) async {
    await PlatrareDatabase.instance.replaceAllData(
      accounts: backup.accounts,
      transactions: backup.transactions,
      plannedTransactions: backup.plannedTransactions,
      incomeCategories: backup.incomeCategories,
      expenseCategories: backup.expenseCategories,
    );

    await PlatrareDatabase.instance.loadIntoMemory();
    settings.baseCurrency = backup.baseCurrency;
    settings.secondaryCurrency = backup.secondaryCurrency;
    await saveCurrencyPreferences();

    data.accounts.sort(compareAccountsStorageOrder);
  }

  /// Maps absolute on-disk paths → `attachments/NNN_name` (deduplicated).
  static Future<Map<String, String>> _buildAttachmentPathMap() async {
    final seen = <String>{};
    final paths = <String>[];
    for (final t in data.transactions) {
      for (final a in t.attachments) {
        if (seen.add(a)) paths.add(a);
      }
    }
    for (final pt in data.plannedTransactions) {
      for (final a in pt.attachments) {
        if (seen.add(a)) paths.add(a);
      }
    }
    paths.sort();

    final map = <String, String>{};
    var i = 0;
    for (final abs in paths) {
      final f = File(abs);
      if (!await f.exists()) continue;
      final safe = _sanitizeFileName(p.basename(abs));
      final rel = '$kAttachmentsFolder/${i.toString().padLeft(3, '0')}_$safe';
      map[abs] = rel;
      i++;
    }
    return map;
  }

  static String _sanitizeFileName(String name) {
    var s = name.replaceAll(RegExp(r'[\\/]+'), '_').trim();
    if (s.isEmpty) s = 'file';
    if (s.length > 120) s = s.substring(s.length - 120);
    return s;
  }

  static String _encodeDataJson({
    Map<String, String>? attachmentPathMap,
  }) {
    final payload = {
      'version': _dataJsonVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'attachmentLayout': kAttachmentLayoutBundled,
      'preferences': {
        'baseCurrency': settings.baseCurrency,
        'secondaryCurrency': settings.secondaryCurrency,
      },
      'accounts': data.accounts.map(_accountToJson).toList(growable: false),
      'transactions': data.transactions
          .map((t) => _transactionToJson(t, attachmentPathMap: attachmentPathMap))
          .toList(growable: false),
      'plannedTransactions': data.plannedTransactions
          .map((p) => _plannedToJson(p, attachmentPathMap: attachmentPathMap))
          .toList(growable: false),
      'categories': {
        'income': data.incomeCategories,
        'expense': data.expenseCategories,
      },
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  static BackupData _decodeDataJson(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup format.');
    }

    final version = decoded['version'];
    if (version is! int || version > _dataJsonVersion) {
      throw const FormatException('Unsupported backup version.');
    }

    final accountMap = <String, Account>{};
    final accountList = <Account>[];
    final accountsRaw = decoded['accounts'];
    if (accountsRaw is! List) {
      throw const FormatException('Backup is missing accounts.');
    }
    for (final raw in accountsRaw) {
      final account = _accountFromJson(raw);
      accountMap[account.id] = account;
      accountList.add(account);
    }

    final txRaw = decoded['transactions'];
    if (txRaw is! List) {
      throw const FormatException('Backup is missing transactions.');
    }
    final transactions = txRaw
        .map((raw) => _transactionFromJson(raw, accountMap))
        .toList(growable: false);

    final plannedRaw = decoded['plannedTransactions'];
    if (plannedRaw is! List) {
      throw const FormatException('Backup is missing planned transactions.');
    }
    final planned = plannedRaw
        .map((raw) => _plannedFromJson(raw, accountMap))
        .toList(growable: false);

    final categoriesRaw = decoded['categories'];
    if (categoriesRaw is! Map<String, dynamic>) {
      throw const FormatException('Backup is missing categories.');
    }
    final income = _stringList(categoriesRaw['income']);
    final expense = _stringList(categoriesRaw['expense']);

    final prefs = decoded['preferences'];
    final prefsMap = prefs is Map<String, dynamic> ? prefs : const {};
    final baseCurrency = _safeCurrency(
      prefsMap['baseCurrency'],
      fallback: settings.baseCurrency,
    );
    final secondaryCurrency = _safeCurrency(
      prefsMap['secondaryCurrency'],
      fallback: settings.secondaryCurrency,
    );

    return BackupData(
      accounts: accountList,
      transactions: transactions,
      plannedTransactions: planned,
      incomeCategories: income,
      expenseCategories: expense,
      baseCurrency: baseCurrency,
      secondaryCurrency: secondaryCurrency,
    );
  }

  static String _safeCurrency(Object? value, {required String fallback}) {
    if (value is String && settings.supportedCurrencies.contains(value)) {
      return value;
    }
    return fallback;
  }

  static List<String> _stringList(Object? raw) {
    if (raw is! List) return const [];
    return raw.whereType<String>().toList(growable: false);
  }

  static Map<String, dynamic> _accountToJson(Account a) => {
        'id': a.id,
        'name': a.name,
        'institution': a.institution,
        'group': a.group.name,
        'iconCodePoint': a.iconCodePoint,
        'colorArgb': a.colorArgb,
        'balance': a.balance,
        'currencyCode': a.currencyCode,
        'overdraftLimit': a.overdraftLimit,
        'archived': a.archived,
        'createdAt': a.createdAt.toIso8601String(),
        'updatedAt': a.updatedAt?.toIso8601String(),
        'sortOrder': a.sortOrder,
      };

  static Account _accountFromJson(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid account row in backup.');
    }
    return Account(
      id: raw['id'] as String?,
      name: raw['name'] as String? ?? '',
      institution: raw['institution'] as String?,
      group: _enumByName(AccountGroup.values, raw['group']) ??
          AccountGroup.personal,
      iconCodePoint: (raw['iconCodePoint'] as num?)?.toInt() ?? 0,
      colorArgb: (raw['colorArgb'] as num?)?.toInt(),
      balance: (raw['balance'] as num?)?.toDouble() ?? 0,
      currencyCode: raw['currencyCode'] as String? ?? 'BAM',
      overdraftLimit: (raw['overdraftLimit'] as num?)?.toDouble() ?? 0,
      archived: raw['archived'] as bool? ?? false,
      createdAt: _parseDate(raw['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(raw['updatedAt']),
      sortOrder: (raw['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  static Map<String, dynamic> _transactionToJson(
    Transaction t, {
    Map<String, String>? attachmentPathMap,
  }) {
    List<String> attachments;
    if (attachmentPathMap == null) {
      attachments = List<String>.from(t.attachments);
    } else {
      attachments = t.attachments
          .where((p) => attachmentPathMap.containsKey(p))
          .map((p) => attachmentPathMap[p]!)
          .toList(growable: false);
    }
    return {
      'id': t.id,
      'nativeAmount': t.nativeAmount,
      'currencyCode': t.currencyCode,
      'baseAmount': t.baseAmount,
      'exchangeRate': t.exchangeRate,
      'destinationAmount': t.destinationAmount,
      'fromAccountId': t.fromAccountId,
      'toAccountId': t.toAccountId,
      'category': t.category,
      'description': t.description,
      'date': t.date.toIso8601String(),
      'txType': t.txType?.name,
      'attachments': attachments,
      'createdAt': t.createdAt.toIso8601String(),
      'updatedAt': t.updatedAt?.toIso8601String(),
      'fromSnapshotName': t.fromSnapshotName,
      'fromSnapshotCurrency': t.fromSnapshotCurrency,
      'toSnapshotName': t.toSnapshotName,
      'toSnapshotCurrency': t.toSnapshotCurrency,
    };
  }

  static Transaction _transactionFromJson(
    Object? raw,
    Map<String, Account> accountsById,
  ) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid transaction row in backup.');
    }
    final fromId = raw['fromAccountId'] as String?;
    final toId = raw['toAccountId'] as String?;
    return Transaction(
      id: raw['id'] as String?,
      nativeAmount: (raw['nativeAmount'] as num?)?.toDouble(),
      currencyCode: raw['currencyCode'] as String?,
      baseAmount: (raw['baseAmount'] as num?)?.toDouble(),
      exchangeRate: (raw['exchangeRate'] as num?)?.toDouble(),
      destinationAmount: (raw['destinationAmount'] as num?)?.toDouble(),
      fromAccount: fromId != null ? accountsById[fromId] : null,
      toAccount: toId != null ? accountsById[toId] : null,
      fromAccountId: fromId,
      toAccountId: toId,
      category: raw['category'] as String?,
      description: raw['description'] as String?,
      date: _parseDate(raw['date']) ?? DateTime.now(),
      txType: _enumByName(TxType.values, raw['txType']),
      attachments: _stringList(raw['attachments']),
      createdAt: _parseDate(raw['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(raw['updatedAt']),
      fromSnapshotName: raw['fromSnapshotName'] as String?,
      fromSnapshotCurrency: raw['fromSnapshotCurrency'] as String?,
      toSnapshotName: raw['toSnapshotName'] as String?,
      toSnapshotCurrency: raw['toSnapshotCurrency'] as String?,
    );
  }

  static Map<String, dynamic> _plannedToJson(
    PlannedTransaction p, {
    Map<String, String>? attachmentPathMap,
  }) {
    List<String> attachments;
    if (attachmentPathMap == null) {
      attachments = List<String>.from(p.attachments);
    } else {
      attachments = p.attachments
          .where((path) => attachmentPathMap.containsKey(path))
          .map((path) => attachmentPathMap[path]!)
          .toList(growable: false);
    }
    return {
      'id': p.id,
      'nativeAmount': p.nativeAmount,
      'currencyCode': p.currencyCode,
      'destinationAmount': p.destinationAmount,
      'fromAccountId': p.fromAccountId ?? p.fromAccount?.id,
      'toAccountId': p.toAccountId ?? p.toAccount?.id,
      'category': p.category,
      'description': p.description,
      'date': p.date.toIso8601String(),
      'txType': p.txType?.name,
      'repeatInterval': p.repeatInterval.name,
      'repeatEvery': p.repeatEvery,
      'repeatDayOfMonth': p.repeatDayOfMonth,
      'weekendAdjustment': p.weekendAdjustment.name,
      'repeatEndDate': p.repeatEndDate?.toIso8601String(),
      'repeatEndAfter': p.repeatEndAfter,
      'repeatConfirmedCount': p.repeatConfirmedCount,
      'createdAt': p.createdAt.toIso8601String(),
      'updatedAt': p.updatedAt?.toIso8601String(),
      'attachments': attachments,
    };
  }

  static PlannedTransaction _plannedFromJson(
    Object? raw,
    Map<String, Account> accountsById,
  ) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid planned transaction row in backup.');
    }
    final fromId = raw['fromAccountId'] as String?;
    final toId = raw['toAccountId'] as String?;
    return PlannedTransaction(
      id: raw['id'] as String?,
      nativeAmount: (raw['nativeAmount'] as num?)?.toDouble(),
      currencyCode: raw['currencyCode'] as String?,
      destinationAmount: (raw['destinationAmount'] as num?)?.toDouble(),
      fromAccount: fromId != null ? accountsById[fromId] : null,
      toAccount: toId != null ? accountsById[toId] : null,
      fromAccountId: fromId,
      toAccountId: toId,
      category: raw['category'] as String?,
      description: raw['description'] as String?,
      date: _parseDate(raw['date']) ?? DateTime.now(),
      txType: _enumByName(TxType.values, raw['txType']),
      repeatInterval: _enumByName(RepeatInterval.values, raw['repeatInterval']) ??
          RepeatInterval.none,
      repeatEvery: (raw['repeatEvery'] as num?)?.toInt() ?? 1,
      repeatDayOfMonth: (raw['repeatDayOfMonth'] as num?)?.toInt(),
      weekendAdjustment:
          _enumByName(WeekendAdjustment.values, raw['weekendAdjustment']) ??
              WeekendAdjustment.ignore,
      repeatEndDate: _parseDate(raw['repeatEndDate']),
      repeatEndAfter: (raw['repeatEndAfter'] as num?)?.toInt(),
      repeatConfirmedCount: (raw['repeatConfirmedCount'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(raw['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(raw['updatedAt']),
      attachments: _stringList(raw['attachments']),
    );
  }

  static T? _enumByName<T extends Enum>(List<T> values, Object? rawName) {
    if (rawName is! String) return null;
    for (final value in values) {
      if (value.name == rawName) return value;
    }
    return null;
  }

  static DateTime? _parseDate(Object? value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }
}
