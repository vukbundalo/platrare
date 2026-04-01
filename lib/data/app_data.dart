import '../models/account.dart';
import '../models/transaction.dart';
import '../models/planned_transaction.dart';

// ─── Accounts ─────────────────────────────────────────────────────────────────

// — Personal —
final _cash = Account(
  name: 'Cash',
  group: AccountGroup.personal,
  balance: 180.00,
  currencyCode: 'BAM',
);

final _card = Account(
  name: 'Debit Card',
  group: AccountGroup.personal,
  balance: 2340.50,
  currencyCode: 'BAM',
  // Example: 2× pay advance line — book balance + limit = spending headroom.
  overdraftLimit: 13600.00,
);

final _eurSavings = Account(
  name: 'EUR Savings',
  group: AccountGroup.personal,
  balance: 850.00,
  currencyCode: 'EUR',
);

// — Individuals —
final _nevena = Account(
  name: 'Nevena',
  group: AccountGroup.individuals,
  balance: 150.00, // she owes me 150 BAM
  currencyCode: 'BAM',
);

final _marko = Account(
  name: 'Marko',
  group: AccountGroup.individuals,
  balance: -300.00, // I owe him 300 BAM
  currencyCode: 'BAM',
);

// — Entities —
final _telecom = Account(
  name: 'M:tel',
  group: AccountGroup.entities,
  balance: -25.00, // outstanding bill
  currencyCode: 'BAM',
);

final _electricity = Account(
  name: 'Elektroprivreda',
  group: AccountGroup.entities,
  balance: 0,
  currencyCode: 'BAM',
);

final List<Account> accounts = [
  _cash,
  _card,
  _eurSavings,
  _nevena,
  _marko,
  _telecom,
  _electricity,
];

// ─── Transactions ─────────────────────────────────────────────────────────────

final List<Transaction> transactions = [
  // ── February ──────────────────────────────────────────────────────────────

  // Salary
  Transaction(
    nativeAmount: 2500.00,
    currencyCode: 'BAM',
    baseAmount: 2500.00,
    exchangeRate: 1.0,
    toAccount: _card,
    category: 'Salary',
    date: DateTime(2026, 2, 1),
    txType: TxType.income,
  ),

  // Groceries
  Transaction(
    nativeAmount: 112.30,
    currencyCode: 'BAM',
    baseAmount: 112.30,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Groceries',
    date: DateTime(2026, 2, 4),
    txType: TxType.expense,
  ),

  // Loan from Marko (he lent me 300 BAM, prior balance was 0)
  Transaction(
    nativeAmount: 300.00,
    currencyCode: 'BAM',
    baseAmount: 300.00,
    exchangeRate: 1.0,
    fromAccount: _marko,
    toAccount: _card,
    description: 'Loan from Marko',
    date: DateTime(2026, 2, 8),
    txType: TxType.loan,
  ),

  // Dining
  Transaction(
    nativeAmount: 45.00,
    currencyCode: 'BAM',
    baseAmount: 45.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Dining',
    date: DateTime(2026, 2, 11),
    txType: TxType.expense,
  ),

  // Transfer card → cash
  Transaction(
    nativeAmount: 200.00,
    currencyCode: 'BAM',
    baseAmount: 200.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    toAccount: _cash,
    date: DateTime(2026, 2, 14),
    txType: TxType.transfer,
  ),

  // Shopping
  Transaction(
    nativeAmount: 75.00,
    currencyCode: 'BAM',
    baseAmount: 75.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Shopping',
    date: DateTime(2026, 2, 20),
    txType: TxType.expense,
  ),

  // Electricity settlement (paid bill, prior balance was -55)
  Transaction(
    nativeAmount: 55.00,
    currencyCode: 'BAM',
    baseAmount: 55.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    toAccount: _electricity,
    description: 'Electricity bill Feb',
    date: DateTime(2026, 2, 25),
    txType: TxType.settlement,
  ),

  // ── March ─────────────────────────────────────────────────────────────────

  // Salary
  Transaction(
    nativeAmount: 2500.00,
    currencyCode: 'BAM',
    baseAmount: 2500.00,
    exchangeRate: 1.0,
    toAccount: _card,
    category: 'Salary',
    date: DateTime(2026, 3, 1),
    txType: TxType.income,
  ),

  // Groceries
  Transaction(
    nativeAmount: 98.50,
    currencyCode: 'BAM',
    baseAmount: 98.50,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Groceries',
    date: DateTime(2026, 3, 4),
    txType: TxType.expense,
  ),

  // Transfer card → cash
  Transaction(
    nativeAmount: 200.00,
    currencyCode: 'BAM',
    baseAmount: 200.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    toAccount: _cash,
    date: DateTime(2026, 3, 6),
    txType: TxType.transfer,
  ),

  // Advance to Nevena (she had balance 0, now owes me 150)
  Transaction(
    nativeAmount: 150.00,
    currencyCode: 'BAM',
    baseAmount: 150.00,
    exchangeRate: 1.0,
    fromAccount: _cash,
    toAccount: _nevena,
    description: 'Lunch advance',
    date: DateTime(2026, 3, 10),
    txType: TxType.advance,
  ),

  // Dining
  Transaction(
    nativeAmount: 34.00,
    currencyCode: 'BAM',
    baseAmount: 34.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Dining',
    date: DateTime(2026, 3, 14),
    txType: TxType.expense,
  ),

  // Cross-currency transfer: card (BAM) → EUR savings
  // 100 BAM → 51.12 EUR at 1.956 rate
  Transaction(
    nativeAmount: 100.00,
    currencyCode: 'BAM',
    baseAmount: 100.00,
    exchangeRate: 1.0,
    destinationAmount: 51.12,
    fromAccount: _card,
    toAccount: _eurSavings,
    description: 'Savings deposit',
    date: DateTime(2026, 3, 18),
    txType: TxType.transfer,
  ),

  // Utilities / housing
  Transaction(
    nativeAmount: 55.00,
    currencyCode: 'BAM',
    baseAmount: 55.00,
    exchangeRate: 1.0,
    fromAccount: _card,
    category: 'Utilities',
    date: DateTime(2026, 3, 22),
    txType: TxType.expense,
  ),

  // Freelance income
  Transaction(
    nativeAmount: 500.00,
    currencyCode: 'BAM',
    baseAmount: 500.00,
    exchangeRate: 1.0,
    toAccount: _card,
    category: 'Freelance',
    description: 'Website project',
    date: DateTime(2026, 3, 28),
    txType: TxType.income,
  ),
];

final List<PlannedTransaction> plannedTransactions = [
  // Salary end of March
  PlannedTransaction(
    nativeAmount: 2500.00,
    currencyCode: 'BAM',
    toAccount: _card,
    category: 'Salary',
    date: DateTime(2026, 3, 31),
    txType: TxType.income,
  ),

  // Rent — April
  PlannedTransaction(
    nativeAmount: 450.00,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Housing',
    description: 'Monthly rent',
    date: DateTime(2026, 4, 5),
    txType: TxType.expense,
  ),

  // Phone bill settlement (M:tel balance is -25, so this is a settlement)
  PlannedTransaction(
    nativeAmount: 25.00,
    currencyCode: 'BAM',
    fromAccount: _card,
    toAccount: _telecom,
    description: 'M:tel April',
    date: DateTime(2026, 4, 8),
    txType: TxType.settlement,
  ),

  // Collect partial from Nevena
  PlannedTransaction(
    nativeAmount: 100.00,
    currencyCode: 'BAM',
    fromAccount: _nevena,
    toAccount: _cash,
    description: 'Nevena repays lunch',
    date: DateTime(2026, 4, 12),
    txType: TxType.collection,
  ),

  // Dentist
  PlannedTransaction(
    nativeAmount: 80.00,
    currencyCode: 'BAM',
    fromAccount: _card,
    category: 'Healthcare',
    description: 'Dentist checkup',
    date: DateTime(2026, 4, 18),
    txType: TxType.expense,
  ),

  // May salary
  PlannedTransaction(
    nativeAmount: 2500.00,
    currencyCode: 'BAM',
    toAccount: _card,
    category: 'Salary',
    date: DateTime(2026, 5, 1),
    txType: TxType.income,
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
