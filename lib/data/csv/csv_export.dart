import 'dart:io';
import 'dart:ui' show Rect;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/account.dart';
import '../../models/transaction.dart';
import '../../utils/account_display.dart';
import '../../utils/fx.dart' as fx;
import '../app_data.dart' as data;
import 'csv_codec.dart';
import 'csv_format.dart';

/// Writes the ledger as a spreadsheet-friendly CSV and hands it to the share
/// sheet, mirroring `DataTransfer.shareBackup`.
///
/// Values are written exactly as stored — raw category keys and the
/// `__opening_balance__`-style sentinels included — so a file exported in one
/// language re-imports identically in another. The `.zip` / `.platrare` backup
/// remains the full-fidelity format; CSV deliberately drops attachments,
/// planned transactions and account metadata.
class CsvExport {
  CsvExport._();

  static String _stamp() =>
      DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

  static String defaultTransactionsFileName() =>
      'platrare_transactions_${_stamp()}.csv';

  static const String templateFileName = 'platrare_import_template.csv';

  /// Shortest decimal string that reads back as exactly [v].
  ///
  /// Starts at the currency's minor units so ordinary money exports as `42.50`,
  /// and widens only when rounding would lose value — a CSV round trip must not
  /// shift account balances.
  static String _decimal(double? v, int digits) {
    if (v == null) return '';
    var s = v.toStringAsFixed(digits);
    if (double.parse(s) == v) return s;
    s = v.toStringAsFixed(6);
    if (double.parse(s) == v) return s;
    return v.toString();
  }

  static String _accountLabel(String? snapshotName, Account? account) {
    if (account != null) return accountDisplayName(account);
    return snapshotName ?? '';
  }

  /// Builds the transactions CSV. Rows are ordered oldest-first, which is what
  /// a spreadsheet user expects even though the app lists newest-first.
  static Uint8List buildTransactionsCsvBytes({
    List<Transaction>? source,
  }) {
    final txs = List<Transaction>.from(source ?? data.transactions)
      ..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate;
        return a.createdAt.compareTo(b.createdAt);
      });

    final dateFmt = DateFormat('yyyy-MM-dd');
    final rows = <List<String>>[
      [for (final c in kCsvExportColumns) kCsvCanonicalHeader[c]!],
    ];

    for (final t in txs) {
      final ccy = t.currencyCode ??
          t.fromAccount?.currencyCode ??
          t.toAccount?.currencyCode ??
          '';
      final srcDigits = ccy.isEmpty ? 2 : fx.currencyMinorUnits(ccy);
      final dstCcy = t.toAccount?.currencyCode ?? t.toSnapshotCurrency ?? ccy;
      final dstDigits = dstCcy.isEmpty ? 2 : fx.currencyMinorUnits(dstCcy);

      rows.add(<String>[
        dateFmt.format(t.date),
        csvSanitizeText(t.txType?.name ?? ''),
        csvSanitizeText(_accountLabel(t.fromSnapshotName, t.fromAccount)),
        csvSanitizeText(_accountLabel(t.toSnapshotName, t.toAccount)),
        _decimal(t.nativeAmount, srcDigits),
        csvSanitizeText(ccy),
        _decimal(t.destinationAmount, dstDigits),
        csvSanitizeText(t.category ?? ''),
        csvSanitizeText(t.description ?? ''),
        _decimal(t.baseAmount, 2),
        _decimal(t.exchangeRate, 6),
      ]);
    }

    return encodeCsvDocument(rows);
  }

  /// Builds the example file users edit their old data into.
  ///
  /// [instructionLines] are written as `#`-prefixed rows, which the importer
  /// skips, so the guidance can ship localized without breaking a re-import.
  static Uint8List buildTemplateCsvBytes({
    required List<String> instructionLines,
    String? currencyCode,
  }) {
    final ccy = currencyCode ?? 'EUR';
    final rows = <List<String>>[
      [for (final c in kCsvTemplateColumns) kCsvCanonicalHeader[c]!],
      for (final line in instructionLines) <String>['# $line'],
      ['2024-01-15', 'expense', 'Checking', '', '42.50', ccy, 'Groceries', 'Weekly shop'],
      ['2024-01-16', 'income', '', 'Checking', '2100.00', ccy, 'Salary', 'January salary'],
      ['2024-01-17', 'transfer', 'Checking', 'Savings', '500.00', ccy, '', 'Move to savings'],
    ];
    return encodeCsvDocument(rows);
  }

  /// Writes [bytes] to a temp file, opens the share sheet, then deletes it.
  /// The ledger must not linger in the temp directory.
  static Future<void> _shareBytes(
    Uint8List bytes,
    String fileName, {
    Rect? sharePositionOrigin,
  }) async {
    final tmpDir = await getTemporaryDirectory();
    final tmpFile = File(p.join(tmpDir.path, fileName));
    await tmpFile.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      debugPrint('[CSV:Export] Wrote temp file — ${bytes.length} bytes');
    }
    try {
      await Share.shareXFiles(
        [XFile(tmpFile.path, mimeType: 'text/csv', name: fileName)],
        subject: fileName,
        sharePositionOrigin: sharePositionOrigin,
      );
    } finally {
      try {
        await tmpFile.delete();
      } catch (_) {}
    }
  }

  static Future<void> shareTransactionsCsv({Rect? sharePositionOrigin}) async {
    if (kDebugMode) {
      debugPrint(
        '[CSV:Export] Building — ${data.transactions.length} transactions',
      );
    }
    await _shareBytes(
      buildTransactionsCsvBytes(),
      defaultTransactionsFileName(),
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  static Future<void> shareTemplateCsv({
    required List<String> instructionLines,
    String? currencyCode,
    Rect? sharePositionOrigin,
  }) async {
    await _shareBytes(
      buildTemplateCsvBytes(
        instructionLines: instructionLines,
        currencyCode: currencyCode,
      ),
      templateFileName,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
