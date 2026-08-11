import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kEnabled = 'planned_reminders_enabled';
const _kHour = 'planned_reminders_hour';
const _kMinute = 'planned_reminders_minute';
const _kLeadDays = 'planned_reminders_lead_days';

const int kPlannedReminderHourDefault = 9;
const int kPlannedReminderMinuteDefault = 0;

/// Selectable advance-notice choices (days before the due date).
const List<int> kPlannedReminderLeadDayChoices = [0, 1, 2, 3, 7];

final ValueNotifier<bool> plannedRemindersEnabled = ValueNotifier(false);
final ValueNotifier<int> plannedReminderHour =
    ValueNotifier(kPlannedReminderHourDefault);
final ValueNotifier<int> plannedReminderMinute =
    ValueNotifier(kPlannedReminderMinuteDefault);
final ValueNotifier<int> plannedReminderLeadDays = ValueNotifier(0);

Listenable get plannedReminderListenable => Listenable.merge([
      plannedRemindersEnabled,
      plannedReminderHour,
      plannedReminderMinute,
      plannedReminderLeadDays,
    ]);

Future<void> initPlannedReminderPrefs() async {
  final p = await SharedPreferences.getInstance();
  plannedRemindersEnabled.value = p.getBool(_kEnabled) ?? false;
  plannedReminderHour.value =
      p.getInt(_kHour)?.clamp(0, 23) ?? kPlannedReminderHourDefault;
  plannedReminderMinute.value =
      p.getInt(_kMinute)?.clamp(0, 59) ?? kPlannedReminderMinuteDefault;
  final lead = p.getInt(_kLeadDays) ?? 0;
  plannedReminderLeadDays.value =
      kPlannedReminderLeadDayChoices.contains(lead) ? lead : 0;
}

Future<void> setPlannedRemindersEnabled(bool v) async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kEnabled, v);
  plannedRemindersEnabled.value = v;
}

Future<void> setPlannedReminderTime(int hour, int minute) async {
  final h = hour.clamp(0, 23);
  final m = minute.clamp(0, 59);
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kHour, h);
  await p.setInt(_kMinute, m);
  plannedReminderHour.value = h;
  plannedReminderMinute.value = m;
}

Future<void> setPlannedReminderLeadDays(int days) async {
  final d = kPlannedReminderLeadDayChoices.contains(days) ? days : 0;
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kLeadDays, d);
  plannedReminderLeadDays.value = d;
}
