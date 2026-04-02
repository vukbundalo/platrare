import 'package:uuid/uuid.dart';
import 'account.dart';

enum RepeatInterval { none, daily, weekly, monthly, yearly }

/// When a monthly/yearly repeat lands on a weekend, shift the effective date.
enum WeekendAdjustment {
  /// Keep the calendar date even if Saturday or Sunday.
  ignore,

  /// Saturday → Friday; Sunday → preceding Friday (typical early payroll).
  previousFriday,

  /// Saturday → Monday; Sunday → Monday.
  nextMonday,
}

String weekendAdjustmentLabel(WeekendAdjustment w) => switch (w) {
      WeekendAdjustment.ignore => 'No change',
      WeekendAdjustment.previousFriday => 'Move to Friday',
      WeekendAdjustment.nextMonday => 'Move to Monday',
    };

/// Returns the label shown in the UI for a repeat interval.
String repeatLabel(RepeatInterval r) => switch (r) {
      RepeatInterval.none => 'No repeat',
      RepeatInterval.daily => 'Daily',
      RepeatInterval.weekly => 'Weekly',
      RepeatInterval.monthly => 'Monthly',
      RepeatInterval.yearly => 'Yearly',
    };

/// Advances [date] by one [interval] step.
/// Monthly/yearly use end-of-month clamping so e.g. Jan 31 → Feb 28.
DateTime nextOccurrence(DateTime date, RepeatInterval interval) {
  return switch (interval) {
    RepeatInterval.none => date,
    RepeatInterval.daily => date.add(const Duration(days: 1)),
    RepeatInterval.weekly => date.add(const Duration(days: 7)),
    RepeatInterval.monthly => _addMonths(date, 1),
    RepeatInterval.yearly => _addMonths(date, 12),
  };
}

DateTime _addMonths(DateTime d, int months) {
  final totalMonths = d.year * 12 + (d.month - 1) + months;
  final year = totalMonths ~/ 12;
  final month = totalMonths % 12 + 1;
  final maxDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, d.day > maxDay ? maxDay : d.day);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Clamps [day] into a valid calendar day for [year]/[month].
DateTime dateWithDayInMonth(int year, int month, int day) {
  final maxDay = DateTime(year, month + 1, 0).day;
  final d = day > maxDay ? maxDay : day;
  return DateTime(year, month, d);
}

/// Applies [policy] when [date] (date-only) falls on Saturday or Sunday.
DateTime applyWeekendAdjustment(DateTime date, WeekendAdjustment policy) {
  final d = _dateOnly(date);
  if (policy == WeekendAdjustment.ignore) return d;
  final w = d.weekday;
  if (w != DateTime.saturday && w != DateTime.sunday) return d;
  switch (policy) {
    case WeekendAdjustment.previousFriday:
      if (w == DateTime.saturday) return d.subtract(const Duration(days: 1));
      return d.subtract(const Duration(days: 2));
    case WeekendAdjustment.nextMonday:
      if (w == DateTime.saturday) return d.add(const Duration(days: 2));
      return d.add(const Duration(days: 1));
    case WeekendAdjustment.ignore:
      return d;
  }
}

/// Next effective occurrence after [fromEffective], using repeat rules and
/// [WeekendAdjustment] for monthly/yearly. [fromEffective] is date-only in practice.
DateTime nextPlannedEffectiveDate(
    PlannedTransaction pt, DateTime fromEffective) {
  final from = _dateOnly(fromEffective);
  switch (pt.repeatInterval) {
    case RepeatInterval.none:
      return from;
    case RepeatInterval.daily:
      return from.add(const Duration(days: 1));
    case RepeatInterval.weekly:
      return from.add(const Duration(days: 7));
    case RepeatInterval.monthly:
    case RepeatInterval.yearly:
      final dom = pt.repeatDayOfMonth ?? from.day;
      final nominalThis = dateWithDayInMonth(from.year, from.month, dom);
      final step = pt.repeatInterval == RepeatInterval.monthly ? 1 : 12;
      final nextNominal = _addMonths(nominalThis, step);
      return _dateOnly(
          applyWeekendAdjustment(nextNominal, pt.weekendAdjustment));
  }
}

class PlannedTransaction {
  final String id;

  // ── Multi-currency fields ─────────────────────────────────────────────────

  /// Planned amount in the source account's currency (same semantics as
  /// Transaction.nativeAmount).  No [baseAmount] here — the rate is NOT locked
  /// until the transaction is confirmed and becomes a real Transaction.
  final double? nativeAmount;

  /// ISO-4217 code of [nativeAmount].
  final String? currencyCode;

  /// For cross-currency planned moves: the expected destination amount in the
  /// receiving account's own currency.  The user can update this when
  /// confirming the transaction if the actual rate differs from the estimate.
  final double? destinationAmount;

  // ── Core fields ───────────────────────────────────────────────────────────
  final Account? fromAccount;
  final Account? toAccount;
  final String? category;
  final String? description;
  final DateTime date;
  final TxType? txType;
  final RepeatInterval repeatInterval;

  /// For monthly/yearly repeats: calendar day-of-month (e.g. 15). Null → use [date].day.
  final int? repeatDayOfMonth;

  /// For monthly/yearly: how weekend dates are shifted for each occurrence.
  final WeekendAdjustment weekendAdjustment;

  /// Backward-compatibility alias.
  double? get amount => nativeAmount;

  PlannedTransaction({
    String? id,
    this.nativeAmount,
    this.currencyCode,
    this.destinationAmount,
    this.fromAccount,
    this.toAccount,
    this.category,
    this.description,
    required this.date,
    this.txType,
    this.repeatInterval = RepeatInterval.none,
    this.repeatDayOfMonth,
    this.weekendAdjustment = WeekendAdjustment.ignore,
  }) : id = id ?? const Uuid().v4();
}
