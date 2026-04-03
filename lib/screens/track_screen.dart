import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/account_lifecycle.dart';
import '../data/app_data.dart' as data;
import '../data/data_repository.dart';
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_format.dart';
import '../utils/day_grouped_list.dart';
import '../utils/fx.dart' as fx;
import '../utils/projections.dart' as proj;
import '../utils/tx_display.dart';
import 'new_transaction_screen.dart';
import 'review_screen.dart' show AccountFormSheet;
import 'settings_screen.dart';
import 'transaction_detail_screen.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/track_plan_filter_ui.dart';

class TrackScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const TrackScreen({super.key, this.onChanged});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

// Type-group strings used by the filter.
const _kTypeIncome   = 'income';
const _kTypeExpense  = 'expense';
const _kTypeTransfer = 'transfer';

bool _inGroup(TxType t, String group) => switch (group) {
  _kTypeIncome   => const {TxType.income, TxType.collection, TxType.loan, TxType.invoice}.contains(t),
  _kTypeExpense  => const {TxType.expense, TxType.bill, TxType.settlement, TxType.advance}.contains(t),
  _kTypeTransfer => const {TxType.transfer, TxType.offset}.contains(t),
  _ => true,
};

class _TrackScreenState extends State<TrackScreen> {
  // ── Pagination ──────────────────────────────────────────────────────────────
  final _scrollController = ScrollController();

  /// Reset when filters / data window change; caps how many day sections build.
  int _visibleTrackDaySlots = kLazyDayInitialCount;
  int? _trackLazyListSig;

  // ── Filters ─────────────────────────────────────────────────────────────────
  String? _typeFilter;      // _kTypeIncome / _kTypeExpense / _kTypeTransfer
  Account? _accountFilter;
  String? _categoryFilter;
  /// null = current calendar month only [start, next month); UI cycles week/month/year; 'day'|'all' in data paths.
  String? _dateFilter;
  DateTime _dateAnchor = DateTime.now();
  bool _newestFirst = true;
  TrackPlanFilterPanel _trackPanel = TrackPlanFilterPanel.none;
  String _searchQuery = '';

  bool get _hasActiveFilter =>
      _typeFilter != null ||
      _accountFilter != null ||
      _categoryFilter != null ||
      _dateFilter != null ||
      !_newestFirst ||
      _searchQuery.trim().isNotEmpty;

  void _clearFilters() => setState(() {
        _typeFilter = null;
        _accountFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
        _newestFirst = true;
        _trackPanel = TrackPlanFilterPanel.none;
        _searchQuery = '';
      });

  void _toggleTrackPanel(TrackPlanFilterPanel panel) => setState(() {
        _trackPanel = _trackPanel == panel ? TrackPlanFilterPanel.none : panel;
      });

  void _cycleTypeFilter() => setState(() {
        if (_typeFilter == null) {
          _typeFilter = _kTypeIncome;
        } else if (_typeFilter == _kTypeIncome) {
          _typeFilter = _kTypeExpense;
        } else if (_typeFilter == _kTypeExpense) {
          _typeFilter = _kTypeTransfer;
        } else {
          _typeFilter = null;
        }
      });

  /// Cycles: this month (null) → month → week → year → all time → null.
  /// Closes account/category strip when switching date mode only.
  void _cycleDateFilter() => setState(() {
        _trackPanel = TrackPlanFilterPanel.none;
        if (_dateFilter == null) {
          _dateFilter = 'month';
          _dateAnchor = DateTime.now();
        } else if (_dateFilter == 'month') {
          _dateFilter = 'week';
          _dateAnchor = DateTime.now();
        } else if (_dateFilter == 'week') {
          _dateFilter = 'year';
          _dateAnchor = DateTime.now();
        } else if (_dateFilter == 'year') {
          _dateFilter = 'all';
        } else {
          _dateFilter = null;
        }
      });

  void _toggleSort() => setState(() => _newestFirst = !_newestFirst);

  bool get _hasNavigableDateFilter =>
      _dateFilter == 'week' ||
      _dateFilter == 'month' ||
      _dateFilter == 'year';

  /// Shown on the date chip (calendar when null = this month only).
  String? get _dateChipModeLetter => switch (_dateFilter) {
        'month' => 'M',
        'week' => 'W',
        'year' => 'Y',
        'all' => '∞',
        _ => null,
      };

  void _navigateDate(int direction) {
    setState(() {
      var next = switch (_dateFilter) {
        'day' => DateTime(_dateAnchor.year, _dateAnchor.month,
            _dateAnchor.day + direction),
        'week' => DateTime(_dateAnchor.year, _dateAnchor.month,
            _dateAnchor.day + direction * 7),
        'month' => DateTime(_dateAnchor.year, _dateAnchor.month + direction,
            _dateAnchor.day),
        'year' => DateTime(_dateAnchor.year + direction, _dateAnchor.month,
            _dateAnchor.day),
        _ => _dateAnchor,
      };
      if (_dateFilter == 'day') {
        final today = DateUtils.dateOnly(DateTime.now());
        final n = DateUtils.dateOnly(next);
        if (n.isAfter(today)) next = _dateAnchor;
      }
      _dateAnchor = next;
    });
  }

  bool get _canNavigateDateForward {
    final now = DateTime.now();
    return switch (_dateFilter) {
      'day' => DateUtils.dateOnly(_dateAnchor)
          .isBefore(DateUtils.dateOnly(now)),
      'week' => () {
          final a = _dateAnchor;
          final mon = DateTime(a.year, a.month, a.day - (a.weekday - 1));
          final nMon =
              DateTime(now.year, now.month, now.day - (now.weekday - 1));
          return mon.isBefore(nMon);
        }(),
      'month' => DateTime(_dateAnchor.year, _dateAnchor.month)
          .isBefore(DateTime(now.year, now.month)),
      'year' => _dateAnchor.year < now.year,
      _ => true,
    };
  }

  /// Inclusive start / exclusive end for the selected date period.
  (DateTime, DateTime) get _dateRange {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'day' => (
          DateTime(a.year, a.month, a.day),
          DateTime(a.year, a.month, a.day + 1),
        ),
      'week' => () {
          final mon =
              DateTime(a.year, a.month, a.day - (a.weekday - 1));
          return (mon, DateTime(mon.year, mon.month, mon.day + 7));
        }(),
      'month' => (DateTime(a.year, a.month), DateTime(a.year, a.month + 1)),
      'year' => (DateTime(a.year), DateTime(a.year + 1)),
      _ => (DateTime(0), DateTime(9999)),
    };
  }

  /// Human-readable label for the current date anchor + period.
  String _dateLabel(BuildContext context) {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'day' => formatAppDate(context, 'EEE, d MMM yyyy', a),
      'week' => () {
          final mon = DateTime(a.year, a.month, a.day - (a.weekday - 1));
          final sun = DateTime(mon.year, mon.month, mon.day + 6);
          final sameMon = mon.month == sun.month;
          return sameMon
              ? '${formatAppDate(context, 'd', mon)} – ${formatAppDate(context, 'd MMM yyyy', sun)}'
              : '${formatAppDate(context, 'd MMM', mon)} – ${formatAppDate(context, 'd MMM yyyy', sun)}';
        }(),
      'month' => formatAppDate(context, 'MMMM yyyy', a),
      'year' => formatAppDate(context, 'yyyy', a),
      _ => '',
    };
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onTrackScrollLoadMoreDays);
  }

  void _onTrackScrollLoadMoreDays() {
    if (_dateFilter != 'all') return;
    if (_searchQuery.trim().isNotEmpty) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasPixels || !pos.hasContentDimensions) return;
    if (pos.pixels < pos.maxScrollExtent - 360) return;

    final g = DayGroupedTransactions.build(_baseFilteredTx, _newestFirst);
    if (!shouldLazyLoadDaySections(_dateFilter, g.dayKeys.length)) return;
    if (_visibleTrackDaySlots >= g.dayKeys.length) return;

    setState(() {
      _visibleTrackDaySlots = math.min(
        _visibleTrackDaySlots + kLazyDayLoadBatch,
        g.dayKeys.length,
      );
    });
  }

  void _syncTrackLazyWindowSignature() {
    final sig = Object.hash(
      _dateFilter,
      _typeFilter,
      _accountFilter?.id,
      _categoryFilter,
      _newestFirst,
      _baseFilteredTx.length,
      data.transactions.length,
    );
    if (_trackLazyListSig != sig) {
      _trackLazyListSig = sig;
      _visibleTrackDaySlots = kLazyDayInitialCount;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onTrackScrollLoadMoreDays);
    _scrollController.dispose();
    super.dispose();
  }

  /// Default window when the date chip is on “this month” (calendar icon): same as Plan — current month only.
  (DateTime, DateTime) get _currentMonthRange {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    return (start, end);
  }

  /// Transactions in the current calendar month only (when [_dateFilter] is null).
  List<Transaction> get _visibleTx {
    final (start, end) = _currentMonthRange;
    return data.transactions
        .where((t) => !t.date.isBefore(start) && t.date.isBefore(end))
        .toList();
  }

  /// Income and expense totals reflecting the current filter/window.
  ({double totalIn, double totalOut}) get _periodTotals {
    final source = _baseFilteredTx;
    double totalIn = 0, totalOut = 0;
    for (final t in source) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      final base = fx.toBase(
          t.nativeAmount ?? 0, t.currencyCode ?? settings.baseCurrency);
      if (_inGroup(type, _kTypeIncome)) {
        totalIn += base;
      } else if (_inGroup(type, _kTypeExpense)) {
        totalOut += base;
      }
    }
    return (totalIn: totalIn, totalOut: totalOut);
  }

  /// Filters only (no text search). Used for hero totals and lazy-load signature.
  List<Transaction> get _baseFilteredTx {
    Iterable<Transaction> source;
    if (_dateFilter == null) {
      source = _visibleTx;
    } else if (_dateFilter == 'all') {
      source = data.transactions;
    } else {
      final (start, end) = _dateRange;
      source = data.transactions.where(
          (t) => !t.date.isBefore(start) && t.date.isBefore(end));
    }

    if (_typeFilter != null) {
      source = source.where((t) {
        final type = t.txType ??
            classifyTransaction(from: t.fromAccount, to: t.toAccount);
        return _inGroup(type, _typeFilter!);
      });
    }

    if (_accountFilter != null && !_accountFilter!.archived) {
      final id = _accountFilter!.id;
      source = source.where(
        (t) =>
            t.fromAccount?.id == id ||
            t.toAccount?.id == id ||
            t.fromAccountId == id ||
            t.toAccountId == id,
      );
    }

    if (_categoryFilter != null) {
      source = source.where((t) => t.category == _categoryFilter);
    }

    return source.toList();
  }

  List<Transaction> _applySearch(
      List<Transaction> txs, BuildContext context) {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return txs;
    return txs.where((t) {
      if (t.description?.toLowerCase().contains(q) ?? false) return true;
      final cat = t.category;
      if (cat != null) {
        if (cat.toLowerCase().contains(q)) return true;
        if (l10nCategoryName(context, cat).toLowerCase().contains(q)) {
          return true;
        }
      }
      final fn = t.fromAccount?.name ?? t.fromSnapshotName;
      final tn = t.toAccount?.name ?? t.toSnapshotName;
      if (fn != null && fn.toLowerCase().contains(q)) return true;
      if (tn != null && tn.toLowerCase().contains(q)) return true;
      final amt = t.nativeAmount;
      if (amt != null && amt.toString().contains(q)) return true;
      return false;
    }).toList();
  }

  Future<void> _addAccount() async {
    final result = await showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) => const AccountFormSheet(),
    );
    if (result is Account) {
      await DataRepository.addAccount(result);
      if (mounted) setState(() {});
      widget.onChanged?.call();
    }
  }

  Future<void> _openNewTransaction() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NewTransactionScreen()),
    );
    if (result == true) {
      setState(() {});
      widget.onChanged?.call();
    }
  }

  Future<void> _editTransaction(Transaction t) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NewTransactionScreen(existing: t)),
    );
    if (result == true) {
      setState(() {});
      widget.onChanged?.call();
    }
  }

  void _openTransactionDetail(Transaction t) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionDetailScreen(
          transaction: t,
          onEdit: () => _editTransaction(t),
          onDelete: () => _deleteTransaction(t),
        ),
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction t) async {
    final index = data.transactions.indexOf(t);
    if (t.nativeAmount != null) {
      if (t.fromAccount != null) t.fromAccount!.balance += t.nativeAmount!;
      if (t.toAccount != null) {
        t.toAccount!.balance -=
            (t.destinationAmount ?? t.nativeAmount!);
      }
    }
    await DataRepository.removeTransaction(t);
    if (!mounted) return;
    setState(() {});
    widget.onChanged?.call();
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).trackTransactionDeleted),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        duration: const Duration(seconds: 5),
        persist: false,
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () async {
            messenger.clearSnackBars();
            if (t.nativeAmount != null) {
              if (t.fromAccount != null) {
                t.fromAccount!.balance -= t.nativeAmount!;
              }
              if (t.toAccount != null) {
                t.toAccount!.balance +=
                    (t.destinationAmount ?? t.nativeAmount!);
              }
            }
            final insertAt = index < 0 ? 0 : index.clamp(0, data.transactions.length);
            await DataRepository.insertTransactionAt(insertAt, t);
            if (mounted) setState(() {});
            widget.onChanged?.call();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_accountFilter != null && _accountFilter!.archived) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            _accountFilter != null &&
            _accountFilter!.archived) {
          setState(() => _accountFilter = null);
        }
      });
    }
    final trackChipsEnabled = activeAccounts(data.accounts).isNotEmpty &&
        data.transactions.isNotEmpty;
    if (!trackChipsEnabled &&
        (_trackPanel != TrackPlanFilterPanel.none || _hasActiveFilter)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _clearFilters();
      });
    }
    final cs = Theme.of(context).colorScheme;
    final allTx = data.transactions;

    return Scaffold(
      backgroundColor: cs.surface,
      body: allTx.isEmpty
          ? _emptyBody(context, trackChipsEnabled)
          : _listBody(context, trackChipsEnabled),
      floatingActionButton: allTx.isEmpty
          ? null
          : _hasActiveFilter
              ? FloatingActionButton.extended(
                  heroTag: 'track_fab',
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  label: Text(AppLocalizations.of(context).filterClearFilters),
                )
              : FloatingActionButton(
                  heroTag: 'track_fab',
                  onPressed: _openNewTransaction,
                  child: const Icon(Icons.add_rounded),
                ),
    );
  }

  Widget _emptyBody(BuildContext context, bool trackChipsEnabled) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final hasAccounts = activeAccounts(data.accounts).isNotEmpty;
    final trackDisabledSemantics = !hasAccounts
        ? l10n.semanticsFiltersDisabledNeedAccount
        : l10n.semanticsFiltersDisabledNeedRecordedTransaction;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          backgroundColor: cs.surface,
          scrolledUnderElevation: 0,
          title: Text(AppLocalizations.of(context).navTrack),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: AppLocalizations.of(context).tooltipSettings,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
                if (mounted) setState(() {});
                widget.onChanged?.call();
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
                  _TrackHero(
                    totalIn: 0,
                    totalOut: 0,
                    panel: _trackPanel,
                    onTogglePanel: _toggleTrackPanel,
                    typeFilter: _typeFilter,
                    onCycleType: _cycleTypeFilter,
                    dateModeLetter: _dateChipModeLetter,
                    dateFilterActive: _dateFilter != null,
                    onCycleDate: _cycleDateFilter,
                    accountFilter: _accountFilter,
                    categoryFilter: _categoryFilter,
                    newestFirst: _newestFirst,
                    onToggleSort: _toggleSort,
                    filterChipsEnabled: trackChipsEnabled,
                    filterChipsDisabledSemantics: trackDisabledSemantics,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (trackChipsEnabled && _hasNavigableDateFilter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TrackPlanDateNavBar(
                label: _dateLabel(context),
                onNavigateBack: () => _navigateDate(-1),
                onNavigateForward: _canNavigateDateForward
                    ? () => _navigateDate(1)
                    : null,
              ),
            ),
          ),
        if (trackChipsEnabled && _trackPanel != TrackPlanFilterPanel.none)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
              child: TrackPlanFilterStrip(
                panel: _trackPanel,
                accounts: activeAccounts(data.accounts),
                accountFilter: _accountFilter,
                onAccountFilter: (a) => setState(() => _accountFilter = a),
                categories: <String>{
                  ...data.incomeCategories,
                  ...data.expenseCategories,
                }.toList()
                  ..sort(),
                categoryFilter: _categoryFilter,
                onCategoryFilter: (c) => setState(() => _categoryFilter = c),
              ),
            ),
          ),

        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: hasAccounts ? 80 : 88,
                  height: hasAccounts ? 80 : 88,
                  decoration: BoxDecoration(
                    color: hasAccounts
                        ? cs.primaryContainer
                        : cs.primaryContainer.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasAccounts
                        ? Icons.receipt_long_rounded
                        : Icons.account_balance_wallet_rounded,
                    size: hasAccounts ? 36 : 44,
                    color: cs.primary,
                  ),
                ),
                SizedBox(height: hasAccounts ? 20 : 24),
                Text(
                  hasAccounts
                      ? l10n.emptyNoTransactionsYet
                      : l10n.emptyNoAccountsYet,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: hasAccounts ? 6 : 8),
                Text(
                  hasAccounts
                      ? l10n.emptyRecordFirstTransaction
                      : l10n.emptyAddFirstAccountTx,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                    height: hasAccounts ? null : 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed:
                      hasAccounts ? _openNewTransaction : _addAccount,
                  icon: const Icon(Icons.add),
                  label: Text(
                      hasAccounts
                          ? l10n.emptyAddTransaction
                          : l10n.emptyAddAccount),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _listBody(BuildContext context, bool trackChipsEnabled) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final trackDisabledSemantics = activeAccounts(data.accounts).isEmpty
        ? l10n.semanticsFiltersDisabledNeedAccount
        : data.transactions.isEmpty
            ? l10n.semanticsFiltersDisabledNeedRecordedTransaction
            : l10n.semanticsFiltersDisabled;
    final isFiltered = _hasActiveFilter;
    final displayTx = _applySearch(_baseFilteredTx, context);
    final totals = _periodTotals;

    _syncTrackLazyWindowSignature();
    final dayBundle =
        DayGroupedTransactions.build(displayTx, _newestFirst);
    final days = dayBundle.dayKeys;
    final grouped = dayBundle.grouped;
    final lazyDays = shouldLazyLoadDaySections(_dateFilter, days.length);
    final visibleDayCount = lazyDays
        ? math.min(_visibleTrackDaySlots, days.length)
        : days.length;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          backgroundColor: cs.surface,
          scrolledUnderElevation: 0,
          title: Text(AppLocalizations.of(context).navTrack),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: AppLocalizations.of(context).tooltipSettings,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
                if (mounted) setState(() {});
                widget.onChanged?.call();
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
                  _TrackHero(
                    totalIn: totals.totalIn,
                    totalOut: totals.totalOut,
                    panel: _trackPanel,
                    onTogglePanel: _toggleTrackPanel,
                    typeFilter: _typeFilter,
                    onCycleType: _cycleTypeFilter,
                    dateModeLetter: _dateChipModeLetter,
                    dateFilterActive: _dateFilter != null,
                    onCycleDate: _cycleDateFilter,
                    accountFilter: _accountFilter,
                    categoryFilter: _categoryFilter,
                    newestFirst: _newestFirst,
                    onToggleSort: _toggleSort,
                    filterChipsEnabled: trackChipsEnabled,
                    filterChipsDisabledSemantics: trackDisabledSemantics,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (trackChipsEnabled && _hasNavigableDateFilter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TrackPlanDateNavBar(
                label: _dateLabel(context),
                onNavigateBack: () => _navigateDate(-1),
                onNavigateForward: _canNavigateDateForward
                    ? () => _navigateDate(1)
                    : null,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: l10n.trackSearchHint,
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        tooltip: l10n.trackSearchClear,
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (trackChipsEnabled && _trackPanel != TrackPlanFilterPanel.none)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
              child: TrackPlanFilterStrip(
                panel: _trackPanel,
                accounts: activeAccounts(data.accounts),
                accountFilter: _accountFilter,
                onAccountFilter: (a) => setState(() => _accountFilter = a),
                categories: <String>{
                  ...data.incomeCategories,
                  ...data.expenseCategories,
                }.toList()
                  ..sort(),
                categoryFilter: _categoryFilter,
                onCategoryFilter: (c) => setState(() => _categoryFilter = c),
              ),
            ),
          ),

        if (displayTx.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFiltered
                        ? Icons.search_off_rounded
                        : Icons.calendar_today_outlined,
                    size: 48,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isFiltered
                        ? l10n.emptyNoTransactionsForFilters
                        : _dateFilter == 'all'
                            ? l10n.emptyNoTransactionsInHistory
                            : l10n.emptyNoTransactionsForMonth(
                                formatAppDate(
                                    context, 'MMMM', DateTime.now())),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          )
        else ...[
          // Day-grouped list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final day = days[i];
                final txs = grouped[day]!;
                final date = DateTime.parse(day);
                return _DaySection(
                  date: date,
                  transactions: txs,
                  onRefresh: () {
                    setState(() {});
                    widget.onChanged?.call();
                  },
                  onEdit: _editTransaction,
                  onTap: _openTransactionDetail,
                );
              },
              childCount: visibleDayCount,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ],
    );
  }
}

// ─── Track hero (totals + main filter chips only) ────────────────────────────

class _TrackHero extends StatelessWidget {
  final double totalIn;
  final double totalOut;
  final TrackPlanFilterPanel panel;
  final void Function(TrackPlanFilterPanel) onTogglePanel;
  final String? typeFilter;
  final VoidCallback onCycleType;
  /// `M` / `W` / `Y` when that period mode is active; null → calendar icon.
  final String? dateModeLetter;
  final bool dateFilterActive;
  final VoidCallback onCycleDate;
  final Account? accountFilter;
  final String? categoryFilter;
  final bool newestFirst;
  final VoidCallback onToggleSort;
  final bool filterChipsEnabled;
  final String filterChipsDisabledSemantics;

  const _TrackHero({
    required this.totalIn,
    required this.totalOut,
    required this.panel,
    required this.onTogglePanel,
    required this.typeFilter,
    required this.onCycleType,
    required this.dateModeLetter,
    required this.dateFilterActive,
    required this.onCycleDate,
    required this.accountFilter,
    required this.categoryFilter,
    required this.newestFirst,
    required this.onToggleSort,
    required this.filterChipsEnabled,
    required this.filterChipsDisabledSemantics,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final net = totalIn - totalOut;
    final netPos = net >= 0;
    final borderColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final sym = fx.currencySymbol(settings.baseCurrency);

    return Container(
      padding: AppHeroConstants.cardPadding,
      decoration: BoxDecoration(
        color: borderColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroTwoColumnMetricsRow(
            dividerColor: borderColor.withValues(alpha: 0.2),
            leftColumn: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).heroIn,
                  style: TextStyle(
                    fontSize: AppHeroConstants.labelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '+${totalIn.toStringAsFixed(2)} $sym',
                  style: const TextStyle(
                    fontSize: AppHeroConstants.primaryAmountFontSize,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16A34A),
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
                  AppLocalizations.of(context).heroOut,
                  style: TextStyle(
                    fontSize: AppHeroConstants.secondaryLabelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '-${totalOut.toStringAsFixed(2)} $sym',
                  style: const TextStyle(
                    fontSize: AppHeroConstants.secondaryAmountFontSize,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppHeroConstants.chipGapBelowMetrics),
          TrackPlanFilterChipRow(
            panel: panel,
            onTogglePanel: onTogglePanel,
            typeFilter: typeFilter,
            onCycleType: onCycleType,
            dateModeLetter: dateModeLetter,
            dateFilterActive: dateFilterActive,
            onCycleDate: onCycleDate,
            accountFilter: accountFilter,
            categoryFilter: categoryFilter,
            newestFirst: newestFirst,
            onToggleSort: onToggleSort,
            enabled: filterChipsEnabled,
            disabledSemanticsLabel: filterChipsDisabledSemantics,
          ),
        ],
      ),
    );
  }
}

// ─── Day section ──────────────────────────────────────────────────────────────

class _DaySection extends StatefulWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final VoidCallback onRefresh;
  final void Function(Transaction) onEdit;
  final void Function(Transaction) onTap;

  const _DaySection({
    required this.date,
    required this.transactions,
    required this.onRefresh,
    required this.onEdit,
    required this.onTap,
  });

  @override
  State<_DaySection> createState() => _DaySectionState();
}

class _DaySectionState extends State<_DaySection> {
  bool _showHistory = false;

  String _dayLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(widget.date);
    if (target == today) return l10n.dateToday;
    if (target == today.subtract(const Duration(days: 1))) {
      return l10n.dateYesterday;
    }
    return formatAppDate(context, 'EEEE, MMM d', widget.date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final historicalBals = proj.historicalBalances(widget.date);
    final gainIds = <String>{
      for (final t in widget.transactions)
        if (t.toAccount != null) t.toAccount!.id,
    };
    final loseIds = <String>{
      for (final t in widget.transactions)
        if (t.fromAccount != null) t.fromAccount!.id,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(_dayLabel(context),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.1)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                ...widget.transactions.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final isLast = idx == widget.transactions.length - 1;
                  return Column(
                    children: [
                      if (idx > 0)
                        Divider(
                          height: 0.5,
                          indent: 68,
                          color: cs.outlineVariant.withValues(alpha: 0.4),
                        ),
                      _TransactionTile(
                        transaction: entry.value,
                        onRefresh: widget.onRefresh,
                        onEdit: widget.onEdit,
                        onTap: widget.onTap,
                        showHistory: isLast ? _showHistory : false,
                        onToggleHistory: isLast
                            ? () => setState(() => _showHistory = !_showHistory)
                            : null,
                      ),
                    ],
                  );
                }),
                if (_showHistory) ...[
                  Divider(
                      height: 0.5,
                      color: cs.outlineVariant.withValues(alpha: 0.4)),
                  _HistoryPanel(
                    balances: historicalBals,
                    gainIds: gainIds,
                    loseIds: loseIds,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Transaction tile ─────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onRefresh;
  final void Function(Transaction) onEdit;
  final void Function(Transaction) onTap;
  final bool showHistory;
  final VoidCallback? onToggleHistory;

  const _TransactionTile({
    required this.transaction,
    required this.onRefresh,
    required this.onEdit,
    required this.onTap,
    this.showHistory = false,
    this.onToggleHistory,
  });

  /// Stored type takes priority; fall back to live classification for old data.
  TxType get _type =>
      transaction.txType ??
      classifyTransaction(
          from: transaction.fromAccount, to: transaction.toAccount);

  Color _iconBg(BuildContext ctx) =>
      txColor(_type).withValues(alpha: 0.12);
  Color _iconColor(BuildContext ctx) => txColor(_type);
  IconData get _icon => txIcon(_type);

  String _title(BuildContext context) {
    final t = transaction;
    if (t.description != null) {
      return l10nSentinel(t.description, AppLocalizations.of(context));
    }
    if (t.category != null) return l10nCategoryName(context, t.category!);
    if (t.fromAccount != null && t.toAccount != null) {
      return '${t.fromAccount!.name} → ${t.toAccount!.name}';
    }
    if (t.fromAccount != null) return t.fromAccount!.name;
    if (t.toAccount != null) return t.toAccount!.name;
    return AppLocalizations.of(context).trackTransaction;
  }

  String? _subtitle(BuildContext context) {
    final t = transaction;
    final parts = <String>[];
    if (t.description != null || t.category != null) {
      if (t.fromAccount != null && t.toAccount != null) {
        parts.add('${t.fromAccount!.name} → ${t.toAccount!.name}');
      } else if (t.fromAccount != null) {
        parts.add(t.fromAccount!.name);
      } else if (t.toAccount != null) {
        parts.add(t.toAccount!.name);
      }
    }
    if (t.description != null && t.category != null) {
      parts.add(l10nCategoryName(context, t.category!));
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String _amountDisplay() {
    final amount = transaction.nativeAmount;
    if (amount == null) return '';
    return txAmountDisplay(_type, amount, transaction.currencyCode ?? 'BAM');
  }

  Color _amountColor(BuildContext ctx) => txColor(_type);

  Future<void> _delete(BuildContext context) async {
    final t = transaction;
    final index = data.transactions.indexOf(t);
    if (t.nativeAmount != null) {
      // Reverse the balance changes in each account's native currency.
      if (t.fromAccount != null) t.fromAccount!.balance += t.nativeAmount!;
      // Rule 4: cross-currency moves used destinationAmount for the receiving
      // account — reverse the same amount.
      if (t.toAccount != null) {
        t.toAccount!.balance -=
            (t.destinationAmount ?? t.nativeAmount!);
      }
    }
    await DataRepository.removeTransaction(t);
    if (!context.mounted) return;
    onRefresh();
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).trackTransactionDeleted),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        duration: const Duration(seconds: 5),
        persist: false,
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () async {
            messenger.clearSnackBars();
            if (t.nativeAmount != null) {
              if (t.fromAccount != null) {
                t.fromAccount!.balance -= t.nativeAmount!;
              }
              if (t.toAccount != null) {
                t.toAccount!.balance +=
                    (t.destinationAmount ?? t.nativeAmount!);
              }
            }
            final insertAt = index < 0 ? 0 : index.clamp(0, data.transactions.length);
            await DataRepository.insertTransactionAt(insertAt, t);
            onRefresh();
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context).trackDeleteTitle),
        content: Text(AppLocalizations.of(context).trackDeleteBody),
        icon: Icon(Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(ctx).cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _delete(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(ctx).delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = _subtitle(context);

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _confirmDelete(context);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.withValues(alpha: 0.12),
        child: const Icon(Icons.delete_outline_rounded,
            color: Color(0xFFDC2626), size: 22),
      ),
      child: InkWell(
        onTap: () => onTap(transaction),
        onLongPress: () => onEdit(transaction),
        child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBg(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(_icon, size: 18, color: _iconColor(context)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_title(context),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: cs.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            if (transaction.nativeAmount != null) ...[
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(_amountDisplay(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _amountColor(context))),
              ),
            ],
            if (onToggleHistory != null)
              SizedBox(
                width: 48,
                height: 48,
                child: GestureDetector(
                  onTap: onToggleHistory,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Icon(
                      showHistory
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.55),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }
}

// ─── History panel ────────────────────────────────────────────────────────────

const _kHistoryIncomeColor = Color(0xFF16A34A);
const _kHistoryExpenseColor = Color(0xFFDC2626);

class _HistoryPanel extends StatelessWidget {
  final Map<String, double> balances;
  final Set<String> gainIds;
  final Set<String> loseIds;

  const _HistoryPanel({
    required this.balances,
    this.gainIds = const {},
    this.loseIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final active = activeAccounts(data.accounts);
    final personal = active
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final individuals = active
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final entities = active
        .where((a) => a.group == AccountGroup.entities)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (personal.isNotEmpty) ...[
            Text(
                l10nAccountSectionTitle(context, AccountGroup.personal)
                    .toUpperCase(),
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
            const SizedBox(height: 6),
            ...personal.map((a) {
              final book = balances[a.id] ?? a.balance;
              return _HistoryChip(
                name: a.name,
                balance: a.personalHeadroomNative(book),
                currencyCode: a.currencyCode,
                isGain: gainIds.contains(a.id),
                isLose: loseIds.contains(a.id),
              );
            }),
          ],
          if (individuals.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
                l10nAccountSectionTitle(context, AccountGroup.individuals)
                    .toUpperCase(),
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.tertiary)),
            const SizedBox(height: 6),
            ...individuals.map((a) {
              final book = balances[a.id] ?? a.balance;
              return _HistoryChip(
                name: a.name,
                balance: a.personalHeadroomNative(book),
                currencyCode: a.currencyCode,
                isPartner: true,
                isGain: gainIds.contains(a.id),
                isLose: loseIds.contains(a.id),
              );
            }),
          ],
          if (entities.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
                l10nAccountSectionTitle(context, AccountGroup.entities)
                    .toUpperCase(),
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.secondary)),
            const SizedBox(height: 6),
            ...entities.map((a) {
              final book = balances[a.id] ?? a.balance;
              return _HistoryChip(
                name: a.name,
                balance: a.personalHeadroomNative(book),
                currencyCode: a.currencyCode,
                isPartner: true,
                isGain: gainIds.contains(a.id),
                isLose: loseIds.contains(a.id),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  final String name;
  final double balance;
  final String currencyCode;
  final bool isPartner;
  final bool isGain;
  final bool isLose;

  const _HistoryChip({
    required this.name,
    required this.balance,
    required this.currencyCode,
    this.isPartner = false,
    this.isGain = false,
    this.isLose = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAffected = isGain || isLose;
    final color = isGain
        ? _kHistoryIncomeColor
        : isLose
            ? _kHistoryExpenseColor
            : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isAffected
            ? color!.withValues(alpha: 0.14)
            : cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAffected
              ? color!.withValues(alpha: 0.7)
              : cs.outlineVariant.withValues(alpha: 0.4),
          width: isAffected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          if (isAffected)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              color: isPartner ? cs.tertiary : cs.primary,
              fontWeight: isAffected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${balance > 0 ? '+' : ''}${balance.toStringAsFixed(2)} ${fx.currencySymbol(currencyCode)}',
            style: TextStyle(
              color: isAffected ? color : cs.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
