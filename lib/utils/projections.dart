import '../data/app_data.dart' as data;
import '../models/account.dart';

/// Returns projected balances for every account at end-of-day on [date],
/// starting from current real balances and applying planned transactions
/// whose date is on or before [date].
Map<String, double> projectBalances(DateTime date) {
  final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
  final balances = {for (final a in data.accounts) a.id: a.balance};

  final sorted = List.of(data.plannedTransactions)
    ..sort((a, b) => a.date.compareTo(b.date));

  for (final pt in sorted) {
    if (pt.date.isAfter(dayEnd)) break;
    if (pt.amount != null) {
      if (pt.fromAccount != null) {
        balances[pt.fromAccount!.id] =
            (balances[pt.fromAccount!.id] ?? 0) - pt.amount!;
      }
      if (pt.toAccount != null) {
        balances[pt.toAccount!.id] =
            (balances[pt.toAccount!.id] ?? 0) + pt.amount!;
      }
    }
  }
  return balances;
}

double personalTotal(Map<String, double> balances) {
  return data.accounts
      .where((a) => a.group == AccountGroup.personal)
      .fold(0.0, (sum, a) => sum + (balances[a.id] ?? a.balance));
}
