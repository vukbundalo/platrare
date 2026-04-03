import '../models/account.dart';
import '../models/transaction.dart';

/// Tolerance when comparing stored vs replayed balances (floating point).
const double ledgerVerifyEpsilon = 1e-6;

class LedgerMismatch {
  LedgerMismatch({
    required this.accountId,
    required this.storedBalance,
    required this.recomputedBalance,
  });

  final String accountId;
  final double storedBalance;
  final double recomputedBalance;

  double get delta => recomputedBalance - storedBalance;
}

/// Replays [transactions] in chronological order and compares book balances to
/// [accounts]. Matches [NewTransactionScreen] Rule 4: from subtracts
/// [Transaction.nativeAmount]; to adds [Transaction.destinationAmount] ??
/// [Transaction.nativeAmount].
List<LedgerMismatch> verifyLedger({
  required List<Account> accounts,
  required List<Transaction> transactions,
}) {
  final ids = <String>{};
  for (final a in accounts) {
    ids.add(a.id);
  }
  for (final t in transactions) {
    final fid = t.fromAccountId ?? t.fromAccount?.id;
    final tid = t.toAccountId ?? t.toAccount?.id;
    if (fid != null) ids.add(fid);
    if (tid != null) ids.add(tid);
  }

  final balances = <String, double>{for (final id in ids) id: 0.0};

  final sorted = List<Transaction>.from(transactions)
    ..sort((a, b) {
      final byDate = a.date.compareTo(b.date);
      if (byDate != 0) return byDate;
      return a.createdAt.compareTo(b.createdAt);
    });

  for (final t in sorted) {
    final amt = t.nativeAmount;
    if (amt == null) continue;

    final fid = t.fromAccountId ?? t.fromAccount?.id;
    if (fid != null) {
      balances[fid] = (balances[fid] ?? 0.0) - amt;
    }

    final tid = t.toAccountId ?? t.toAccount?.id;
    if (tid != null) {
      final credit = t.destinationAmount ?? amt;
      balances[tid] = (balances[tid] ?? 0.0) + credit;
    }
  }

  final out = <LedgerMismatch>[];
  for (final a in accounts) {
    final r = balances[a.id] ?? 0.0;
    if ((a.balance - r).abs() > ledgerVerifyEpsilon) {
      out.add(LedgerMismatch(
        accountId: a.id,
        storedBalance: a.balance,
        recomputedBalance: r,
      ));
    }
  }
  return out;
}
