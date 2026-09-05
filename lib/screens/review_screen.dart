import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/account_lifecycle.dart';
import '../data/app_data.dart' as data;
import '../data/app_signals.dart';
import '../data/balance_privacy_prefs.dart';
import '../data/user_settings.dart' as settings;
import '../help/help_tour.dart';
import '../l10n/app_localizations.dart';
import '../models/account.dart';
import '../theme/ledger_colors.dart';
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import '../utils/fx.dart' as fx;
import '../utils/persistence_guard.dart';
import '../widgets/account_avatar.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/review_stats_empty_state.dart';
import '../widgets/stacked_scroll_fab.dart';
import 'account_transactions_screen.dart';
import 'review/account_form_widgets.dart';
import 'settings_screen.dart';


export 'review/account_form_widgets.dart'
    show AccountFormSheet, AccountFormScreen;

/// Pages of the Review screen, in PageView order.
enum _ReviewSection { personal, individuals, entities, statistics }

/// Statistics tab: what the category breakdown shows.
enum _StatsMode { expense, income }

/// Statistics window. [months] is 0 for all time.
enum _StatsPeriod {
  month(1),
  quarter(3),
  halfYear(6),
  year(12),
  allTime(0);

  const _StatsPeriod(this.months);
  final int months;
}

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
    DateTime(year, (quarter - 1) * 3 + 1);

DateTime _quarterEndExclusive(int year, int quarter) {
  if (quarter == 4) return DateTime(year + 1);
  return DateTime(year, quarter * 3 + 1);
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
    return (start: DateTime(year), end: DateTime(year, 7));
  }
  return (start: DateTime(year, 7), end: DateTime(year + 1));
}

DateTime _quarterStartContaining(DateTime d) =>
    _quarterStart(d.year, _calendarQuarter(d.month));

DateTime _halfYearStartContaining(DateTime d) =>
    d.month <= 6 ? DateTime(d.year) : DateTime(d.year, 7);

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

/// Compare-mode data for Review statistics (built lazily with the stats page).
class _ReviewCompareRows {
  final List<String> compareExpenseCategoryKeys;
  final List<String> compareIncomeCategoryKeys;
  final String? effectiveCompareExpenseCategory;
  final String? effectiveCompareIncomeCategory;
  final List<MapEntry<String, ({double total, int count})>> compareExpenseA;
  final List<MapEntry<String, ({double total, int count})>> compareExpenseB;
  final List<MapEntry<String, ({double total, int count})>> compareIncomeA;
  final List<MapEntry<String, ({double total, int count})>> compareIncomeB;

  const _ReviewCompareRows._({
    required this.compareExpenseCategoryKeys,
    required this.compareIncomeCategoryKeys,
    required this.effectiveCompareExpenseCategory,
    required this.effectiveCompareIncomeCategory,
    required this.compareExpenseA,
    required this.compareExpenseB,
    required this.compareIncomeA,
    required this.compareIncomeB,
  });

  static const _ReviewCompareRows empty = _ReviewCompareRows._(
    compareExpenseCategoryKeys: [],
    compareIncomeCategoryKeys: [],
    effectiveCompareExpenseCategory: null,
    effectiveCompareIncomeCategory: null,
    compareExpenseA: [],
    compareExpenseB: [],
    compareIncomeA: [],
    compareIncomeB: [],
  );
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _displayCurrency = settings.baseCurrency;
  /// Opens with Personal so account cards are visible without an extra tap.
  _ReviewSection _activeSection = _ReviewSection.personal;
    _StatsMode? _activeStats;
  // 0 = all time, 1 = calendar month, 3 = calendar quarter, 6 = half-year, 12 = year
  _StatsPeriod _statsPeriod = _StatsPeriod.month;
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

  late final PageController _sectionPageController;

  static const double _kReviewScrollToTopFabThreshold = 280;

  late final List<ScrollController> _reviewPageScrollControllers;
  final ScrollController _reviewEmptyScrollController = ScrollController();
  bool _showReviewScrollToTopFab = false;

  // ── Help tour anchors ("?" in the app bar) ─────────────────────────────────
  final GlobalKey _helpHeroKey = GlobalKey();
  final GlobalKey _helpFabKey = GlobalKey();

  List<HelpStep> _helpSteps() {
    final l10n = AppLocalizations.of(context);
    return [
      HelpStep(
        targetKey: _helpHeroKey,
        title: l10n.helpReviewHeroTitle,
        body: l10n.helpReviewHeroBody,
      ),
      HelpStep(
        title: l10n.helpReviewSectionsTitle,
        body: l10n.helpReviewSectionsBody,
      ),
      HelpStep(
        title: l10n.helpReviewAccountsTitle,
        body: l10n.helpReviewAccountsBody,
      ),
      HelpStep(
        targetKey: _helpFabKey,
        title: l10n.helpReviewFabTitle,
        body: l10n.helpReviewFabBody,
      ),
    ];
  }

  /// Drives hero bottom shadow under [NestedScrollView] (real scroll offset).
  final ValueNotifier<bool> _reviewHeroOverlapShadow = ValueNotifier(false);

  late final List<GlobalKey> _reviewSectionScrollProbeKeys =
      List<GlobalKey>.generate(_ReviewSection.values.length, (_) => GlobalKey());

  static const double _kReviewHeroOverlapShadowPixels = 1.0;

  @override
  void initState() {
    super.initState();
    ledgerRevision.addListener(_onLedgerChanged);
    final now = DateTime.now();
    _compareMonthB = DateTime(now.year, now.month);
    _compareMonthA = now.month == 1
        ? DateTime(now.year - 1, 12)
        : DateTime(now.year, now.month - 1);
    _sectionPageController = PageController(
      initialPage: _activeSection.index,
    );
    _reviewPageScrollControllers = List.generate(
      _ReviewSection.values.length,
      (_) {
        final c = ScrollController();
        c.addListener(_onReviewScrollPositionChanged);
        return c;
      },
    );
    _reviewEmptyScrollController.addListener(_onReviewScrollPositionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scheduleReviewHeroOverlapShadowSyncForPage(
          _sectionPageIndex(_activeSection));
    });
  }

  /// Any ledger mutation anywhere (other tabs, Settings, imports, a
  /// recovery reload) re-renders this tab; no callback chain needed.
  void _onLedgerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    ledgerRevision.removeListener(_onLedgerChanged);
    for (final c in _reviewPageScrollControllers) {
      c.removeListener(_onReviewScrollPositionChanged);
      c.dispose();
    }
    _reviewEmptyScrollController.removeListener(_onReviewScrollPositionChanged);
    _reviewEmptyScrollController.dispose();
    _reviewHeroOverlapShadow.dispose();
    _sectionPageController.dispose();
    super.dispose();
  }

  int _sectionPageIndex(_ReviewSection section) => section.index;

  void _onReviewSectionPageChanged(int index) {
    if (index < 0 || index >= _ReviewSection.values.length) return;
    final section = _ReviewSection.values[index];
    setState(() {
      _activeSection = section;
      if (section == _ReviewSection.statistics && _activeStats == null) {
        _activeStats = _StatsMode.expense;
      }
    });
    _scheduleReviewHeroOverlapShadowSyncForPage(index);
    _scheduleReviewScrollToTopFabSync();
  }

  void _selectReviewSection(_ReviewSection section) {
    final i = _sectionPageIndex(section);
    setState(() {
      _activeSection = section;
      if (section == _ReviewSection.statistics && _activeStats == null) {
        _activeStats = _StatsMode.expense;
      }
    });
    if (_sectionPageController.hasClients) {
      _sectionPageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
    _scheduleReviewHeroOverlapShadowSyncForPage(i);
    _scheduleReviewScrollToTopFabSync();
  }

  /// PageView can lag [_activeSection] during [animateToPage]; use [page] when attached.
  int _reviewVisiblePageIndex() {
    if (_sectionPageController.hasClients) {
      final p = _sectionPageController.page;
      if (p != null) {
        return p.round().clamp(0, _ReviewSection.values.length - 1);
      }
    }
    return _sectionPageIndex(_activeSection);
  }

  void _onReviewScrollPositionChanged() {
    if (!mounted) return;
    final hasAccounts = activeAccounts(data.accounts).isNotEmpty;
    bool show = false;
    if (!hasAccounts) {
      if (_reviewEmptyScrollController.hasClients) {
        show = _reviewEmptyScrollController.offset >
            _kReviewScrollToTopFabThreshold;
      }
    } else {
      final i = _reviewVisiblePageIndex();
      if (i < _reviewPageScrollControllers.length) {
        final c = _reviewPageScrollControllers[i];
        show = c.hasClients &&
            c.offset > _kReviewScrollToTopFabThreshold;
      }
    }
    if (show != _showReviewScrollToTopFab) {
      setState(() => _showReviewScrollToTopFab = show);
    }
  }

  void _maybeUpdateReviewScrollToTopFabFromNotification(Notification n) {
    if (!mounted) return;
    if (activeAccounts(data.accounts).isEmpty) return;
    ScrollMetrics? metrics;
    if (n is ScrollNotification) {
      if (n.metrics.axis != Axis.vertical) return;
      metrics = n.metrics;
    } else if (n is ScrollMetricsNotification) {
      if (n.metrics.axis != Axis.vertical) return;
      metrics = n.metrics;
    } else {
      return;
    }
    final show = metrics.pixels > _kReviewScrollToTopFabThreshold;
    if (show != _showReviewScrollToTopFab) {
      setState(() => _showReviewScrollToTopFab = show);
    }
  }

  void _scheduleReviewScrollToTopFabSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onReviewScrollPositionChanged();
    });
  }

  void _scrollReviewToTop() {
    if (activeAccounts(data.accounts).isEmpty) {
      final c = _reviewEmptyScrollController;
      if (!c.hasClients) return;
      c.animateTo(
        0,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    final i = _reviewVisiblePageIndex();
    final c = _reviewPageScrollControllers[i];
    if (!c.hasClients) return;
    c.animateTo(
      0,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  void _setReviewHeroOverlapShadow(bool value) {
    if (_reviewHeroOverlapShadow.value != value) {
      _reviewHeroOverlapShadow.value = value;
    }
  }

  /// Vertical scroll from section [PageView] pages only (not outer header).
  void _handleReviewNotificationForHeroShadow(Notification n) {
    if (n is ScrollNotification) {
      _applyReviewShadowFromScrollContext(
        n.context,
        n.metrics.axis,
        n.metrics.pixels,
      );
    } else if (n is ScrollMetricsNotification) {
      _applyReviewShadowFromScrollContext(
        n.context,
        n.metrics.axis,
        n.metrics.pixels,
      );
    }
  }

  void _applyReviewShadowFromScrollContext(
    BuildContext? ctx,
    Axis axis,
    double pixels,
  ) {
    if (ctx == null || axis != Axis.vertical) return;
    if (ctx.findAncestorWidgetOfExactType<PageView>() == null) return;
    _setReviewHeroOverlapShadow(pixels > _kReviewHeroOverlapShadowPixels);
  }

  void _scheduleReviewHeroOverlapShadowSyncForPage(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (index < 0 || index >= _reviewSectionScrollProbeKeys.length) return;
      final probeCtx = _reviewSectionScrollProbeKeys[index].currentContext;
      if (probeCtx == null) return;
      final position = Scrollable.maybeOf(probeCtx)?.position;
      if (position == null || position.axis != Axis.vertical) return;
      _setReviewHeroOverlapShadow(
          position.pixels > _kReviewHeroOverlapShadowPixels);
    });
  }

  /// Matches [AppBar] + hero [SizedBox] height so lists align under the overlay header.
  double _reviewUnderHeaderScrollPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).top +
        kToolbarHeight +
        AppHeroConstants.heroHeaderExtent;
  }

  DateTime get _compareEarliestMonth {
    final e = _earliestTxDate;
    if (e == null) return DateTime(DateTime.now().year - 5);
    return DateTime(e.year, e.month);
  }

  DateTime get _compareLatestMonth =>
      DateTime(DateTime.now().year, DateTime.now().month);

  /// Returns null if that direction is out of bounds (earliest/latest tx month).
  /// For 3M / 6M, steps one **quarter** or **half-year** so each tap changes the window
  /// (monthly steps would repeat the same quarter three or six times).
  DateTime? _compareShiftMonth(DateTime anchor, int direction) {
    final cur = DateTime(anchor.year, anchor.month);
    if (_statsPeriod == _StatsPeriod.year) {
      if (direction < 0) {
        final prev = DateTime(cur.year - 1);
        if (prev.year >= _compareEarliestMonth.year) return prev;
        return null;
      }
      final next = DateTime(cur.year + 1);
      if (next.year <= _compareLatestMonth.year) return next;
      return null;
    }
    if (_statsPeriod == _StatsPeriod.quarter) {
      final qStart = _quarterStartContaining(cur);
      final delta = direction < 0 ? -3 : 3;
      final raw = DateTime(qStart.year, qStart.month + delta);
      final nextStart = _quarterStartContaining(raw);
      if (direction < 0) {
        if (nextStart.isBefore(_compareEarliestMonth)) return null;
        return nextStart;
      }
      if (nextStart.isAfter(_compareLatestMonth)) return null;
      return nextStart;
    }
    if (_statsPeriod == _StatsPeriod.halfYear) {
      final hStart = _halfYearStartContaining(cur);
      final delta = direction < 0 ? -6 : 6;
      final raw = DateTime(hStart.year, hStart.month + delta);
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
          ? DateTime(cur.year - 1, 12)
          : DateTime(cur.year, cur.month - 1);
      if (!prev.isBefore(_compareEarliestMonth)) return prev;
      return null;
    }
    final next = cur.month == 12
        ? DateTime(cur.year + 1)
        : DateTime(cur.year, cur.month + 1);
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
    final a = DateTime(anchorMonth.year, anchorMonth.month);
    switch (_statsPeriod) {
      case _StatsPeriod.quarter:
        final q = _boundsQuarterContaining(a.year, a.month);
        return (start: q.start, end: q.end);
      case _StatsPeriod.halfYear:
        final h = _boundsHalfYearContaining(a.year, a.month);
        return (start: h.start, end: h.end);
      case _StatsPeriod.year:
        return (
          start: DateTime(a.year),
          end: DateTime(a.year + 1),
        );
      case _StatsPeriod.month:
      case _StatsPeriod.allTime:
        return (start: a, end: DateTime(a.year, a.month + 1));
    }
  }

  String _compareRangeLabel(BuildContext context, DateTime anchorMonth) {
    final l10n = AppLocalizations.of(context);
    final b = _compareBounds(anchorMonth);
    final s = b.start;
    final e = b.end;
    if (s == null || e == null) return l10n.statsAllTime;
    if (_statsPeriod == _StatsPeriod.month) return formatAppDate(context, 'MMMM yyyy', s);
    if (_statsPeriod == _StatsPeriod.year) return '${s.year}';
    final lastMonth = DateTime(e.year, e.month - 1);
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
    if (_statsPeriod == _StatsPeriod.month) return formatAppDate(context, 'MMM yyyy', s);
    if (_statsPeriod == _StatsPeriod.year) return '${s.year}';
    final lastMonth = DateTime(e.year, e.month - 1);
    if (s.year == lastMonth.year) {
      return '${formatAppDate(context, 'MMM', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
    }
    return '${formatAppDate(context, 'MMM yyyy', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
  }

  String _periodLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (_statsPeriod) {
      _StatsPeriod.month => l10n.period1M,
      _StatsPeriod.quarter => l10n.period3M,
      _StatsPeriod.halfYear => l10n.period6M,
      _StatsPeriod.year => l10n.period1Y,
      _StatsPeriod.allTime => l10n.periodAll,
    };
  }

  void _cyclePeriod() => setState(() {
    _dateOffset = 0;
    if (_compareMode) {
      // Compare mode has no all-time window.
      _statsPeriod = switch (_statsPeriod) {
        _StatsPeriod.month => _StatsPeriod.quarter,
        _StatsPeriod.quarter => _StatsPeriod.halfYear,
        _StatsPeriod.halfYear => _StatsPeriod.year,
        _StatsPeriod.year || _StatsPeriod.allTime => _StatsPeriod.month,
      };
      if (_statsPeriod == _StatsPeriod.year) {
        _compareMonthA = DateTime(_compareMonthA.year);
        _compareMonthB = DateTime(_compareMonthB.year);
      } else if (_statsPeriod == _StatsPeriod.quarter) {
        _compareMonthA = _quarterStartContaining(_compareMonthA);
        _compareMonthB = _quarterStartContaining(_compareMonthB);
      } else if (_statsPeriod == _StatsPeriod.halfYear) {
        _compareMonthA = _halfYearStartContaining(_compareMonthA);
        _compareMonthB = _halfYearStartContaining(_compareMonthB);
      }
    } else {
      _statsPeriod = switch (_statsPeriod) {
        _StatsPeriod.month => _StatsPeriod.quarter,
        _StatsPeriod.quarter => _StatsPeriod.halfYear,
        _StatsPeriod.halfYear => _StatsPeriod.year,
        _StatsPeriod.year => _StatsPeriod.allTime,
        _StatsPeriod.allTime => _StatsPeriod.month,
      };
    }
  });

  void _cycleViz() => setState(() => _vizMode = (_vizMode + 1) % 2);
  void _navigateBack() => setState(() => _dateOffset++);
  void _navigateForward() => setState(() { if (_dateOffset > 0) _dateOffset--; });

  /// Statistics tab: show reset FAB only after the user changes chips (period,
  /// viz, compare, income vs expense, date nav, or hero currency).
  bool get _reviewStatisticsHasNonDefaultChoices {
    if (_activeSection != _ReviewSection.statistics) return false;
    return _compareMode ||
        _vizMode != 0 ||
        _statsPeriod != _StatsPeriod.month ||
        _dateOffset != 0 ||
        (_activeStats ?? _StatsMode.expense) != _StatsMode.expense ||
        _displayCurrency != settings.baseCurrency;
  }

  void _reviewFabResetStatistics() {
    final now = DateTime.now();
    setState(() {
      _compareMode = false;
      _vizMode = 0;
      _statsPeriod = _StatsPeriod.month;
      _dateOffset = 0;
      _activeStats = _StatsMode.expense;
      _compareCategoryExpense = null;
      _compareCategoryIncome = null;
      _displayCurrency = settings.baseCurrency;
      _compareMonthB = DateTime(now.year, now.month);
      _compareMonthA = now.month == 1
          ? DateTime(now.year - 1, 12)
          : DateTime(now.year, now.month - 1);
    });
  }

  // The active date window (start inclusive, end exclusive). null = no filter.
  ({DateTime? start, DateTime? end}) get _dateRange {
    if (_statsPeriod == _StatsPeriod.allTime) return (start: null, end: null);
    final now = DateTime.now();
    if (_statsPeriod == _StatsPeriod.year) {
      final year = now.year - _dateOffset;
      return (start: DateTime(year), end: DateTime(year + 1));
    }
    if (_statsPeriod == _StatsPeriod.quarter) {
      final r = _quarterByOffsetFrom(now, _dateOffset);
      return (start: r.start, end: r.end);
    }
    if (_statsPeriod == _StatsPeriod.halfYear) {
      final r = _halfYearByOffsetFrom(now, _dateOffset);
      return (start: r.start, end: r.end);
    }
    final endM = now.month + 1 - _dateOffset * _statsPeriod.months;
    return (
      start: DateTime(now.year, endM - _statsPeriod.months),
      end: DateTime(now.year, endM),
    );
  }

  DateTime? get _earliestTxDate => data.transactions.isEmpty
      ? null
      : data.transactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);

  String _dateRangeLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    if (_statsPeriod == _StatsPeriod.allTime) {
      final earliest = _earliestTxDate;
      if (earliest == null) return l10n.statsAllTime;
      return '${formatAppDate(context, 'MMM yyyy', earliest)} – ${formatAppDate(context, 'MMM yyyy', now)}';
    }
    if (_statsPeriod == _StatsPeriod.year) return '${now.year - _dateOffset}';
    final range = _dateRange;
    final s = range.start!;
    final lastMonth = DateTime(range.end!.year, range.end!.month - 1);
    if (_statsPeriod == _StatsPeriod.month) return formatAppDate(context, 'MMMM yyyy', s);
    if (s.year == lastMonth.year) {
      return '${formatAppDate(context, 'MMM', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
    }
    return '${formatAppDate(context, 'MMM yyyy', s)} – ${formatAppDate(context, 'MMM yyyy', lastMonth)}';
  }

  // ── Account mutations ──────────────────────────────────────────────────────

  AccountGroup? get _activeGroupFromSection => switch (_activeSection) {
        _ReviewSection.personal => AccountGroup.personal,
        _ReviewSection.individuals => AccountGroup.individuals,
        _ReviewSection.entities => AccountGroup.entities,
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
    }
  }

  Future<void> _onReorderAccounts(
    List<Account> groupList,
    int oldIndex,
    int newIndex,
  ) async {
    final ordered =
        applyAccountGroupReorder(groupList, oldIndex, newIndex);
    if (mounted) setState(() {});
    final ok = await persistAccountOrdersAfterReorder(context, ordered);
    if (!mounted) return;
    if (!ok) {
      setState(() {});
      return;
    }
  }

  Future<void> _openAccountTransactions(Account account) async {
    final r = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
          builder: (_) => AccountTransactionsScreen(account: account)),
    );
    if (!mounted) return;
    if (r == kAccountFormSheetDeleted) {
      setState(() {});
    }
  }

  _ReviewCompareRows _reviewCompareRows() {
    if (!_compareMode || data.transactions.isEmpty) {
      return _ReviewCompareRows.empty;
    }
    final ba = _compareBounds(_compareMonthA);
    final bb = _compareBounds(_compareMonthB);
    final ma = _categorySpendingInRange(ba.start, ba.end);
    final mb = _categorySpendingInRange(bb.start, bb.end);
    final mLife = _categorySpendingInRange(null, null);
    final compareExpenseCategoryKeys =
        _orderedCategoryKeysForCompare(ma, mb, mLife);
    final effectiveCompareExpenseCategory = _pickCompareCategoryKey(
        compareExpenseCategoryKeys, _compareCategoryExpense);

    final ia = _categoryIncomeInRange(ba.start, ba.end);
    final ib = _categoryIncomeInRange(bb.start, bb.end);
    final iLife = _categoryIncomeInRange(null, null);
    final compareIncomeCategoryKeys =
        _orderedCategoryKeysForCompare(ia, ib, iLife);
    final effectiveCompareIncomeCategory = _pickCompareCategoryKey(
        compareIncomeCategoryKeys, _compareCategoryIncome);

    final sk = effectiveCompareExpenseCategory;
    final compareExpenseA = sk != null
        ? <MapEntry<String, ({double total, int count})>>[
            MapEntry(sk, ma[sk] ?? (total: 0.0, count: 0)),
          ]
        : <MapEntry<String, ({double total, int count})>>[];
    final compareExpenseB = sk != null
        ? <MapEntry<String, ({double total, int count})>>[
            MapEntry(sk, mb[sk] ?? (total: 0.0, count: 0)),
          ]
        : <MapEntry<String, ({double total, int count})>>[];

    final ik = effectiveCompareIncomeCategory;
    final compareIncomeA = ik != null
        ? <MapEntry<String, ({double total, int count})>>[
            MapEntry(ik, ia[ik] ?? (total: 0.0, count: 0)),
          ]
        : <MapEntry<String, ({double total, int count})>>[];
    final compareIncomeB = ik != null
        ? <MapEntry<String, ({double total, int count})>>[
            MapEntry(ik, ib[ik] ?? (total: 0.0, count: 0)),
          ]
        : <MapEntry<String, ({double total, int count})>>[];

    return _ReviewCompareRows._(
      compareExpenseCategoryKeys: compareExpenseCategoryKeys,
      compareIncomeCategoryKeys: compareIncomeCategoryKeys,
      effectiveCompareExpenseCategory: effectiveCompareExpenseCategory,
      effectiveCompareIncomeCategory: effectiveCompareIncomeCategory,
      compareExpenseA: compareExpenseA,
      compareExpenseB: compareExpenseB,
      compareIncomeA: compareIncomeA,
      compareIncomeB: compareIncomeB,
    );
  }

  List<Widget> _reviewAccountSectionSlivers(
    BuildContext context,
    AccountGroup group,
    List<Account> accounts,
  ) {
    if (accounts.isNotEmpty) {
      return [
        SliverToBoxAdapter(
          child: _SectionLabel(l10nAccountSectionTitle(context, group)),
        ),
        SliverReorderableList(
          itemCount: accounts.length,
          onReorderItem: (oldIndex, newIndex) =>
              _onReorderAccounts(accounts, oldIndex, newIndex),
          itemBuilder: (context, index) {
            final a = accounts[index];
            return _AccountCard(
              key: ValueKey(a.id),
              account: a,
              displayCurrency: _displayCurrency,
              onTap: () => _openAccountTransactions(a),
              reorderListIndex: index,
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 4)),
      ];
    }
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyAccountGroupHint(
          group: group,
          onAdd: _addAccount,
        ),
      ),
    ];
  }

  List<Widget> _reviewStatisticsSlivers(BuildContext context, ColorScheme cs) {
    final statsTab = _activeStats ?? _StatsMode.expense;
    final cmp = _reviewCompareRows();
    final compareExpenseA = cmp.compareExpenseA;
    final compareExpenseB = cmp.compareExpenseB;
    final compareIncomeA = cmp.compareIncomeA;
    final compareIncomeB = cmp.compareIncomeB;
    final effectiveCompareExpenseCategory = cmp.effectiveCompareExpenseCategory;
    final effectiveCompareIncomeCategory = cmp.effectiveCompareIncomeCategory;

    return [
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 40),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            if (data.transactions.isEmpty) const ReviewStatsEmptyState(),
            if (data.transactions.isNotEmpty) ...[
              _StatsHeader(
                activeStats: statsTab,
                onSelectStats: (s) => setState(() {
                  _activeStats = s;
                }),
                periodLabel: _periodLabel(context),
                statsPeriod: _statsPeriod,
                dateRangeLabel: _dateRangeLabel(context),
                onCyclePeriod: _cyclePeriod,
                canNavigateForward: _dateOffset > 0,
                onNavigateBack: _navigateBack,
                onNavigateForward: _navigateForward,
                vizMode: _vizMode,
                onCycleViz: _cycleViz,
                compareMode: _compareMode,
                onToggleCompare: () => setState(() {
                  if (_compareMode) {
                    _compareMode = false;
                  } else {
                    _compareMode = true;
                    if (_statsPeriod == _StatsPeriod.allTime) {
                      _statsPeriod = _StatsPeriod.month;
                    }
                  }
                }),
                compareCategoryKeys: _compareMode
                    ? (statsTab == _StatsMode.expense
                        ? cmp.compareExpenseCategoryKeys
                        : cmp.compareIncomeCategoryKeys)
                    : const [],
                compareSelectedCategory: _compareMode
                    ? (statsTab == _StatsMode.expense
                        ? effectiveCompareExpenseCategory
                        : effectiveCompareIncomeCategory)
                    : null,
                onCompareCategoryChanged: _compareMode
                    ? (String v) => setState(() {
                          if (statsTab == _StatsMode.expense) {
                            _compareCategoryExpense = v;
                          } else {
                            _compareCategoryIncome = v;
                          }
                        })
                    : null,
              ),
              if (statsTab == _StatsMode.expense &&
                  _compareMode &&
                  effectiveCompareExpenseCategory != null &&
                  compareExpenseA.isNotEmpty &&
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
                    dateRangeLabelA: _compareMiniNavRangeLabel(
                        context, _compareMonthA),
                    dateRangeLabelB: _compareMiniNavRangeLabel(
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
              if (statsTab == _StatsMode.expense && !_compareMode)
                _SpendingBody(
                  spending: _categorySpending,
                  periodLabel: _periodLabel(context),
                  statsPeriod: _statsPeriod,
                  vizMode: _vizMode,
                  displayCurrency: _displayCurrency,
                ),
              if (statsTab == _StatsMode.income &&
                  _compareMode &&
                  effectiveCompareIncomeCategory != null &&
                  compareIncomeA.isNotEmpty &&
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
                    dateRangeLabelA: _compareMiniNavRangeLabel(
                        context, _compareMonthA),
                    dateRangeLabelB: _compareMiniNavRangeLabel(
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
              if (statsTab == _StatsMode.income && !_compareMode)
                _IncomeBody(
                  income: _categoryIncome,
                  periodLabel: _periodLabel(context),
                  statsPeriod: _statsPeriod,
                  vizMode: _vizMode,
                  displayCurrency: _displayCurrency,
                ),
            ],
          ]),
        ),
      ),
    ];
  }

  List<Widget> _reviewSectionPageSlivers(
    BuildContext context,
    ColorScheme cs,
    _ReviewSection section,
    List<Account> personal,
    List<Account> individuals,
    List<Account> entities,
  ) {
    switch (section) {
      case _ReviewSection.personal:
        return _reviewAccountSectionSlivers(
            context, AccountGroup.personal, personal);
      case _ReviewSection.individuals:
        return _reviewAccountSectionSlivers(
            context, AccountGroup.individuals, individuals);
      case _ReviewSection.entities:
        return _reviewAccountSectionSlivers(
            context, AccountGroup.entities, entities);
      case _ReviewSection.statistics:
        return _reviewStatisticsSlivers(context, cs);
    }
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

  Widget? _reviewFloatingActionButton(
      AppLocalizations l10n, bool hasVisibleAccounts) {
    if (!hasVisibleAccounts) {
      if (!_showReviewScrollToTopFab) return null;
      return FloatingActionButton.small(
        heroTag: 'review_scroll_top',
        onPressed: _scrollReviewToTop,
        tooltip: l10n.fabScrollToTop,
        child: const Icon(Icons.vertical_align_top_rounded),
      );
    }

    Widget? mainFab;
    if (_activeSection == _ReviewSection.statistics) {
      if (_reviewStatisticsHasNonDefaultChoices) {
        mainFab = FloatingActionButton.small(
          heroTag: 'review_fab_reset',
          onPressed: _reviewFabResetStatistics,
          tooltip: l10n.heroResetButton,
          child: const Icon(Icons.restart_alt_rounded),
        );
      }
    } else if (_displayCurrency != settings.baseCurrency) {
      mainFab = FloatingActionButton.small(
        heroTag: 'review_fab_reset',
        onPressed: () =>
            setState(() => _displayCurrency = settings.baseCurrency),
        tooltip: l10n.heroResetButton,
        child: const Icon(Icons.restart_alt_rounded),
      );
    } else {
      mainFab = FloatingActionButton(
        key: _helpFabKey,
        heroTag: 'review_fab_add',
        onPressed: _addAccount,
        tooltip: l10n.tooltipAddAccount,
        child: const Icon(Icons.add_rounded),
      );
    }

    if (mainFab == null && !_showReviewScrollToTopFab) return null;

    return StackedScrollFab(
      showScrollToTop: _showReviewScrollToTopFab,
      onScrollToTop: _scrollReviewToTop,
      scrollToTopTooltip: l10n.fabScrollToTop,
      scrollHeroTag: 'review_scroll_top',
      mainFab: mainFab,
    );
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _reviewFloatingActionButton(
          l10n, visibleAccounts.isNotEmpty),
      body: visibleAccounts.isEmpty
          ? CustomScrollView(
              controller: _reviewEmptyScrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  scrolledUnderElevation: 0,
                  title: Text(l10n.navReview),
                  leading: HelpTourButton(steps: _helpSteps),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      tooltip: l10n.tooltipSettings,
                      onPressed: () async {
                        final prevSecondary = settings.secondaryCurrency;
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => const SettingsScreen()),
                        );
                        if (mounted) {
                          setState(() {
                            if (_displayCurrency == prevSecondary) {
                              _displayCurrency = settings.secondaryCurrency;
                            }
                            final validCurrencies = [
                              settings.secondaryCurrency,
                              settings.baseCurrency
                            ];
                            if (!validCurrencies.contains(_displayCurrency)) {
                              _displayCurrency = settings.baseCurrency;
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HeroPinnedDelegate(
                    child: _NetWorthHero(
                      key: _helpHeroKey,
                      personal: _personalTotal,
                      net: _netTotal,
                      displayCurrency: _displayCurrency,
                      sectionChipsEnabled: false,
                      activeSection: _activeSection,
                      onSelectSection: _selectReviewSection,
                      onToggleCurrency: () => setState(() {
                        _displayCurrency =
                            _displayCurrency == settings.baseCurrency
                                ? settings.secondaryCurrency
                                : settings.baseCurrency;
                      }),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyAccountsHint(onAdd: _addAccount),
                ),
              ],
            )
          : Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                // PageView paints first so the hero shadow (stacked above) blends
                // over scrolling content like Track/Plan slivers. A Column layout
                // painted the PageView on top and hid the soft shadow tail.
                Positioned.fill(
                  child: NotificationListener<Notification>(
                    onNotification: (notification) {
                      _handleReviewNotificationForHeroShadow(notification);
                      _maybeUpdateReviewScrollToTopFabFromNotification(
                          notification);
                      return false;
                    },
                    child: PageView.builder(
                      controller: _sectionPageController,
                      onPageChanged: _onReviewSectionPageChanged,
                      itemCount: _ReviewSection.values.length,
                      itemBuilder: (context, index) {
                        final section = _ReviewSection.values[index];
                        final topPad =
                            _reviewUnderHeaderScrollPadding(context);
                        return Builder(
                          builder: (context) {
                            return CustomScrollView(
                              key: PageStorageKey<String>(
                                  'review_section_$section'),
                              controller:
                                  _reviewPageScrollControllers[index],
                              slivers: [
                                SliverToBoxAdapter(
                                    child: SizedBox(height: topPad)),
                                SliverToBoxAdapter(
                                  child: KeyedSubtree(
                                    key: _reviewSectionScrollProbeKeys[index],
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                                ..._reviewSectionPageSlivers(
                                  context,
                                  cs,
                                  section,
                                  personal,
                                  individuals,
                                  entities,
                                ),
                                if (visibleAccounts.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: stackedFabScrollBottomInset(
                                          context),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _reviewHeroOverlapShadow,
                    builder: (context, contentScrolledUnder, _) {
                      final headerCs = Theme.of(context).colorScheme;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            scrolledUnderElevation: 0,
                            elevation: 0,
                            forceMaterialTransparency: true,
                            title: Text(l10n.navReview),
                            leading: HelpTourButton(steps: _helpSteps),
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.settings_outlined),
                                tooltip: l10n.tooltipSettings,
                                onPressed: () async {
                                  final prevSecondary =
                                      settings.secondaryCurrency;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const SettingsScreen()),
                                  );
                                  if (mounted) {
                                    setState(() {
                                      if (_displayCurrency == prevSecondary) {
                                        _displayCurrency =
                                            settings.secondaryCurrency;
                                      }
                                      final validCurrencies = [
                                        settings.secondaryCurrency,
                                        settings.baseCurrency
                                      ];
                                      if (!validCurrencies
                                          .contains(_displayCurrency)) {
                                        _displayCurrency =
                                            settings.baseCurrency;
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppHeroConstants.heroHeaderExtent,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: contentScrolledUnder
                                    ? AppHeroChrome.overlapScrollUnderShadows(
                                        headerCs)
                                    : const [],
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: AppHeroConstants
                                      .mainFlexibleSpaceHeroOuterPadding,
                                  child: _NetWorthHero(
                                    key: _helpHeroKey,
                                    personal: _personalTotal,
                                    net: _netTotal,
                                    displayCurrency: _displayCurrency,
                                    sectionChipsEnabled: true,
                                    activeSection: _activeSection,
                                    onSelectSection: _selectReviewSection,
                                    onToggleCurrency: () => setState(() {
                                      _displayCurrency =
                                          _displayCurrency ==
                                                  settings.baseCurrency
                                              ? settings.secondaryCurrency
                                              : settings.baseCurrency;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
  final _ReviewSection activeSection;
  final void Function(_ReviewSection section) onSelectSection;
  final VoidCallback onToggleCurrency;

  const _NetWorthHero({
    super.key,
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
    final lc = context.ledgerColors;
    final l10n = AppLocalizations.of(context);
    final displayPersonal =
        fx.convert(personal, settings.baseCurrency, displayCurrency);
    final displayNet =
        fx.convert(net, settings.baseCurrency, displayCurrency);
    final netPos = displayNet >= 0;
    final netColor = netPos ? lc.positive : lc.negative;
    final balanceColor =
        displayPersonal >= 0 ? lc.positive : lc.negative;
    final brightness = Theme.of(context).brightness;
    final sym = fx.currencySymbol(displayCurrency);
    final isSecondary = displayCurrency == settings.secondaryCurrency;
    final balanceStr =
        '${formatBalanceAmount(displayPersonal)} $sym';
    final netStr = '${formatBalanceAmount(displayNet)} $sym';

    Widget chip({
      required IconData icon,
      required bool active,
      required VoidCallback onTap,
      required String label,
      Widget? child,
    }) {
      return HeroTapChip(
        onTap: onTap,
        active: active,
        semanticsLabel: label,
        child: child ??
            Icon(
              icon,
              size: 15,
              color: HeroFilterChipStyle.foreground(cs, selected: active),
            ),
      );
    }

    final balanceStyle = TextStyle(
      fontSize: AppHeroConstants.primaryAmountFontSize,
      fontWeight: FontWeight.w800,
      color: balanceColor,
      letterSpacing: -1,
    );
    final netAmountStyle = TextStyle(
      fontSize: AppHeroConstants.secondaryAmountFontSize,
      fontWeight: FontWeight.w700,
      color: netColor,
      letterSpacing: -0.5,
    );

    return ListenableBuilder(
      listenable: balancePrivacyListenable,
      builder: (context, _) {
        final showAmounts = heroBalancesVisible;
        final balDisplay = showAmounts ? balanceStr : kHeroBalanceMasked;
        final netDisplay = showAmounts ? netStr : kHeroBalanceMasked;
        final balStyle = showAmounts
            ? balanceStyle
            : heroPrivacyMaskedAmountStyle(
                balanceStyle, cs, brightness);
        final netStyleEff = showAmounts
            ? netAmountStyle
            : heroPrivacyMaskedAmountStyle(
                netAmountStyle, cs, brightness);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: AppHeroConstants.cardPadding,
              decoration: AppHeroChrome.cardDecoration(cs, brightness),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroTwoColumnMetricsRow(
                    dividerColor:
                        AppHeroChrome.metricsDividerColor(cs, brightness),
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
                        const SizedBox(
                            height: AppHeroConstants.labelToAmountGap),
                        Semantics(
                          label: showAmounts
                              ? '${l10n.heroBalance} $balanceStr'
                              : l10n.semanticsHeroBalanceHidden,
                          child: HeroFittedAmount(
                            text: balDisplay,
                            style: balStyle,
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
                            fontSize:
                                AppHeroConstants.secondaryLabelFontSize,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                            height: AppHeroConstants.labelToAmountGap),
                        Semantics(
                          label: showAmounts
                              ? '${l10n.heroNet} $netStr'
                              : l10n.semanticsHeroBalanceHidden,
                          child: HeroFittedAmount(
                            text: netDisplay,
                            style: netStyleEff,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppHeroConstants.chipGapBelowMetrics),
                  Builder(builder: (context) {
                    final chipRow = Row(
                      children: [
                        Expanded(
                            child: chip(
                                icon: Icons.person_outline_rounded,
                                active: activeSection == _ReviewSection.personal,
                                label: l10n.accountGroupPersonal,
                                onTap: () =>
                                    onSelectSection(_ReviewSection.personal))),
                        const SizedBox(width: 6),
                        Expanded(
                            child: chip(
                                icon: Icons.people_outline_rounded,
                                active: activeSection == _ReviewSection.individuals,
                                label: l10n.accountSectionIndividuals,
                                onTap: () =>
                                    onSelectSection(_ReviewSection.individuals))),
                        const SizedBox(width: 6),
                        Expanded(
                            child: chip(
                                icon: Icons.business_outlined,
                                active: activeSection == _ReviewSection.entities,
                                label: l10n.accountSectionEntities,
                                onTap: () =>
                                    onSelectSection(_ReviewSection.entities))),
                        const SizedBox(width: 6),
                        Expanded(
                            child: chip(
                                icon: Icons.bar_chart_rounded,
                                active: activeSection == _ReviewSection.statistics,
                                label: l10n.semanticsSectionStatistics,
                                onTap: () =>
                                    onSelectSection(_ReviewSection.statistics))),
                        const SizedBox(width: 6),
                        Expanded(
                            child: chip(
                                icon: Icons.currency_exchange_rounded,
                                active: isSecondary,
                                label: l10n.semanticsCurrencyToggle,
                                onTap: onToggleCurrency)),
                      ],
                    );
                    if (!sectionChipsEnabled) {
                      return Semantics(
                        enabled: false,
                        label: l10n
                            .semanticsReviewSectionChipsDisabledNeedAccount,
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
            ),
            const PositionedDirectional(
              top: 2,
              end: 2,
              child: HeroBalancePrivacyToggleButton(),
            ),
          ],
        );
      },
    );
  }
}

// ─── Stats header (shared chips + date navigator) ─────────────────────────────

class _StatsHeader extends StatelessWidget {
  final _StatsMode? activeStats;
  final void Function(_StatsMode s) onSelectStats;
  final String periodLabel;
  final _StatsPeriod statsPeriod;
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
    required this.statsPeriod,
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
    final isAllTime = statsPeriod == _StatsPeriod.allTime;
    final vizIcon = vizMode == 1 ? Icons.donut_large_rounded : Icons.bar_chart_rounded;

    // Same footprint as _NetWorthHero chips: full row width, shared chip height, 6px gaps.
    // Row: spent / received / period / chart type (bar↔pie) / compare toggle.
    Widget chip({
      required IconData icon,
      required bool active,
      required VoidCallback onTap,
      String? label,
      String? semanticsLabel,
    }) =>
        HeroTapChip(
          onTap: onTap,
          active: active,
          semanticsLabel: semanticsLabel,
          child: label != null
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: HeroFilterChipStyle.foreground(cs,
                            selected: active),
                      )),
                )
              : Icon(icon,
                  size: 15,
                  color:
                      HeroFilterChipStyle.foreground(cs, selected: active)),
        );

    Widget navBtn({
      required IconData icon,
      required bool enabled,
      required VoidCallback onTap,
      required String semanticsLabel,
    }) =>
        _InkNavButton(
          icon: icon,
          enabled: enabled,
          onTap: onTap,
          size: 36,
          semanticsLabel: semanticsLabel,
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          // Chip row: spent, received, period, chart type (bar↔pie), compare.
          Row(
            children: [
              Expanded(
                child: chip(
                  icon: Icons.arrow_upward_rounded,
                  active: activeStats == _StatsMode.expense,
                  semanticsLabel: l10n.semanticsStatsSpent,
                  onTap: () => onSelectStats(_StatsMode.expense),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: chip(
                  icon: Icons.arrow_downward_rounded,
                  active: activeStats == _StatsMode.income,
                  semanticsLabel: l10n.semanticsStatsReceived,
                  onTap: () => onSelectStats(_StatsMode.income),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: chip(
                  icon: Icons.calendar_today_outlined,
                  active: true,
                  onTap: onCyclePeriod,
                  label: periodLabel,
                  semanticsLabel: l10n.semanticsPeriod(periodLabel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Semantics(
                  enabled: !compareMode,
                  label: compareMode
                      ? l10n.semanticsChartStyleUnavailable
                      : l10n.semanticsChartStyle,
                  button: true,
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
                child: Semantics(
                  label: l10n.reviewStatsModeComparison,
                  button: true,
                  selected: compareMode,
                  child: chip(
                    icon: Icons.compare_arrows_rounded,
                    active: compareMode,
                    onTap: onToggleCompare,
                  ),
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
                              '${activeStats?.name}_${compareCategoryKeys.length}_$k'),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
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
                  navBtn(
                    icon: Icons.chevron_left_rounded,
                    enabled: true,
                    onTap: onNavigateBack,
                    semanticsLabel: l10n.semanticsPreviousPeriod,
                  ),
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
                  
              semanticsLabel: AppLocalizations.of(context).semanticsNextPeriod,),
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
      required String semanticsLabel,
    }) =>
        _InkNavButton(
          icon: icon,
          enabled: enabled,
          onTap: onTap,
          size: 32,
          semanticsLabel: semanticsLabel,
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
            
              semanticsLabel: AppLocalizations.of(context).semanticsPreviousPeriod,),
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
            
              semanticsLabel: AppLocalizations.of(context).semanticsNextPeriod,),
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
    final lc = context.ledgerColors;
    final l10n = AppLocalizations.of(context);
    final sym = fx.currencySymbol(displayCurrency);
    final a = fx.convert(amountABase, settings.baseCurrency, displayCurrency);
    final b = fx.convert(amountBBase, settings.baseCurrency, displayCurrency);
    final accent = isExpense ? lc.negative : lc.positive;
    final brightness = Theme.of(context).brightness;
    final accentSoft = accent.withValues(
      alpha: brightness == Brightness.dark ? 0.20 : 0.11,
    );
    final sign = isExpense ? '−' : '+';
    String fmt(double v) =>
        '$sign${fx.formatNativeAmountDigits(v, displayCurrency)} $sym';
    final diff = b - a;
    final diffAbs = diff.abs();
    final diffStr =
        '${diff >= 0 ? '+' : '−'}${fx.formatNativeAmountDigits(diffAbs, displayCurrency)} $sym';

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
              cs.surfaceContainerLow,
              cs.surfaceContainerHighest.withValues(
                alpha: brightness == Brightness.dark ? 0.55 : 0.40,
              ),
            ],
          ),
          border: Border.all(
            color: cs.outlineVariant.withValues(
              alpha: brightness == Brightness.dark ? 0.50 : 0.65,
            ),
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
  final _StatsPeriod statsPeriod;
  final int vizMode;
  final String displayCurrency;

  const _SpendingBody({
    required this.spending,
    required this.periodLabel,
    required this.statsPeriod,
    required this.vizMode,
    required this.displayCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final expenseColor = context.ledgerColors.negative;
    const hPad = 16.0;
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalSpentBase = sorted.fold(0.0, (s, e) => s + e.value.total);
    final totalSpent = fx.convert(totalSpentBase, settings.baseCurrency, displayCurrency);
    final sym = fx.currencySymbol(displayCurrency);

    final emptyMsg = switch (statsPeriod) {
      _StatsPeriod.month => l10n.statsNoExpensesMonth,
      _StatsPeriod.allTime => l10n.statsNoExpensesAll,
      _ => l10n.statsNoExpensesPeriod(periodLabel),
    };

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 8),
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
          padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 6),
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
                    '-${formatBalanceAmount(totalSpent)} $sym',
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
                padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
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
            );
          }),
        ] else
          _BarsView(
            sorted: sorted,
            maxAmount: maxAmount,
            displayCurrency: displayCurrency,
            barColor: expenseColor,
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
  final _StatsPeriod statsPeriod;
  final int vizMode;
  final String displayCurrency;

  const _IncomeBody({
    required this.income,
    required this.periodLabel,
    required this.statsPeriod,
    required this.vizMode,
    required this.displayCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final incomeColor = context.ledgerColors.positive;
    const hPad = 16.0;
    final sorted = income.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalReceivedBase = sorted.fold(0.0, (s, e) => s + e.value.total);
    final totalReceived = fx.convert(totalReceivedBase, settings.baseCurrency, displayCurrency);
    final sym = fx.currencySymbol(displayCurrency);

    final emptyMsg = switch (statsPeriod) {
      _StatsPeriod.month => l10n.statsNoIncomeMonth,
      _StatsPeriod.allTime => l10n.statsNoIncomeAll,
      _ => l10n.statsNoIncomePeriod(periodLabel),
    };

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 8),
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
          padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 6),
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
                    '+${formatBalanceAmount(totalReceived)} $sym',
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
                padding: const EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
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
            );
          }),
        ] else
          _BarsView(
            sorted: sorted,
            maxAmount: maxAmount,
            displayCurrency: displayCurrency,
            barColor: incomeColor,
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

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
  })  : horizontalPadding = 16,
        narrowLayout = false;

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
                                '${fx.formatNativeAmountDigits(amount, displayCurrency)} ${fx.currencySymbol(displayCurrency)}',
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
  })  : donutHeight = 170,
        horizontalPadding = 16,
        narrowLegend = false;

  Color _colorForCategory(BuildContext context, int positionInList) {
    final palette =
        LedgerColors.chartPalette(Theme.of(context).colorScheme);
    return palette[positionInList % palette.length];
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
        .map((e) => _colorForCategory(context, e.key))
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
                final color = _colorForCategory(context, idx);
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
                              ? '${formatBalanceAmount(amount, fractionDigits: 1)} $sym'
                              : '${formatBalanceAmount(amount)} $sym',
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
  /// When set, the row can be reordered via long press and drag.
  final int? reorderListIndex;
  const _AccountCard({
    super.key,
    required this.account,
    required this.displayCurrency,
    required this.onTap,
    this.reorderListIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
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
    final mainColor = mainPositive ? lc.positive : lc.negative;
    final bookPositive = shownBook >= 0;
    final bookColor = bookPositive ? lc.positive : lc.negative;

    final nameLabel = accountDisplayName(account);

    final inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                AccountAvatar(account: account),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    nameLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${formatBalanceAmount(shownMain)} $shownSymbol',
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
                                  '${formatBalanceAmount(shownBook)} $shownSymbol',
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

    if (reorderListIndex != null) {
      final l10n = AppLocalizations.of(context);
      return Semantics(
        container: true,
        label: nameLabel,
        hint: l10n.semanticsReorderAccountHint,
        child: ReorderableDelayedDragStartListener(
          index: reorderListIndex!,
          child: inner,
        ),
      );
    }
    return inner;
  }
}

class _EmptyAccountGroupHint extends StatelessWidget {
  final AccountGroup group;
  final VoidCallback onAdd;

  const _EmptyAccountGroupHint({
    required this.group,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final (title, body, icon, accent) = switch (group) {
      AccountGroup.personal => (
          l10n.reviewEmptyGroupPersonalTitle,
          l10n.reviewEmptyGroupPersonalBody,
          Icons.person_outline_rounded,
          cs.primary,
        ),
      AccountGroup.individuals => (
          l10n.reviewEmptyGroupIndividualsTitle,
          l10n.reviewEmptyGroupIndividualsBody,
          Icons.people_outline_rounded,
          cs.tertiary,
        ),
      AccountGroup.entities => (
          l10n.reviewEmptyGroupEntitiesTitle,
          l10n.reviewEmptyGroupEntitiesBody,
          Icons.business_outlined,
          cs.secondary,
        ),
    };
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: accent),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
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


/// Round/rounded arrow button with ink and a screen-reader label; replaces
/// the GestureDetector arrows in the stats row and the compare mini-nav.
class _InkNavButton extends StatelessWidget {
  const _InkNavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.size,
    required this.semanticsLabel,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final double size;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(size / 2);
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel,
      child: Tooltip(
        message: semanticsLabel,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: radius,
            child: Ink(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: enabled
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: radius,
              ),
              child: Icon(
                icon,
                size: size / 2,
                color: enabled
                    ? cs.primary
                    : cs.onSurfaceVariant.withValues(alpha: 0.35),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
