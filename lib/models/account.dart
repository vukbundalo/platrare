import 'package:uuid/uuid.dart';

/// Three-way group: your own accounts, individuals, and entities.
enum AccountGroup { personal, individuals, entities }

/// Semantic transaction type, determined at save time using prior balances.
enum TxType {
  income,     // null → personal
  expense,    // personal → null
  invoice,    // null → individuals/entities  (they owe me)
  bill,       // individuals/entities → null  (I owe them)
  advance,    // personal → ind/ent (prior balance ≥ 0, creating receivable)
  settlement, // personal → ind/ent (prior balance < 0, paying my debt)
  loan,       // ind/ent → personal (prior balance ≤ 0, borrowing)
  collection, // ind/ent → personal (prior balance > 0, collecting receivable)
  offset,     // non-personal → non-personal (debt reassignment)
  transfer,   // personal → personal
}

/// Classify a transaction using the accounts' PRIOR balances (before applying).
TxType classifyTransaction({required Account? from, required Account? to}) {
  final fg = from?.group;
  final tg = to?.group;

  if (from == null && tg == AccountGroup.personal)                  return TxType.income;
  if (fg == AccountGroup.personal && to == null)                    return TxType.expense;
  if (from == null && to != null && tg != AccountGroup.personal)    return TxType.invoice;
  if (from != null && fg != AccountGroup.personal && to == null)    return TxType.bill;
  if (fg == AccountGroup.personal && tg == AccountGroup.personal)   return TxType.transfer;
  if (fg == AccountGroup.personal && to != null) {
    return to.balance < 0 ? TxType.settlement : TxType.advance;
  }
  if (from != null && tg == AccountGroup.personal) {
    return from.balance > 0 ? TxType.collection : TxType.loan;
  }
  if (from != null && to != null) return TxType.offset;

  return TxType.expense;
}

class Account {
  final String id;
  String name;
  AccountGroup group;

  /// Native balance in this account's own currency (Rule 2).
  /// For net-worth calculations always multiply by a live FX rate (Rule 5).
  double balance;

  /// ISO-4217 currency code assigned at creation time and immutable (Rule 2).
  /// Every account holds exactly one currency; users create separate accounts
  /// for separate currencies.
  String currencyCode;

  /// Bank overdraft / salary-advance facility in this account's currency.
  /// [balance] is the **book** position (negative = you owe the bank).
  /// Spending headroom ≈ [balance] + [overdraftLimit] (e.g. balance -6800,
  /// limit 13600 → 6800 still available). When 0, there is no facility.
  double overdraftLimit;

  /// Hidden from pickers and Review lists; restore from Settings.
  bool archived;

  final DateTime createdAt;
  int sortOrder;

  Account({
    String? id,
    required this.name,
    AccountGroup? group,
    this.balance = 0.0,
    this.currencyCode = 'BAM',
    this.overdraftLimit = 0.0,
    this.archived = false,
    DateTime? createdAt,
    this.sortOrder = 0,
  }) : id = id ?? const Uuid().v4(),
       group = group ?? AccountGroup.personal,
       createdAt = createdAt ?? DateTime.now();

  bool get hasOverdraftFacility => overdraftLimit > 0;

  /// Amount still usable for spending with an active overdraft/advance line.
  /// Below zero means over the agreed facility.
  double get availableToSpend =>
      hasOverdraftFacility ? balance + overdraftLimit : balance;

  /// Personal “Balance” hero / Plan personal row: [bookNative] plus overdraft line
  /// (same as [availableToSpend] when [bookNative] is current [balance]). Net worth
  /// uses book only so facility does not double-count debt vs spending power.
  double personalHeadroomNative(double bookNative) =>
      hasOverdraftFacility ? bookNative + overdraftLimit : bookNative;

  Account copyWith({
    String? name,
    AccountGroup? group,
    double? balance,
    String? currencyCode,
    double? overdraftLimit,
    bool? archived,
    DateTime? createdAt,
    int? sortOrder,
  }) => Account(
    id: id,
    name: name ?? this.name,
    group: group ?? this.group,
    balance: balance ?? this.balance,
    currencyCode: currencyCode ?? this.currencyCode,
    overdraftLimit: overdraftLimit ?? this.overdraftLimit,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Account && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
