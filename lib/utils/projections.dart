import 'package:flutter/material.dart' show DateUtils;

import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import 'fx.dart' as fx;

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Returns historical native balances for every account at end-of-day on
/// [date] by taking current real balances and reversing all transactions
/// that occurred strictly after [date].
Map<String, double> historicalBalances(DateTime date) {
  final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
  final balances = {for (final a in data.accounts) a.id: a.balance};

  for (final t in data.transactions) {
    if (t.nativeAmount == null) continue;
    if (!t.date.isAfter(dayEnd)) continue; // only reverse post-date txns

    if (t.fromAccount != null) {
      balances[t.fromAccount!.id] =
          (balances[t.fromAccount!.id] ?? 0) + t.nativeAmount!;
    }
    if (t.toAccount != null) {
      final credit = (t.destinationAmount != null &&
              t.toAccount!.currencyCode != t.fromAccount?.currencyCode)
          ? t.destinationAmount!
          : t.nativeAmount!;
      balances[t.toAccount!.id] =
          (balances[t.toAccount!.id] ?? 0) - credit;
    }
  }

  return balances;
}

/// Returns projected native balances for every account at end-of-day on [date],
/// starting from current real balances and applying planned transactions
/// whose date is on or before [date].
///
/// Repeated transactions are expanded into all occurrences up to [date].
/// Balances remain in each account's own currency (Rule 2).
/// Use [personalTotal] (book + overdraft on personal) / [netWorthInBase] (book only).
Map<String, double> projectBalances(DateTime date) {
  final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);
  final balances = {for (final a in data.accounts) a.id: a.balance};

  for (final pt in data.plannedTransactions) {
    if (pt.nativeAmount == null) continue;

    // Walk every occurrence of this planned transaction up to dayEnd.
    //
    // Do not use [shouldSpawnNextOccurrence] here: it is defined for “spawn the
    // next row after a confirm” and only looks at [repeatConfirmedCount], which
    // never increases during this simulation. That made capped series
    // (repeatEndAfter) iterate until dayEnd as if they were infinite — freezing
    // the UI when the projection date is far out (e.g. months ahead).
    DateTime occurrence = DateUtils.dateOnly(pt.date);
    var appliedHere = 0;
    var guard = 0;
    const maxOccurrencesPerPlanned = 50000;

    while (true) {
      if (++guard > maxOccurrencesPerPlanned) break;

      final occEnd = DateTime(
          occurrence.year, occurrence.month, occurrence.day, 23, 59, 59);
      if (occEnd.isAfter(dayEnd)) break;

      if (pt.repeatEndAfter != null &&
          pt.repeatConfirmedCount + appliedHere >= pt.repeatEndAfter!) {
        break;
      }

      if (pt.fromAccount != null) {
        balances[pt.fromAccount!.id] =
            (balances[pt.fromAccount!.id] ?? 0) - pt.nativeAmount!;
      }
      if (pt.toAccount != null) {
        final credit = (pt.destinationAmount != null &&
                pt.toAccount!.currencyCode != pt.fromAccount?.currencyCode)
            ? pt.destinationAmount!
            : pt.nativeAmount!;
        balances[pt.toAccount!.id] =
            (balances[pt.toAccount!.id] ?? 0) + credit;
      }
      appliedHere++;

      if (pt.repeatInterval == RepeatInterval.none) break;

      final next = nextPlannedEffectiveDate(pt, occurrence);
      if (!next.isAfter(occurrence)) break;

      if (pt.repeatEndDate != null &&
          _dateOnly(next).isAfter(_dateOnly(pt.repeatEndDate!))) {
        break;
      }
      if (pt.repeatEndAfter != null &&
          pt.repeatConfirmedCount + appliedHere >= pt.repeatEndAfter!) {
        break;
      }

      occurrence = next;
    }
  }

  return balances;
}

/// Projected personal **headroom** (book + overdraft where set) at live rates.
double personalTotal(Map<String, double> balances) {
  return data.accounts
      .where((a) => a.group == AccountGroup.personal)
      .fold(0.0, (sum, a) {
    final book = balances[a.id] ?? a.balance;
    final native = a.personalHeadroomNative(book);
    return sum + fx.toBase(native, a.currencyCode);
  });
}

/// Sum of ALL accounts’ **book** balances at live rates (real net position).
double netWorthInBase(Map<String, double> balances) {
  return data.accounts.fold(0.0, (sum, a) {
    final native = balances[a.id] ?? a.balance;
    return sum + fx.toBase(native, a.currencyCode);
  });
}

/// Convenience: live balance currency label for the base currency.
String get baseCurrencySymbol => fx.currencySymbol(settings.baseCurrency);
