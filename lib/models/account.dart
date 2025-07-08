import 'package:platrare/models/enums.dart';

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
}