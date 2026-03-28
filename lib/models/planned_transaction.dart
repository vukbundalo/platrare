import 'package:uuid/uuid.dart';
import 'account.dart';

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
  }) : id = id ?? const Uuid().v4();
}
