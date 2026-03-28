import '../models/account.dart';
import '../models/transaction.dart';
import '../models/planned_transaction.dart';

final List<Account> accounts = [
  // Personal
  Account(name: 'Cash', group: AccountGroup.personal),
  Account(name: 'Debit Card', group: AccountGroup.personal),
  Account(name: 'Savings', group: AccountGroup.personal),
  // Partner
  Account(name: 'Mom', group: AccountGroup.partner),
  Account(name: 'Sister', group: AccountGroup.partner),
  Account(name: 'Father', group: AccountGroup.partner),
  Account(name: 'Electricity', group: AccountGroup.partner),
  Account(name: 'Building', group: AccountGroup.partner),
  Account(name: 'Internet', group: AccountGroup.partner),
  Account(name: 'Nova Banka', group: AccountGroup.partner),
];

final List<Transaction> transactions = [];

final List<PlannedTransaction> plannedTransactions = [];

final List<String> categories = [
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
  'Other',
];
