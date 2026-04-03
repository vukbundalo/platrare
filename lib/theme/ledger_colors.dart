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

  /// Default gain/loss hues (aligned with common fintech semantics).
  /// On `surface` / `surfaceContainerLow` these read clearly for bold amounts;
  /// if a future surface goes darker, re-check WCAG contrast for body-sized text.
  static const Color kPositive = Color(0xFF16A34A);
  static const Color kNegative = Color(0xFFDC2626);

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
