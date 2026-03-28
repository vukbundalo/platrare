import '../models/account.dart';
import '../models/transaction.dart';
import '../models/planned_transaction.dart';

// ─── Accounts ────────────────────────────────────────────────────────────────
// Rule 2: every account has exactly one immutable currency.
// Rule 5: balances are in native currency; net worth = Σ(balance × liveRate).
//
// Balance story: all values below are the net result of the seed transactions.

final _cash      = Account(name: 'Cash',       group: AccountGroup.personal,   currencyCode: 'BAM', balance: 1901.80);
final _debit     = Account(name: 'Debit Card',  group: AccountGroup.personal,   currencyCode: 'BAM', balance: 295.00);
final _savings   = Account(name: 'Savings',     group: AccountGroup.personal,   currencyCode: 'BAM', balance: 500.00);

final _mom       = Account(name: 'Mom',         group: AccountGroup.individuals, currencyCode: 'BAM', balance: 200.00);
final _sister    = Account(name: 'Sister',      group: AccountGroup.individuals, currencyCode: 'BAM', balance: 0.00);
final _father    = Account(name: 'Father',      group: AccountGroup.individuals, currencyCode: 'BAM', balance: -500.00);
// Client invoiced / pays in EUR — separate account, different currency (Rule 2).
final _client    = Account(name: 'Client',      group: AccountGroup.individuals, currencyCode: 'EUR', balance: 0.00);

final _elec      = Account(name: 'Electricity', group: AccountGroup.entities,   currencyCode: 'BAM', balance: 0.00);
final _building  = Account(name: 'Building',    group: AccountGroup.entities,   currencyCode: 'BAM', balance: -45.00);
final _internet  = Account(name: 'Internet',    group: AccountGroup.entities,   currencyCode: 'BAM', balance: 0.00);
// Nova Banka operates in EUR (e.g. an EU-denominated bank loan / fee).
final _novaBanka = Account(name: 'Nova Banka',  group: AccountGroup.entities,   currencyCode: 'EUR', balance: -50.00);

final List<Account> accounts = [
  _cash, _debit, _savings,
  _mom, _sister, _father, _client,
  _elec, _building, _internet, _novaBanka,
];

// ─── Helpers ─────────────────────────────────────────────────────────────────

DateTime _d(int day) => DateTime(2026, 3, day);
DateTime _p(int day) => DateTime(2026, 4, day);

// EUR/BAM rate used throughout seed data (mirrors user_settings.dart default).
const _eurRate = 1.956;

// ─── Tracked Transactions ────────────────────────────────────────────────────
// Covers all 10 TxTypes. Newest first so the Track screen list is in order.
//
// Rule 3: every entry stores nativeAmount + currencyCode + baseAmount + exchangeRate.
// Rule 4: cross-currency moves also store destinationAmount.

final List<Transaction> transactions = [
  // ── OFFSET (March 22) ─────────────────────────────────────────────────────
  // Sister(BAM) reassigns her BAM debt to Mom(BAM). Same currency → no dest.
  Transaction(
    nativeAmount: 80, currencyCode: 'BAM', baseAmount: 80, exchangeRate: 1.0,
    fromAccount: _sister, toAccount: _mom,
    description: 'Sister transfers debt to Mom',
    date: _d(22), txType: TxType.offset,
  ),

  // ── COLLECTION (March 20) — cross-currency (Rule 4) ──────────────────────
  // Client(EUR) pays the EUR invoice. Cash(BAM) receives the BAM equivalent.
  // nativeAmount = 300 EUR sent by Client.
  // destinationAmount = 586.80 BAM received by Cash (user-entered at the bank
  //   counter; locks the exact real-world rate of 1.956 BAM/EUR).
  Transaction(
    nativeAmount: 300, currencyCode: 'EUR',
    baseAmount: 586.80, exchangeRate: _eurRate,
    destinationAmount: 586.80, // BAM received by Cash
    fromAccount: _client, toAccount: _cash,
    description: 'Invoice collected', category: 'Consulting',
    date: _d(20), txType: TxType.collection,
  ),

  // ── LOAN (March 18) ───────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 500, currencyCode: 'BAM', baseAmount: 500, exchangeRate: 1.0,
    fromAccount: _father, toAccount: _cash,
    description: 'Emergency loan from Father',
    date: _d(18), txType: TxType.loan,
  ),

  // ── SETTLEMENT (March 15) ─────────────────────────────────────────────────
  Transaction(
    nativeAmount: 65, currencyCode: 'BAM', baseAmount: 65, exchangeRate: 1.0,
    fromAccount: _debit, toAccount: _elec,
    description: 'Electricity bill payment',
    date: _d(15), txType: TxType.settlement,
  ),

  // ── ADVANCE (March 12) ────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 80, currencyCode: 'BAM', baseAmount: 80, exchangeRate: 1.0,
    fromAccount: _cash, toAccount: _sister,
    description: 'Concert tickets for Sister',
    date: _d(12), txType: TxType.advance,
  ),

  // ── ADVANCE (March 10) ────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 120, currencyCode: 'BAM', baseAmount: 120, exchangeRate: 1.0,
    fromAccount: _cash, toAccount: _mom,
    description: 'Paid dentist for Mom',
    date: _d(10), txType: TxType.advance,
  ),

  // ── BILL (March 9) — cross-currency (Rule 4) ─────────────────────────────
  // Nova Banka(EUR) issues a 50 EUR bank fee. No destination account — it's a
  // bill, so only fromAccount is set. baseAmount is the BAM equivalent locked
  // at today's rate; destinationAmount is null (no receiving account).
  Transaction(
    nativeAmount: 50, currencyCode: 'EUR',
    baseAmount: 97.80, exchangeRate: _eurRate,
    fromAccount: _novaBanka, toAccount: null,
    description: 'Nova Banka annual fee',
    date: _d(9), txType: TxType.bill,
  ),

  // ── BILL (March 8) ────────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 45, currencyCode: 'BAM', baseAmount: 45, exchangeRate: 1.0,
    fromAccount: _building, toAccount: null,
    description: 'Building maintenance fee',
    date: _d(8), txType: TxType.bill,
  ),

  // ── BILL (March 7) ────────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 65, currencyCode: 'BAM', baseAmount: 65, exchangeRate: 1.0,
    fromAccount: _elec, toAccount: null,
    description: 'March electricity bill',
    date: _d(7), txType: TxType.bill,
  ),

  // ── INVOICE (March 6) — cross-currency (Rule 4) ──────────────────────────
  // Web design project invoiced to Client(EUR). No fromAccount — it's an
  // invoice, toAccount is the party who now owes us.
  // baseAmount = 300 EUR × 1.956 = 586.80 BAM locked at invoice date.
  Transaction(
    nativeAmount: 300, currencyCode: 'EUR',
    baseAmount: 586.80, exchangeRate: _eurRate,
    fromAccount: null, toAccount: _client,
    description: 'Website redesign project', category: 'Consulting',
    date: _d(6), txType: TxType.invoice,
  ),

  // ── EXPENSE (March 5) ─────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 40, currencyCode: 'BAM', baseAmount: 40, exchangeRate: 1.0,
    fromAccount: _debit, toAccount: null,
    category: 'Transport',
    date: _d(5), txType: TxType.expense,
  ),

  // ── EXPENSE (March 4) ─────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 85, currencyCode: 'BAM', baseAmount: 85, exchangeRate: 1.0,
    fromAccount: _cash, toAccount: null,
    category: 'Groceries',
    date: _d(4), txType: TxType.expense,
  ),

  // ── TRANSFER (March 3) ────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 400, currencyCode: 'BAM', baseAmount: 400, exchangeRate: 1.0,
    fromAccount: _cash, toAccount: _debit,
    description: 'Top up card',
    date: _d(3), txType: TxType.transfer,
  ),

  // ── TRANSFER (March 2) ────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 500, currencyCode: 'BAM', baseAmount: 500, exchangeRate: 1.0,
    fromAccount: _cash, toAccount: _savings,
    description: 'Savings deposit',
    date: _d(2), txType: TxType.transfer,
  ),

  // ── INCOME (March 1) ──────────────────────────────────────────────────────
  Transaction(
    nativeAmount: 2000, currencyCode: 'BAM', baseAmount: 2000, exchangeRate: 1.0,
    fromAccount: null, toAccount: _cash,
    category: 'Salary',
    date: _d(1), txType: TxType.income,
  ),
];

// ─── Planned Transactions ─────────────────────────────────────────────────────
// Covers all 10 TxTypes for April 2026.
// No baseAmount here — the rate is locked only when the plan is confirmed.

final List<PlannedTransaction> plannedTransactions = [
  // INCOME — same currency
  PlannedTransaction(
    nativeAmount: 2000, currencyCode: 'BAM',
    fromAccount: null, toAccount: _cash,
    category: 'Salary', description: 'April salary',
    date: _p(1), txType: TxType.income,
  ),

  // EXPENSE — same currency
  PlannedTransaction(
    nativeAmount: 600, currencyCode: 'BAM',
    fromAccount: _cash, toAccount: null,
    category: 'Housing', description: 'Monthly rent',
    date: _p(2), txType: TxType.expense,
  ),

  // BILL — same currency
  PlannedTransaction(
    nativeAmount: 35, currencyCode: 'BAM',
    fromAccount: _internet, toAccount: null,
    description: 'Internet monthly fee',
    date: _p(3), txType: TxType.bill,
  ),

  // TRANSFER — same currency
  PlannedTransaction(
    nativeAmount: 200, currencyCode: 'BAM',
    fromAccount: _savings, toAccount: _cash,
    description: 'Cash withdrawal',
    date: _p(8), txType: TxType.transfer,
  ),

  // ADVANCE — same currency (Sister.balance = 0)
  PlannedTransaction(
    nativeAmount: 200, currencyCode: 'BAM',
    fromAccount: _savings, toAccount: _sister,
    description: 'Help Sister with rent',
    date: _p(9), txType: TxType.advance,
  ),

  // INVOICE — cross-currency: new project, Client(EUR) will owe €500
  PlannedTransaction(
    nativeAmount: 500, currencyCode: 'EUR',
    destinationAmount: 500, // EUR credited to Client's EUR balance
    fromAccount: null, toAccount: _client,
    description: 'Mobile app design project', category: 'Consulting',
    date: _p(10), txType: TxType.invoice,
  ),

  // SETTLEMENT — cross-currency (Rule 4): paying Nova Banka(EUR) from Debit(BAM)
  // Paying 97.80 BAM from Debit; Nova Banka EUR account receives 50 EUR.
  // lockedRate (estimated) = 97.80 / 50 = 1.956 BAM/EUR — confirmed at realization.
  PlannedTransaction(
    nativeAmount: 97.80, currencyCode: 'BAM',
    destinationAmount: 50.0, // EUR credited to Nova Banka
    fromAccount: _debit, toAccount: _novaBanka,
    description: 'Nova Banka fee payment',
    date: _p(12), txType: TxType.settlement,
  ),

  // LOAN — same currency (Father.balance = -500 ≤ 0)
  PlannedTransaction(
    nativeAmount: 100, currencyCode: 'BAM',
    fromAccount: _father, toAccount: _cash,
    description: 'Extra loan from Father',
    date: _p(15), txType: TxType.loan,
  ),

  // COLLECTION — same currency (Mom.balance = +200 > 0)
  PlannedTransaction(
    nativeAmount: 100, currencyCode: 'BAM',
    fromAccount: _mom, toAccount: _savings,
    description: 'Mom repays part of debt',
    date: _p(20), txType: TxType.collection,
  ),

  // OFFSET — same currency (Mom(BAM) → Father(BAM), both non-personal)
  PlannedTransaction(
    nativeAmount: 100, currencyCode: 'BAM',
    fromAccount: _mom, toAccount: _father,
    description: 'Debt reassignment: Mom → Father',
    date: _p(25), txType: TxType.offset,
  ),
];

// ─── Categories ──────────────────────────────────────────────────────────────

final List<String> incomeCategories = [
  'Salary', 'Freelance', 'Consulting', 'Gift', 'Rental', 'Dividends',
  'Refund', 'Other',
];

final List<String> expenseCategories = [
  'Groceries', 'Dining', 'Transport', 'Utilities', 'Housing', 'Healthcare',
  'Entertainment', 'Shopping', 'Travel', 'Education', 'Other',
];
