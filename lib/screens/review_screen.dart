import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/account_lifecycle.dart';
import '../data/app_data.dart' as data;
import '../data/currency_localized_names.dart';
import '../data/data_repository.dart';
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_format.dart';
import '../utils/balance_correction.dart';
import '../utils/fx.dart' as fx;
import 'account_transactions_screen.dart';
import 'settings_screen.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/review_stats_empty_state.dart';

/// Shared category order for compare mode: max per side, then combined, then name.
List<String> _orderedCategoryKeysForCompare(
  Map<String, ({double total, int count})> sideA,
  Map<String, ({double total, int count})> sideB,
  Map<String, ({double total, int count})> lifetime,
) {
  final keys = <String>{...sideA.keys, ...sideB.keys, ...lifetime.keys};
  final list = keys.toList();
  list.sort((k1, k2) {
    final t1a = sideA[k1]?.total ?? 0;
    final t1b = sideB[k1]?.total ?? 0;
    final t2a = sideA[k2]?.total ?? 0;
    final t2b = sideB[k2]?.total ?? 0;
    final m1 = math.max(t1a, t1b);
    final m2 = math.max(t2a, t2b);
    final c = m2.compareTo(m1);
    if (c != 0) return c;
    final s1 = t1a + t1b;
    final s2 = t2a + t2b;
    final c2 = s2.compareTo(s1);
    if (c2 != 0) return c2;
    return k1.compareTo(k2);
  });
  return list;
}

/// Picks the category to compare: [stored] if still valid, otherwise first key.
String? _pickCompareCategoryKey(List<String> keys, String? stored) {
  if (keys.isEmpty) return null;
  if (stored != null && keys.contains(stored)) return stored;
  return keys.first;
}

// ─── Calendar 3M / 6M (quarters & half-years) ─────────────────────────────────

int _calendarQuarter(int month) => ((month - 1) ~/ 3) + 1;

DateTime _quarterStart(int year, int quarter) =>
    DateTime(year, (quarter - 1) * 3 + 1, 1);

DateTime _quarterEndExclusive(int year, int quarter) {
  if (quarter == 4) return DateTime(year + 1, 1, 1);
  return DateTime(year, quarter * 3 + 1, 1);
}

({DateTime start, DateTime end}) _boundsQuarterContaining(int year, int month) {
  final q = _calendarQuarter(month);
  return (
    start: _quarterStart(year, q),
    end: _quarterEndExclusive(year, q),
  );
}

({DateTime start, DateTime end}) _boundsHalfYearContaining(int year, int month) {
  if (month <= 6) {
    return (start: DateTime(year, 1, 1), end: DateTime(year, 7, 1));
  }
  return (start: DateTime(year, 7, 1), end: DateTime(year + 1, 1, 1));
}

DateTime _quarterStartContaining(DateTime d) =>
    _quarterStart(d.year, _calendarQuarter(d.month));

DateTime _halfYearStartContaining(DateTime d) =>
    d.month <= 6 ? DateTime(d.year, 1, 1) : DateTime(d.year, 7, 1);

({DateTime start, DateTime end}) _quarterByOffsetFrom(DateTime now, int offset) {
  var y = now.year;
  var q = _calendarQuarter(now.month);
  for (var i = 0; i < offset; i++) {
    q--;
    if (q < 1) {
      q = 4;
      y--;
    }
  }
  return (
    start: _quarterStart(y, q),
    end: _quarterEndExclusive(y, q),
  );
}

({DateTime start, DateTime end}) _halfYearByOffsetFrom(DateTime now, int offset) {
  var y = now.year;
  var h = now.month <= 6 ? 1 : 2;
  for (var i = 0; i < offset; i++) {
    if (h == 1) {
      h = 2;
      y--;
    } else {
      h = 1;
    }
  }
  return _boundsHalfYearContaining(y, h == 1 ? 1 : 7);
}

class ReviewScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const ReviewScreen({super.key, this.onChanged});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _displayCurrency = settings.baseCurrency;
  // 'personal' | 'individuals' | 'entities' | 'statistics' | null
  /// Opens with Personal expanded so account cards are visible without an extra tap.
  String? _activeSection = 'personal';
  // 'expense' | 'income' | null
  String? _activeStats;
  // 0 = all time, 1 = calendar month, 3 = calendar quarter, 6 = half-year, 12 = year
  int _spendingMonths = 1;
  // 0 = bars, 1 = donut
  int _vizMode = 0;
  // how many periods back from current (0 = most recent)
  int _dateOffset = 0;

  bool _compareMode = false;
  late DateTime _compareMonthA;
  late DateTime _compareMonthB;
  /// User-selected category for compare mode (falls back to first available key).
  String? _compareCategoryExpense;
  String? _compareCategoryIncome;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _compareMonthB = DateTime(now.year, now.month, 1);
    _compareMonthA = now.month == 1
        ? DateTime(now.year - 1, 12, 1)
        : DateTime(now.year, now.month - 1, 1);
  }

  DateTime get _compareEarliestMonth {
    final e = _earliestTxDate;
    if (e == null) return DateTime(DateTime.now().year - 5, 1, 1);
    return DateTime(e.year, e.month, 1);
  }

  DateTime get _compareLatestMonth =>
      DateTime(DateTime.now().year, DateTime.now().month, 1);

  /// Returns null if that direction is out of bounds (earliest/latest tx month).
  /// For 3M / 6M, steps one **quarter** or **half-year** so each tap changes the window
  /// (monthly steps would repeat the same quarter three or six times).
  DateTime? _compareShiftMonth(DateTime anchor, int direction) {
    final cur = DateTime(anchor.year, anchor.month, 1);
    if (_spendingMonths == 12) {
      if (direction < 0) {
        final prev = DateTime(cur.year - 1, 1, 1);
        if (prev.year >= _compareEarliestMonth.year) return prev;
        return null;
      }
      final next = DateTime(cur.year + 1, 1, 1);
      if (next.year <= _compareLatestMonth.year) return next;
      return null;
    }
    if (_spendingMonths == 3) {
      final qStart = _quarterStartContaining(cur);
      final delta = direction < 0 ? -3 : 3;
      final raw = DateTime(qStart.year, qStart.month + delta, 1);
      final nextStart = _quarterStartContaining(raw);
      if (direction < 0) {
        if (nextStart.isBefore(_compareEarliestMonth)) return null;
        return nextStart;
      }
      if (nextStart.isAfter(_compareLatestMonth)) return null;
      return nextStart;
    }
    if (_spendingMonths == 6) {
      final hStart = _halfYearStartContaining(cur);
      final delta = direction < 0 ? -6 : 6;
      final raw = DateTime(hStart.year, hStart.month + delta, 1);
      final nextStart = _halfYearStartContaining(raw);
      if (direction < 0) {
        if (nextStart.isBefore(_compareEarliestMonth)) return null;
        return nextStart;
      }
      if (nextStart.isAfter(_compareLatestMonth)) return null;
      return nextStart;
    }
    if (direction < 0) {
      final prev = cur.month == 1
          ? DateTime(cur.year - 1, 12, 1)
          : DateTime(cur.year, cur.month - 1, 1);
      if (!prev.isBefore(_compareEarliestMonth)) return prev;
      return null;
    }
    final next = cur.month == 12
        ? DateTime(cur.year + 1, 1, 1)
        : DateTime(cur.year, cur.month + 1, 1);
    if (!next.isAfter(_compareLatestMonth)) return next;
    return null;
  }

  bool _compareCanNavigateBackFor(DateTime anchor) =>
      _compareShiftMonth(anchor, -1) != null;

  bool _compareCanNavigateForwardFor(DateTime anchor) =>
      _compareShiftMonth(anchor, 1) != null;

  void _compareNavigateBackA() {
    final n = _compareShiftMonth(_compareMonthA, -1);
    if (n != null) setState(() => _compareMonthA = n);
  }

  void _compareNavigateForwardA() {
    final n = _compareShiftMonth(_compareMonthA, 1);
    if (n != null) setState(() => _compareMonthA = n);
  }

  void _compareNavigateBackB() {
    final n = _compareShiftMonth(_compareMonthB, -1);
    if (n != null) setState(() => _compareMonthB = n);
  }

  void _compareNavigateForwardB() {
    final n = _compareShiftMonth(_compareMonthB, 1);
    if (n != null) setState(() => _compareMonthB = n);
  }

  /// Compare window [start, end) for a period anchored at the first day of [anchorMonth].
  ({DateTime? start, DateTime? end}) _compareBounds(DateTime anchorMonth) {
    final a = DateTime(anchorMonth.year, anchorMonth.month, 1);
    switch (_spendingMonths) {
      case 1:
        return (start: a, end: DateTime(a.year, a.month + 1, 1));
      case 3:
        final q = _boundsQuarterContaining(a.year, a.month);
        return (start: q.start, end: q.end);
      case 6:
        final h = _boundsHalfYearContaining(a.year, a.month);
        return (start: h.start, end: h.end);
      case 12:
        return (
          start: DateTime(a.year, 1, 1),
          end: DateTime(a.year + 1, 1, 1),
        );
      default:
        return (start: a, end: DateTime(a.year, a.month + 1, 1));
    }
  }

  String _compareRangeLabel(BuildContext context, DateTime anchorMonth) {
    final l10n = AppLocalizations.of(context);
    final b = _compareBounds(anchorMonth);
    final s = b.start;
    final e = b.end;
    if (s == null || e == null) return l10n.statsAllTime;
    if (_spendingMonths == 1) return formatAppDate(context, 'MMMM yyyy', s);
    if (_spendingMonths == 12) return '${s.year}';
    final lastMonth = DateTime(e.year, e.month - 1, 1);
    if (s.year == lastMonth.year) {
      return '${formatAppDate(context, 'MMM', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
    }
    return '${formatAppDate(context, 'MMM yyyy', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
  }

  /// Same windows as [_compareRangeLabel] but months always abbreviated (MMM).
  String _compareMiniNavRangeLabel(
      BuildContext context, DateTime anchorMonth) {
    final l10n = AppLocalizations.of(context);
    final b = _compareBounds(anchorMonth);
    final s = b.start;
    final e = b.end;
    if (s == null || e == null) return l10n.statsAllTime;
    if (_spendingMonths == 1) return formatAppDate(context, 'MMM yyyy', s);
    if (_spendingMonths == 12) return '${s.year}';
    final lastMonth = DateTime(e.year, e.month - 1, 1);
    if (s.year == lastMonth.year) {
      return '${formatAppDate(context, 'MMM', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
    }
    return '${formatAppDate(context, 'MMM yyyy', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
  }

  String _periodLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (_spendingMonths) {
      1 => l10n.period1M,
      3 => l10n.period3M,
      6 => l10n.period6M,
      12 => l10n.period1Y,
      _ => l10n.periodAll,
    };
  }

  void _cyclePeriod() => setState(() {
    _dateOffset = 0;
    if (_compareMode) {
      _spendingMonths = switch (_spendingMonths) {
        1 => 3,
        3 => 6,
        6 => 12,
        _ => 1,
      };
      if (_spendingMonths == 12) {
        _compareMonthA = DateTime(_compareMonthA.year, 1, 1);
        _compareMonthB = DateTime(_compareMonthB.year, 1, 1);
      } else if (_spendingMonths == 3) {
        _compareMonthA = _quarterStartContaining(_compareMonthA);
        _compareMonthB = _quarterStartContaining(_compareMonthB);
      } else if (_spendingMonths == 6) {
        _compareMonthA = _halfYearStartContaining(_compareMonthA);
        _compareMonthB = _halfYearStartContaining(_compareMonthB);
      }
    } else {
      _spendingMonths = switch (_spendingMonths) {
        1 => 3, 3 => 6, 6 => 12, 12 => 0, _ => 1,
      };
    }
  });

  void _cycleViz() => setState(() => _vizMode = (_vizMode + 1) % 2);
  void _navigateBack() => setState(() => _dateOffset++);
  void _navigateForward() => setState(() { if (_dateOffset > 0) _dateOffset--; });

  // The active date window (start inclusive, end exclusive). null = no filter.
  ({DateTime? start, DateTime? end}) get _dateRange {
    if (_spendingMonths == 0) return (start: null, end: null);
    final now = DateTime.now();
    if (_spendingMonths == 12) {
      final year = now.year - _dateOffset;
      return (start: DateTime(year, 1, 1), end: DateTime(year + 1, 1, 1));
    }
    if (_spendingMonths == 3) {
      final r = _quarterByOffsetFrom(now, _dateOffset);
      return (start: r.start, end: r.end);
    }
    if (_spendingMonths == 6) {
      final r = _halfYearByOffsetFrom(now, _dateOffset);
      return (start: r.start, end: r.end);
    }
    final endM = now.month + 1 - _dateOffset * _spendingMonths;
    return (
      start: DateTime(now.year, endM - _spendingMonths, 1),
      end: DateTime(now.year, endM, 1),
    );
  }

  DateTime? get _earliestTxDate => data.transactions.isEmpty
      ? null
      : data.transactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);

  String _dateRangeLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    if (_spendingMonths == 0) {
      final earliest = _earliestTxDate;
      if (earliest == null) return l10n.statsAllTime;
      return '${formatAppDate(context, 'MMM yyyy', earliest)} – ${formatAppDate(context, 'MMM yyyy', now)}';
    }
    if (_spendingMonths == 12) return '${now.year - _dateOffset}';
    final range = _dateRange;
    final s = range.start!;
    final lastMonth = DateTime(range.end!.year, range.end!.month - 1, 1);
    if (_spendingMonths == 1) return formatAppDate(context, 'MMMM yyyy', s);
    if (s.year == lastMonth.year) {
      return '${formatAppDate(context, 'MMM', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
    }
    return '${formatAppDate(context, 'MMM yyyy', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
  }

  // ── Account mutations ──────────────────────────────────────────────────────

  AccountGroup? get _activeGroupFromSection => switch (_activeSection) {
        'personal' => AccountGroup.personal,
        'individuals' => AccountGroup.individuals,
        'entities' => AccountGroup.entities,
        _ => null,
      };

  Future<void> _addAccount() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) =>
              AccountFormScreen(initialGroup: _activeGroupFromSection)),
    );
    if (result == true) {
      setState(() {});
      widget.onChanged?.call();
    }
  }

  Future<void> _editAccount(Account account) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => AccountFormScreen(existing: account)),
    );
    if (result == true) {
      setState(() {});
      widget.onChanged?.call();
    }
  }

  void _openAccountTransactions(Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AccountTransactionsScreen(account: account)),
    );
  }

  // ── Computed values ────────────────────────────────────────────────────────

  // Rule 5: multiply CURRENT native balances by CURRENT live rates.
  // Never sum historical locked baseAmounts for the balance sheet.
  /// Personal spending power: **book + overdraft limit** per account at live FX.
  /// (Bank line increases what you can use without changing ledger net.)
  double get _personalTotal => data.accounts
      .where((a) => a.group == AccountGroup.personal)
      .fold(0.0, (sum, a) => sum +
          fx.toBase(a.personalHeadroomNative(a.balance), a.currencyCode));

  /// True net: sum of **ledger** balances only at live FX (overdraft limit excluded).
  double get _netTotal => data.accounts.fold(
      0.0,
      (sum, a) => sum + fx.toBase(a.balance, a.currencyCode));

  Map<String, ({double total, int count})> _categoryIncomeInRange(
      DateTime? rangeStart, DateTime? rangeEnd) {
    final result = <String, ({double total, int count})>{};
    for (final t in data.transactions) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      const incomeTypes = {
        TxType.income, TxType.invoice, TxType.collection, TxType.loan,
      };
      if (!incomeTypes.contains(type)) continue;
      if (t.nativeAmount == null) continue;
      if (rangeStart != null && t.date.isBefore(rangeStart)) continue;
      if (rangeEnd != null && !t.date.isBefore(rangeEnd)) continue;

      final baseValue = fx.toBase(
          t.nativeAmount!, t.currencyCode ?? settings.baseCurrency);

      final key = t.category ?? 'Uncategorized';
      final existing = result[key];
      if (existing == null) {
        result[key] = (total: baseValue, count: 1);
      } else {
        result[key] = (
          total: existing.total + baseValue,
          count: existing.count + 1,
        );
      }
    }
    return result;
  }

  Map<String, ({double total, int count})> get _categoryIncome {
    final range = _dateRange;
    return _categoryIncomeInRange(range.start, range.end);
  }

  Map<String, ({double total, int count})> _categorySpendingInRange(
      DateTime? rangeStart, DateTime? rangeEnd) {
    final result = <String, ({double total, int count})>{};
    for (final t in data.transactions) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      const expenseTypes = {
        TxType.expense, TxType.settlement, TxType.advance,
      };
      if (!expenseTypes.contains(type)) continue;
      if (t.nativeAmount == null) continue;
      if (rangeStart != null && t.date.isBefore(rangeStart)) continue;
      if (rangeEnd != null && !t.date.isBefore(rangeEnd)) continue;

      final baseValue = fx.toBase(
          t.nativeAmount!, t.currencyCode ?? settings.baseCurrency);

      final key = t.category ?? 'Uncategorized';
      final existing = result[key];
      if (existing == null) {
        result[key] = (total: baseValue, count: 1);
      } else {
        result[key] = (
          total: existing.total + baseValue,
          count: existing.count + 1,
        );
      }
    }
    return result;
  }

  Map<String, ({double total, int count})> get _categorySpending {
    final range = _dateRange;
    return _categorySpendingInRange(range.start, range.end);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final visibleAccounts = activeAccounts(data.accounts);
    final personal = visibleAccounts
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final individuals = visibleAccounts
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final entities = visibleAccounts
        .where((a) => a.group == AccountGroup.entities)
        .toList();
    // Spent vs received: always one selected; fallback avoids empty body if unset.
    final statsTab = _activeStats ?? 'expense';

    List<MapEntry<String, ({double total, int count})>>? compareExpenseRowsA;
    List<MapEntry<String, ({double total, int count})>>? compareExpenseRowsB;
    List<MapEntry<String, ({double total, int count})>>? compareIncomeRowsA;
    List<MapEntry<String, ({double total, int count})>>? compareIncomeRowsB;

    var compareExpenseCategoryKeys = const <String>[];
    var compareIncomeCategoryKeys = const <String>[];
    String? effectiveCompareExpenseCategory;
    String? effectiveCompareIncomeCategory;

    if (_activeSection == 'statistics' &&
        _compareMode &&
        data.transactions.isNotEmpty) {
      final ba = _compareBounds(_compareMonthA);
      final bb = _compareBounds(_compareMonthB);
      final ma = _categorySpendingInRange(ba.start, ba.end);
      final mb = _categorySpendingInRange(bb.start, bb.end);
      final mLife = _categorySpendingInRange(null, null);
      compareExpenseCategoryKeys =
          _orderedCategoryKeysForCompare(ma, mb, mLife);
      effectiveCompareExpenseCategory = _pickCompareCategoryKey(
          compareExpenseCategoryKeys, _compareCategoryExpense);

      final ia = _categoryIncomeInRange(ba.start, ba.end);
      final ib = _categoryIncomeInRange(bb.start, bb.end);
      final iLife = _categoryIncomeInRange(null, null);
      compareIncomeCategoryKeys =
          _orderedCategoryKeysForCompare(ia, ib, iLife);
      effectiveCompareIncomeCategory = _pickCompareCategoryKey(
          compareIncomeCategoryKeys, _compareCategoryIncome);

      final sk = effectiveCompareExpenseCategory;
      if (sk != null) {
        compareExpenseRowsA = [
          MapEntry(sk, ma[sk] ?? (total: 0.0, count: 0)),
        ];
        compareExpenseRowsB = [
          MapEntry(sk, mb[sk] ?? (total: 0.0, count: 0)),
        ];
      } else {
        compareExpenseRowsA = [];
        compareExpenseRowsB = [];
      }

      final ik = effectiveCompareIncomeCategory;
      if (ik != null) {
        compareIncomeRowsA = [
          MapEntry(ik, ia[ik] ?? (total: 0.0, count: 0)),
        ];
        compareIncomeRowsB = [
          MapEntry(ik, ib[ik] ?? (total: 0.0, count: 0)),
        ];
      } else {
        compareIncomeRowsA = [];
        compareIncomeRowsB = [];
      }
    }

    final compareExpenseA = compareExpenseRowsA;
    final compareExpenseB = compareExpenseRowsB;
    final compareIncomeA = compareIncomeRowsA;
    final compareIncomeB = compareIncomeRowsB;

    return Scaffold(
      floatingActionButton: visibleAccounts.isEmpty
          ? null
          : FloatingActionButton(
              heroTag: 'review_fab',
              onPressed: _addAccount,
              tooltip: l10n.tooltipAddAccount,
              child: const Icon(Icons.add_rounded),
            ),
      body: CustomScrollView(
        slivers: [
          // ── App bar with net worth ────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: Text(l10n.navReview),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: l10n.tooltipSettings,
                onPressed: () async {
                  final prevSecondary = settings.secondaryCurrency;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()),
                  );
                  if (mounted) {
                    setState(() {
                      if (_displayCurrency == prevSecondary) {
                        _displayCurrency = settings.secondaryCurrency;
                      }
                      final validCurrencies = [settings.secondaryCurrency, settings.baseCurrency];
                      if (!validCurrencies.contains(_displayCurrency)) {
                        _displayCurrency = settings.baseCurrency;
                      }
                    });
                    // Rebuild Track and Plan screens too so their
                    // base-currency totals/symbols update immediately.
                    widget.onChanged?.call();
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _NetWorthHero(
                      personal: _personalTotal,
                      net: _netTotal,
                      displayCurrency: _displayCurrency,
                      sectionChipsEnabled: visibleAccounts.isNotEmpty,
                      activeSection: _activeSection,
                      onSelectSection: (s) => setState(() {
                        if (_activeSection == s) {
                          _activeSection = null;
                        } else {
                          _activeSection = s;
                          if (s == 'statistics' && _activeStats == null) {
                            _activeStats = 'expense';
                          }
                        }
                      }),
                      onToggleCurrency: () => setState(() {
                        _displayCurrency =
                            _displayCurrency == settings.baseCurrency
                                ? settings.secondaryCurrency
                                : settings.baseCurrency;
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (visibleAccounts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyAccountsHint(onAdd: _addAccount),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Accounts (per-group toggles) ─────────────────────────
                  if (_activeSection == 'personal' && personal.isNotEmpty) ...[
                    _SectionLabel(
                        l10nAccountSectionTitle(context, AccountGroup.personal)),
                    ...personal.map(
                      (a) => _AccountCard(
                          account: a,
                          displayCurrency: _displayCurrency,
                          onTap: () => _openAccountTransactions(a),
                          onLongPress: () => _editAccount(a)),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (_activeSection == 'individuals' && individuals.isNotEmpty) ...[
                    _SectionLabel(l10nAccountSectionTitle(
                        context, AccountGroup.individuals)),
                    ...individuals.map(
                      (a) => _AccountCard(
                          account: a,
                          displayCurrency: _displayCurrency,
                          onTap: () => _openAccountTransactions(a),
                          onLongPress: () => _editAccount(a)),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (_activeSection == 'entities' && entities.isNotEmpty) ...[
                    _SectionLabel(
                        l10nAccountSectionTitle(context, AccountGroup.entities)),
                    ...entities.map(
                      (a) => _AccountCard(
                          account: a,
                          displayCurrency: _displayCurrency,
                          onTap: () => _openAccountTransactions(a),
                          onLongPress: () => _editAccount(a)),
                    ),
                    const SizedBox(height: 4),
                  ],

                  // ── Statistics ────────────────────────────────────────────
                  if (_activeSection == 'statistics' && data.transactions.isEmpty) ...[
                    const ReviewStatsEmptyState(),
                  ],
                  if (_activeSection == 'statistics' && data.transactions.isNotEmpty) ...[
                    _StatsHeader(
                      activeStats: statsTab,
                      onSelectStats: (s) => setState(() {
                        // Always keep exactly one of expense/income selected.
                        _activeStats = s;
                      }),
                      periodLabel: _periodLabel(context),
                      spendingMonths: _spendingMonths,
                      dateRangeLabel: _dateRangeLabel(context),
                      onCyclePeriod: _cyclePeriod,
                      canNavigateForward: _dateOffset > 0,
                      onNavigateBack: _navigateBack,
                      onNavigateForward: _navigateForward,
                      vizMode: _vizMode,
                      onCycleViz: _cycleViz,
                      compareMode: _compareMode,
                      onToggleCompare: () => setState(() {
                        _compareMode = !_compareMode;
                        if (_compareMode && _spendingMonths == 0) {
                          _spendingMonths = 1;
                        }
                      }),
                      compareCategoryKeys: _compareMode
                          ? (statsTab == 'expense'
                              ? compareExpenseCategoryKeys
                              : compareIncomeCategoryKeys)
                          : const [],
                      compareSelectedCategory: _compareMode
                          ? (statsTab == 'expense'
                              ? effectiveCompareExpenseCategory
                              : effectiveCompareIncomeCategory)
                          : null,
                      onCompareCategoryChanged: _compareMode
                          ? (String v) => setState(() {
                                if (statsTab == 'expense') {
                                  _compareCategoryExpense = v;
                                } else {
                                  _compareCategoryIncome = v;
                                }
                              })
                          : null,
                    ),
                    if (statsTab == 'expense' &&
                        _compareMode &&
                        effectiveCompareExpenseCategory != null &&
                        compareExpenseA != null &&
                        compareExpenseA.isNotEmpty &&
                        compareExpenseB != null &&
                        compareExpenseB.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                        child: _CompareCategoryAmountsPanel(
                          colorScheme: cs,
                          categoryName: effectiveCompareExpenseCategory,
                          semanticLabelA:
                              _compareRangeLabel(context, _compareMonthA),
                          semanticLabelB:
                              _compareRangeLabel(context, _compareMonthB),
                          dateRangeLabelA:
                              _compareMiniNavRangeLabel(
                                  context, _compareMonthA),
                          dateRangeLabelB:
                              _compareMiniNavRangeLabel(
                                  context, _compareMonthB),
                          canBackA: _compareCanNavigateBackFor(_compareMonthA),
                          canForwardA:
                              _compareCanNavigateForwardFor(_compareMonthA),
                          canBackB: _compareCanNavigateBackFor(_compareMonthB),
                          canForwardB:
                              _compareCanNavigateForwardFor(_compareMonthB),
                          onBackA: _compareNavigateBackA,
                          onForwardA: _compareNavigateForwardA,
                          onBackB: _compareNavigateBackB,
                          onForwardB: _compareNavigateForwardB,
                          amountABase: compareExpenseA.first.value.total,
                          amountBBase: compareExpenseB.first.value.total,
                          countA: compareExpenseA.first.value.count,
                          countB: compareExpenseB.first.value.count,
                          displayCurrency: _displayCurrency,
                          isExpense: true,
                        ),
                      ),
                    if (statsTab == 'expense' && !_compareMode)
                      _SpendingBody(
                        spending: _categorySpending,
                        periodLabel: _periodLabel(context),
                        spendingMonths: _spendingMonths,
                        vizMode: _vizMode,
                        displayCurrency: _displayCurrency,
                      ),
                    if (statsTab == 'income' &&
                        _compareMode &&
                        effectiveCompareIncomeCategory != null &&
                        compareIncomeA != null &&
                        compareIncomeA.isNotEmpty &&
                        compareIncomeB != null &&
                        compareIncomeB.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                        child: _CompareCategoryAmountsPanel(
                          colorScheme: cs,
                          categoryName: effectiveCompareIncomeCategory,
                          semanticLabelA:
                              _compareRangeLabel(context, _compareMonthA),
                          semanticLabelB:
                              _compareRangeLabel(context, _compareMonthB),
                          dateRangeLabelA:
                              _compareMiniNavRangeLabel(
                                  context, _compareMonthA),
                          dateRangeLabelB:
                              _compareMiniNavRangeLabel(
                                  context, _compareMonthB),
                          canBackA: _compareCanNavigateBackFor(_compareMonthA),
                          canForwardA:
                              _compareCanNavigateForwardFor(_compareMonthA),
                          canBackB: _compareCanNavigateBackFor(_compareMonthB),
                          canForwardB:
                              _compareCanNavigateForwardFor(_compareMonthB),
                          onBackA: _compareNavigateBackA,
                          onForwardA: _compareNavigateForwardA,
                          onBackB: _compareNavigateBackB,
                          onForwardB: _compareNavigateForwardB,
                          amountABase: compareIncomeA.first.value.total,
                          amountBBase: compareIncomeB.first.value.total,
                          countA: compareIncomeA.first.value.count,
                          countB: compareIncomeB.first.value.count,
                          displayCurrency: _displayCurrency,
                          isExpense: false,
                        ),
                      ),
                    if (statsTab == 'income' && !_compareMode)
                      _IncomeBody(
                        income: _categoryIncome,
                        periodLabel: _periodLabel(context),
                        spendingMonths: _spendingMonths,
                        vizMode: _vizMode,
                        displayCurrency: _displayCurrency,
                      ),
                  ],
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Net Worth Hero ───────────────────────────────────────────────────────────

class _NetWorthHero extends StatelessWidget {
  final double personal;
  final double net;
  final String displayCurrency;
  final bool sectionChipsEnabled;
  final String? activeSection;
  final void Function(String section) onSelectSection;
  final VoidCallback onToggleCurrency;

  const _NetWorthHero({
    required this.personal,
    required this.net,
    required this.displayCurrency,
    required this.sectionChipsEnabled,
    required this.activeSection,
    required this.onSelectSection,
    required this.onToggleCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final displayPersonal =
        fx.convert(personal, settings.baseCurrency, displayCurrency);
    final displayNet =
        fx.convert(net, settings.baseCurrency, displayCurrency);
    final netPos = displayNet >= 0;
    final netColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final balanceColor = displayPersonal >= 0
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);
    final sym = fx.currencySymbol(displayCurrency);
    final isSecondary = displayCurrency == settings.secondaryCurrency;

    Widget chip({required IconData icon, required bool active, required VoidCallback onTap, Widget? child}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: AppHeroConstants.filterChipHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child ?? Icon(icon, size: 15,
              color: active ? cs.primary : cs.onSurfaceVariant),
        ),
      );
    }

    return Container(
      padding: AppHeroConstants.cardPadding,
      decoration: BoxDecoration(
        color: balanceColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: balanceColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroTwoColumnMetricsRow(
            dividerColor: netColor.withValues(alpha: 0.2),
            leftColumn: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.heroBalance,
                  style: TextStyle(
                    fontSize: AppHeroConstants.labelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '${displayPersonal > 0 ? '+' : ''}${displayPersonal.toStringAsFixed(2)} $sym',
                  style: TextStyle(
                    fontSize: AppHeroConstants.primaryAmountFontSize,
                    fontWeight: FontWeight.w800,
                    color: balanceColor,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            rightColumn: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.heroNet,
                  style: TextStyle(
                    fontSize: AppHeroConstants.secondaryLabelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '${displayNet > 0 ? '+' : ''}${displayNet.toStringAsFixed(2)} $sym',
                  style: TextStyle(
                    fontSize: AppHeroConstants.secondaryAmountFontSize,
                    fontWeight: FontWeight.w700,
                    color: netColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppHeroConstants.chipGapBelowMetrics),
          // 4 section chips (mutually exclusive) + currency (independent)
          Builder(builder: (context) {
            final chipRow = Row(
              children: [
                Expanded(
                    child: chip(
                        icon: Icons.person_outline_rounded,
                        active: activeSection == 'personal',
                        onTap: () => onSelectSection('personal'))),
                const SizedBox(width: 6),
                Expanded(
                    child: chip(
                        icon: Icons.people_outline_rounded,
                        active: activeSection == 'individuals',
                        onTap: () => onSelectSection('individuals'))),
                const SizedBox(width: 6),
                Expanded(
                    child: chip(
                        icon: Icons.business_outlined,
                        active: activeSection == 'entities',
                        onTap: () => onSelectSection('entities'))),
                const SizedBox(width: 6),
                Expanded(
                    child: chip(
                        icon: Icons.bar_chart_rounded,
                        active: activeSection == 'statistics',
                        onTap: () => onSelectSection('statistics'))),
                const SizedBox(width: 6),
                Expanded(
                    child: chip(
                        icon: Icons.currency_exchange_rounded,
                        active: isSecondary,
                        onTap: onToggleCurrency)),
              ],
            );
            if (!sectionChipsEnabled) {
              return Semantics(
                enabled: false,
                label: l10n.semanticsReviewSectionChipsDisabledNeedAccount,
                child: Opacity(
                  opacity: 0.5,
                  child: IgnorePointer(
                    child: ExcludeSemantics(child: chipRow),
                  ),
                ),
              );
            }
            return chipRow;
          }),
        ],
      ),
    );
  }
}

// ─── Stats header (shared chips + date navigator) ─────────────────────────────

class _StatsHeader extends StatelessWidget {
  final String? activeStats;
  final void Function(String s) onSelectStats;
  final String periodLabel;
  final int spendingMonths;
  final String dateRangeLabel;
  final VoidCallback onCyclePeriod;
  final bool canNavigateForward;
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateForward;
  final int vizMode;
  final VoidCallback onCycleViz;
  final bool compareMode;
  final VoidCallback onToggleCompare;
  /// Compare mode: categories available for the two periods (Spent vs Received).
  final List<String> compareCategoryKeys;
  final String? compareSelectedCategory;
  final ValueChanged<String>? onCompareCategoryChanged;

  const _StatsHeader({
    required this.activeStats,
    required this.onSelectStats,
    required this.periodLabel,
    required this.spendingMonths,
    required this.dateRangeLabel,
    required this.onCyclePeriod,
    required this.canNavigateForward,
    required this.onNavigateBack,
    required this.onNavigateForward,
    required this.vizMode,
    required this.onCycleViz,
    required this.compareMode,
    required this.onToggleCompare,
    this.compareCategoryKeys = const [],
    this.compareSelectedCategory,
    this.onCompareCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isAllTime = spendingMonths == 0;
    final vizIcon = vizMode == 1 ? Icons.donut_large_rounded : Icons.bar_chart_rounded;

    // Same footprint as _NetWorthHero chips: full row width, shared chip height, 6px gaps.
    Widget chip({required IconData icon, required bool active, required VoidCallback onTap, String? label}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppHeroConstants.filterChipHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: label != null
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: active ? cs.primary : cs.onSurfaceVariant)),
                )
              : Icon(icon, size: 15,
                  color: active ? cs.primary : cs.onSurfaceVariant),
        ),
      );

    Widget navBtn({required IconData icon, required bool enabled, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: enabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 18,
              color: enabled ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.4)),
        ),
      );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          // Chip row: spent, received, period, viz, compare (same tap targets as hero).
          Row(
            children: [
              Expanded(
                child: chip(
                  icon: Icons.arrow_upward_rounded,
                  active: activeStats == 'expense',
                  onTap: () => onSelectStats('expense'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: chip(
                  icon: Icons.arrow_downward_rounded,
                  active: activeStats == 'income',
                  onTap: () => onSelectStats('income'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: chip(
                  icon: Icons.calendar_today_outlined,
                  active: true,
                  onTap: onCyclePeriod,
                  label: periodLabel,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Semantics(
                  enabled: !compareMode,
                  label: compareMode
                      ? l10n.semanticsChartStyleUnavailable
                      : l10n.semanticsChartStyle,
                  child: IgnorePointer(
                    ignoring: compareMode,
                    child: chip(
                      icon: vizIcon,
                      active: !compareMode,
                      onTap: onCycleViz,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: chip(
                  icon: Icons.compare_arrows_rounded,
                  active: compareMode,
                  onTap: onToggleCompare,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (compareMode) ...[
            if (compareCategoryKeys.isNotEmpty &&
                compareSelectedCategory != null &&
                onCompareCategoryChanged != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: AppHeroConstants.filterChipHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: compareCategoryKeys.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final k = compareCategoryKeys[i];
                    final selected = compareSelectedCategory == k;
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: ChoiceChip(
                          key: ValueKey(
                              '${activeStats}_${compareCategoryKeys.length}_$k'),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          labelPadding: EdgeInsets.zero,
                          label: Text(
                            k == 'Uncategorized'
                                ? l10n.statsUncategorized
                                : l10nCategoryName(context, k),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                          selected: selected,
                          showCheckmark: false,
                          selectedColor:
                              cs.primary.withValues(alpha: 0.16),
                          backgroundColor:
                              cs.surfaceContainerHighest.withValues(alpha: 0.65),
                          side: BorderSide(
                            color: selected
                                ? cs.primary.withValues(alpha: 0.55)
                                : cs.outlineVariant.withValues(alpha: 0.45),
                            width: selected ? 1.5 : 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) =>
                              onCompareCategoryChanged!(k),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else if (compareCategoryKeys.isEmpty) ...[
              const SizedBox(height: 10),
              Text(
                l10n.statsNoCategories,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ] else
            Row(
              children: [
                if (!isAllTime)
                  navBtn(icon: Icons.chevron_left_rounded, enabled: true, onTap: onNavigateBack),
                if (!isAllTime) const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    dateRangeLabel,
                    textAlign: isAllTime ? TextAlign.start : TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                if (!isAllTime) const SizedBox(width: 6),
                if (!isAllTime)
                  navBtn(
                    icon: Icons.chevron_right_rounded,
                    enabled: canNavigateForward,
                    onTap: onNavigateForward,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Compact prev / next + label row for each compare column.
class _CompareMiniDateNav extends StatelessWidget {
  final ColorScheme colorScheme;
  final String label;
  final String semanticsLabel;
  final bool canBack;
  final bool canForward;
  final VoidCallback onBack;
  final VoidCallback onForward;

  const _CompareMiniDateNav({
    required this.colorScheme,
    required this.label,
    required this.semanticsLabel,
    required this.canBack,
    required this.canForward,
    required this.onBack,
    required this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme;
    Widget navBtn({
      required IconData icon,
      required bool enabled,
      required VoidCallback onTap,
    }) =>
        GestureDetector(
          onTap: enabled ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: enabled
                  ? cs.primary.withValues(alpha: 0.12)
                  : cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 17,
              color: enabled
                  ? cs.primary
                  : cs.onSurfaceVariant.withValues(alpha: 0.35),
            ),
          ),
        );

    return Semantics(
      container: true,
      label: AppLocalizations.of(context).semanticsPeriod(semanticsLabel),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            navBtn(
              icon: Icons.chevron_left_rounded,
              enabled: canBack,
              onTap: onBack,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 4),
            navBtn(
              icon: Icons.chevron_right_rounded,
              enabled: canForward,
              onTap: onForward,
            ),
          ],
        ),
      ),
    );
  }
}

/// Side‑by‑side comparison for a single category: amounts only, polished layout.
class _CompareCategoryAmountsPanel extends StatelessWidget {
  final ColorScheme colorScheme;
  final String categoryName;
  final String semanticLabelA;
  final String semanticLabelB;
  final String dateRangeLabelA;
  final String dateRangeLabelB;
  final bool canBackA;
  final bool canForwardA;
  final bool canBackB;
  final bool canForwardB;
  final VoidCallback onBackA;
  final VoidCallback onForwardA;
  final VoidCallback onBackB;
  final VoidCallback onForwardB;
  final double amountABase;
  final double amountBBase;
  final int countA;
  final int countB;
  final String displayCurrency;
  final bool isExpense;

  const _CompareCategoryAmountsPanel({
    required this.colorScheme,
    required this.categoryName,
    required this.semanticLabelA,
    required this.semanticLabelB,
    required this.dateRangeLabelA,
    required this.dateRangeLabelB,
    required this.canBackA,
    required this.canForwardA,
    required this.canBackB,
    required this.canForwardB,
    required this.onBackA,
    required this.onForwardA,
    required this.onBackB,
    required this.onForwardB,
    required this.amountABase,
    required this.amountBBase,
    required this.countA,
    required this.countB,
    required this.displayCurrency,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme;
    final l10n = AppLocalizations.of(context);
    final sym = fx.currencySymbol(displayCurrency);
    final a = fx.convert(amountABase, settings.baseCurrency, displayCurrency);
    final b = fx.convert(amountBBase, settings.baseCurrency, displayCurrency);
    final accent = isExpense ? const Color(0xFFE11D48) : const Color(0xFF059669);
    final accentSoft = isExpense
        ? const Color(0xFFFFF1F2)
        : const Color(0xFFECFDF5);
    final sign = isExpense ? '−' : '+';
    String fmt(double v) => '$sign${v.abs().toStringAsFixed(2)} $sym';
    final diff = b - a;
    final diffAbs = diff.abs();
    final diffStr =
        '${diff >= 0 ? '+' : '−'}${diffAbs.toStringAsFixed(2)} $sym';

    Widget periodTile({
      required String badge,
      required String semantic,
      required double amount,
      required int count,
    }) {
      return Semantics(
        container: true,
        label: '$semantic. ${fmt(amount)}. $count.',
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  fmt(amount),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: accent,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count == 0
                    ? l10n.statsNoTransactions
                    : '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.07),
              cs.surfaceContainerHighest.withValues(alpha: 0.35),
            ],
          ),
          border: Border.all(
            color: accent.withValues(alpha: 0.18),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isExpense
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    size: 22,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName == 'Uncategorized'
                            ? l10n.statsUncategorized
                            : l10nCategoryName(context, categoryName),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isExpense
                            ? l10n.statsSpendingInCategory
                            : l10n.statsIncomeInCategory,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CompareMiniDateNav(
                        colorScheme: cs,
                        label: dateRangeLabelA,
                        semanticsLabel: semanticLabelA,
                        canBack: canBackA,
                        canForward: canForwardA,
                        onBack: onBackA,
                        onForward: onForwardA,
                      ),
                      const SizedBox(height: 10),
                      periodTile(
                        badge: 'A',
                        semantic: semanticLabelA,
                        amount: a,
                        count: countA,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CompareMiniDateNav(
                        colorScheme: cs,
                        label: dateRangeLabelB,
                        semanticsLabel: semanticLabelB,
                        canBack: canBackB,
                        canForward: canForwardB,
                        onBack: onBackB,
                        onForward: onForwardB,
                      ),
                      const SizedBox(height: 10),
                      periodTile(
                        badge: 'B',
                        semantic: semanticLabelB,
                        amount: b,
                        count: countB,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (diffAbs >= 0.005) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insights_outlined,
                      size: 17,
                      color: cs.primary.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.statsDifference,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      diffStr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Spending body ────────────────────────────────────────────────────────────

class _SpendingBody extends StatelessWidget {
  final Map<String, ({double total, int count})> spending;
  final String periodLabel;
  final int spendingMonths;
  final int vizMode;
  final String displayCurrency;

  const _SpendingBody({
    required this.spending,
    required this.periodLabel,
    required this.spendingMonths,
    required this.vizMode,
    required this.displayCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    const expenseColor = Color(0xFFDC2626);
    const hPad = 16.0;
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalSpentBase = sorted.fold(0.0, (s, e) => s + e.value.total);
    final totalSpent = fx.convert(totalSpentBase, settings.baseCurrency, displayCurrency);
    final sym = fx.currencySymbol(displayCurrency);

    final emptyMsg = switch (spendingMonths) {
      1 => l10n.statsNoExpensesMonth,
      0 => l10n.statsNoExpensesAll,
      _ => l10n.statsNoExpensesPeriod(periodLabel),
    };

    if (sorted.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline_rounded, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 10),
                Text(emptyMsg, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 6),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.arrow_upward_rounded, size: 16, color: expenseColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.statsTotalSpent,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                  ),
                  Text(
                    '-${totalSpent.toStringAsFixed(2)} $sym',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: expenseColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vizMode == 1) ...[
          Builder(builder: (context) {
            final donutSorted =
                sorted.where((e) => e.value.total > 0).toList();
            if (donutSorted.isEmpty) {
              return Padding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 16),
                    child: Center(
                      child: Text(
                        l10n.statsNoExpensesThisPeriod,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: cs.onSurfaceVariant, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              );
            }
            return _DonutView(
              sorted: donutSorted,
              displayCurrency: displayCurrency,
              donutHeight: 170.0,
              horizontalPadding: hPad,
              narrowLegend: false,
            );
          }),
        ] else
          _BarsView(
            sorted: sorted,
            maxAmount: maxAmount,
            displayCurrency: displayCurrency,
            barColor: expenseColor,
            horizontalPadding: hPad,
            narrowLayout: false,
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Income body ──────────────────────────────────────────────────────────────

class _IncomeBody extends StatelessWidget {
  final Map<String, ({double total, int count})> income;
  final String periodLabel;
  final int spendingMonths;
  final int vizMode;
  final String displayCurrency;

  const _IncomeBody({
    required this.income,
    required this.periodLabel,
    required this.spendingMonths,
    required this.vizMode,
    required this.displayCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    const incomeColor = Color(0xFF16A34A);
    const hPad = 16.0;
    final sorted = income.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalReceivedBase = sorted.fold(0.0, (s, e) => s + e.value.total);
    final totalReceived = fx.convert(totalReceivedBase, settings.baseCurrency, displayCurrency);
    final sym = fx.currencySymbol(displayCurrency);

    final emptyMsg = switch (spendingMonths) {
      1 => l10n.statsNoIncomeMonth,
      0 => l10n.statsNoIncomeAll,
      _ => l10n.statsNoIncomePeriod(periodLabel),
    };

    if (sorted.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline_rounded, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 10),
                Text(emptyMsg, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 6),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.arrow_downward_rounded, size: 16, color: incomeColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.statsTotalReceived,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                    ),
                  ),
                  Text(
                    '+${totalReceived.toStringAsFixed(2)} $sym',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: incomeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vizMode == 1) ...[
          Builder(builder: (context) {
            final donutSorted =
                sorted.where((e) => e.value.total > 0).toList();
            if (donutSorted.isEmpty) {
              return Padding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 16),
                    child: Center(
                      child: Text(
                        l10n.statsNoIncomeThisPeriod,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: cs.onSurfaceVariant, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              );
            }
            return _DonutView(
              sorted: donutSorted,
              displayCurrency: displayCurrency,
              donutHeight: 170.0,
              horizontalPadding: hPad,
              narrowLegend: false,
            );
          }),
        ] else
          _BarsView(
            sorted: sorted,
            maxAmount: maxAmount,
            displayCurrency: displayCurrency,
            barColor: incomeColor,
            horizontalPadding: hPad,
            narrowLayout: false,
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Chart palette ────────────────────────────────────────────────────────────

const _kChartColors = [
  Color(0xFF6366F1), Color(0xFF22C55E), Color(0xFFF59E0B),
  Color(0xFFEC4899), Color(0xFF14B8A6), Color(0xFFF97316),
  Color(0xFF8B5CF6), Color(0xFF06B6D4), Color(0xFFEF4444),
  Color(0xFF84CC16),
];

// ─── Bars view ────────────────────────────────────────────────────────────────

class _BarsView extends StatelessWidget {
  final List<MapEntry<String, ({double total, int count})>> sorted;
  final double maxAmount;
  final String displayCurrency;
  final Color barColor;
  final double horizontalPadding;
  final bool narrowLayout;

  const _BarsView({
    required this.sorted,
    required this.maxAmount,
    required this.displayCurrency,
    required this.barColor,
    this.horizontalPadding = 16,
    this.narrowLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final innerH = horizontalPadding < 12 ? 8.0 : 14.0;
    final nameSize = narrowLayout ? 12.0 : 13.0;
    final amtSize = narrowLayout ? 11.0 : 13.0;
    final gap = narrowLayout ? 4.0 : 8.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: sorted.asMap().entries.map((entry) {
              final isLast = entry.key == sorted.length - 1;
              final cat = entry.value.key;
              final displayCat = cat == 'Uncategorized'
                  ? AppLocalizations.of(context).statsUncategorized
                  : l10nCategoryName(context, cat);
              final info = entry.value.value;
              final frac = maxAmount > 0 ? info.total / maxAmount : 0.0;
              final amount = fx.convert(info.total, settings.baseCurrency, displayCurrency);
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: innerH, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: narrowLayout ? 11 : 10,
                              child: Text(displayCat,
                                  style: TextStyle(
                                      fontSize: nameSize,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(width: gap),
                            Expanded(
                              flex: narrowLayout ? 9 : 8,
                              child: Text(
                                '${amount.toStringAsFixed(2)} ${fx.currencySymbol(displayCurrency)}',
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: amtSize,
                                    fontWeight: FontWeight.w700,
                                    color: barColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: frac,
                            minHeight: 10,
                            backgroundColor: barColor.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(barColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                        height: 0.5,
                        indent: innerH,
                        color: cs.outlineVariant.withValues(alpha: 0.4)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─── Donut view ───────────────────────────────────────────────────────────────

class _DonutView extends StatelessWidget {
  final List<MapEntry<String, ({double total, int count})>> sorted;
  final String displayCurrency;
  final double donutHeight;
  final double horizontalPadding;
  final bool narrowLegend;

  const _DonutView({
    required this.sorted,
    required this.displayCurrency,
    this.donutHeight = 170,
    this.horizontalPadding = 16,
    this.narrowLegend = false,
  });

  Color _colorForCategory(int positionInList) {
    return _kChartColors[positionInList % _kChartColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = sorted.fold(0.0, (s, e) => s + e.value.total);
    final fractions =
        sorted.map((e) => total > 0 ? e.value.total / total : 0.0).toList();
    final segmentColors = sorted
        .asMap()
        .entries
        .map((e) => _colorForCategory(e.key))
        .toList();
    final innerPad = horizontalPadding < 12 ? 8.0 : 16.0;
    final countSize = donutHeight < 150 ? 22.0 : 28.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(innerPad, 16, innerPad, 12),
          child: Column(
            children: [
              SizedBox(
                height: donutHeight,
                child: CustomPaint(
                  painter: _DonutPainter(
                    fractions: fractions,
                    segmentColors: segmentColors,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${sorted.length}',
                            style: TextStyle(
                                fontSize: countSize, fontWeight: FontWeight.w800)),
                        Text(
                          sorted.length == 1
                              ? AppLocalizations.of(context).categoryLabel
                              : AppLocalizations.of(context).categoriesLabel,
                          style: TextStyle(
                              fontSize: 11, color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(height: 16, color: cs.outlineVariant.withValues(alpha: 0.4)),
              // Legend
              ...sorted.asMap().entries.map((entry) {
                final idx = entry.key;
                final cat = entry.value.key;
                final displayCat = cat == 'Uncategorized'
                    ? AppLocalizations.of(context).statsUncategorized
                    : l10nCategoryName(context, cat);
                final info = entry.value.value;
                final color = _colorForCategory(idx);
                final amount = fx.convert(
                    info.total, settings.baseCurrency, displayCurrency);
                final pct = total > 0 ? info.total / total * 100 : 0.0;
                final legSize = narrowLegend ? 11.0 : 13.0;
                final pctSize = narrowLegend ? 10.0 : 12.0;
                final sym = fx.currencySymbol(displayCurrency);
                // Fixed-width numeric columns so % and amounts line up on every row.
                final pctW = narrowLegend ? 34.0 : 50.0;
                final amtW = narrowLegend ? 68.0 : 92.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: narrowLegend ? 8 : 10,
                        height: narrowLegend ? 8 : 10,
                        decoration:
                            BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      SizedBox(width: narrowLegend ? 6 : 8),
                      Expanded(
                        child: Text(displayCat,
                            style: TextStyle(
                                fontSize: legSize, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        width: pctW,
                        child: Text(
                          narrowLegend
                              ? '${pct.toStringAsFixed(0)}%'
                              : '${pct.toStringAsFixed(1)}%',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: pctSize,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(width: narrowLegend ? 6 : 10),
                      SizedBox(
                        width: amtW,
                        child: Text(
                          narrowLegend
                              ? '${amount.toStringAsFixed(1)} $sym'
                              : '${amount.toStringAsFixed(2)} $sym',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: legSize,
                            fontWeight: narrowLegend
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: narrowLegend
                                ? cs.onSurfaceVariant
                                : cs.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> fractions;
  final List<Color> segmentColors;

  _DonutPainter({
    required this.fractions,
    required this.segmentColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    const strokeWidth = 32.0;

    var startAngle = -math.pi / 2;
    const gap = 0.04;

    for (int i = 0; i < fractions.length; i++) {
      final sweep = fractions[i] * 2 * math.pi;
      if (sweep < gap) { startAngle += sweep; continue; }
      final paint = Paint()
        ..color = segmentColors[i % segmentColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle + gap / 2,
        sweep - gap,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.fractions != fractions || old.segmentColors != segmentColors;
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  final String displayCurrency;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const _AccountCard({
    required this.account,
    required this.displayCurrency,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPersonal = account.group == AccountGroup.personal;
    final isEntities = account.group == AccountGroup.entities;
    // Show native when base chip is selected; convert when secondary is active.
    final isSecondary = displayCurrency != settings.baseCurrency;
    final shownBook = isSecondary
        ? fx.convert(account.balance, account.currencyCode, displayCurrency)
        : account.balance;
    final shownMain = account.hasOverdraftFacility
        ? (isSecondary
            ? fx.convert(account.availableToSpend, account.currencyCode,
                displayCurrency)
            : account.availableToSpend)
        : shownBook;
    final shownSymbol = isSecondary
        ? fx.currencySymbol(displayCurrency)
        : fx.currencySymbol(account.currencyCode);
    final mainPositive = shownMain >= 0;
    final mainColor =
        mainPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final bookPositive = shownBook >= 0;
    final bookColor =
        bookPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    final avatarBg = isPersonal
        ? cs.primaryContainer
        : isEntities
            ? cs.secondaryContainer
            : cs.tertiaryContainer;
    final avatarFg = isPersonal
        ? cs.onPrimaryContainer
        : isEntities
            ? cs.onSecondaryContainer
            : cs.onTertiaryContainer;
    final groupLabel = l10nAccountCardGroupLabel(context, account.group);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: avatarBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      account.name[0].toUpperCase(),
                      style: TextStyle(
                        color: avatarFg,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(groupLabel,
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${shownMain > 0 ? '+' : ''}${shownMain.toStringAsFixed(2)} $shownSymbol',
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                    if (account.hasOverdraftFacility) ...[
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(text: '${AppLocalizations.of(context).labelRealBalance} '),
                            TextSpan(
                              text:
                                  '${shownBook > 0 ? '+' : ''}${shownBook.toStringAsFixed(2)} $shownSymbol',
                              style: TextStyle(color: bookColor),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyAccountsHint extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyAccountsHint({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet_rounded,
                size: 44, color: cs.primary),
          ),
          const SizedBox(height: 24),
          Text(l10n.emptyNoAccountsYet,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            l10n.emptyAddFirstAccountReview,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.emptyAddAccount),
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Account Form Sheet ───────────────────────────────────────────────────────

Future<void> _showBalanceCorrectionDialog(
  BuildContext context, {
  required double previousBook,
  required double newBook,
  required Account account,
  required BalanceCorrectionResult correction,
}) async {
  final sym = fx.currencySymbol(account.currencyCode);
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.balanceAdjustedTitle),
      content: Text(
        l10n.balanceAdjustedBody(
          previousBook.toStringAsFixed(2),
          newBook.toStringAsFixed(2),
          sym,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  late AccountGroup _group;
  late String _currencyCode;
  bool _forceClose = false;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account != null
          ? widget.account!.balance.toStringAsFixed(2)
          : '',
    );
    _overdraftController = TextEditingController(
      text: widget.account != null && widget.account!.overdraftLimit > 0
          ? widget.account!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _group = widget.account?.group ?? AccountGroup.personal;
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
  }

  bool get _isDirty {
    if (widget.account != null) {
      return _nameController.text.trim() != widget.account!.name ||
          _balanceController.text.trim() !=
              widget.account!.balance.toStringAsFixed(2) ||
          _group != widget.account!.group ||
          _parseOverdraftLimit() != widget.account!.overdraftLimit ||
          _currencyCode != widget.account!.currencyCode;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        _parseOverdraftLimit() > 0 ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal;
  }

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null) setState(() => _currencyCode = result);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    if (isAccountNameTaken(
      name,
      data.accounts,
      exceptAccountId: widget.account?.id,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance = double.tryParse(
            _balanceController.text.trim().replaceAll(',', '.')) ??
        0.0;
    final overdraft = _parseOverdraftLimit();
    if (widget.account != null) {
      final acc = widget.account!;
      final previousBook = acc.balance;
      acc.name = name;
      acc.group = _group;
      acc.overdraftLimit = overdraft;

      final correction = await applyLedgerBalanceCorrection(
        account: acc,
        previousBookBalance: previousBook,
        newBookBalance: balance,
      );
      if (!correction.inserted) {
        acc.balance = balance;
      }
      await DataRepository.persistAccountFields(acc);
      HapticFeedback.lightImpact();
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, acc);
    } else {
      Navigator.pop(
        context,
        Account(
          name: name,
          group: _group,
          balance: balance,
          overdraftLimit: overdraft,
          currencyCode: _currencyCode,
        ),
      );
    }
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _confirmArchiveSheet() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finish() async {
      acc.archived = true;
      await DataRepository.persistAccountFields(acc);
      if (mounted) Navigator.pop(context, acc);
    }
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await DataRepository.removePlannedReferencingAccount(acc);
                await finish();
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finish();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _delete() {
    final acc = widget.account!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(l10n.cannotDeleteBodyHistory),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await DataRepository.removePlannedReferencingAccount(acc);
                await DataRepository.removeAccount(acc);
                if (mounted) {
                  Navigator.pop(context, kAccountFormSheetDeleted);
                }
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DataRepository.removeAccount(acc);
              if (mounted) {
                Navigator.pop(context, kAccountFormSheetDeleted);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.account != null;

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(isEdit ? l10n.editAccountTitle : l10n.newAccountTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      if (_isDirty) {
                        _showDiscardDialog();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SegmentedButton<AccountGroup>(
                segments: [
                  ButtonSegment(
                    value: AccountGroup.personal,
                    icon: const Icon(Icons.account_balance_wallet_outlined,
                        size: 16),
                    label: Text(l10n.accountGroupPersonal),
                  ),
                  ButtonSegment(
                    value: AccountGroup.individuals,
                    icon: const Icon(Icons.person_outline_rounded, size: 16),
                    label: Text(l10n.accountGroupIndividual),
                  ),
                  ButtonSegment(
                    value: AccountGroup.entities,
                    icon: const Icon(Icons.business_outlined, size: 16),
                    label: Text(l10n.accountGroupEntity),
                  ),
                ],
                selected: {_group},
                onSelectionChanged: (s) =>
                    setState(() => _group = s.first),
              ),
              const SizedBox(height: 6),
              Text(
                _groupDescriptionL10n(context),
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: !isEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.labelAccountName,
                ),
              ),
              const SizedBox(height: 12),

              // Currency — editable only when creating
              if (!isEdit)
                _CurrencyTile(
                  currencyCode: _currencyCode,
                  onTap: _pickCurrency,
                )
              else
                _CurrencyTile(currencyCode: _currencyCode, onTap: null),
              const SizedBox(height: 12),

              TextField(
                controller: _balanceController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                decoration: InputDecoration(
                  labelText: l10n.labelRealBalance,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _overdraftController,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(
                  labelText: l10n.labelOverdraftLimit,
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _save(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              if (isEdit) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed:
                      widget.account!.archived ? null : _confirmArchiveSheet,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: Text(l10n.archiveAction),
                ),
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18),
                  label: Text(l10n.deletePermanently),
                  style: TextButton.styleFrom(
                    foregroundColor: cs.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Account Form Screen (full-screen push) ──────────────────────────────────

class AccountFormScreen extends StatefulWidget {
  final Account? existing;
  final AccountGroup? initialGroup;
  const AccountFormScreen({super.key, this.existing, this.initialGroup});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _overdraftController;
  late AccountGroup _group;
  late String _currencyCode;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

  double _parseOverdraftLimit() {
    final t = _overdraftController.text.trim();
    if (t.isEmpty) return 0;
    return (double.tryParse(t.replaceAll(',', '.')) ?? 0).clamp(0.0, 1e15);
  }

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.balance.toStringAsFixed(2)
          : '',
    );
    _overdraftController = TextEditingController(
      text: widget.existing != null && widget.existing!.overdraftLimit > 0
          ? widget.existing!.overdraftLimit.toStringAsFixed(2)
          : '',
    );
    _group = widget.existing?.group ?? widget.initialGroup ?? AccountGroup.personal;
    _currencyCode =
        widget.existing?.currencyCode ?? settings.baseCurrency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _overdraftController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    if (_isEdit) {
      return _nameController.text.trim() != widget.existing!.name ||
          _balanceController.text.trim() !=
              widget.existing!.balance.toStringAsFixed(2) ||
          _group != widget.existing!.group ||
          _parseOverdraftLimit() != widget.existing!.overdraftLimit;
    }
    final defaultGroup = widget.initialGroup ?? AccountGroup.personal;
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        _parseOverdraftLimit() > 0 ||
        _currencyCode != settings.baseCurrency ||
        _group != defaultGroup;
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.discardTitle),
        content: Text(l10n.discardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.keepEditing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.discard),
          ),
        ],
      ),
    ).then((discard) {
      if (discard == true && mounted) {
        setState(() => _forceClose = true);
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    if (isAccountNameTaken(
      name,
      data.accounts,
      exceptAccountId: _isEdit ? widget.existing!.id : null,
    )) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).accountNameTaken,
          ),
        ),
      );
      return;
    }
    final balance =
        double.tryParse(_balanceController.text.trim().replaceAll(',', '.')) ??
            0.0;
    final overdraft = _parseOverdraftLimit();
    if (_isEdit) {
      final acc = widget.existing!;
      final previousBook = acc.balance;
      acc.name = name;
      acc.group = _group;
      acc.overdraftLimit = overdraft;

      final correction = await applyLedgerBalanceCorrection(
        account: acc,
        previousBookBalance: previousBook,
        newBookBalance: balance,
      );
      if (!correction.inserted) {
        acc.balance = balance;
      }
      await DataRepository.persistAccountFields(acc);
      HapticFeedback.lightImpact();
      if (mounted && correction.inserted) {
        await _showBalanceCorrectionDialog(
          context,
          previousBook: previousBook,
          newBook: balance,
          account: acc,
          correction: correction,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } else {
      await DataRepository.addAccount(Account(
        name: name,
        group: _group,
        balance: balance,
        overdraftLimit: overdraft,
        currencyCode: _currencyCode,
      ));
      HapticFeedback.lightImpact();
      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _restoreArchived() async {
    widget.existing!.archived = false;
    await DataRepository.persistAccountFields(widget.existing!);
    setState(() {});
  }

  void _confirmArchive() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (acc.archived) return;
    if (!canArchiveAccount(acc)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotArchiveTitle),
          content: Text(l10n.cannotArchiveBodyAdjust),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    Future<void> finishArchive() async {
      acc.archived = true;
      await DataRepository.persistAccountFields(acc);
      if (mounted) Navigator.pop(context, true);
    }

    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.archiveAccountTitle),
          content: Text(l10n.archiveWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await DataRepository.removePlannedReferencingAccount(acc);
                await finishArchive();
              },
              child: Text(l10n.removeAndArchive),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.archiveAccountTitle),
        content: Text(l10n.archiveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await finishArchive();
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    final acc = widget.existing!;
    final l10n = AppLocalizations.of(context);
    HapticFeedback.mediumImpact();
    if (accountReferencedInTrack(acc, data.transactions)) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.cannotDeleteTitle),
          content: Text(
            acc.archived
                ? l10n.cannotDeleteBodyShort
                : l10n.cannotDeleteBodySuggestArchive,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close),
            ),
            if (!acc.archived)
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _confirmArchive();
                },
                child: Text(l10n.archiveInstead),
              ),
          ],
        ),
      );
      return;
    }
    final nPlanned = plannedReferenceCount(acc, data.plannedTransactions);
    if (nPlanned > 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteWithPlannedBody(nPlanned)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await DataRepository.removePlannedReferencingAccount(acc);
                await DataRepository.removeAccount(acc);
                if (mounted) Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.deleteAllAndDelete),
            ),
          ],
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountBodyPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DataRepository.removeAccount(acc);
              if (mounted) Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _CurrencyPickerSheet(selected: _currencyCode),
    );
    if (result != null && mounted) setState(() => _currencyCode = result);
  }

  String _groupDescriptionL10n(BuildContext context) => switch (_group) {
        AccountGroup.personal => AppLocalizations.of(context).groupDescPersonal,
        AccountGroup.individuals => AppLocalizations.of(context).groupDescIndividuals,
        AccountGroup.entities => AppLocalizations.of(context).groupDescEntities,
      };

  void _showRemoveAccountSheet() {
    HapticFeedback.lightImpact();
    final acc = widget.existing!;
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  l10n.removeAccountSheetTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: cs.error),
                title: Text(
                  l10n.deletePermanently,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.error,
                  ),
                ),
                subtitle: Text(l10n.deletePermanentlySubtitle),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete();
                },
              ),
              if (!acc.archived)
                ListTile(
                  leading: Icon(Icons.inventory_2_outlined, color: cs.primary),
                  title: Text(
                    l10n.archiveAction,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.archiveOptionSubtitle),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmArchive();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text(_isEdit ? l10n.editAccountTitle : l10n.newAccountTitle),
          centerTitle: false,
          backgroundColor: cs.surface,
          surfaceTintColor: Colors.transparent,
          actions: _isEdit
              ? [
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                    tooltip: l10n.tooltipRemoveAccount,
                    onPressed: _showRemoveAccountSheet,
                  ),
                ]
              : null,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isEdit && widget.existing!.archived)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Material(
                          color: cs.secondaryContainer
                              .withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 22, color: cs.onSecondaryContainer),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.archivedBannerText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.35,
                                      color: cs.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _restoreArchived(),
                                  child: Text(l10n.restore),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SegmentedButton<AccountGroup>(
                      segments: [
                        ButtonSegment(
                          value: AccountGroup.personal,
                          icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16),
                          label: Text(l10n.accountGroupPersonal),
                        ),
                        ButtonSegment(
                          value: AccountGroup.individuals,
                          icon: const Icon(Icons.person_outline_rounded, size: 16),
                          label: Text(l10n.accountGroupIndividual),
                        ),
                        ButtonSegment(
                          value: AccountGroup.entities,
                          icon: const Icon(Icons.business_outlined, size: 16),
                          label: Text(l10n.accountGroupEntity),
                        ),
                      ],
                      selected: {_group},
                      onSelectionChanged: (s) =>
                          setState(() => _group = s.first),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _groupDescriptionL10n(context),
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      autofocus: !_isEdit,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          InputDecoration(labelText: l10n.labelAccountName),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    if (!_isEdit)
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: _pickCurrency)
                    else
                      _CurrencyTile(
                          currencyCode: _currencyCode, onTap: null),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      decoration: InputDecoration(
                        labelText: l10n.labelRealBalance,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _overdraftController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: InputDecoration(
                        labelText: l10n.labelOverdraftLimit,
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(
                    top: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                        width: 0.5)),
              ),
              child: FilledButton(
                onPressed: _canSave ? () => _save() : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_isEdit ? l10n.saveChanges : l10n.addAccountAction,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Currency picker tile ────────────────────────────────────────────────────

class _CurrencyTile extends StatelessWidget {
  final String currencyCode;
  final VoidCallback? onTap;

  const _CurrencyTile({required this.currencyCode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final name =
        currencyDisplayName(currencyCode, Localizations.localeOf(context));
    final symbol = fx.currencySymbol(currencyCode);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.labelCurrency,
          suffixIcon: enabled
              ? const Icon(Icons.arrow_drop_down_rounded)
              : Icon(Icons.lock_outline_rounded,
                  size: 16, color: cs.onSurfaceVariant),
          enabled: enabled,
        ),
        child: Text(
          '$currencyCode  ·  $symbol  ·  $name',
          style: TextStyle(
            fontSize: 14,
            color: enabled ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── Currency picker bottom sheet ───────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selected;
  const _CurrencyPickerSheet({required this.selected});

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  final _searchController = TextEditingController();
  List<String> _filtered = settings.supportedCurrencies;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    final locale = Localizations.localeOf(context);
    setState(() {
      _filtered = q.isEmpty
          ? settings.supportedCurrencies
          : settings.supportedCurrencies.where((code) {
              final name = currencyDisplayName(code, locale).toLowerCase();
              return code.toLowerCase().contains(q) || name.contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchCurrencies,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (ctx, i) {
                  final code = _filtered[i];
                  final name = currencyDisplayName(
                      code, Localizations.localeOf(ctx));
                  final symbol = fx.currencySymbol(code);
                  final isSelected = code == widget.selected;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected
                          ? cs.primaryContainer
                          : cs.surfaceContainerHighest,
                      child: Text(
                        symbol.length <= 2 ? symbol : code.substring(0, 1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? cs.onPrimaryContainer
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      '$code  —  $name',
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      symbol,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => Navigator.pop(ctx, code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
