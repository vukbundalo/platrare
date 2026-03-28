import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import 'fx.dart' as fx;

/// Returns projected native balances for every account at end-of-day on [date],
/// starting from current real balances and applying planned transactions
/// whose date is on or before [date].
///
/// Balances remain in each account's own currency (Rule 2).
/// Use [personalTotal] / [netWorthInBase] to convert to the base currency.
Map<String, double> projectBalances(DateTime date) {
  final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
  final balances = {for (final a in data.accounts) a.id: a.balance};

  final sorted = List.of(data.plannedTransactions)
    ..sort((a, b) => a.date.compareTo(b.date));

  for (final pt in sorted) {
    if (pt.date.isAfter(dayEnd)) break;
    if (pt.nativeAmount != null) {
      // Deduct from source account in its native currency.
      if (pt.fromAccount != null) {
        balances[pt.fromAccount!.id] =
            (balances[pt.fromAccount!.id] ?? 0) - pt.nativeAmount!;
      }
      // Credit destination account.
      // Rule 4: cross-currency moves use destinationAmount for the receiving
      // account; same-currency moves use nativeAmount directly.
      if (pt.toAccount != null) {
        final credit = (pt.destinationAmount != null &&
                pt.toAccount!.currencyCode != pt.fromAccount?.currencyCode)
            ? pt.destinationAmount!
            : pt.nativeAmount!;
        balances[pt.toAccount!.id] =
            (balances[pt.toAccount!.id] ?? 0) + credit;
      }
    }
  }
  return balances;
}

/// Sum of projected personal account balances converted to base currency
/// using LIVE exchange rates (Rule 5).
double personalTotal(Map<String, double> balances) {
  return data.accounts
      .where((a) => a.group == AccountGroup.personal)
      .fold(0.0, (sum, a) {
    final native = balances[a.id] ?? a.balance;
    return sum + fx.toBase(native, a.currencyCode);
  });
}

/// Sum of ALL accounts (that opt-in) converted to base currency at live rates.
double netWorthInBase(Map<String, double> balances) {
  return data.accounts
      .where((a) => a.includeInBalance)
      .fold(0.0, (sum, a) {
    final native = balances[a.id] ?? a.balance;
    return sum + fx.toBase(native, a.currencyCode);
  });
}

/// Convenience: live balance currency label for the base currency.
String get baseCurrencySymbol => fx.currencySymbol(settings.baseCurrency);
