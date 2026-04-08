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

  /// Optional bank, issuer, or place where the account lives. Shown as
  /// "Name (Institution)" in lists when non-empty.
  String? institution;

  AccountGroup group;

  /// Material icon code point; `0` means show the first letter of [name].
  int iconCodePoint;

  /// Custom avatar background as [Color.value]; null uses theme by [group].
  int? colorArgb;

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

  /// Last time this row was written to local storage (sync / conflict helpers).
  DateTime? updatedAt;

  int sortOrder;

  Account({
    String? id,
    required this.name,
    this.institution,
    AccountGroup? group,
    this.iconCodePoint = 0,
    this.colorArgb,
    this.balance = 0.0,
    this.currencyCode = 'BAM',
    this.overdraftLimit = 0.0,
    this.archived = false,
    DateTime? createdAt,
    this.updatedAt,
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
    String? institution,
    AccountGroup? group,
    int? iconCodePoint,
    int? colorArgb,
    double? balance,
    String? currencyCode,
    double? overdraftLimit,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? sortOrder,
  }) => Account(
    id: id,
    name: name ?? this.name,
    institution: institution ?? this.institution,
    group: group ?? this.group,
    iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    colorArgb: colorArgb ?? this.colorArgb,
    balance: balance ?? this.balance,
    currencyCode: currencyCode ?? this.currencyCode,
    overdraftLimit: overdraftLimit ?? this.overdraftLimit,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Account && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
