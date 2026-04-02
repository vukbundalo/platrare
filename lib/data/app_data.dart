import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';

// ─── Accounts (balances start at 0; replay applies transactions below) ───────

final _cash = Account(
  name: 'Cash',
  group: AccountGroup.personal,
  balance: 0,
  currencyCode: 'BAM',
);

/// Primary spending — overdraft facility for stress-testing Review/Plan.
final _card = Account(
  name: 'Debit Card',
  group: AccountGroup.personal,
  balance: 0,
  currencyCode: 'BAM',
  overdraftLimit: 13600,
);

final _eurSavings = Account(
  name: 'EUR Savings',
  group: AccountGroup.personal,
  balance: 0,
  currencyCode: 'EUR',
);

final _checking = Account(
  name: 'Checking',
  group: AccountGroup.personal,
  balance: 0,
  currencyCode: 'BAM',
);

final _pocket = Account(
  name: 'Pocket money',
  group: AccountGroup.personal,
  balance: 0,
  currencyCode: 'BAM',
);

final _nevena = Account(
  name: 'Nevena',
  group: AccountGroup.individuals,
  balance: 0,
  currencyCode: 'BAM',
);

final _marko = Account(
  name: 'Marko',
  group: AccountGroup.individuals,
  balance: 0,
  currencyCode: 'BAM',
);

final _ana = Account(
  name: 'Ana',
  group: AccountGroup.individuals,
  balance: 0,
  currencyCode: 'BAM',
);

final _telecom = Account(
  name: 'M:tel',
  group: AccountGroup.entities,
  balance: 0,
  currencyCode: 'BAM',
);

final _electricity = Account(
  name: 'Elektroprivreda',
  group: AccountGroup.entities,
  balance: 0,
  currencyCode: 'BAM',
);

final _landlord = Account(
  name: 'Landlord (rent)',
  group: AccountGroup.entities,
  balance: 0,
  currencyCode: 'BAM',
);

final _softwareLtd = Account(
  name: 'Software Ltd',
  group: AccountGroup.entities,
  balance: 0,
  currencyCode: 'BAM',
);

final List<Account> accounts = [
  _cash,
  _card,
  _eurSavings,
  _checking,
  _pocket,
  _nevena,
  _marko,
  _ana,
  _telecom,
  _electricity,
  _landlord,
  _softwareLtd,
];

// ─── Seed transactions (2026, all TxTypes, realistic mix) ─────────────────────

List<Transaction> _buildSeedTransactions() {
  const y = 2026;
  final txs = <Transaction>[];

  void add(Transaction t) => txs.add(t);

  // ── One-off demos for every semantic type (spread across the year) ────────

  add(Transaction(
    nativeAmount: 1200.0,
    currencyCode: 'BAM',
    baseAmount: 1200.0,
    exchangeRate: 1.0,
    toAccount: _softwareLtd,
    category: 'Consulting',
    description: 'Invoice — Q1 retainer (they owe us)',
    date: DateTime(y, 1, 8),
    txType: TxType.invoice,
  ));

  add(Transaction(
    nativeAmount: 400.0,
    currencyCode: 'BAM',
    baseAmount: 400.0,
    exchangeRate: 1.0,
    fromAccount: _marko,
    toAccount: _card,
    description: 'Short loan from Marko',
    date: DateTime(y, 2, 3),
    txType: TxType.loan,
  ));

  add(Transaction(
    nativeAmount: 50.0,
    currencyCode: 'BAM',
    baseAmount: 50.0,
    exchangeRate: 1.0,
    fromAccount: _softwareLtd,
    category: 'Other',
    description: 'Entity bill — payout to supplier',
    date: DateTime(y, 2, 14),
    txType: TxType.bill,
  ));

  add(Transaction(
    nativeAmount: 200.0,
    currencyCode: 'BAM',
    baseAmount: 200.0,
    exchangeRate: 1.0,
    fromAccount: _nevena,
    toAccount: _cash,
    description: 'Repayment — coffee tab',
    date: DateTime(y, 2, 18),
    txType: TxType.collection,
  ));

  add(Transaction(
    nativeAmount: 150.0,
    currencyCode: 'BAM',
    baseAmount: 150.0,
    exchangeRate: 1.0,
    fromAccount: _cash,
    toAccount: _nevena,
    description: 'Lunch advance',
    date: DateTime(y, 3, 5),
    txType: TxType.advance,
  ));

  add(Transaction(
    nativeAmount: 60.0,
    currencyCode: 'BAM',
    baseAmount: 60.0,
    exchangeRate: 1.0,
    fromAccount: _card,
    toAccount: _electricity,
    description: 'Electricity settlement',
    date: DateTime(y, 3, 14),
    txType: TxType.settlement,
  ));

  add(Transaction(
    nativeAmount: 75.0,
    currencyCode: 'BAM',
    baseAmount: 75.0,
    exchangeRate: 1.0,
    fromAccount: _marko,
    toAccount: _ana,
    description: 'Split bill reassignment',
    date: DateTime(y, 4, 9),
    txType: TxType.offset,
  ));

  add(Transaction(
    nativeAmount: 100.0,
    currencyCode: 'BAM',
    baseAmount: 100.0,
    exchangeRate: 1.0,
    destinationAmount: 51.12,
    fromAccount: _card,
    toAccount: _eurSavings,
    description: 'EUR top-up',
    date: DateTime(y, 5, 11),
    txType: TxType.transfer,
  ));

  // ── Monthly rhythm (Jan–Dec): salary, living, social, savings ─────────────

  for (var month = 1; month <= 12; month++) {
    final salary = 2480.0 + (month % 3) * 40.0;
    add(Transaction(
      nativeAmount: salary,
      currencyCode: 'BAM',
      baseAmount: salary,
      exchangeRate: 1.0,
      toAccount: _card,
      category: 'Salary',
      date: DateTime(y, month, 1),
      txType: TxType.income,
    ));

    add(Transaction(
      nativeAmount: 85.0 + month * 3.0,
      currencyCode: 'BAM',
      baseAmount: 85.0 + month * 3.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Groceries',
      date: DateTime(y, month, 4),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 42.0 + month * 2.0,
      currencyCode: 'BAM',
      baseAmount: 42.0 + month * 2.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Dining',
      date: DateTime(y, month, 7),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 25.0,
      currencyCode: 'BAM',
      baseAmount: 25.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Coffee',
      date: DateTime(y, month, 9),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 18.0 + (month % 4) * 4.0,
      currencyCode: 'BAM',
      baseAmount: 18.0 + (month % 4) * 4.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Transport',
      date: DateTime(y, month, 11),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 180.0,
      currencyCode: 'BAM',
      baseAmount: 180.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      toAccount: _cash,
      date: DateTime(y, month, 14),
      txType: TxType.transfer,
    ));

    add(Transaction(
      nativeAmount: 120.0,
      currencyCode: 'BAM',
      baseAmount: 120.0,
      exchangeRate: 1.0,
      fromAccount: _cash,
      toAccount: _pocket,
      description: 'Allowance',
      date: DateTime(y, month, 15),
      txType: TxType.transfer,
    ));

    add(Transaction(
      nativeAmount: 55.0 + (month % 2),
      currencyCode: 'BAM',
      baseAmount: 55.0 + (month % 2),
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Utilities',
      date: DateTime(y, month, 17),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 35.0,
      currencyCode: 'BAM',
      baseAmount: 35.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Subscriptions',
      date: DateTime(y, month, 19),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 450.0,
      currencyCode: 'BAM',
      baseAmount: 450.0,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Housing',
      description: 'Rent',
      date: DateTime(y, month, 22),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 60.0 + month,
      currencyCode: 'BAM',
      baseAmount: 60.0 + month,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Entertainment',
      date: DateTime(y, month, 24),
      txType: TxType.expense,
    ));

    add(Transaction(
      nativeAmount: 320.0,
      currencyCode: 'BAM',
      baseAmount: 320.0,
      exchangeRate: 1.0,
      toAccount: _checking,
      category: 'Freelance',
      description: 'Side project milestone',
      date: DateTime(y, month, 26),
      txType: TxType.income,
    ));

    add(Transaction(
      nativeAmount: 200.0,
      currencyCode: 'BAM',
      baseAmount: 200.0,
      exchangeRate: 1.0,
      fromAccount: _checking,
      toAccount: _card,
      date: DateTime(y, month, 27),
      txType: TxType.transfer,
    ));

    add(Transaction(
      nativeAmount: 50.0,
      currencyCode: 'BAM',
      baseAmount: 50.0,
      exchangeRate: 1.0,
      destinationAmount: 25.56,
      fromAccount: _card,
      toAccount: _eurSavings,
      description: 'Monthly EUR save',
      date: DateTime(y, month, 28),
      txType: TxType.transfer,
    ));
  }

  // Extra density mid-year (stress lists / filters)
  for (var d = 1; d <= 28; d += 3) {
    add(Transaction(
      nativeAmount: 12.0 + d * 0.5,
      currencyCode: 'BAM',
      baseAmount: 12.0 + d * 0.5,
      exchangeRate: 1.0,
      fromAccount: _card,
      category: 'Coffee',
      date: DateTime(y, 7, d),
      txType: TxType.expense,
    ));
  }

  // Year-end bonus + gifts
  add(Transaction(
    nativeAmount: 800.0,
    currencyCode: 'BAM',
    baseAmount: 800.0,
    exchangeRate: 1.0,
    toAccount: _card,
    category: 'Bonus',
    description: 'Year-end bonus',
    date: DateTime(y, 12, 15),
    txType: TxType.income,
  ));

  add(Transaction(
    nativeAmount: 150.0,
    currencyCode: 'BAM',
    baseAmount: 150.0,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Gifts',
    description: 'Holiday gifts',
    date: DateTime(y, 12, 22),
    txType: TxType.expense,
  ));

  txs.sort((a, b) => a.date.compareTo(b.date));
  return txs;
}

// ─── Planned (future + recurring stress) ─────────────────────────────────────

List<PlannedTransaction> _buildSeedPlanned() {
  const y = 2026;
  final planned = <PlannedTransaction>[];

  planned.add(PlannedTransaction(
    nativeAmount: 2500.0,
    currencyCode: 'BAM',
    toAccount: _card,
    category: 'Salary',
    date: DateTime(y, 4, 1),
    txType: TxType.income,
    repeatInterval: RepeatInterval.monthly,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 450.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Housing',
    description: 'Rent',
    date: DateTime(y, 4, 5),
    txType: TxType.expense,
    repeatInterval: RepeatInterval.monthly,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 25.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    toAccount: _telecom,
    description: 'Phone bill',
    date: DateTime(y, 4, 8),
    txType: TxType.settlement,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 100.0,
    currencyCode: 'BAM',
    fromAccount: _nevena,
    toAccount: _cash,
    description: 'Nevena repays',
    date: DateTime(y, 4, 12),
    txType: TxType.collection,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 80.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Healthcare',
    description: 'Dentist',
    date: DateTime(y, 4, 18),
    txType: TxType.expense,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 120.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Travel',
    description: 'Weekend trip',
    date: DateTime(y, 5, 10),
    txType: TxType.expense,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 40.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Gym',
    date: DateTime(y, 5, 17),
    txType: TxType.expense,
    repeatInterval: RepeatInterval.monthly,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 200.0,
    currencyCode: 'BAM',
    toAccount: _card,
    category: 'Freelance',
    date: DateTime(y, 6, 5),
    txType: TxType.income,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 95.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Insurance',
    date: DateTime(y, 6, 12),
    txType: TxType.expense,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 30.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Charity',
    date: DateTime(y, 8, 1),
    txType: TxType.expense,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 500.0,
    currencyCode: 'BAM',
    fromAccount: _marko,
    toAccount: _card,
    description: 'Planned loan draw',
    date: DateTime(y, 9, 2),
    txType: TxType.loan,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 70.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Education',
    date: DateTime(y, 10, 3),
    txType: TxType.expense,
  ));

  planned.add(PlannedTransaction(
    nativeAmount: 150.0,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Shopping',
    description: 'Black Friday',
    date: DateTime(y, 11, 28),
    txType: TxType.expense,
  ));

  planned.sort((a, b) => a.date.compareTo(b.date));
  return planned;
}

final List<Transaction> transactions = _buildSeedTransactions();

final List<PlannedTransaction> plannedTransactions = _buildSeedPlanned();

/// Recomputes [Account.balance] from [transactions] (same rules as applying
/// a new transaction). Call once after seed lists are built.
void applySeedBalancesFromReplay() {
  for (final a in accounts) {
    a.balance = 0;
  }
  for (final t in transactions) {
    final amt = t.nativeAmount;
    if (amt == null) continue;
    if (t.fromAccount != null) {
      t.fromAccount!.balance -= amt;
    }
    if (t.toAccount != null) {
      final credit = (t.destinationAmount != null &&
              t.toAccount!.currencyCode != t.fromAccount?.currencyCode)
          ? t.destinationAmount!
          : amt;
      t.toAccount!.balance += credit;
    }
  }
}

int _runSeedReplay() {
  applySeedBalancesFromReplay();
  return 0;
}

/// Eager seed: balances match transaction history on library load.
// ignore: unused_element
final int _seedReplay = _runSeedReplay();

// ─── Categories (used by filters & pickers) ─────────────────────────────────

final List<String> incomeCategories = [
  'Salary',
  'Freelance',
  'Consulting',
  'Gift',
  'Rental',
  'Dividends',
  'Refund',
  'Bonus',
  'Interest',
  'Side hustle',
  'Sale of goods',
  'Other',
];

final List<String> expenseCategories = [
  'Groceries',
  'Dining',
  'Transport',
  'Utilities',
  'Housing',
  'Healthcare',
  'Entertainment',
  'Shopping',
  'Travel',
  'Education',
  'Subscriptions',
  'Insurance',
  'Fuel',
  'Gym',
  'Pets',
  'Kids',
  'Charity',
  'Coffee',
  'Gifts',
  'Other',
];
