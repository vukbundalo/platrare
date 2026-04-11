import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_data.dart' as data;
import 'data_transfer.dart';

/// What happened when [AutoBackupService.runIfDue] was called.
enum AutoBackupResult {
  /// Auto-backup is disabled or there is no data worth backing up.
  skipped,

  /// Last backup is recent enough — nothing to do.
  notDue,

  /// Backup ran successfully.
  ran,

  /// Backup attempted but failed; previous backup is preserved.
  failed,
}

/// Silently backs up data (no attachments, no encryption) to the app's
/// Documents directory once every 24 hours.
///
/// The file is a standard Platrare `.zip` backup, fully restorable via the
/// normal import flow.  Because it lives in the app sandbox it is:
///   • included in iCloud Backup (iOS) and Google Auto Backup (Android)
///     automatically — protecting against device loss / destruction.
///   • never accessible to other apps without the user explicitly sharing it.
///
/// At most [_kMaxFiles] auto-backup files are kept; older ones are pruned
/// automatically so device storage is not impacted.
class AutoBackupService {
  AutoBackupService._();
  static final AutoBackupService instance = AutoBackupService._();

  // ── SharedPreferences keys ─────────────────────────────────────────────
  static const _kEnabledKey = 'auto_backup_enabled';
  static const _kLastAtKey = 'auto_backup_last_at';

  // ── Behaviour constants ────────────────────────────────────────────────
  static const _kInterval = Duration(hours: 24);
  static const _kMaxFiles = 3;

  /// Prefix used to identify auto-backup files in the Documents directory.
  static const kFilePrefix = 'platrare_auto_';

  // ── Runtime state ──────────────────────────────────────────────────────
  bool _enabled = true;
  DateTime? _lastBackupAt;

  /// Path of the newest auto-backup file written this session.
  /// Use [findLatestBackupPath] for a cross-session lookup.
  String? latestPath;

  // ── Public getters ─────────────────────────────────────────────────────

  /// Whether automatic daily backups are enabled.
  bool get enabled => _enabled;

  /// Timestamp of the last successful auto-backup, or null if never run.
  DateTime? get lastBackupAt => _lastBackupAt;

  // ── Initialisation ─────────────────────────────────────────────────────

  /// Loads persisted preferences.  Call once at app startup before
  /// [runIfDue] is invoked.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_kEnabledKey) ?? true;
    final at = prefs.getString(_kLastAtKey);
    _lastBackupAt = at != null ? DateTime.tryParse(at) : null;
    // Resolve the most-recent file path so the Settings tile can show it
    // immediately without waiting for [runIfDue].
    latestPath = await findLatestBackupPath();
  }

  // ── Core API ───────────────────────────────────────────────────────────

  /// Enables or disables automatic backups and persists the preference.
  Future<void> setEnabled(bool v) async {
    _enabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabledKey, v);
  }

  /// Checks whether a new backup is due and, if so, writes it to disk silently.
  ///
  /// Safe to call frequently — returns [AutoBackupResult.notDue] when the
  /// last backup is less than 24 h old.
  Future<AutoBackupResult> runIfDue() async {
    if (!_enabled) {
      debugPrint('[AutoBackup] Skipped — auto-backup is disabled');
      return AutoBackupResult.skipped;
    }
    if (data.accounts.isEmpty && data.transactions.isEmpty) {
      debugPrint('[AutoBackup] Skipped — no data to back up');
      return AutoBackupResult.skipped;
    }

    final now = DateTime.now();
    final last = _lastBackupAt;
    if (last != null && now.difference(last) < _kInterval) {
      debugPrint('[AutoBackup] Not due — last backup was ${now.difference(last).inMinutes} min ago');
      return AutoBackupResult.notDue;
    }

    debugPrint('[AutoBackup] Running backup…');
    try {
      final path = await _writeBackupFile();
      _lastBackupAt = now;
      latestPath = path;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastAtKey, now.toIso8601String());

      await _pruneOldFiles();

      debugPrint('[AutoBackup] Success → $path');
      return AutoBackupResult.ran;
    } catch (e) {
      debugPrint('[AutoBackup] Backup failed: $e');
      return AutoBackupResult.failed;
    }
  }

  /// Returns the path of the newest auto-backup file in Documents, or null
  /// if no auto-backup has ever been created.
  Future<String?> findLatestBackupPath() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith(kFilePrefix))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path)); // newest-first via timestamp in name
      return files.isEmpty ? null : files.first.path;
    } catch (_) {
      return null;
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────

  Future<String> _writeBackupFile() async {
    final bytes = await DataTransfer.buildAutoBackupBytes();
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File(p.join(dir.path, '$kFilePrefix$ts.zip'));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> _pruneOldFiles() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith(kFilePrefix))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path)); // newest first
      for (final f in files.skip(_kMaxFiles)) {
        await f.delete();
      }
    } catch (e) {
      debugPrint('[AutoBackup] Prune failed: $e');
    }
  }
}
