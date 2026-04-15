import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

const _kEnabled = 'backup_export_reminder_enabled';
const _kThreshold = 'backup_export_reminder_threshold';
const _kSinceExport = 'backup_export_reminder_tx_since_export';
const _kSuppressedUntil = 'backup_export_reminder_suppressed_until';

/// Extra qualifying transactions after "Remind later" before the banner can show again.
const int kBackupReminderSnoozeExtraTransactions = 5;

const int kBackupReminderThresholdDefault = 10;
const int kBackupReminderThresholdMin = 1;
const int kBackupReminderThresholdMax = 500;

final ValueNotifier<bool> backupExportReminderEnabled = ValueNotifier(false);
final ValueNotifier<int> backupExportReminderThreshold =
    ValueNotifier(kBackupReminderThresholdDefault);
final ValueNotifier<int> backupExportReminderSinceExportCount =
    ValueNotifier(0);
/// When > 0, banner is hidden while [backupExportReminderSinceExportCount] < this value.
final ValueNotifier<int> backupExportReminderSuppressedUntil =
    ValueNotifier(0);

/// Bumped after counter/snooze changes so the home shell can re-sync the banner.
final ValueNotifier<int> backupExportReminderReevaluate = ValueNotifier(0);

Listenable get backupExportReminderListenable => Listenable.merge([
      backupExportReminderEnabled,
      backupExportReminderThreshold,
      backupExportReminderSinceExportCount,
      backupExportReminderSuppressedUntil,
      backupExportReminderReevaluate,
    ]);

bool transactionCountsTowardBackupReminder(Transaction t) {
  final d = t.description;
  if (d == '__opening_balance__' || d == '__balance_correction__') {
    return false;
  }
  return true;
}

bool shouldShowBackupExportReminderBanner() {
  if (!backupExportReminderEnabled.value) return false;
  final c = backupExportReminderSinceExportCount.value;
  final threshold = backupExportReminderThreshold.value;
  if (c < threshold) return false;
  final suppressed = backupExportReminderSuppressedUntil.value;
  if (suppressed > 0 && c < suppressed) return false;
  return true;
}

Future<void> initBackupExportReminderPrefs() async {
  final p = await SharedPreferences.getInstance();
  backupExportReminderEnabled.value =
      p.getBool(_kEnabled) ?? false;
  backupExportReminderThreshold.value = p
          .getInt(_kThreshold)
          ?.clamp(kBackupReminderThresholdMin, kBackupReminderThresholdMax) ??
      kBackupReminderThresholdDefault;
  backupExportReminderSinceExportCount.value =
      p.getInt(_kSinceExport) ?? 0;
  backupExportReminderSuppressedUntil.value =
      p.getInt(_kSuppressedUntil) ?? 0;
}

Future<void> setBackupExportReminderEnabled(bool v) async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kEnabled, v);
  backupExportReminderEnabled.value = v;
  if (!v) {
    backupExportReminderSuppressedUntil.value = 0;
    await p.setInt(_kSuppressedUntil, 0);
  }
  backupExportReminderReevaluate.value++;
}

Future<void> setBackupExportReminderThreshold(int v) async {
  final clamped =
      v.clamp(kBackupReminderThresholdMin, kBackupReminderThresholdMax);
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kThreshold, clamped);
  backupExportReminderThreshold.value = clamped;
  backupExportReminderReevaluate.value++;
}

Future<void> _persistCounterAndSuppressed() async {
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kSinceExport, backupExportReminderSinceExportCount.value);
  await p.setInt(_kSuppressedUntil, backupExportReminderSuppressedUntil.value);
}

Future<void> recordQualifyingTransactionForBackupReminder(
    Transaction persisted) async {
  if (!backupExportReminderEnabled.value) return;
  if (!transactionCountsTowardBackupReminder(persisted)) return;
  backupExportReminderSinceExportCount.value++;
  await _persistCounterAndSuppressed();
  backupExportReminderReevaluate.value++;
}

Future<void> remindLaterBackupExportReminder() async {
  final c = backupExportReminderSinceExportCount.value;
  final next = c + kBackupReminderSnoozeExtraTransactions;
  backupExportReminderSuppressedUntil.value = next;
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kSuppressedUntil, next);
  backupExportReminderReevaluate.value++;
}

Future<void> recordSuccessfulManualBackupExport() async {
  backupExportReminderSinceExportCount.value = 0;
  backupExportReminderSuppressedUntil.value = 0;
  await _persistCounterAndSuppressed();
  backupExportReminderReevaluate.value++;
}

/// After import or when transactions were cleared outside normal export flow.
Future<void> resetBackupExportReminderState() async {
  backupExportReminderSinceExportCount.value = 0;
  backupExportReminderSuppressedUntil.value = 0;
  await _persistCounterAndSuppressed();
  backupExportReminderReevaluate.value++;
}
