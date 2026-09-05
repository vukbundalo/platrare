import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/account_lifecycle.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../l10n/app_localizations.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../theme/ledger_colors.dart';
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import '../utils/day_grouped_list.dart';
import '../utils/fx.dart' as fx;
import '../utils/period_filter.dart';
import '../utils/persistence_guard.dart';
import '../utils/tx_display.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/stacked_scroll_fab.dart';
import '../widgets/track_plan_filter_ui.dart';
import 'new_transaction_screen.dart';
import 'review/account_form_widgets.dart' show AccountFormScreen;
import 'transaction_detail_screen.dart';

/// True when the transaction has both legs and they are exactly [a] and [b].
bool _txBetweenAccounts(Transaction t, String a, String b) {
  final from = t.fromAccount?.id ?? t.fromAccountId;
  final to = t.toAccount?.id ?? t.toAccountId;
  if (from == null || to == null) return false;
  final legs = {from, to};
  return legs.contains(a) && legs.contains(b);
}

class AccountTransactionsScreen extends StatefulWidget {
  final Account account;
  const AccountTransactionsScreen({super.key, required this.account});

  @override
  State<AccountTransactionsScreen> createState() =>
      _AccountTransactionsScreenState();
}

class _AccountTransactionsScreenState
    extends State<AccountTransactionsScreen> {
  TxTypeGroup? _typeFilter;
  String? _categoryFilter;
  /// When set, only transactions that involve both [widget.account] and this account.
  Account? _counterpartyFilter;
  PeriodFilter _period = PeriodFilter.allTime();
  bool _newestFirst = true;
  TrackPlanFilterPanel _filterPanel = TrackPlanFilterPanel.none;

  final _scrollController = ScrollController();
  int _visibleAccountDaySlots = kLazyDayInitialCount;
  int? _accountLazyListSig;

  List<Transaction> get _allAccountTx => data.transactions
      .where((t) =>
          t.fromAccount?.id == widget.account.id ||
          t.toAccount?.id == widget.account.id ||
          t.fromAccountId == widget.account.id ||
          t.toAccountId == widget.account.id)
      .toList();

  bool get _hasActiveFilter =>
      _typeFilter != null ||
      _categoryFilter != null ||
      _counterpartyFilter != null ||
      !_period.isAllTime ||
      !_newestFirst;

  void _toggleFilterPanel(TrackPlanFilterPanel panel) {
    setState(() {
      _filterPanel = _filterPanel == panel ? TrackPlanFilterPanel.none : panel;
    });
  }

  void _cycleTypeFilter() =>
      setState(() => _typeFilter = TxTypeGroup.next(_typeFilter));

  void _toggleSort() => setState(() => _newestFirst = !_newestFirst);

  void _clearFilters() => setState(() {
        _typeFilter = null;
        _categoryFilter = null;
        _counterpartyFilter = null;
        _period = PeriodFilter.allTime();
        _newestFirst = true;
        _filterPanel = TrackPlanFilterPanel.none;
      });

  List<Transaction> get _filteredTx {
    Iterable<Transaction> source;
    if (_period.isAllTime) {
      source = _allAccountTx;
    } else {
      final (start, end) = _period.range;
      source = _allAccountTx.where(
          (t) => !t.date.isBefore(start) && t.date.isBefore(end));
    }

    if (_typeFilter != null) {
      source = source.where((t) {
        final type = t.txType ??
            classifyTransaction(from: t.fromAccount, to: t.toAccount);
        return _typeFilter!.contains(type);
      });
    }

    if (_categoryFilter != null) {
      source = source.where((t) => t.category == _categoryFilter);
    }

    if (_counterpartyFilter != null) {
      final mainId = widget.account.id;
      final otherId = _counterpartyFilter!.id;
      source = source.where(
          (t) => _txBetweenAccounts(t, mainId, otherId));
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
      if (TxTypeGroup.income.contains(type)) {
        totalIn += base;
      } else if (TxTypeGroup.expense.contains(type)) {
        totalOut += base;
      }
    }
    return (totalIn: totalIn, totalOut: totalOut);
  }

  void _openDetail(Transaction t) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => TransactionDetailScreen(transaction: t)),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onAccountScrollLoadMoreDays);
  }

  void _onAccountScrollLoadMoreDays() {
    if (!_period.isAllTime) return;
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasPixels || !pos.hasContentDimensions) return;
    if (pos.pixels < pos.maxScrollExtent - 360) return;

    final g = DayGroupedTransactions.build(_filteredTx, _newestFirst);
    if (!shouldLazyLoadDaySections(true, g.dayKeys.length)) return;
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
      _period,
      _typeFilter,
      _categoryFilter,
      _counterpartyFilter?.id,
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
    final acctChipsEnabled = activeAccounts(data.accounts).isNotEmpty &&
        _allAccountTx.isNotEmpty;

    if (_counterpartyFilter != null && _counterpartyFilter!.archived) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            _counterpartyFilter != null &&
            _counterpartyFilter!.archived) {
          setState(() => _counterpartyFilter = null);
        }
      });
    }
    if (!acctChipsEnabled &&
        (_filterPanel != TrackPlanFilterPanel.none || _hasActiveFilter)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _clearFilters();
      });
    }
    final acctFilterDisabledSemantics = activeAccounts(data.accounts).isEmpty
        ? l10n.semanticsFiltersDisabledNeedAccount
        : _allAccountTx.isEmpty
            ? l10n.semanticsFiltersDisabledNeedRecordedTransaction
            : l10n.semanticsFiltersDisabled;

    _syncAccountLazyWindowSignature();
    final dayBundle =
        DayGroupedTransactions.build(displayTx, _newestFirst);
    final days = dayBundle.dayKeys;
    final grouped = dayBundle.grouped;
    // Default (null) date filter is all-time — lazy-load it like 'all'.
    final lazyDays =
        shouldLazyLoadDaySections(_period.isAllTime, days.length);
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
              tooltip: l10n.heroResetButton,
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(l10n.heroResetButton),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: AppHeroConstants.mainSliverAppBarExpandedHeight,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: Text(accountDisplayName(account)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.editAccountTitle,
                onPressed: () async {
                  final acct =
                      refreshedAccount(widget.account) ?? widget.account;
                  final r = await Navigator.push<Object?>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AccountFormScreen(existing: acct)),
                  );
                  if (!context.mounted) return;
                  if (r == kAccountFormSheetDeleted) {
                    Navigator.pop(context, kAccountFormSheetDeleted);
                    return;
                  }
                  if (r == true) setState(() {});
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: AppHeroConstants.mainFlexibleSpaceHeroOuterPadding,
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
                      dateModeLetter: _period.chipLetter,
                      dateFilterActive: !_period.isAllTime,
                      onCycleDate: () => setState(() => _period = _period.cycled()),
                      counterpartyFilter: _counterpartyFilter,
                      categoryFilter: _categoryFilter,
                      newestFirst: _newestFirst,
                      onToggleSort: _toggleSort,
                      filterChipsEnabled: acctChipsEnabled,
                      filterChipsDisabledSemantics: acctFilterDisabledSemantics,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (acctChipsEnabled && _period.isNavigable)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TrackPlanDateNavBar(
                  label: _period.label(context),
                  onNavigateBack: () => setState(() => _period = _period.navigated(-1, latest: DateTime.now())),
                  onNavigateForward: _period.canNavigateForward(latest: DateTime.now())
                      ? () => setState(() => _period = _period.navigated(1, latest: DateTime.now()))
                      : null,
                ),
              ),
            ),
          if (acctChipsEnabled && _filterPanel != TrackPlanFilterPanel.none)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                child: TrackPlanFilterStrip(
                  showAccountSection:
                      _filterPanel == TrackPlanFilterPanel.account,
                  showCategorySection:
                      _filterPanel == TrackPlanFilterPanel.category,
                  accounts: activeAccounts(data.accounts)
                      .where((a) => a.id != account.id)
                      .toList(),
                  accountFilter: _counterpartyFilter,
                  onAccountFilter: (a) =>
                      setState(() => _counterpartyFilter = a),
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
                          : l10n.emptyNoTransactionsForAccount,
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
            SliverToBoxAdapter(
              child: SizedBox(height: stackedFabScrollBottomInset(context)),
            ),
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
  final TxTypeGroup? typeFilter;
  final VoidCallback onCycleType;
  final String? dateModeLetter;
  final bool dateFilterActive;
  final VoidCallback onCycleDate;
  final Account? counterpartyFilter;
  final String? categoryFilter;
  final bool newestFirst;
  final VoidCallback onToggleSort;
  final bool filterChipsEnabled;
  final String filterChipsDisabledSemantics;

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
    required this.counterpartyFilter,
    required this.categoryFilter,
    required this.newestFirst,
    required this.onToggleSort,
    required this.filterChipsEnabled,
    required this.filterChipsDisabledSemantics,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
    final baseSym = fx.currencySymbol(settings.baseCurrency);
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: AppHeroConstants.cardPadding,
      decoration: AppHeroChrome.cardDecoration(cs, brightness),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroTwoColumnMetricsRow(
            dividerColor: AppHeroChrome.metricsDividerColor(cs, brightness),
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
                HeroFittedAmount(
                  text: '+${formatBalanceAmount(totalIn)} $baseSym',
                  style: TextStyle(
                    fontSize: AppHeroConstants.primaryAmountFontSize,
                    fontWeight: FontWeight.w800,
                    color: lc.positive,
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
                HeroFittedAmount(
                  text: '-${formatBalanceAmount(totalOut)} $baseSym',
                  style: TextStyle(
                    fontSize: AppHeroConstants.secondaryAmountFontSize,
                    fontWeight: FontWeight.w700,
                    color: lc.negative,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppHeroConstants.chipGapBelowMetrics),
          TrackPlanFilterChipRow(
            accountPanelOpen: panel == TrackPlanFilterPanel.account,
            categoryPanelOpen: panel == TrackPlanFilterPanel.category,
            onToggleAccountPanel: () =>
                onTogglePanel(TrackPlanFilterPanel.account),
            onToggleCategoryPanel: () =>
                onTogglePanel(TrackPlanFilterPanel.category),
            typeFilter: typeFilter,
            onCycleType: onCycleType,
            dateModeLetter: dateModeLetter,
            dateFilterActive: dateFilterActive,
            onCycleDate: onCycleDate,
            accountFilter: counterpartyFilter,
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
    if (t.description != null) {
      return l10nSentinel(t.description, AppLocalizations.of(context));
    }
    if (t.category != null) return l10nCategoryName(context, t.category!);
    if (t.fromAccount != null && t.toAccount != null) {
      return '${accountDisplayName(t.fromAccount!)} → ${accountDisplayName(t.toAccount!)}';
    }
    if (t.fromSnapshotName != null && t.toSnapshotName != null) {
      return '${t.fromSnapshotName} → ${t.toSnapshotName}';
    }
    if (t.fromAccount != null) return accountDisplayName(t.fromAccount!);
    if (t.toAccount != null) return accountDisplayName(t.toAccount!);
    if (t.fromSnapshotName != null) return t.fromSnapshotName!;
    if (t.toSnapshotName != null) return t.toSnapshotName!;
    return l10n.trackTransaction;
  }

  String? _counterpart() {
    final t = transaction;
    final fid = focusAccount.id;
    if (t.fromAccount?.id == fid || t.fromAccountId == fid) {
      final a = t.toAccount;
      if (a != null) return accountDisplayName(a);
      return t.toSnapshotName;
    }
    if (t.toAccount?.id == fid || t.toAccountId == fid) {
      final a = t.fromAccount;
      if (a != null) return accountDisplayName(a);
      return t.fromSnapshotName;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typeColor = txColor(context, _type);
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
