import 'package:flutter/material.dart' show BuildContext, DateUtils;

import 'app_format.dart';

/// Calendar window used by the Track, Plan and account-history lists.
enum PeriodUnit { day, week, month, year }

/// Immutable date-window state: a [unit] (null = all time) and an [anchor]
/// date inside the window. Replaces three copies of a string-typed state
/// machine ('day' | 'week' | 'month' | 'year' | null) that lived in the
/// screens.
class PeriodFilter {
  const PeriodFilter({this.unit, required this.anchor});

  /// All time, anchored on today.
  PeriodFilter.allTime() : this(anchor: DateTime.now());

  final PeriodUnit? unit;
  final DateTime anchor;

  bool get isAllTime => unit == null;

  /// Whether previous/next arrows apply.
  bool get isNavigable => unit != null;

  /// Letter on the hero date chip; ∞ for all time.
  String get chipLetter => switch (unit) {
        PeriodUnit.day => 'D',
        PeriodUnit.week => 'W',
        PeriodUnit.month => 'M',
        PeriodUnit.year => 'Y',
        null => '∞',
      };

  PeriodFilter copyWith({PeriodUnit? unit, DateTime? anchor, bool allTime = false}) =>
      PeriodFilter(
        unit: allTime ? null : (unit ?? this.unit),
        anchor: anchor ?? this.anchor,
      );

  /// all time → day → week → month → year → all time, re-anchored on today
  /// whenever a unit is entered.
  PeriodFilter cycled() {
    final next = switch (unit) {
      null => PeriodUnit.day,
      PeriodUnit.day => PeriodUnit.week,
      PeriodUnit.week => PeriodUnit.month,
      PeriodUnit.month => PeriodUnit.year,
      PeriodUnit.year => null,
    };
    return PeriodFilter(unit: next, anchor: DateTime.now());
  }

  static DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - 1));

  /// Inclusive start / exclusive end of the window around [anchor].
  (DateTime, DateTime) get range => rangeAround(anchor);

  (DateTime, DateTime) rangeAround(DateTime a) => switch (unit) {
        PeriodUnit.day => (
            DateTime(a.year, a.month, a.day),
            DateTime(a.year, a.month, a.day + 1),
          ),
        PeriodUnit.week => () {
            final mon = _mondayOf(a);
            return (mon, DateTime(mon.year, mon.month, mon.day + 7));
          }(),
        PeriodUnit.month => (
            DateTime(a.year, a.month),
            DateTime(a.year, a.month + 1),
          ),
        PeriodUnit.year => (DateTime(a.year), DateTime(a.year + 1)),
        null => (DateTime(0), DateTime(9999)),
      };

  /// [anchor] moved by [direction] windows (no clamping).
  DateTime steppedAnchor(int direction) {
    final a = anchor;
    return switch (unit) {
      PeriodUnit.day => DateTime(a.year, a.month, a.day + direction),
      PeriodUnit.week => DateTime(a.year, a.month, a.day + direction * 7),
      PeriodUnit.month => DateTime(a.year, a.month + direction, a.day),
      PeriodUnit.year => DateTime(a.year + direction, a.month, a.day),
      null => a,
    };
  }

  /// Whether the next window starts on or before [latest] (a date-only
  /// value: today for history lists, a forward horizon for Plan).
  bool canNavigateForward({required DateTime latest}) {
    if (unit == null) return true;
    final (nextStart, _) = rangeAround(steppedAnchor(1));
    return !DateUtils.dateOnly(nextStart).isAfter(DateUtils.dateOnly(latest));
  }

  /// Moves one window back or forward; a forward step past [latest] is a
  /// no-op so the list never shows an empty future window by accident.
  PeriodFilter navigated(int direction, {required DateTime latest}) {
    if (unit == null || direction == 0) return this;
    if (direction > 0 && !canNavigateForward(latest: latest)) return this;
    return copyWith(anchor: steppedAnchor(direction));
  }

  /// Human-readable window, e.g. "Mon, 5 Sep 2026", "1 – 7 Sep 2026",
  /// "September 2026", "2026"; empty for all time.
  String label(BuildContext context) {
    final a = anchor;
    return switch (unit) {
      PeriodUnit.day => formatAppDate(context, 'EEE, d MMM yyyy', a),
      PeriodUnit.week => () {
          final mon = _mondayOf(a);
          final sun = DateTime(mon.year, mon.month, mon.day + 6);
          final sameMon = mon.month == sun.month;
          return sameMon
              ? '${formatAppDate(context, 'd', mon)} – ${formatAppDate(context, 'd MMM yyyy', sun)}'
              : '${formatAppDate(context, 'd MMM', mon)} – ${formatAppDate(context, 'd MMM yyyy', sun)}';
        }(),
      PeriodUnit.month => formatAppDate(context, 'MMMM yyyy', a),
      PeriodUnit.year => formatAppDate(context, 'yyyy', a),
      null => '',
    };
  }

  @override
  bool operator ==(Object other) =>
      other is PeriodFilter && other.unit == unit && other.anchor == anchor;

  @override
  int get hashCode => Object.hash(unit, anchor);
}
