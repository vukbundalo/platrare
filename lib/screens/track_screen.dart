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
  /// null = current calendar month only; 'day'|'week'|'month'|'year'|'all' = explicit
  String? _dateFilter;
  DateTime _dateAnchor = DateTime.now();
  bool _newestFirst = true;

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

  String get _dateChipLabel {
    if (_dateFilter == null) {
      return DateFormat('MMM yyyy').format(DateTime.now());
    }
    if (_dateFilter == 'all') return 'All time';
    return _dateLabel;
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

  Future<void> _showTrackDateSheet() async {
    final result = await showModalBottomSheet<({String? mode, DateTime anchor})>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _TrackDateRangeSheet(
        dateFilter: _dateFilter,
        dateAnchor: _dateAnchor,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _dateFilter = result.mode;
        _dateAnchor = result.anchor;
      });
    }
  }

  Future<void> _showAccountFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _AccountPickerSheet(
        selected: _accountFilter,
        onPick: (a) {
          Navigator.pop(ctx);
          setState(() => _accountFilter = a);
        },
      ),
    );
  }

  Future<void> _showCategoryFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _CategoryPickerSheet(
        selected: _categoryFilter,
        onPick: (c) {
          Navigator.pop(ctx);
          setState(() => _categoryFilter = c);
        },
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
                    typeFilter: null,
                    onCycleType: _cycleTypeFilter,
                    dateFilter: _dateFilter,
                    dateChipLabel: _dateChipLabel,
                    onOpenDateSheet: _showTrackDateSheet,
                    accountFilter: _accountFilter,
                    onOpenAccountSheet: _showAccountFilterSheet,
                    categoryFilter: _categoryFilter,
                    onOpenCategorySheet: _showCategoryFilterSheet,
                    newestFirst: _newestFirst,
                    onToggleSort: () =>
                        setState(() => _newestFirst = !_newestFirst),
                  ),
                ],
              ),
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
                    typeFilter: _typeFilter,
                    onCycleType: _cycleTypeFilter,
                    dateFilter: _dateFilter,
                    dateChipLabel: _dateChipLabel,
                    onOpenDateSheet: _showTrackDateSheet,
                    accountFilter: _accountFilter,
                    onOpenAccountSheet: _showAccountFilterSheet,
                    categoryFilter: _categoryFilter,
                    onOpenCategorySheet: _showCategoryFilterSheet,
                    newestFirst: _newestFirst,
                    onToggleSort: () =>
                        setState(() => _newestFirst = !_newestFirst),
                  ),
                ],
              ),
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

// ─── Track hero (totals + 5 filter chips) ────────────────────────────────────

class _TrackHero extends StatelessWidget {
  final double totalIn;
  final double totalOut;
  final String? typeFilter;
  final VoidCallback onCycleType;
  final String? dateFilter;
  final String dateChipLabel;
  final VoidCallback onOpenDateSheet;
  final Account? accountFilter;
  final VoidCallback onOpenAccountSheet;
  final String? categoryFilter;
  final VoidCallback onOpenCategorySheet;
  final bool newestFirst;
  final VoidCallback onToggleSort;

  const _TrackHero({
    required this.totalIn,
    required this.totalOut,
    required this.typeFilter,
    required this.onCycleType,
    required this.dateFilter,
    required this.dateChipLabel,
    required this.onOpenDateSheet,
    required this.accountFilter,
    required this.onOpenAccountSheet,
    required this.categoryFilter,
    required this.onOpenCategorySheet,
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

    (IconData icon, String label) typeVisual() {
      if (typeFilter == null) {
        return (Icons.payments_outlined, 'All');
      }
      if (typeFilter == _kTypeIncome) {
        return (Icons.south_west_rounded, 'In');
      }
      if (typeFilter == _kTypeExpense) {
        return (Icons.north_east_rounded, 'Out');
      }
      return (Icons.swap_horiz_rounded, 'Xfer');
    }

    final tv = typeVisual();

    Widget filterChip({
      required bool active,
      required VoidCallback onTap,
      required Widget child,
    }) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 30,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: active
                  ? cs.primary.withValues(alpha: 0.15)
                  : cs.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: borderColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('In',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      '+${totalIn.toStringAsFixed(2)} $sym',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: borderColor.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Out',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    '-${totalOut.toStringAsFixed(2)} $sym',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFDC2626),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Tooltip(
                message: 'Transaction type',
                child: filterChip(
                  active: typeFilter != null,
                  onTap: onCycleType,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tv.$1,
                          size: 14,
                          color: typeFilter != null
                              ? cs.primary
                              : cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        tv.$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: typeFilter != null
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: dateChipLabel,
                child: filterChip(
                  active: dateFilter != null,
                  onTap: onOpenDateSheet,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13,
                          color: dateFilter != null
                              ? cs.primary
                              : cs.onSurfaceVariant),
                      const SizedBox(width: 3),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 56),
                        child: Text(
                          dateChipLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: dateFilter != null
                                ? cs.primary
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message:
                    accountFilter != null ? accountFilter!.name : 'Account',
                child: filterChip(
                  active: accountFilter != null,
                  onTap: onOpenAccountSheet,
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 15,
                    color: accountFilter != null
                        ? cs.primary
                        : cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: categoryFilter ?? 'Category',
                child: filterChip(
                  active: categoryFilter != null,
                  onTap: onOpenCategorySheet,
                  child: Icon(
                    Icons.label_outline_rounded,
                    size: 15,
                    color: categoryFilter != null
                        ? cs.primary
                        : cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: newestFirst
                    ? 'Newest first — tap for oldest first'
                    : 'Oldest first — tap for newest first',
                child: filterChip(
                  active: !newestFirst,
                  onTap: onToggleSort,
                  child: Icon(
                    newestFirst
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 15,
                    color: !newestFirst ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Date range bottom sheet ─────────────────────────────────────────────────

class _TrackDateRangeSheet extends StatefulWidget {
  final String? dateFilter;
  final DateTime dateAnchor;

  const _TrackDateRangeSheet({
    required this.dateFilter,
    required this.dateAnchor,
  });

  @override
  State<_TrackDateRangeSheet> createState() => _TrackDateRangeSheetState();
}

class _TrackDateRangeSheetState extends State<_TrackDateRangeSheet> {
  late String? _mode;
  late DateTime _anchor;

  @override
  void initState() {
    super.initState();
    _mode = widget.dateFilter;
    _anchor = widget.dateAnchor;
  }

  String _navLabel() {
    final a = _anchor;
    return switch (_mode) {
      null => DateFormat('MMMM yyyy').format(DateTime.now()),
      'all' => 'All time',
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

  bool get _canNavigateForward {
    if (_mode != 'day') return true;
    return DateUtils.dateOnly(_anchor)
        .isBefore(DateUtils.dateOnly(DateTime.now()));
  }

  void _navigate(int direction) {
    setState(() {
      var next = switch (_mode) {
        'day' => DateTime(_anchor.year, _anchor.month, _anchor.day + direction),
        'week' => DateTime(_anchor.year, _anchor.month, _anchor.day + direction * 7),
        'month' => DateTime(_anchor.year, _anchor.month + direction, _anchor.day),
        'year' => DateTime(_anchor.year + direction, _anchor.month, _anchor.day),
        _ => _anchor,
      };
      if (_mode == 'day') {
        final today = DateUtils.dateOnly(DateTime.now());
        final n = DateUtils.dateOnly(next);
        if (n.isAfter(today)) next = _anchor;
      }
      _anchor = next;
    });
  }

  Widget _modeChip({
    required String label,
    required String? value,
  }) {
    final cs = Theme.of(context).colorScheme;
    final sel = _mode == value;
    return FilterChip(
      label: Text(label),
      selected: sel,
      onSelected: (_) {
        setState(() {
          final prev = _mode;
          _mode = value;
          if (value != prev && value != null && value != 'all') {
            _anchor = DateTime.now();
          }
        });
      },
      visualDensity: VisualDensity.compact,
      selectedColor: cs.primary.withValues(alpha: 0.18),
      checkmarkColor: cs.primary,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: sel ? cs.primary : cs.onSurfaceVariant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Date range',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _modeChip(label: 'This month', value: null),
              _modeChip(label: 'Day', value: 'day'),
              _modeChip(label: 'Week', value: 'week'),
              _modeChip(label: 'Month', value: 'month'),
              _modeChip(label: 'Year', value: 'year'),
              _modeChip(label: 'All time', value: 'all'),
            ],
          ),
          if (_mode != null && _mode != 'all') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _NavButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _navigate(-1),
                ),
                Expanded(
                  child: Text(
                    _navLabel(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                _NavButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: _canNavigateForward ? () => _navigate(1) : null,
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, (mode: _mode, anchor: _anchor));
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

// ─── Account picker sheet ────────────────────────────────────────────────────

class _AccountPickerSheet extends StatelessWidget {
  final Account? selected;
  final void Function(Account?) onPick;

  const _AccountPickerSheet({
    required this.selected,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = MediaQuery.sizeOf(context).height * 0.52;
    final bottom = MediaQuery.paddingOf(context).bottom;

    Widget section(String title, Color color, List<Account> accounts) {
      if (accounts.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          ...accounts.map((a) {
            final isSel = selected?.id == a.id;
            return ListTile(
              leading: Icon(
                Icons.account_balance_rounded,
                color: isSel ? cs.primary : cs.onSurfaceVariant,
                size: 22,
              ),
              title: Text(a.name),
              trailing: isSel
                  ? Icon(Icons.check_rounded, color: cs.primary)
                  : null,
              onTap: () => onPick(isSel ? null : a),
            );
          }),
        ],
      );
    }

    final personal = data.accounts
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final individuals = data.accounts
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final entities = data.accounts
        .where((a) => a.group == AccountGroup.entities)
        .toList();

    return SizedBox(
      height: h + bottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              'Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.all_inclusive_rounded,
                      color: selected == null ? cs.primary : cs.onSurfaceVariant),
                  title: const Text('All accounts'),
                  trailing: selected == null
                      ? Icon(Icons.check_rounded, color: cs.primary)
                      : null,
                  onTap: () => onPick(null),
                ),
                section('PERSONAL', cs.primary, personal),
                section('INDIVIDUALS', cs.tertiary, individuals),
                section('ENTITIES', cs.secondary, entities),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category picker sheet ───────────────────────────────────────────────────

class _CategoryPickerSheet extends StatelessWidget {
  final String? selected;
  final void Function(String?) onPick;

  const _CategoryPickerSheet({
    required this.selected,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = MediaQuery.sizeOf(context).height * 0.48;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final cats = <String>{
      ...data.incomeCategories,
      ...data.expenseCategories,
    }.toList()
      ..sort();

    return SizedBox(
      height: h + bottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.clear_all_rounded,
                      color: selected == null ? cs.primary : cs.onSurfaceVariant),
                  title: const Text('All categories'),
                  trailing: selected == null
                      ? Icon(Icons.check_rounded, color: cs.primary)
                      : null,
                  onTap: () => onPick(null),
                ),
                ...cats.map((c) {
                  final isSel = selected == c;
                  return ListTile(
                    leading: Icon(
                      Icons.label_outline_rounded,
                      color: isSel ? cs.primary : cs.onSurfaceVariant,
                      size: 22,
                    ),
                    title: Text(c),
                    trailing: isSel
                        ? Icon(Icons.check_rounded, color: cs.primary)
                        : null,
                    onTap: () => onPick(isSel ? null : c),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled
              ? cs.primaryContainer.withValues(alpha: 0.5)
              : cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.35),
        ),
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
