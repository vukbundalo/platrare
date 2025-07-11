// lib/models/account.dart

enum AccountType { personal, partner, vendor, incomeSource, category }

class Account {
  final String name;
  final AccountType type;
  final double balance;
  final bool includeInBalance;

  Account({
    required this.name,
    required this.type,
    required this.balance,
    required this.includeInBalance,
  });

  /// Add a copyWith so you can update balances immutably:
  Account copyWith({
    String? name,
    AccountType? type,
    double? balance,
    bool? includeInBalance,
  }) {
    return Account(
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      includeInBalance: includeInBalance ?? this.includeInBalance,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}
