import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import 'app_data.dart' as data;
import 'balance_posting.dart' as bp;
import 'data_repository.dart';
import 'user_settings.dart' as settings;

export 'balance_posting.dart' show BalanceCorrectionResult;

/// The one place that moves money between account balances.
///
/// Screens used to mutate `Account.balance` inline and then call the
/// repository; every operation here applies (or reverses) the balance effect
/// on the *live* account instances and persists through [DataRepository] so
/// the SQLite row and the in-memory balance change together. On failure the
/// caller's `guardPersist` reloads memory from SQLite, which discards the
/// in-memory shift.
class LedgerService {
  LedgerService._();

  /// The instance in [data.accounts] for [a]'s id, or [a] itself when it is
  /// not (yet) registered. Screens can hold detached instances after a
  /// persistence-recovery reload; shifting those would corrupt balances.
  static Account? live(Account? a) {
    if (a == null) return null;
    for (final x in data.accounts) {
      if (x.id == a.id) return x;
    }
    return a;
  }

  static void _shift(Transaction t, int sign) {
    final amt = t.nativeAmount;
    if (amt == null) return;
    final from = live(t.fromAccount);
    final to = live(t.toAccount);
    if (from != null) from.balance -= sign * amt;
    if (to != null) {
      to.balance += sign *
          creditAmountOf(
            nativeAmount: amt,
            destinationAmount: t.destinationAmount,
          );
    }
  }

  /// Applies [t]'s balance effect in memory only (no persistence).
  static void applyInMemory(Transaction t) => _shift(t, 1);

  /// Reverses [t]'s balance effect in memory only (no persistence).
  static void reverseInMemory(Transaction t) => _shift(t, -1);

  /// Posts a new transaction: shifts balances, then persists row + accounts.
  static Future<void> post(Transaction t) async {
    applyInMemory(t);
    await DataRepository.addTransaction(t);
  }

  /// Undo of [remove]: re-applies balances and re-inserts at [index].
  static Future<void> restoreAt(int index, Transaction t) async {
    applyInMemory(t);
    await DataRepository.insertTransactionAt(index, t);
  }

  /// Deletes [t] and reverses its balance effect.
  static Future<void> remove(Transaction t) async {
    reverseInMemory(t);
    await DataRepository.removeTransaction(t);
  }

  /// Edits [old]: reverses it, lets [buildUpdated] classify against the
  /// restored balances and build the replacement, applies that, and persists
  /// with the previous accounts included so a retargeted transfer leaves no
  /// stale balance behind.
  static Future<Transaction> replace(
    Transaction old,
    Transaction Function() buildUpdated,
  ) async {
    reverseInMemory(old);
    final updated = buildUpdated();
    applyInMemory(updated);
    await DataRepository.replaceOrInsertTransaction(updated, isUpdate: true);
    return updated;
  }

  /// Confirms a planned row: builds the realized transaction with the base
  /// value locked at today's rate, shifts balances, removes the planned row
  /// and inserts the next occurrence, all in one SQLite commit.
  static Future<Transaction> realizePlanned(
    PlannedTransaction pt, {
    DateTime? realizationDate,
  }) async {
    final from = live(pt.fromAccount);
    final to = live(pt.toAccount);
    final ccy = pt.currencyCode ??
        from?.currencyCode ??
        to?.currencyCode ??
        settings.baseCurrency;
    final rate = fx.rateToBase(ccy);
    final realized = Transaction(
      nativeAmount: pt.nativeAmount,
      currencyCode: ccy,
      baseAmount: pt.nativeAmount != null ? pt.nativeAmount! * rate : null,
      exchangeRate: rate,
      destinationAmount: pt.destinationAmount,
      fromAccount: from,
      toAccount: to,
      category: pt.category,
      description: pt.description,
      date: realizationDate ?? pt.date,
      txType: pt.txType,
      attachments: List<String>.from(pt.attachments),
    );

    PlannedTransaction? next;
    if (pt.repeatInterval != RepeatInterval.none) {
      final nextDate = nextPlannedEffectiveDate(pt, pt.date);
      if (shouldSpawnNextOccurrence(pt, nextDate)) {
        next = nextOccurrenceOf(
          pt,
          date: nextDate,
          repeatConfirmedCount: pt.repeatConfirmedCount + 1,
        );
      }
    }

    applyInMemory(realized);
    await DataRepository.realizePlanned(
      planned: pt,
      realized: realized,
      next: next,
    );
    return realized;
  }

  /// A fresh planned row that continues [pt]'s schedule on [date].
  static PlannedTransaction nextOccurrenceOf(
    PlannedTransaction pt, {
    required DateTime date,
    required int repeatConfirmedCount,
  }) =>
      PlannedTransaction(
        nativeAmount: pt.nativeAmount,
        currencyCode: pt.currencyCode,
        destinationAmount: pt.destinationAmount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        fromAccountId: pt.fromAccountId,
        toAccountId: pt.toAccountId,
        category: pt.category,
        description: pt.description,
        date: date,
        txType: pt.txType,
        repeatInterval: pt.repeatInterval,
        repeatEvery: pt.repeatEvery,
        repeatDayOfMonth: pt.repeatDayOfMonth,
        weekendAdjustment: pt.weekendAdjustment,
        repeatEndDate: pt.repeatEndDate,
        repeatEndAfter: pt.repeatEndAfter,
        repeatConfirmedCount: repeatConfirmedCount,
        createdAt: pt.createdAt,
        attachments: List<String>.from(pt.attachments),
      );

  /// Moves [account]'s book balance to [newBook] through a correction row
  /// (so ledger replay still matches), then persists the account's other
  /// edited fields. A zero delta writes no row.
  static Future<bp.BalanceCorrectionResult> setBookBalance(
    Account account,
    double newBook,
  ) async {
    final result = await bp.applyLedgerBalanceCorrection(
      account: account,
      previousBookBalance: account.balance,
      newBookBalance: newBook,
      persistTransaction: DataRepository.addTransaction,
    );
    if (!result.inserted) account.balance = newBook;
    await DataRepository.persistAccountFields(account);
    return result;
  }
}
