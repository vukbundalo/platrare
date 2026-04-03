import 'package:intl/intl.dart';

import '../models/planned_transaction.dart';
import '../models/transaction.dart';

/// Groups transactions by calendar day for Track / account history lists.
class DayGroupedTransactions {
  DayGroupedTransactions._(this.dayKeys, this.grouped);

  final List<String> dayKeys;
  final Map<String, List<Transaction>> grouped;

  static DayGroupedTransactions build(
    List<Transaction> txs,
    bool newestFirst,
  ) {
    final grouped = <String, List<Transaction>>{};
    for (final t in txs) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => newestFirst
          ? b.date.compareTo(a.date)
          : a.date.compareTo(b.date));
    }
    final days = grouped.keys.toList()
      ..sort((a, b) => newestFirst ? b.compareTo(a) : a.compareTo(b));
    return DayGroupedTransactions._(days, grouped);
  }
}

/// Groups planned items by calendar day for Plan timeline.
class DayGroupedPlanned {
  DayGroupedPlanned._(this.dayKeys, this.grouped);

  final List<String> dayKeys;
  final Map<String, List<PlannedTransaction>> grouped;

  static DayGroupedPlanned build(
    List<PlannedTransaction> pts,
    bool newestFirst,
  ) {
    final grouped = <String, List<PlannedTransaction>>{};
    for (final p in pts) {
      final key = DateFormat('yyyy-MM-dd').format(p.date);
      grouped.putIfAbsent(key, () => []).add(p);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => newestFirst
          ? b.date.compareTo(a.date)
          : a.date.compareTo(b.date));
    }
    final days = grouped.keys.toList()
      ..sort((a, b) => newestFirst ? b.compareTo(a) : a.compareTo(b));
    return DayGroupedPlanned._(days, grouped);
  }
}

/// Lazy-load day sections when "all time" would create many slivers.
bool shouldLazyLoadDaySections(String? dateFilter, int dayCount) =>
    dateFilter == 'all' && dayCount > 10;

const kLazyDayInitialCount = 28;
const kLazyDayLoadBatch = 24;
