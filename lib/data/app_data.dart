import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';

// Global in-memory lists. Start empty; user creates everything.
final List<Account> accounts = [];
final List<Transaction> transactions = [];
final List<PlannedTransaction> plannedTransactions = [];

// ─── Default categories (universal essentials) ───────────────────────────────

final List<String> incomeCategories = [
  'Salary',
  'Freelance',
  'Gift',
  'Refund',
  'Investment',
  'Other',
];

final List<String> expenseCategories = [
  'Groceries',
  'Transport',
  'Housing',
  'Utilities',
  'Healthcare',
  'Dining',
  'Shopping',
  'Other',
];
