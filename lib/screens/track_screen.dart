import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
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

  // ── Filters ─────────────────────────────────────────────────────────────────
  String? _typeFilter;      // _kTypeIncome / _kTypeExpense / _kTypeTransfer
  Account? _accountFilter;
  String? _categoryFilter;
  /// null = current calendar month only; UI cycles week/month/year; 'day'|'all' still supported in data paths.
  String? _dateFilter;
  DateTime _dateAnchor = DateTime.now();
  bool _newestFirst = true;
  TrackPlanFilterPanel _trackPanel = TrackPlanFilterPanel.none;

  bool get _hasActiveFilter =>
      _typeFilter != null ||
      _accountFilter != null ||
      _categoryFilter != null ||
      _dateFilter != null ||
      !_newestFirst;

  void _clearFilters() => setState(() {
        _typeFilter = null;
        _accountFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
        _newestFirst = true;
        _trackPanel = TrackPlanFilterPanel.none;
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

  /// Cycles: this month (null) → navigable month → week → year → null.
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
        } else {
          _dateFilter = null;
        }
      });

  void _toggleSort() => setState(() => _newestFirst = !_newestFirst);

  bool get _hasNavigableDateFilter =>
      _dateFilter == 'week' ||
      _dateFilter == 'month' ||
      _dateFilter == 'year';

  /// Shown on the date chip for month / week / year (calendar icon when null).
  String? get _dateChipModeLetter => switch (_dateFilter) {
        'month' => 'M',
        'week' => 'W',
        'year' => 'Y',
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
  String get _dateLabel {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'day' => DateFormat('EEE, d MMM yyyy').format(a),
      'week' => () {
          final mon = DateTime(a.year, a.month, a.day - (a.weekday - 1));
          final sun = DateTime(mon.year, mon.month, mon.day + 6);
          final sameMon = mon.month == sun.month;
          return sameMon
              ? '${DateFormat('d').format(mon)} – ${DateFormat('d MMM yyyy').format(sun)}'
              : '${DateFormat('d MMM').format(mon)} – ${DateFormat('d MMM yyyy').format(sun)}';
        }(),
      'month' => DateFormat('MMMM yyyy').format(a),
      'year' => DateFormat('yyyy').format(a),
      _ => '',
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// First day of the current month.
  DateTime get _currentMonthStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Transactions within the current month, newest first.
  List<Transaction> get _visibleTx => data.transactions
      .where((t) => !t.date.isBefore(_currentMonthStart))
      .toList();

  /// Income and expense totals reflecting the current filter/window.
  ({double totalIn, double totalOut}) get _periodTotals {
    final source = _filteredTx;
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

  List<Transaction> get _filteredTx {
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

    if (_accountFilter != null) {
      final id = _accountFilter!.id;
      source = source.where(
          (t) => t.fromAccount?.id == id || t.toAccount?.id == id);
    }

    if (_categoryFilter != null) {
      source = source.where((t) => t.category == _categoryFilter);
    }

    return source.toList();
  }

  Future<void> _addAccount() async {
    final result = await showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) => const AccountFormSheet(),
    );
    if (result != null) {
      setState(() => data.accounts.add(result));
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final allTx = data.transactions;

    return Scaffold(
      backgroundColor: cs.surface,
      body: allTx.isEmpty ? _emptyBody(context) : _listBody(context),
      floatingActionButton: allTx.isEmpty
          ? null
          : _hasActiveFilter
              ? FloatingActionButton.extended(
                  heroTag: 'track_fab',
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  label: const Text('Clear filters'),
                )
              : FloatingActionButton(
                  heroTag: 'track_fab',
                  onPressed: _openNewTransaction,
                  child: const Icon(Icons.add_rounded),
                ),
    );
  }

  Widget _emptyBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasAccounts = data.accounts.isNotEmpty;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          backgroundColor: cs.surface,
          scrolledUnderElevation: 0,
          title: const Text('Track'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
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
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_hasNavigableDateFilter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TrackPlanDateNavBar(
                label: _dateLabel,
                onNavigateBack: () => _navigateDate(-1),
                onNavigateForward: _canNavigateDateForward
                    ? () => _navigateDate(1)
                    : null,
              ),
            ),
          ),
        if (_trackPanel != TrackPlanFilterPanel.none)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
              child: TrackPlanFilterStrip(
                panel: _trackPanel,
                accounts: data.accounts,
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
                  hasAccounts ? 'No transactions yet' : 'No accounts yet',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: hasAccounts ? 6 : 8),
                Text(
                  hasAccounts
                      ? 'Tap the button below to record your first transaction.'
                      : 'Add your first account before recording transactions.',
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
                      hasAccounts ? 'Add transaction' : 'Add account'),
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

  Widget _listBody(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFiltered = _hasActiveFilter;
    final displayTx = _filteredTx;
    final totals = _periodTotals;

    final grouped = <String, List<Transaction>>{};
    for (final t in displayTx) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => _newestFirst
          ? b.date.compareTo(a.date)
          : a.date.compareTo(b.date));
    }
    final days = grouped.keys.toList()
      ..sort((a, b) => _newestFirst ? b.compareTo(a) : a.compareTo(b));

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          backgroundColor: cs.surface,
          scrolledUnderElevation: 0,
          title: const Text('Track'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
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
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_hasNavigableDateFilter)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TrackPlanDateNavBar(
                label: _dateLabel,
                onNavigateBack: () => _navigateDate(-1),
                onNavigateForward: _canNavigateDateForward
                    ? () => _navigateDate(1)
                    : null,
              ),
            ),
          ),
        if (_trackPanel != TrackPlanFilterPanel.none)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
              child: TrackPlanFilterStrip(
                panel: _trackPanel,
                accounts: data.accounts,
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
                        ? 'No transactions for applied filters'
                        : 'No transactions for ${DateFormat('MMMM').format(DateTime.now())}',
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
              childCount: days.length,
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: _EndOfHistoryFooter(
              isEmpty: displayTx.isEmpty,
              hasHiddenTx:
                  !isFiltered && data.transactions.length > displayTx.length,
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
                  'In',
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
                  'Out',
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
          ),
        ],
      ),
    );
  }
}

// ─── Pagination footers ───────────────────────────────────────────────────────

class _EndOfHistoryFooter extends StatelessWidget {
  final bool isEmpty;
  final bool hasHiddenTx;

  const _EndOfHistoryFooter({
    required this.isEmpty,
    required this.hasHiddenTx,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
              child:
                  Divider(color: cs.outlineVariant.withValues(alpha: 0.5))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              hasHiddenTx ? 'All transactions loaded' : 'Beginning of history',
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(
              child:
                  Divider(color: cs.outlineVariant.withValues(alpha: 0.5))),
          const SizedBox(width: 24),
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

  String _dayLabel() {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(widget.date);
    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEEE, MMM d').format(widget.date);
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
          child: Text(_dayLabel(),
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

  String _title() {
    final t = transaction;
    if (t.description != null) return t.description!;
    if (t.category != null) return t.category!;
    if (t.fromAccount != null && t.toAccount != null) {
      return '${t.fromAccount!.name} → ${t.toAccount!.name}';
    }
    if (t.fromAccount != null) return t.fromAccount!.name;
    if (t.toAccount != null) return t.toAccount!.name;
    return 'Transaction';
  }

  String? _subtitle() {
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
    if (t.description != null && t.category != null) parts.add(t.category!);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String _amountDisplay() {
    final amount = transaction.nativeAmount;
    if (amount == null) return '';
    return txAmountDisplay(_type, amount, transaction.currencyCode ?? 'BAM');
  }

  Color _amountColor(BuildContext ctx) => txColor(_type);

  void _delete(BuildContext context) {
    final t = transaction;
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
    data.transactions.remove(t);
    onRefresh();
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete transaction?'),
        content:
            const Text('This will reverse the account balance changes.'),
        icon: Icon(Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _delete(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = _subtitle();

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
                  Text(_title(),
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
                            color: cs.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            if (transaction.nativeAmount != null) ...[
              const SizedBox(width: 8),
              Text(_amountDisplay(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _amountColor(context))),
            ],
            if (onToggleHistory != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onToggleHistory,
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  showHistory
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
              ),
            ],
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
    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final individuals = data.accounts
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final entities = data.accounts
        .where((a) => a.group == AccountGroup.entities)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (personal.isNotEmpty) ...[
            Text('PERSONAL',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
            const SizedBox(height: 6),
            ...personal.map((a) => _HistoryChip(
                  name: a.name,
                  balance: balances[a.id] ?? a.balance,
                  currencyCode: a.currencyCode,
                  isGain: gainIds.contains(a.id),
                  isLose: loseIds.contains(a.id),
                )),
          ],
          if (individuals.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('INDIVIDUALS',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.tertiary)),
            const SizedBox(height: 6),
            ...individuals.map((a) => _HistoryChip(
                  name: a.name,
                  balance: balances[a.id] ?? a.balance,
                  currencyCode: a.currencyCode,
                  isPartner: true,
                  isGain: gainIds.contains(a.id),
                  isLose: loseIds.contains(a.id),
                )),
          ],
          if (entities.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('ENTITIES',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.secondary)),
            const SizedBox(height: 6),
            ...entities.map((a) => _HistoryChip(
                  name: a.name,
                  balance: balances[a.id] ?? a.balance,
                  currencyCode: a.currencyCode,
                  isPartner: true,
                  isGain: gainIds.contains(a.id),
                  isLose: loseIds.contains(a.id),
                )),
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
