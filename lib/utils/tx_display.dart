import 'package:flutter/material.dart';
import '../models/account.dart';
import 'fx.dart' as fx;

Color txColor(TxType t) => switch (t) {
      TxType.income || TxType.collection => const Color(0xFF16A34A),
      TxType.expense || TxType.settlement => const Color(0xFFDC2626),
      TxType.transfer || TxType.offset => const Color(0xFF2563EB),
      TxType.advance => const Color(0xFF7C3AED),
      TxType.loan => const Color(0xFF4F46E5),
      TxType.invoice => const Color(0xFF0891B2),
      TxType.bill => const Color(0xFFD97706),
    };

IconData txIcon(TxType t) => switch (t) {
      TxType.income || TxType.collection => Icons.arrow_downward_rounded,
      TxType.expense || TxType.settlement => Icons.arrow_outward_rounded,
      TxType.transfer || TxType.offset => Icons.swap_horiz_rounded,
      TxType.advance => Icons.trending_up_rounded,
      TxType.loan => Icons.account_balance_outlined,
      TxType.invoice => Icons.description_outlined,
      TxType.bill => Icons.receipt_outlined,
    };

/// Signed amount string using the transaction's native currency symbol.
/// e.g. txAmountDisplay(TxType.expense, 50, 'BAM') → '-KM50.00'
///      txAmountDisplay(TxType.invoice, 300, 'EUR') → '+€300.00'
String txAmountDisplay(TxType t, double nativeAmount,
    [String currencyCode = 'BAM']) {
  final sym = fx.currencySymbol(currencyCode);
  final abs = nativeAmount.abs();
  if (abs == 0) {
    final z = fx.formatNativeAmountDigits(0, currencyCode);
    return '$z $sym';
  }
  final absStr = '${fx.formatNativeAmountDigits(abs, currencyCode)} $sym';
  return switch (t) {
    TxType.income ||
    TxType.collection ||
    TxType.invoice ||
    TxType.loan =>
      '+$absStr',
    TxType.expense ||
    TxType.settlement ||
    TxType.bill ||
    TxType.advance =>
      '-$absStr',
    TxType.transfer || TxType.offset => '⇄ $absStr',
  };
}

/// Which category list to show for a given [TxType], or null to hide.
enum CategoryList { income, expense }

CategoryList? categoryListFor(TxType t) => switch (t) {
      TxType.income || TxType.invoice => CategoryList.income,
      TxType.expense || TxType.bill => CategoryList.expense,
      _ => null,
    };
