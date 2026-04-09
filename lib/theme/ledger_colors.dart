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
  });

  final Color positive;
  final Color negative;
  final Color transfer;
  final Color advance;
  final Color loan;
  final Color invoice;
  final Color bill;

  /// Gain/loss hues: deep emerald / brick red (institutional, not neon).
  static const Color kPositive = Color(0xFF047857);
  static const Color kNegative = Color(0xFFB91C1C);

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
      positive: kPositive,
      negative: kNegative,
      transfer: scheme.primary,
      advance: scheme.tertiary,
      loan: scheme.secondary,
      invoice: invoiceTint,
      bill: billTint,
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
  }) {
    return LedgerColors(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
      transfer: transfer ?? this.transfer,
      advance: advance ?? this.advance,
      loan: loan ?? this.loan,
      invoice: invoice ?? this.invoice,
      bill: bill ?? this.bill,
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
