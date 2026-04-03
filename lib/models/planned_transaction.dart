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

/// Advances [date] by [every] × [interval] steps.
/// Monthly/yearly use end-of-month clamping so e.g. Jan 31 → Feb 28.
DateTime nextOccurrence(DateTime date, RepeatInterval interval,
    [int every = 1]) {
  final n = every.clamp(1, 999);
  return switch (interval) {
    RepeatInterval.none => date,
    RepeatInterval.daily => date.add(Duration(days: n)),
    RepeatInterval.weekly => date.add(Duration(days: 7 * n)),
    RepeatInterval.monthly => _addMonths(date, n),
    RepeatInterval.yearly => _addMonths(date, 12 * n),
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
  final every = pt.repeatEvery.clamp(1, 999);
  switch (pt.repeatInterval) {
    case RepeatInterval.none:
      return from;
    case RepeatInterval.daily:
      return from.add(Duration(days: every));
    case RepeatInterval.weekly:
      return from.add(Duration(days: 7 * every));
    case RepeatInterval.monthly:
    case RepeatInterval.yearly:
      final dom = pt.repeatDayOfMonth ?? from.day;
      final nominalThis = dateWithDayInMonth(from.year, from.month, dom);
      final step =
          (pt.repeatInterval == RepeatInterval.monthly ? 1 : 12) * every;
      final nextNominal = _addMonths(nominalThis, step);
      return _dateOnly(
          applyWeekendAdjustment(nextNominal, pt.weekendAdjustment));
  }
}

/// Whether the series should spawn another occurrence after the current one.
/// Takes into account [repeatEndDate] and [repeatEndAfter].
bool shouldSpawnNextOccurrence(PlannedTransaction pt, DateTime nextDate) {
  if (pt.repeatInterval == RepeatInterval.none) return false;
  if (pt.repeatEndDate != null) {
    if (_dateOnly(nextDate).isAfter(_dateOnly(pt.repeatEndDate!))) return false;
  }
  if (pt.repeatEndAfter != null) {
    if (pt.repeatConfirmedCount + 1 >= pt.repeatEndAfter!) return false;
  }
  return true;
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

  /// Repeat every N intervals (e.g. every 2 weeks). Defaults to 1.
  final int repeatEvery;

  /// For monthly/yearly repeats: calendar day-of-month (e.g. 15). Null → use [date].day.
  final int? repeatDayOfMonth;

  /// For monthly/yearly: how weekend dates are shifted for each occurrence.
  final WeekendAdjustment weekendAdjustment;

  /// Stop generating occurrences after this date (inclusive).
  final DateTime? repeatEndDate;

  /// Stop after this many confirmations. Null = infinite.
  final int? repeatEndAfter;

  /// How many times this series has been confirmed so far.
  final int repeatConfirmedCount;

  final DateTime createdAt;

  /// Last user edit time (DB-ready).
  final DateTime? updatedAt;

  /// Receipts / documents (same as [Transaction.attachments]).
  final List<String> attachments;

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
    this.repeatEvery = 1,
    this.repeatDayOfMonth,
    this.weekendAdjustment = WeekendAdjustment.ignore,
    this.repeatEndDate,
    this.repeatEndAfter,
    this.repeatConfirmedCount = 0,
    DateTime? createdAt,
    this.updatedAt,
    List<String>? attachments,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        attachments = attachments ?? const [];
}
