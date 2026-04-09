import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'account_lifecycle.dart' show compareAccountsStorageOrder;
import 'app_data.dart' as data;
import 'currency_prefs.dart';
import 'local/platrare_database.dart';
import 'user_settings.dart' as settings;

/// v1: JSON only, attachment paths are device-local (fragile).
/// v2: ZIP with [kBackupJsonFileName] + `attachments/` relative paths.
const _backupVersionLatest = 2;
const kBackupJsonFileName = 'backup.json';
const _attachmentLayoutBundled = 'bundled';
const _attachmentsFolder = 'attachments';

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

class DataTransfer {
  DataTransfer._();

  static String defaultBackupFileName() {
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'platrare_backup_$stamp.zip';
  }

  /// Writes a ZIP with [kBackupJsonFileName] plus copied attachment files.
  static Future<String?> exportToPickedPath() async {
    final zipBytes = await _buildBackupZipBytes();

    if (Platform.isAndroid || Platform.isIOS) {
      return FilePicker.platform.saveFile(
        dialogTitle: 'Export backup',
        fileName: defaultBackupFileName(),
        type: FileType.any,
        bytes: zipBytes,
      );
    }

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export backup',
      fileName: defaultBackupFileName(),
      type: FileType.any,
    );
    if (path == null) return null;

    var outPath = path;
    if (!outPath.toLowerCase().endsWith('.zip')) {
      outPath = '$outPath.zip';
    }
    await File(outPath).writeAsBytes(zipBytes);
    return outPath;
  }

  static Future<Uint8List> _buildBackupZipBytes() async {
    final pathToArchive = await _buildAttachmentPathMap();
    final json = _encodeBackupJson(attachmentPathMap: pathToArchive);

    final archive = Archive();
    archive.addFile(ArchiveFile.string(kBackupJsonFileName, json));

    for (final e in pathToArchive.entries) {
      final file = File(e.key);
      if (!await file.exists()) continue;
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile.bytes(e.value, bytes));
    }

    return ZipEncoder().encodeBytes(archive);
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
      final rel = '$_attachmentsFolder/${i.toString().padLeft(3, '0')}_$safe';
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

  static Future<BackupData?> importFromPickedFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final platformFile = result.files.single;
    Uint8List? bytes = platformFile.bytes;
    final path = platformFile.path;
    if (bytes == null && path != null) {
      bytes = await File(path).readAsBytes();
    }
    if (bytes == null) {
      throw const FormatException('Could not read the selected file.');
    }

    final name = platformFile.name.toLowerCase();
    if (name.endsWith('.json')) {
      return _decodeBackupJson(utf8.decode(bytes));
    }
    if (name.endsWith('.zip') || _looksLikeZip(bytes)) {
      return _importFromZipBytes(bytes);
    }
    return _decodeBackupJson(utf8.decode(bytes));
  }

  static bool _looksLikeZip(Uint8List bytes) =>
      bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4b;

  static Future<BackupData> _importFromZipBytes(Uint8List bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    try {
      final jsonFile = archive.find(kBackupJsonFileName);
      if (jsonFile == null) {
        throw FormatException('ZIP does not contain $kBackupJsonFileName.');
      }
      final jsonBytes = jsonFile.readBytes();
      if (jsonBytes == null) {
        throw const FormatException('Could not read backup JSON from ZIP.');
      }
      final backup = _decodeBackupJson(utf8.decode(jsonBytes));

      final attachmentBytes = <String, Uint8List>{};
      for (final f in archive.files) {
        if (!f.isFile) continue;
        if (!_isSafeBundledAttachmentPath(f.name)) continue;
        final b = f.readBytes();
        if (b != null) attachmentBytes[f.name] = b;
      }

      return _materializeBundledAttachments(backup, attachmentBytes);
    } finally {
      await archive.clear();
    }
  }

  /// Prevents zip-slip / absolute paths in archive entry names.
  static bool _isSafeBundledAttachmentPath(String name) {
    if (name.isEmpty) return false;
    final n = p.normalize(name.replaceAll('\\', '/'));
    if (p.isAbsolute(n) || n.startsWith('..')) return false;
    return n.startsWith('$_attachmentsFolder/');
  }

  static Future<BackupData> _materializeBundledAttachments(
    BackupData backup,
    Map<String, Uint8List> bytesByPath,
  ) async {
    final destDir = await _attachmentsLibraryDir();

    Future<String?> materializePath(String ref) async {
      if (ref.startsWith('$_attachmentsFolder/')) {
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

  static String _encodeBackupJson({
    Map<String, String>? attachmentPathMap,
  }) {
    final payload = {
      'version': _backupVersionLatest,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'attachmentLayout': _attachmentLayoutBundled,
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

  static BackupData _decodeBackupJson(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup format.');
    }

    final version = decoded['version'];
    if (version is! int || version > _backupVersionLatest) {
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
