import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';
import 'new_transaction_screen.dart';
import 'review_screen.dart';
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
  int _visibleMonths = 2;
  final _scrollController = ScrollController();
  bool _batchPending = false;

  // ── Filters ─────────────────────────────────────────────────────────────────
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _typeFilter;      // _kTypeIncome / _kTypeExpense / _kTypeTransfer
  Account? _accountFilter;
  String? _categoryFilter;
  bool _filtersExpanded = false;

  // ── Date filter ─────────────────────────────────────────────────────────────
  String? _dateFilter;     // 'day' | 'week' | 'month' | 'year'
  DateTime _dateAnchor = DateTime.now();

  bool get _hasActiveFilter =>
      _searchQuery.isNotEmpty ||
      _typeFilter != null ||
      _accountFilter != null ||
      _categoryFilter != null ||
      _dateFilter != null;

  void _clearFilters() => setState(() {
        _searchController.clear();
        _searchQuery = '';
        _typeFilter = null;
        _accountFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
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
      'year'  => (DateTime(a.year),          DateTime(a.year + 1)),
      _       => (DateTime(0),               DateTime(9999)),
    };
  }

  /// Move the date anchor forward (+1) or backward (-1) by one period step.
  void _navigateDate(int direction) {
    setState(() {
      _dateAnchor = switch (_dateFilter) {
        'day'   => DateTime(_dateAnchor.year, _dateAnchor.month,
                       _dateAnchor.day + direction),
        'week'  => DateTime(_dateAnchor.year, _dateAnchor.month,
                       _dateAnchor.day + direction * 7),
        'month' => DateTime(_dateAnchor.year, _dateAnchor.month + direction,
                       _dateAnchor.day),
        'year'  => DateTime(_dateAnchor.year + direction, _dateAnchor.month,
                       _dateAnchor.day),
        _       => _dateAnchor,
      };
    });
  }

  /// Human-readable label for the current date anchor + period.
  String get _dateLabel {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'day'   => DateFormat('d MMM yyyy').format(a),
      'week'  => () {
          final mon = DateTime(a.year, a.month, a.day - (a.weekday - 1));
          final sun = DateTime(mon.year, mon.month, mon.day + 6);
          final sameMon = mon.month == sun.month;
          return sameMon
              ? '${DateFormat('d').format(mon)} – ${DateFormat('d MMM yyyy').format(sun)}'
              : '${DateFormat('d MMM').format(mon)} – ${DateFormat('d MMM yyyy').format(sun)}';
        }(),
      'month' => DateFormat('MMMM yyyy').format(a),
      'year'  => DateFormat('yyyy').format(a),
      _       => '',
    };
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_batchPending || !_hasOlderTx || _hasActiveFilter) return;
    final pos = _scrollController.position;
    if (pos.extentAfter < 350) {
      _batchPending = true;
      setState(() => _visibleMonths++);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _batchPending = false);
    }
  }

  /// First day of the oldest visible calendar month.
  DateTime get _oldestVisible {
    final now = DateTime.now();
    var month = now.month - (_visibleMonths - 1);
    var year = now.year;
    while (month <= 0) {
      month += 12;
      year--;
    }
    return DateTime(year, month, 1);
  }

  /// Transactions within the visible window, newest first.
  List<Transaction> get _visibleTx => data.transactions
      .where((t) => !t.date.isBefore(_oldestVisible))
      .toList();

  /// True when there is at least one transaction older than the visible window.
  bool get _hasOlderTx =>
      data.transactions.any((t) => t.date.isBefore(_oldestVisible));

  /// Income and expense totals reflecting the current filter/window.
  ({double totalIn, double totalOut}) get _periodTotals {
    final source = _hasActiveFilter ? _filteredTx : _visibleTx;
    double totalIn = 0, totalOut = 0;
    for (final t in source) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      final base = t.baseAmount ??
          fx.toBase(t.nativeAmount ?? 0, t.currencyCode ?? settings.baseCurrency);
      if (_inGroup(type, _kTypeIncome)) {
        totalIn += base;
      } else if (_inGroup(type, _kTypeExpense)) {
        totalOut += base;
      }
    }
    return (totalIn: totalIn, totalOut: totalOut);
  }

  /// When filters are active, searches the entire history so the user can
  /// find any transaction regardless of the loaded window.
  List<Transaction> get _filteredTx {
    // Active filter → search all history; no filter → use the loaded window.
    Iterable<Transaction> source =
        _hasActiveFilter ? data.transactions : _visibleTx;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      source = source.where((t) =>
          (t.description?.toLowerCase().contains(q) ?? false) ||
          (t.category?.toLowerCase().contains(q) ?? false) ||
          (t.fromAccount?.name.toLowerCase().contains(q) ?? false) ||
          (t.toAccount?.name.toLowerCase().contains(q) ?? false));
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

    if (_dateFilter != null) {
      final (start, end) = _dateRange;
      source = source.where(
          (t) => !t.date.isBefore(start) && t.date.isBefore(end));
    }

    return source.toList();
  }

  Future<void> _addAccount() async {
    final result = await showModalBottomSheet<Account>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
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
          onEdit: () => _editTransaction(t),
          onDelete: () {
            if (t.nativeAmount != null) {
              if (t.fromAccount != null) t.fromAccount!.balance += t.nativeAmount!;
              if (t.toAccount != null) t.toAccount!.balance -= t.nativeAmount!;
            }
            setState(() => data.transactions.remove(t));
            widget.onChanged?.call();
          },
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
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _FilterHero(
                    totalIn: 0,
                    totalOut: 0,
                    typeFilter: null,
                    onTypeFilter: (_) {},
                    filtersExpanded: false,
                    hasAccountFilter: false,
                    onToggleFilters: () {},
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
    final hasOlder = !isFiltered && _hasOlderTx;

    final grouped = <String, List<Transaction>>{};
    for (final t in displayTx) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final totals = _periodTotals;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 210,
          backgroundColor: cs.surface,
          scrolledUnderElevation: 0,
          title: const Text('Track'),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _FilterHero(
                    totalIn: totals.totalIn,
                    totalOut: totals.totalOut,
                    typeFilter: _typeFilter,
                    onTypeFilter: (v) => setState(() => _typeFilter = v),
                    filtersExpanded: _filtersExpanded,
                    hasAccountFilter:
                        _accountFilter != null || _dateFilter != null,
                    onToggleFilters: () =>
                        setState(() => _filtersExpanded = !_filtersExpanded),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (_filtersExpanded)
          SliverToBoxAdapter(
            child: _FiltersPanel(
              accountFilter: _accountFilter,
              onAccountFilter: (a) => setState(() => _accountFilter = a),
              dateFilter: _dateFilter,
              dateLabel: _dateLabel,
              onDateFilter: (v) => setState(() {
                _dateFilter = v;
                _dateAnchor = DateTime.now();
              }),
              onNavigateDate: _navigateDate,
            ),
          ),

        if (days.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 48, color: cs.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text('No matching transactions',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Clear filters'),
                  ),
                ],
              ),
            ),
          )
        else ...[
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

          // Footer: load more or end-of-history
          SliverToBoxAdapter(
            child: hasOlder
                ? _LoadMoreFooter(
                    visibleMonths: _visibleMonths,
                    oldestVisible: _oldestVisible,
                    onTap: () => setState(() => _visibleMonths++),
                  )
                : _EndOfHistoryFooter(
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

// ─── Filter hero ─────────────────────────────────────────────────────────────

class _FilterHero extends StatelessWidget {
  final double totalIn;
  final double totalOut;
  final String? typeFilter;
  final ValueChanged<String?> onTypeFilter;
  final bool filtersExpanded;
  final bool hasAccountFilter;
  final VoidCallback onToggleFilters;

  const _FilterHero({
    required this.totalIn,
    required this.totalOut,
    required this.typeFilter,
    required this.onTypeFilter,
    required this.filtersExpanded,
    required this.hasAccountFilter,
    required this.onToggleFilters,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final net = totalIn - totalOut;
    final netPos = net >= 0;
    final borderColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final sym = fx.currencySymbol(settings.baseCurrency);

    Widget chip(String label, String key, IconData icon) {
      final active = typeFilter == key;
      return GestureDetector(
        onTap: () => onTypeFilter(active ? null : key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12,
                  color: active ? cs.primary : cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
            ],
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
              chip('Income', _kTypeIncome, Icons.arrow_downward_rounded),
              const SizedBox(width: 6),
              chip('Expense', _kTypeExpense, Icons.arrow_upward_rounded),
              const SizedBox(width: 6),
              chip('Transfer', _kTypeTransfer, Icons.swap_horiz_rounded),
              const Spacer(),
              GestureDetector(
                onTap: onToggleFilters,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (filtersExpanded || hasAccountFilter)
                        ? cs.primary.withValues(alpha: 0.15)
                        : cs.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune_rounded,
                          size: 12,
                          color: (filtersExpanded || hasAccountFilter)
                              ? cs.primary
                              : cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (filtersExpanded || hasAccountFilter)
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        filtersExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: (filtersExpanded || hasAccountFilter)
                            ? cs.primary
                            : cs.onSurfaceVariant,
                      ),
                    ],
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

// ─── Filters panel ───────────────────────────────────────────────────────────

class _FiltersPanel extends StatelessWidget {
  final Account? accountFilter;
  final ValueChanged<Account?> onAccountFilter;
  final String? dateFilter;
  final String dateLabel;
  final ValueChanged<String?> onDateFilter;
  final ValueChanged<int> onNavigateDate;

  const _FiltersPanel({
    required this.accountFilter,
    required this.onAccountFilter,
    required this.dateFilter,
    required this.dateLabel,
    required this.onDateFilter,
    required this.onNavigateDate,
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

    Widget periodChip(String label, String key) {
      final active = dateFilter == key;
      return GestureDetector(
        onTap: () => onDateFilter(active ? null : key),
        child: Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      );
    }

    Widget accountChip(Account a) {
      final active = accountFilter?.id == a.id;
      return GestureDetector(
        onTap: () => onAccountFilter(active ? null : a),
        child: Container(
          margin: const EdgeInsets.only(right: 6, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active
                  ? cs.primary.withValues(alpha: 0.4)
                  : cs.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            a.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? cs.primary : cs.onSurface,
            ),
          ),
        ),
      );
    }

    Widget sectionLabel(String label) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(label,
              style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: cs.primary)),
        );

    Widget accountSection(String label, List<Account> accounts) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionLabel(label),
            Wrap(children: accounts.map(accountChip).toList()),
          ],
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Date period ───────────────────────────────────────────
              sectionLabel('DATE PERIOD'),
              Row(
                children: [
                  periodChip('Day', 'day'),
                  periodChip('Week', 'week'),
                  periodChip('Month', 'month'),
                  periodChip('Year', 'year'),
                ],
              ),
              if (dateFilter != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      iconSize: 20,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onNavigateDate(-1),
                      style: IconButton.styleFrom(
                        foregroundColor: cs.primary,
                        backgroundColor:
                            cs.primaryContainer.withValues(alpha: 0.5),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      iconSize: 20,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onNavigateDate(1),
                      style: IconButton.styleFrom(
                        foregroundColor: cs.primary,
                        backgroundColor:
                            cs.primaryContainer.withValues(alpha: 0.5),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ),
              ],

              // ── Account ───────────────────────────────────────────────
              const SizedBox(height: 12),
              if (personal.isNotEmpty) ...[
                accountSection('PERSONAL', personal),
                const SizedBox(height: 10),
              ],
              if (individuals.isNotEmpty) ...[
                accountSection('INDIVIDUALS', individuals),
                const SizedBox(height: 10),
              ],
              if (entities.isNotEmpty)
                accountSection('ENTITIES', entities),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pagination footers ───────────────────────────────────────────────────────

class _LoadMoreFooter extends StatelessWidget {
  final int visibleMonths;
  final DateTime oldestVisible;
  final VoidCallback onTap;

  const _LoadMoreFooter({
    required this.visibleMonths,
    required this.oldestVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final since = DateFormat('MMM yyyy').format(oldestVisible);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.history_rounded, size: 16),
        label: Text('Load older transactions  ·  showing since $since'),
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.onSurfaceVariant,
          side: BorderSide(color: cs.outlineVariant),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

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

class _DaySection extends StatelessWidget {
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

  String _dayLabel() {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEEE, MMM d').format(date);
  }

  double get _dayNet {
    double net = 0;
    for (final t in transactions) {
      if (t.nativeAmount == null) continue;
      // Use locked baseAmount for a consistent base-currency day total.
      final base = t.baseAmount ??
          fx.toBase(t.nativeAmount!, t.currencyCode ?? 'BAM');
      if (t.fromAccount != null && t.toAccount == null) {
        net -= base;
      } else if (t.toAccount != null && t.fromAccount == null) {
        net += base;
      }
    }
    return net;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final net = _dayNet;
    final netZero = net == 0;
    final netPos = net > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            children: [
              Text(_dayLabel(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.1)),
              const Spacer(),
              if (!netZero)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: netPos
                        ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                        : const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${net > 0 ? '+' : ''}${net.toStringAsFixed(2)} ${fx.currencySymbol(settings.baseCurrency)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: netPos
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFDC2626),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: transactions.asMap().entries.map((entry) {
                final isLast = entry.key == transactions.length - 1;
                return Column(
                  children: [
                    _TransactionTile(
                      transaction: entry.value,
                      onRefresh: onRefresh,
                      onEdit: onEdit,
                      onTap: onTap,
                    ),
                    if (!isLast)
                      Divider(
                        height: 0.5,
                        indent: 68,
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                  ],
                );
              }).toList(),
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

  const _TransactionTile({
    required this.transaction,
    required this.onRefresh,
    required this.onEdit,
    required this.onTap,
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 10, color: cs.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Text(
                        DateFormat('d MMM yyyy').format(transaction.date),
                        style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant),
                      ),
                      if (subtitle != null) ...[
                        Text('  ·  ',
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant)),
                        Expanded(
                          child: Text(subtitle,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ],
                  ),
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
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded,
                  size: 18, color: cs.onSurfaceVariant),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 18, color: cs.primary),
                      const SizedBox(width: 10),
                      const Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          size: 18, color: cs.error),
                      const SizedBox(width: 10),
                      Text('Delete',
                          style: TextStyle(color: cs.error)),
                    ],
                  ),
                ),
              ],
              onSelected: (v) {
                if (v == 'edit') onEdit(transaction);
                if (v == 'delete') _confirmDelete(context);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
