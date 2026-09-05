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

/// Book balances implied by [transactions] alone, replayed in chronological
/// order from zero. Opening balances and manual corrections are ledger rows
/// (`__opening_balance__`, `__balance_correction__`), so a complete log
/// reproduces every stored balance. Rule 4: from subtracts
/// [Transaction.nativeAmount]; to adds [creditAmountOf].
///
/// Accounts referenced only by transactions (deleted accounts) are included
/// so their totals are visible to callers that want them.
Map<String, double> replayBalances({
  required Iterable<Account> accounts,
  required Iterable<Transaction> transactions,
}) {
  final balances = <String, double>{for (final a in accounts) a.id: 0.0};

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
      balances[tid] = (balances[tid] ?? 0.0) +
          creditAmountOf(
            nativeAmount: amt,
            destinationAmount: t.destinationAmount,
          );
    }
  }
  return balances;
}

/// Compares each account's stored balance with [replayBalances].
List<LedgerMismatch> verifyLedger({
  required List<Account> accounts,
  required List<Transaction> transactions,
}) {
  final balances =
      replayBalances(accounts: accounts, transactions: transactions);
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
