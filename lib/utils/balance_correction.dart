import '../data/data_repository.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import 'fx.dart' as fx;

/// Result of [applyLedgerBalanceCorrection].
class BalanceCorrectionResult {
  final bool inserted;
  final TxType? type;
  final double? amount;

  const BalanceCorrectionResult.none()
      : inserted = false,
        type = null,
        amount = null;

  const BalanceCorrectionResult.added({
    required this.type,
    required this.amount,
  })  : inserted = true;
}

/// Inserts a transaction that moves [account]'s book balance from
/// [previousBookBalance] to [newBookBalance], using the same balance rules as
/// [NewTransactionScreen]. Call while [account.balance] still equals
/// [previousBookBalance].
BalanceCorrectionResult applyLedgerBalanceCorrection({
  required Account account,
  required double previousBookBalance,
  required double newBookBalance,
}) {
  final delta = newBookBalance - previousBookBalance;
  if (delta.abs() < 1e-10) {
    return const BalanceCorrectionResult.none();
  }
  final amount = delta.abs();
  final Account? from = delta < 0 ? account : null;
  final Account? to = delta > 0 ? account : null;
  final type = classifyTransaction(from: from, to: to);
  final ccy = account.currencyCode;
  final rate = fx.rateToBase(ccy);
  final baseAmt = amount * rate;

  if (from != null) from.balance -= amount;
  if (to != null) to.balance += amount;

  DataRepository.addTransaction(
    Transaction(
      nativeAmount: amount,
      currencyCode: ccy,
      baseAmount: baseAmt,
      exchangeRate: rate,
      fromAccount: from,
      toAccount: to,
      category: '__balance_adjustment__',
      description: '__balance_correction__',
      date: DateTime.now(),
      txType: type,
    ),
  );

  return BalanceCorrectionResult.added(type: type, amount: amount);
}
