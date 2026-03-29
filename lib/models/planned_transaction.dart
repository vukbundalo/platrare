import 'package:uuid/uuid.dart';
import 'account.dart';

enum RepeatInterval { none, daily, weekly, monthly, yearly }

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
  }) : id = id ?? const Uuid().v4();
}
