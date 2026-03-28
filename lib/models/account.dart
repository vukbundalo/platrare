import 'package:uuid/uuid.dart';

enum AccountType { personal, partner, vendor, incomeSource, category }

/// Kept for backward compatibility with existing code that filters by group.
enum AccountGroup { personal, partner }

class Account {
  final String id;
  String name;
  AccountType type;
  double balance;
  bool includeInBalance;

  Account({
    String? id,
    required this.name,
    AccountType? type,
    AccountGroup? group,
    this.balance = 0.0,
    this.includeInBalance = true,
  }) : id = id ?? const Uuid().v4(),
       type = type ?? _groupToType(group ?? AccountGroup.personal);

  static AccountType _groupToType(AccountGroup g) =>
      g == AccountGroup.personal ? AccountType.personal : AccountType.partner;

  /// Maps type back to a two-value group for screens that only distinguish
  /// personal vs. everything else.
  AccountGroup get group =>
      type == AccountType.personal ? AccountGroup.personal : AccountGroup.partner;

  set group(AccountGroup g) => type = _groupToType(g);

  Account copyWith({
    String? name,
    AccountType? type,
    double? balance,
    bool? includeInBalance,
  }) => Account(
    id: id,
    name: name ?? this.name,
    type: type ?? this.type,
    balance: balance ?? this.balance,
    includeInBalance: includeInBalance ?? this.includeInBalance,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Account && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
