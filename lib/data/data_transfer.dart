import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import 'account_lifecycle.dart' show compareAccountsStorageOrder;
import 'app_data.dart' as data;
import 'currency_prefs.dart';
import 'local/platrare_database.dart';
import 'user_settings.dart' as settings;

const _backupVersion = 1;

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
    return 'platrare_backup_$stamp.json';
  }

  static Future<String?> exportToPickedPath() async {
    final payload = _encodeBackupJson();

    // Android & iOS: file_picker requires [bytes]; the native layer writes the file.
    if (Platform.isAndroid || Platform.isIOS) {
      final bytes = Uint8List.fromList(utf8.encode(payload));
      return FilePicker.platform.saveFile(
        dialogTitle: 'Export backup',
        fileName: defaultBackupFileName(),
        type: FileType.any,
        bytes: bytes,
      );
    }

    // Desktop: dialog returns a path; we write the file here.
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Export backup',
      fileName: defaultBackupFileName(),
      type: FileType.any,
    );
    if (path == null) return null;

    var outPath = path;
    if (!outPath.toLowerCase().endsWith('.json')) {
      outPath = '$outPath.json';
    }
    await File(outPath).writeAsString(payload);
    return outPath;
  }

  static Future<BackupData?> importFromPickedFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return null;

    final filePath = result.files.single.path;
    if (filePath == null) {
      throw const FormatException('Selected backup path is missing.');
    }

    final content = await File(filePath).readAsString();
    return _decodeBackupJson(content);
  }

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

  static String _encodeBackupJson() {
    final payload = {
      'version': _backupVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'preferences': {
        'baseCurrency': settings.baseCurrency,
        'secondaryCurrency': settings.secondaryCurrency,
      },
      'accounts': data.accounts.map(_accountToJson).toList(growable: false),
      'transactions':
          data.transactions.map(_transactionToJson).toList(growable: false),
      'plannedTransactions':
          data.plannedTransactions.map(_plannedToJson).toList(growable: false),
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
    if (version is! int || version > _backupVersion) {
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

  static Map<String, dynamic> _transactionToJson(Transaction t) => {
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
        'attachments': t.attachments,
        'createdAt': t.createdAt.toIso8601String(),
        'updatedAt': t.updatedAt?.toIso8601String(),
        'fromSnapshotName': t.fromSnapshotName,
        'fromSnapshotCurrency': t.fromSnapshotCurrency,
        'toSnapshotName': t.toSnapshotName,
        'toSnapshotCurrency': t.toSnapshotCurrency,
      };

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

  static Map<String, dynamic> _plannedToJson(PlannedTransaction p) => {
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
        'attachments': p.attachments,
      };

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
