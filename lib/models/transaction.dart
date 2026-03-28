import 'package:uuid/uuid.dart';
import 'account.dart';

class Transaction {
  final String id;

  // ── Multi-currency fields (Rules 3 & 4) ──────────────────────────────────

  /// Amount in the *source* currency of this transaction.
  /// • For expense/advance/transfer: fromAccount.currencyCode
  /// • For income/invoice/loan/collection: toAccount.currencyCode
  /// • For bill/settlement: fromAccount.currencyCode
  final double? nativeAmount;

  /// ISO-4217 code of [nativeAmount].  Stored so historical records remain
  /// self-describing even if the account is later deleted.
  final String? currencyCode;

  /// Equivalent value in the user's *base* currency, locked at the exact
  /// moment this transaction was recorded (Rule 3).  Immutable — never
  /// recalculated when future exchange rates change.
  final double? baseAmount;

  /// Base/native rate locked at save time: baseAmount = nativeAmount × exchangeRate.
  /// For same-currency transactions this equals rateToBase(currencyCode).
  final double? exchangeRate;

  /// Cross-currency moves only (Rule 4): the amount *received* by the
  /// destination account expressed in *that* account's own currency.
  /// If null the transaction is same-currency and the destination receives
  /// exactly [nativeAmount].
  final double? destinationAmount;

  // ── Core fields ───────────────────────────────────────────────────────────
  final Account? fromAccount;
  final Account? toAccount;
  final String? category;
  final String? description;
  final DateTime date;
  final TxType? txType;

  /// Backward-compatibility alias — existing display code reads `.amount`.
  double? get amount => nativeAmount;

  Transaction({
    String? id,
    this.nativeAmount,
    this.currencyCode,
    this.baseAmount,
    this.exchangeRate,
    this.destinationAmount,
    this.fromAccount,
    this.toAccount,
    this.category,
    this.description,
    DateTime? date,
    this.txType,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();
}
