import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../data/account_lifecycle.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_format.dart';
import '../utils/day_grouped_list.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/track_plan_filter_ui.dart';
import 'transaction_detail_screen.dart';
import 'new_transaction_screen.dart';

const _kTypeIncome   = 'income';
const _kTypeExpense  = 'expense';
const _kTypeTransfer = 'transfer';

bool _inGroup(TxType t, String group) => switch (group) {
  _kTypeIncome   => const {TxType.income, TxType.collection, TxType.loan, TxType.invoice}.contains(t),
  _kTypeExpense  => const {TxType.expense, TxType.bill, TxType.settlement, TxType.advance}.contains(t),
  _kTypeTransfer => const {TxType.transfer, TxType.offset}.contains(t),
  _ => true,
};

class AccountTransactionsScreen extends StatefulWidget {
  final Account account;
  const AccountTransactionsScreen({super.key, required this.account});

  @override
  State<AccountTransactionsScreen> createState() =>
      _AccountTransactionsScreenState();
}

class _AccountTransactionsScreenState
    extends State<AccountTransactionsScreen> {
  String? _typeFilter;
  String? _categoryFilter;
  String? _dateFilter;
  DateTime _dateAnchor = DateTime.now();
  bool _newestFirst = true;
  TrackPlanFilterPanel _filterPanel = TrackPlanFilterPanel.none;

  final _scrollController = ScrollController();
  int _visibleAccountDaySlots = kLazyDayInitialCount;
  int? _accountLazyListSig;

  List<Transaction> get _allAccountTx => data.transactions
      .where((t) =>
          t.fromAccount?.id == widget.account.id ||
          t.toAccount?.id == widget.account.id)
      .toList();

  (DateTime, DateTime) get _currentMonthRange {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    return (start, end);
  }

  List<Transaction> get _visibleAccountTx {
    final (start, end) = _currentMonthRange;
    return _allAccountTx
        .where((t) => !t.date.isBefore(start) && t.date.isBefore(end))
        .toList();
  }

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

  bool get _hasNavigableDateFilter =>
      _dateFilter == 'week' ||
      _dateFilter == 'month' ||
      _dateFilter == 'year';

  String? get _dateChipModeLetter => switch (_dateFilter) {
        'month' => 'M',
        'week' => 'W',
        'year' => 'Y',
        'all' => '∞',
        _ => null,
      };

  bool get _hasActiveFilter =>
      _typeFilter != null ||
      _categoryFilter != null ||
      _dateFilter != null ||
      !_newestFirst;

  void _toggleFilterPanel(TrackPlanFilterPanel panel) {
    if (panel == TrackPlanFilterPanel.account) return;
    setState(() {
      _filterPanel = _filterPanel == panel ? TrackPlanFilterPanel.none : panel;
    });
  }

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

  void _cycleDateFilter() => setState(() {
        _filterPanel = TrackPlanFilterPanel.none;
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

  void _clearFilters() => setState(() {
        _typeFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
        _newestFirst = true;
        _filterPanel = TrackPlanFilterPanel.none;
      });

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

  List<Transaction> get _filteredTx {
    Iterable<Transaction> source;
    if (_dateFilter == null) {
      source = _visibleAccountTx;
    } else if (_dateFilter == 'all') {
      source = _allAccountTx;
    } else {
      final (start, end) = _dateRange;
      source = _allAccountTx.where(
          (t) => !t.date.isBefore(start) && t.date.isBefore(end));
    }

    if (_typeFilter != null) {
      source = source.where((t) {
        final type = t.txType ??
            classifyTransaction(from: t.fromAccount, to: t.toAccount);
        return _inGroup(type, _typeFilter!);
      });
    }

    if (_categoryFilter != null) {
      source = source.where((t) => t.category == _categoryFilter);
    }

    return source.toList();
  }

  ({double totalIn, double totalOut}) get _totals {
    double totalIn = 0, totalOut = 0;
    for (final t in _filteredTx) {
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

  void _openDetail(Transaction t) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: t)),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onAccountScrollLoadMoreDays);
  }

  void _onAccountScrollLoadMoreDays() {
    if (_dateFilter != 'all') return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasPixels || !pos.hasContentDimensions) return;
    if (pos.pixels < pos.maxScrollExtent - 360) return;

    final g = DayGroupedTransactions.build(_filteredTx, _newestFirst);
    if (!shouldLazyLoadDaySections(_dateFilter, g.dayKeys.length)) return;
    if (_visibleAccountDaySlots >= g.dayKeys.length) return;

    setState(() {
      _visibleAccountDaySlots = math.min(
        _visibleAccountDaySlots + kLazyDayLoadBatch,
        g.dayKeys.length,
      );
    });
  }

  void _syncAccountLazyWindowSignature() {
    final sig = Object.hash(
      _dateFilter,
      _typeFilter,
      _categoryFilter,
      _newestFirst,
      _filteredTx.length,
      data.transactions.length,
      widget.account.id,
    );
    if (_accountLazyListSig != sig) {
      _accountLazyListSig = sig;
      _visibleAccountDaySlots = kLazyDayInitialCount;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onAccountScrollLoadMoreDays);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _editTransaction(Transaction t) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NewTransactionScreen(existing: t)),
    );
    if (result == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final account = widget.account;
    final displayTx = _filteredTx;
    final totals = _totals;

    _syncAccountLazyWindowSignature();
    final dayBundle =
        DayGroupedTransactions.build(displayTx, _newestFirst);
    final days = dayBundle.dayKeys;
    final grouped = dayBundle.grouped;
    final lazyDays = shouldLazyLoadDaySections(_dateFilter, days.length);
    final visibleDayCount = lazyDays
        ? math.min(_visibleAccountDaySlots, days.length)
        : days.length;

    final categoriesSorted = <String>{
      ...data.incomeCategories,
      ...data.expenseCategories,
    }.toList()
      ..sort();

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: _hasActiveFilter
          ? FloatingActionButton.extended(
              heroTag: 'account_tx_clear_filters',
              onPressed: _clearFilters,
              icon: const Icon(Icons.filter_alt_off_rounded),
              label: Text(l10n.filterClearFilters),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: Text(account.name),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _AccountTxHero(
                      totalIn: totals.totalIn,
                      totalOut: totals.totalOut,
                      panel: _filterPanel,
                      onTogglePanel: _toggleFilterPanel,
                      typeFilter: _typeFilter,
                      onCycleType: _cycleTypeFilter,
                      dateModeLetter: _dateChipModeLetter,
                      dateFilterActive: _dateFilter != null,
                      onCycleDate: _cycleDateFilter,
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
                  label: _dateLabel(context),
                  onNavigateBack: () => _navigateDate(-1),
                  onNavigateForward: _canNavigateDateForward
                      ? () => _navigateDate(1)
                      : null,
                ),
              ),
            ),
          if (_filterPanel != TrackPlanFilterPanel.none)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                child: TrackPlanFilterStrip(
                  panel: _filterPanel,
                  accounts: activeAccounts(data.accounts),
                  accountFilter: null,
                  onAccountFilter: (_) {},
                  categories: categoriesSorted,
                  categoryFilter: _categoryFilter,
                  onCategoryFilter: (c) =>
                      setState(() => _categoryFilter = c),
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
                      _hasActiveFilter
                          ? Icons.search_off_rounded
                          : Icons.receipt_long_outlined,
                      size: 48,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _hasActiveFilter
                          ? l10n.emptyNoTransactionsForFilters
                          : _dateFilter == 'all'
                              ? l10n.emptyNoTransactionsForAccount
                              : l10n.emptyNoTransactionsForMonth(
                                  formatAppDate(
                                      context, 'MMMM', DateTime.now())),
                      textAlign: TextAlign.center,
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final day = days[i];
                  final dayTxs = grouped[day]!;
                  final date = DateTime.parse(day);
                  return _DaySection(
                    date: date,
                    transactions: dayTxs,
                    focusAccount: account,
                    onTap: _openDetail,
                    onLongPress: _editTransaction,
                  );
                },
                childCount: visibleDayCount,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ],
      ),
    );
  }
}

// ─── Hero (period In/Out + Track-style chips) ─────────────────────────────────

class _AccountTxHero extends StatelessWidget {
  final double totalIn;
  final double totalOut;
  final TrackPlanFilterPanel panel;
  final void Function(TrackPlanFilterPanel) onTogglePanel;
  final String? typeFilter;
  final VoidCallback onCycleType;
  final String? dateModeLetter;
  final bool dateFilterActive;
  final VoidCallback onCycleDate;
  final String? categoryFilter;
  final bool newestFirst;
  final VoidCallback onToggleSort;

  const _AccountTxHero({
    required this.totalIn,
    required this.totalOut,
    required this.panel,
    required this.onTogglePanel,
    required this.typeFilter,
    required this.onCycleType,
    required this.dateModeLetter,
    required this.dateFilterActive,
    required this.onCycleDate,
    required this.categoryFilter,
    required this.newestFirst,
    required this.onToggleSort,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final net = totalIn - totalOut;
    final borderColor =
        net >= 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final baseSym = fx.currencySymbol(settings.baseCurrency);

    return Container(
      padding: AppHeroConstants.cardPadding,
      decoration: BoxDecoration(
        color: borderColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroTwoColumnMetricsRow(
            dividerColor: borderColor.withValues(alpha: 0.2),
            leftColumn: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.heroIn,
                  style: TextStyle(
                    fontSize: AppHeroConstants.labelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '+${totalIn.toStringAsFixed(2)} $baseSym',
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
                  l10n.heroOut,
                  style: TextStyle(
                    fontSize: AppHeroConstants.secondaryLabelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '-${totalOut.toStringAsFixed(2)} $baseSym',
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
            accountFilter: null,
            categoryFilter: categoryFilter,
            newestFirst: newestFirst,
            onToggleSort: onToggleSort,
            accountChipEnabled: false,
          ),
        ],
      ),
    );
  }
}

// ─── Day section ──────────────────────────────────────────────────────────────

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;
  final Account focusAccount;
  final void Function(Transaction) onTap;
  final void Function(Transaction) onLongPress;

  const _DaySection({
    required this.date,
    required this.transactions,
    required this.focusAccount,
    required this.onTap,
    required this.onLongPress,
  });

  String _dayLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    if (target == today) return l10n.dateToday;
    if (target == today.subtract(const Duration(days: 1))) {
      return l10n.dateYesterday;
    }
    return formatAppDate(context, 'EEEE, d MMM yyyy', date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(
            _dayLabel(context),
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.1),
          ),
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
              children: transactions.asMap().entries.map((entry) {
                final isLast = entry.key == transactions.length - 1;
                return Column(
                  children: [
                    _TxTile(
                      transaction: entry.value,
                      focusAccount: focusAccount,
                      onTap: () => onTap(entry.value),
                      onLongPress: () => onLongPress(entry.value),
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

class _TxTile extends StatelessWidget {
  final Transaction transaction;
  final Account focusAccount;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _TxTile({
    required this.transaction,
    required this.focusAccount,
    required this.onTap,
    required this.onLongPress,
  });

  TxType get _type =>
      transaction.txType ??
      classifyTransaction(
          from: transaction.fromAccount, to: transaction.toAccount);

  String _title(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = transaction;
    if (t.description != null) return t.description!;
    if (t.category != null) return l10nCategoryName(context, t.category!);
    if (t.fromAccount != null && t.toAccount != null) {
      return '${t.fromAccount!.name} → ${t.toAccount!.name}';
    }
    if (t.fromAccount != null) return t.fromAccount!.name;
    if (t.toAccount != null) return t.toAccount!.name;
    return l10n.trackTransaction;
  }

  String? _counterpart() {
    final t = transaction;
    final fid = focusAccount.id;
    if (t.fromAccount?.id == fid && t.toAccount != null) return t.toAccount!.name;
    if (t.toAccount?.id == fid && t.fromAccount != null) return t.fromAccount!.name;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typeColor = txColor(_type);
    final counterpart = _counterpart();

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(txIcon(_type), size: 18, color: typeColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _title(context),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (counterpart != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      counterpart,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (transaction.nativeAmount != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  txAmountDisplay(
                      _type,
                      transaction.nativeAmount!,
                      transaction.currencyCode ?? 'BAM'),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: typeColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
