import 'package:flutter/material.dart';

/// Semantic colors for money movement and transaction types.
///
/// [positive] / [negative] stay fixed for consistent gain/loss signaling.
/// Other roles are derived from [ColorScheme] so they stay coherent with the
/// app seed (trust-forward blue) in light and dark mode.
@immutable
class LedgerColors extends ThemeExtension<LedgerColors> {
  const LedgerColors({
    required this.positive,
    required this.negative,
    required this.transfer,
    required this.advance,
    required this.loan,
    required this.invoice,
    required this.bill,
    required this.pending,
    required this.warning,
  });

  final Color positive;
  final Color negative;
  final Color transfer;
  final Color advance;
  final Color loan;
  final Color invoice;
  final Color bill;

  /// Security/state semantic colors.
  final Color pending;
  final Color warning;

  /// Gain/loss hues — light mode: deep emerald / brick red (institutional).
  static const Color kPositive = Color(0xFF047857);
  static const Color kNegative = Color(0xFFB91C1C);

  /// Gain/loss hues — dark mode: bright enough to read on near-black surfaces.
  static const Color kPositiveDark = Color(0xFF34D399); // emerald-400
  static const Color kNegativeDark = Color(0xFFF87171); // red-400

  /// Pending: amber — awaiting confirmation or settlement.
  static const Color kPending = Color(0xFFB45309);
  static const Color kPendingDark = Color(0xFFFBBF24); // amber-400

  /// Warning: softer amber — advisory, not error severity.
  static const Color kWarning = Color(0xFFD97706);
  static const Color kWarningDark = Color(0xFFFCD34D); // amber-300

  /// Harmonized categorical colors for donuts / charts (scheme-anchored).
  static List<Color> chartPalette(ColorScheme scheme) {
    final p = scheme.primary;
    final s = scheme.secondary;
    final t = scheme.tertiary;
    return [
      p,
      Color.lerp(p, s, 0.45)!,
      s,
      Color.lerp(s, t, 0.45)!,
      t,
      Color.lerp(p, const Color(0xFF0F766E), 0.35)!,
      Color.lerp(s, const Color(0xFFB45309), 0.30)!,
      Color.lerp(t, const Color(0xFF6D28D9), 0.28)!,
      Color.lerp(p, const Color(0xFF0369A1), 0.25)!,
      Color.lerp(s, const Color(0xFFBE185D), 0.22)!,
    ];
  }

  factory LedgerColors.harmonized(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final billTint = Color.lerp(
      scheme.tertiary,
      const Color(0xFFC2410C),
      0.45,
    )!;
    final invoiceTint = Color.lerp(
      scheme.secondary,
      const Color(0xFF0E7490),
      0.35,
    )!;
    return LedgerColors(
      positive: isDark ? kPositiveDark : kPositive,
      negative: isDark ? kNegativeDark : kNegative,
      transfer: scheme.primary,
      advance: scheme.tertiary,
      loan: scheme.secondary,
      invoice: invoiceTint,
      bill: billTint,
      pending: isDark ? kPendingDark : kPending,
      warning: isDark ? kWarningDark : kWarning,
    );
  }

  @override
  LedgerColors copyWith({
    Color? positive,
    Color? negative,
    Color? transfer,
    Color? advance,
    Color? loan,
    Color? invoice,
    Color? bill,
    Color? pending,
    Color? warning,
  }) {
    return LedgerColors(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      transfer: transfer ?? this.transfer,
      advance: advance ?? this.advance,
      loan: loan ?? this.loan,
      invoice: invoice ?? this.invoice,
      bill: bill ?? this.bill,
      pending: pending ?? this.pending,
      warning: warning ?? this.warning,
    );
  }

  @override
  LedgerColors lerp(ThemeExtension<LedgerColors>? other, double t) {
    if (other is! LedgerColors) return this;
    return LedgerColors(
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      transfer: Color.lerp(transfer, other.transfer, t)!,
      advance: Color.lerp(advance, other.advance, t)!,
      loan: Color.lerp(loan, other.loan, t)!,
      invoice: Color.lerp(invoice, other.invoice, t)!,
      bill: Color.lerp(bill, other.bill, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

extension LedgerColorsContext on BuildContext {
  LedgerColors get ledgerColors {
    final ext = Theme.of(this).extension<LedgerColors>();
    if (ext != null) return ext;
    return LedgerColors.harmonized(Theme.of(this).colorScheme);
  }
}
