import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show basicLocaleListResolution;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import '../l10n/supported_languages.dart';
import '../models/planned_transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart' show txAmountDisplay;
import 'app_data.dart' as data;
import 'locale_prefs.dart';
import 'planned_reminder_prefs.dart';

/// Schedules fully offline local notifications for upcoming planned
/// transactions. One notification per planned row (each row is the series'
/// next occurrence; confirming spawns the next row, which triggers a resync).
class PlannedReminderService {
  PlannedReminderService._();

  static final PlannedReminderService instance = PlannedReminderService._();

  static const _channelId = 'planned_reminders';

  /// iOS caps pending local notifications at 64; leave headroom.
  static const _maxScheduled = 60;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  Timer? _debounce;

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (_initialized || !_isMobile) return;
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (e) {
      // Fall back to tz defaults; schedules are near-term and resynced on
      // every launch/resume, so drift stays bounded.
      debugPrint('[PlannedReminders] timezone init failed: $e');
    }
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/platrare'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;

    // Reschedule when settings or language change (notification text is
    // rendered at schedule time).
    plannedReminderListenable.addListener(resync);
    appLocaleTag.addListener(resync);
    resync();
  }

  /// Asks for the OS notification permission (Android 13+ / iOS).
  /// Returns true when notifications are allowed.
  Future<bool> requestPermissions() async {
    if (!_isMobile) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  /// Debounced full reschedule; safe to call after every planned mutation
  /// (a confirm is remove + add, so bursts are common).
  void resync() {
    if (!_initialized) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _rescheduleAll);
  }

  Future<void> _rescheduleAll() async {
    try {
      await _plugin.cancelAll();
      if (!plannedRemindersEnabled.value) return;

      final l10n = _lookupL10n();
      final lead = plannedReminderLeadDays.value;
      final hour = plannedReminderHour.value;
      final minute = plannedReminderMinute.value;
      final now = DateTime.now();

      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l10n.plannedReminderChannelName,
          channelDescription: l10n.plannedReminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentList: true,
          presentSound: true,
        ),
      );

      final items = List<PlannedTransaction>.from(data.plannedTransactions)
        ..sort((a, b) => a.date.compareTo(b.date));

      var scheduled = 0;
      for (final pt in items) {
        if (scheduled >= _maxScheduled) break;
        final due = DateTime(pt.date.year, pt.date.month, pt.date.day);
        final fire = DateTime(
          due.year,
          due.month,
          due.day - lead,
          hour,
          minute,
        );
        // Already past (including overdue rows): no catch-up notification —
        // the user sees overdue plans in the app.
        if (!fire.isAfter(now)) continue;
        await _plugin.zonedSchedule(
          _stableId(pt.id),
          _title(pt, l10n),
          _body(pt, l10n, lead),
          tz.TZDateTime.from(fire, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        scheduled++;
      }
    } catch (e) {
      debugPrint('[PlannedReminders] reschedule failed: $e');
    }
  }

  String _title(PlannedTransaction pt, AppLocalizations l10n) {
    final d = pt.description?.trim();
    if (d != null && d.isNotEmpty) return d;
    final c = pt.category?.trim();
    if (c != null && c.isNotEmpty) return c;
    return l10n.plannedReminderFallbackTitle;
  }

  String _body(PlannedTransaction pt, AppLocalizations l10n, int lead) {
    final due = switch (lead) {
      0 => l10n.plannedReminderDueToday,
      1 => l10n.plannedReminderDueTomorrow,
      _ => l10n.plannedReminderDueInDays(lead),
    };
    final amt = pt.nativeAmount;
    if (amt == null) return due;
    final ccy = pt.currencyCode ?? 'BAM';
    final amount = pt.txType != null
        ? txAmountDisplay(pt.txType!, amt, ccy)
        : '${fx.formatNativeAmountDigits(amt.abs(), ccy)} ${fx.currencySymbol(ccy)}';
    return '$due · $amount';
  }

  /// Effective locale for notification text (mirrors MaterialApp resolution
  /// closely enough: stored override, else best match for the device locales).
  AppLocalizations _lookupL10n() {
    final tag = appLocaleTag.value;
    final locale = tag == kLocaleTagSystem
        ? basicLocaleListResolution(
            PlatformDispatcher.instance.locales,
            AppLocalizations.supportedLocales,
          )
        : localeFromStoredTag(tag);
    return lookupAppLocalizations(locale);
  }

  /// Deterministic 31-bit id from the planned row id (FNV-1a).
  static int _stableId(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0x7fffffff;
    }
    return h;
  }
}
