import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';

// Global in-memory lists. Start empty; user creates everything.
final List<Account> accounts = [];
final List<Transaction> transactions = [];
final List<PlannedTransaction> plannedTransactions = [];

// ─── Categories (loaded from SQLite on startup; see PlatrareDatabase) ───────

final List<String> incomeCategories = [];

final List<String> expenseCategories = [];
