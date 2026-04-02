import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/projections.dart' as proj;
import '../utils/tx_display.dart';
import 'new_planned_transaction_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';
import 'transaction_detail_screen.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/track_plan_filter_ui.dart';

const _kExpenseColor = Color(0xFFDC2626);
const _kIncomeColor = Color(0xFF16A34A);

const _kTypeIncome = 'income';
const _kTypeExpense = 'expense';
const _kTypeTransfer = 'transfer';

bool _inGroup(TxType t, String group) => switch (group) {
      _kTypeIncome =>
        const {TxType.income, TxType.collection, TxType.loan, TxType.invoice}
            .contains(t),
      _kTypeExpense => const {
          TxType.expense,
          TxType.bill,
          TxType.settlement,
          TxType.advance,
        }.contains(t),
      _kTypeTransfer =>
        const {TxType.transfer, TxType.offset}.contains(t),
      _ => true,
    };

class PlanScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const PlanScreen({super.key, this.onChanged});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  /// Projection date for hero totals and per-account breakdown.
  DateTime _snapshotDate = DateUtils.dateOnly(DateTime.now());
  String? _typeFilter;
  Account? _accountFilter;
  String? _categoryFilter;
  String? _dateFilter;
  DateTime _dateAnchor = DateTime.now();
  /// Planned list: oldest → newest by default (overdue / soonest days first).
  bool _newestFirst = false;
  TrackPlanFilterPanel _planPanel = TrackPlanFilterPanel.none;
  bool _detailExpanded = false;

  bool get _hasActiveFilter =>
      _typeFilter != null ||
      _accountFilter != null ||
      _categoryFilter != null ||
      _dateFilter != null ||
      _newestFirst;

  void _clearFilters() => setState(() {
        _typeFilter = null;
        _accountFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
        _newestFirst = false;
        _planPanel = TrackPlanFilterPanel.none;
      });

  void _togglePlanPanel(TrackPlanFilterPanel panel) => setState(() {
        _planPanel = _planPanel == panel ? TrackPlanFilterPanel.none : panel;
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

  void _cycleDateFilter() => setState(() {
        _planPanel = TrackPlanFilterPanel.none;
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

  String? get _dateChipModeLetter => switch (_dateFilter) {
        'month' => 'M',
        'week' => 'W',
        'year' => 'Y',
        _ => null,
      };

  /// Same horizon as the projection snapshot date picker — Plan is forward-looking.
  static const Duration _kPlanListForwardHorizon = Duration(days: 1825);

  DateTime get _planListLatestNavDate =>
      DateUtils.dateOnly(DateTime.now().add(_kPlanListForwardHorizon));

  DateTime _planDateAnchorAfterStep(int direction) {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'day' => DateTime(a.year, a.month, a.day + direction),
      'week' => DateTime(a.year, a.month, a.day + direction * 7),
      'month' => DateTime(a.year, a.month + direction, a.day),
      'year' => DateTime(a.year + direction, a.month, a.day),
      _ => a,
    };
  }

  void _navigateDate(int direction) {
    setState(() {
      var next = _planDateAnchorAfterStep(direction);
      if (direction > 0) {
        final cap = _planListLatestNavDate;
        if (DateUtils.dateOnly(next).isAfter(cap)) next = _dateAnchor;
      }
      _dateAnchor = next;
    });
  }

  bool get _canNavigateDateForward {
    if (_dateFilter == null) return true;
    final next = _planDateAnchorAfterStep(1);
    return !DateUtils.dateOnly(next).isAfter(_planListLatestNavDate);
  }

  /// Default list window when the date chip is on “this month” (calendar icon):
  /// `[first day of this calendar month, first day of next month)`.
  (DateTime, DateTime) get _currentMonthRange {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    return (start, end);
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

  Future<void> _pickSnapshotDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _snapshotDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
    );
    if (picked != null && mounted) setState(() => _snapshotDate = picked);
  }

  /// Snapshot is strictly after today — list filters and timeline are hidden.
  bool get _isFutureProjection =>
      DateUtils.dateOnly(_snapshotDate)
          .isAfter(DateUtils.dateOnly(DateTime.now()));

  void _clearProjectionToToday() => setState(() {
        _snapshotDate = DateUtils.dateOnly(DateTime.now());
      });

  List<PlannedTransaction> get _filteredPlanned {
    Iterable<PlannedTransaction> source = data.plannedTransactions;
    if (_dateFilter != null) {
      final (start, end) = _dateRange;
      source = source.where(
          (pt) => !pt.date.isBefore(start) && pt.date.isBefore(end));
    } else {
      final (start, end) = _currentMonthRange;
      source = source.where(
          (pt) => !pt.date.isBefore(start) && pt.date.isBefore(end));
    }
    if (_typeFilter != null) {
      source = source.where((pt) {
        final type = pt.txType ??
            classifyTransaction(from: pt.fromAccount, to: pt.toAccount);
        return _inGroup(type, _typeFilter!);
      });
    }
    if (_accountFilter != null) {
      final id = _accountFilter!.id;
      source = source.where(
          (pt) => pt.fromAccount?.id == id || pt.toAccount?.id == id);
    }
    if (_categoryFilter != null) {
      source = source.where((pt) => pt.category == _categoryFilter);
    }
    return source.toList();
  }

  void _confirm(PlannedTransaction pt) {
    final today = DateUtils.dateOnly(DateTime.now());
    final ptDate = DateUtils.dateOnly(pt.date);
    final isRepeated = pt.repeatInterval != RepeatInterval.none;
    final earlyRepeat = isRepeated && ptDate.isAfter(today);

    HapticFeedback.mediumImpact();
    final nextAfterScheduled = earlyRepeat
        ? nextPlannedEffectiveDate(pt, pt.date)
        : null;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm transaction?'),
        content: Text(
          earlyRepeat
              ? 'This occurrence is scheduled for ${DateFormat('d MMM y').format(pt.date)}. '
                  'It will be recorded in History with today’s date (${DateFormat('d MMM y').format(today)}). '
                  'The next occurrence remains on ${DateFormat('d MMM y').format(nextAfterScheduled!)}.'
              : 'This will apply the transaction to your real account balances and move it to History.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _realize(pt, realizationDate: today);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _realize(PlannedTransaction pt, {DateTime? realizationDate}) {
    if (pt.nativeAmount != null) {
      // Deduct from source in its native currency.
      if (pt.fromAccount != null) {
        pt.fromAccount!.balance -= pt.nativeAmount!;
      }
      // Rule 4: cross-currency — credit destinationAmount; same-currency —
      // credit nativeAmount.
      if (pt.toAccount != null) {
        final credit = (pt.destinationAmount != null &&
                pt.toAccount!.currencyCode != pt.fromAccount?.currencyCode)
            ? pt.destinationAmount!
            : pt.nativeAmount!;
        pt.toAccount!.balance += credit;
      }
    }

    // Rule 3: lock baseAmount + exchangeRate at realization time.
    final ccy = pt.currencyCode ?? 'BAM';
    final rate = fx.rateToBase(ccy);
    final baseAmt = pt.nativeAmount != null ? pt.nativeAmount! * rate : null;

    data.transactions.insert(
      0,
      Transaction(
        nativeAmount: pt.nativeAmount,
        currencyCode: ccy,
        baseAmount: baseAmt,
        exchangeRate: rate,
        destinationAmount: pt.destinationAmount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        category: pt.category,
        description: pt.description,
        date: realizationDate ?? pt.date,
        txType: pt.txType,
      ),
    );

    data.plannedTransactions.remove(pt);

    // Auto-spawn the next occurrence for repeated transactions.
    if (pt.repeatInterval != RepeatInterval.none) {
      final nextDate = nextPlannedEffectiveDate(pt, pt.date);
      data.plannedTransactions.add(PlannedTransaction(
        nativeAmount: pt.nativeAmount,
        currencyCode: pt.currencyCode,
        destinationAmount: pt.destinationAmount,
        fromAccount: pt.fromAccount,
        toAccount: pt.toAccount,
        category: pt.category,
        description: pt.description,
        date: nextDate,
        txType: pt.txType,
        repeatInterval: pt.repeatInterval,
        repeatDayOfMonth: pt.repeatDayOfMonth,
        weekendAdjustment: pt.weekendAdjustment,
      ));
      data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
    }

    setState(() {});
    widget.onChanged?.call();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction confirmed and applied'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _delete(PlannedTransaction pt) {
    HapticFeedback.lightImpact();
    setState(() => data.plannedTransactions.remove(pt));
    widget.onChanged?.call();
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Planned transaction removed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            messenger.clearSnackBars();
            setState(() {
              data.plannedTransactions.add(pt);
              data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
            });
            widget.onChanged?.call();
          },
        ),
      ),
    );
  }

  void _deleteWithRepeatChoice(PlannedTransaction pt) {
    if (pt.repeatInterval == RepeatInterval.none) {
      _delete(pt);
      return;
    }

    HapticFeedback.lightImpact();
    showDialog<String>(
      context: context,
      builder: (ctx) {
        final error = Theme.of(ctx).colorScheme.error;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Repeating transaction'),
          content: const Text(
            'Skip only this date—the series continues with the next occurrence—or delete every remaining occurrence from your plan.',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx, 'all'),
                      style: TextButton.styleFrom(foregroundColor: error),
                      child: const Text('Delete all'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, 'this'),
                      child: const Text('Skip this only'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((choice) {
      if (choice == null || !mounted) return;
      if (choice == 'all') {
        _delete(pt);
      } else {
        // Delete this occurrence and spawn the next one.
        final nextDate = nextPlannedEffectiveDate(pt, pt.date);
        final spawned = PlannedTransaction(
          nativeAmount: pt.nativeAmount,
          currencyCode: pt.currencyCode,
          destinationAmount: pt.destinationAmount,
          fromAccount: pt.fromAccount,
          toAccount: pt.toAccount,
          category: pt.category,
          description: pt.description,
          date: nextDate,
          txType: pt.txType,
          repeatInterval: pt.repeatInterval,
          repeatDayOfMonth: pt.repeatDayOfMonth,
          weekendAdjustment: pt.weekendAdjustment,
        );
        setState(() {
          data.plannedTransactions.remove(pt);
          data.plannedTransactions.add(spawned);
          data.plannedTransactions
              .sort((a, b) => a.date.compareTo(b.date));
        });
        widget.onChanged?.call();
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: const Text('This occurrence skipped — next one scheduled'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                messenger.clearSnackBars();
                setState(() {
                  data.plannedTransactions.remove(spawned);
                  data.plannedTransactions.add(pt);
                  data.plannedTransactions
                      .sort((a, b) => a.date.compareTo(b.date));
                });
                widget.onChanged?.call();
              },
            ),
          ),
        );
      }
    });
  }

  Future<void> _addPlanned() async {
    final result = await Navigator.push<PlannedTransaction>(
      context,
      MaterialPageRoute(builder: (_) => const NewPlannedTransactionScreen()),
    );
    if (result != null) {
      setState(() {
        data.plannedTransactions.add(result);
        data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
      });
    }
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
      setState(() {
        if (!data.accounts.contains(result)) {
          data.accounts.add(result);
        }
      });
      widget.onChanged?.call();
    }
  }

  Future<void> _edit(PlannedTransaction pt) async {
    final result = await Navigator.push<PlannedTransaction>(
      context,
      MaterialPageRoute(
          builder: (_) => NewPlannedTransactionScreen(existing: pt)),
    );
    if (result != null) {
      setState(() {
        final idx = data.plannedTransactions.indexWhere((t) => t.id == pt.id);
        if (idx >= 0) {
          data.plannedTransactions[idx] = result;
        } else {
          data.plannedTransactions.add(result);
        }
        data.plannedTransactions.sort((a, b) => a.date.compareTo(b.date));
      });
    }
  }

  void _openPlannedDetail(PlannedTransaction pt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlannedTransactionDetailScreen(
          pt: pt,
          onConfirm: () => _confirm(pt),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final planned = _filteredPlanned;

    // Compute once per build — used by both hero and detail card.
    final balances = proj.projectBalances(_snapshotDate);
    final snapshotPersonal = proj.personalTotal(balances);
    final snapshotNet = proj.netWorthInBase(balances);

    Widget? fab;
    if (data.accounts.isNotEmpty) {
      if (_isFutureProjection) {
        fab = FloatingActionButton.extended(
          heroTag: 'plan_fab',
          onPressed: _clearProjectionToToday,
          icon: const Icon(Icons.today_rounded),
          label: const Text('Clear projections'),
        );
      } else if (_hasActiveFilter) {
        fab = FloatingActionButton.extended(
          heroTag: 'plan_fab',
          onPressed: _clearFilters,
          icon: const Icon(Icons.filter_alt_off_rounded),
          label: const Text('Clear filters'),
        );
      } else if (planned.isNotEmpty) {
        fab = FloatingActionButton(
          heroTag: 'plan_fab',
          onPressed: _addPlanned,
          child: const Icon(Icons.add_rounded),
        );
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: cs.surface,
            scrolledUnderElevation: 0,
            title: const Text('Plan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()),
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
                    _ProjectionHero(
                      personal: snapshotPersonal,
                      net: snapshotNet,
                      snapshotDate: _snapshotDate,
                      isFutureSnapshot: _isFutureProjection,
                      detailExpanded: _detailExpanded,
                      filterChipsEnabled: !_isFutureProjection,
                      onPickSnapshotDate: _pickSnapshotDate,
                      onTapBalance: () =>
                          setState(() => _detailExpanded = !_detailExpanded),
                      panel: _planPanel,
                      onTogglePanel: _togglePlanPanel,
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

          if (!_isFutureProjection && _hasNavigableDateFilter)
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
          if (!_isFutureProjection && _planPanel != TrackPlanFilterPanel.none)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                child: TrackPlanFilterStrip(
                  panel: _planPanel,
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

          if (_isFutureProjection || _detailExpanded)
            SliverToBoxAdapter(
              child: _ProjectionDetailCard(balances: balances),
            ),
          if (!_isFutureProjection)
            if (planned.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: data.accounts.isEmpty
                    ? _EmptyState(
                        onAdd: _addAccount,
                        hasAccounts: false,
                      )
                    : data.plannedTransactions.isEmpty
                        ? _EmptyState(
                            onAdd: _addPlanned,
                            hasAccounts: true,
                          )
                        : _PlanFilteredEmpty(
                            hasExplicitFilters: _hasActiveFilter,
                          ),
              )
            else
              _PlanTimeline(
                planned: planned,
                newestFirst: _newestFirst,
                onConfirm: _confirm,
                onDelete: _deleteWithRepeatChoice,
                onEdit: _edit,
                onTap: _openPlannedDetail,
              ),
          if (_isFutureProjection)
            const SliverToBoxAdapter(child: SizedBox(height: 88)),
        ],
      ),
      floatingActionButton: fab,
    );
  }
}

class _ProjectionHero extends StatelessWidget {
  final double personal;
  final double net;
  final DateTime snapshotDate;
  /// Future snapshot: balances-only mode below; amount is not tappable.
  final bool isFutureSnapshot;
  final bool detailExpanded;
  /// Hero chips stay visible; when false they are dimmed and non-interactive.
  final bool filterChipsEnabled;
  final VoidCallback onPickSnapshotDate;
  final VoidCallback onTapBalance;
  final TrackPlanFilterPanel panel;
  final void Function(TrackPlanFilterPanel) onTogglePanel;
  final String? typeFilter;
  final VoidCallback onCycleType;
  final String? dateModeLetter;
  final bool dateFilterActive;
  final VoidCallback onCycleDate;
  final Account? accountFilter;
  final String? categoryFilter;
  final bool newestFirst;
  final VoidCallback onToggleSort;

  const _ProjectionHero({
    required this.personal,
    required this.net,
    required this.snapshotDate,
    required this.isFutureSnapshot,
    required this.detailExpanded,
    required this.filterChipsEnabled,
    required this.onPickSnapshotDate,
    required this.onTapBalance,
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
    final sym = fx.currencySymbol(settings.baseCurrency);
    final personalPos = personal >= 0;
    final netPos = net >= 0;
    final borderColor =
        personalPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final personalColor =
        personalPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final netColor =
        netPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

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
                Semantics(
                  label:
                      'Projection date ${DateFormat('EEE, d MMM yyyy').format(snapshotDate)}. Double tap to choose date',
                  button: true,
                  child: InkWell(
                    onTap: onPickSnapshotDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Text(
                      DateFormat('EEE, d MMM yyyy').format(snapshotDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppHeroConstants.labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                if (isFutureSnapshot)
                  Semantics(
                    label:
                        'Projected personal balance ${personal > 0 ? '+' : ''}${personal.toStringAsFixed(2)} $sym',
                    child: Text(
                      '${personal > 0 ? '+' : ''}${personal.toStringAsFixed(2)} $sym',
                      style: TextStyle(
                        fontSize: AppHeroConstants.primaryAmountFontSize,
                        fontWeight: FontWeight.w800,
                        color: personalColor,
                        letterSpacing: -1,
                      ),
                    ),
                  )
                else
                  Semantics(
                    label: detailExpanded
                        ? 'Hide projected balances by account'
                        : 'Show projected balances by account',
                    button: true,
                    child: InkWell(
                      onTap: onTapBalance,
                      borderRadius: BorderRadius.circular(8),
                      child: Text(
                        '${personal > 0 ? '+' : ''}${personal.toStringAsFixed(2)} $sym',
                        style: TextStyle(
                          fontSize: AppHeroConstants.primaryAmountFontSize,
                          fontWeight: FontWeight.w800,
                          color: personalColor,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            rightColumn: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Net',
                  style: TextStyle(
                    fontSize: AppHeroConstants.secondaryLabelFontSize,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppHeroConstants.labelToAmountGap),
                Text(
                  '${net > 0 ? '+' : ''}${net.toStringAsFixed(2)} $sym',
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
            invertSortChipActive: true,
            enabled: filterChipsEnabled,
          ),
        ],
      ),
    );
  }
}

class _ProjectionDetailCard extends StatelessWidget {
  final Map<String, double> balances;
  const _ProjectionDetailCard({required this.balances});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (personal.isNotEmpty) ...[
            const _PlanProjectionSectionLabel('Personal'),
            ...personal.map(
              (a) => _ProjectionAccountCard(
                account: a,
                projectedBookNative: balances[a.id] ?? a.balance,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (individuals.isNotEmpty) ...[
            const _PlanProjectionSectionLabel('Individuals'),
            ...individuals.map(
              (a) => _ProjectionAccountCard(
                account: a,
                projectedBookNative: balances[a.id] ?? a.balance,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (entities.isNotEmpty) ...[
            const _PlanProjectionSectionLabel('Entities'),
            ...entities.map(
              (a) => _ProjectionAccountCard(
                account: a,
                projectedBookNative: balances[a.id] ?? a.balance,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

/// Same typography and padding as Review’s `_SectionLabel`.
class _PlanProjectionSectionLabel extends StatelessWidget {
  final String title;
  const _PlanProjectionSectionLabel(this.title);

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

/// Same layout as Review’s `_AccountCard` (avatar, name, group, amounts); read-only.
class _ProjectionAccountCard extends StatelessWidget {
  final Account account;
  final double projectedBookNative;

  const _ProjectionAccountCard({
    required this.account,
    required this.projectedBookNative,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPersonal = account.group == AccountGroup.personal;
    final isEntities = account.group == AccountGroup.entities;

    final shownBook = projectedBookNative;
    final shownMain = account.hasOverdraftFacility
        ? account.personalHeadroomNative(projectedBookNative)
        : projectedBookNative;
    final shownSymbol = fx.currencySymbol(account.currencyCode);
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
    final groupLabel = isPersonal
        ? 'Personal'
        : isEntities
            ? 'Entity'
            : 'Individual';

    final initial = account.name.isNotEmpty ? account.name[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    initial,
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
                    Text(
                      account.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      groupLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
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
                      fontSize: 16,
                    ),
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
                          const TextSpan(text: 'Real balance '),
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
    );
  }
}

/// Shown when filters (or the default month window) hide all planned items but
/// some exist at other dates — mirrors Track’s “no results” pattern.
class _PlanFilteredEmpty extends StatelessWidget {
  final bool hasExplicitFilters;

  const _PlanFilteredEmpty({required this.hasExplicitFilters});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final monthLabel = DateFormat('MMMM yyyy').format(DateTime.now());
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              hasExplicitFilters
                  ? 'No planned transactions for applied filters'
                  : 'No planned transactions in $monthLabel',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  final bool hasAccounts;
  const _EmptyState({required this.onAdd, required this.hasAccounts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
            child: Icon(
              hasAccounts
                  ? Icons.event_note_rounded
                  : Icons.account_balance_wallet_rounded,
              size: 44,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            hasAccounts ? 'Nothing planned for now' : 'No accounts yet',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            hasAccounts
                ? 'Plan upcoming transactions.'
                : 'Add your first account before planning transactions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(hasAccounts ? 'Add plan' : 'Add account'),
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

class _PlanTimeline extends StatelessWidget {
  final List<PlannedTransaction> planned;
  final bool newestFirst;
  final void Function(PlannedTransaction) onConfirm;
  final void Function(PlannedTransaction) onDelete;
  final void Function(PlannedTransaction) onEdit;
  final void Function(PlannedTransaction) onTap;

  const _PlanTimeline({
    required this.planned,
    required this.newestFirst,
    required this.onConfirm,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<PlannedTransaction>>{};
    for (final pt in planned) {
      final key = DateFormat('yyyy-MM-dd').format(pt.date);
      grouped.putIfAbsent(key, () => []).add(pt);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => newestFirst
          ? b.date.compareTo(a.date)
          : a.date.compareTo(b.date));
    }
    final days = grouped.keys.toList()
      ..sort((a, b) => newestFirst ? b.compareTo(a) : a.compareTo(b));

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 100),
      sliver: SliverList.builder(
        itemCount: days.length,
        itemBuilder: (ctx, i) {
          final day = days[i];
          final date = DateTime.parse(day);
          final dayPlanned = grouped[day]!;
          final projectedBalances = proj.projectBalances(date);
          return _DayGroup(
            date: date,
            planned: dayPlanned,
            projectedBalances: projectedBalances,
            onConfirm: onConfirm,
            onDelete: onDelete,
            onEdit: onEdit,
            onTap: onTap,
          );
        },
      ),
    );
  }
}

class _DayGroup extends StatefulWidget {
  final DateTime date;
  final List<PlannedTransaction> planned;
  final Map<String, double> projectedBalances;
  final void Function(PlannedTransaction) onConfirm;
  final void Function(PlannedTransaction) onDelete;
  final void Function(PlannedTransaction) onEdit;
  final void Function(PlannedTransaction) onTap;

  const _DayGroup({
    required this.date,
    required this.planned,
    required this.projectedBalances,
    required this.onConfirm,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  State<_DayGroup> createState() => _DayGroupState();
}

class _DayGroupState extends State<_DayGroup> {
  bool _showProjection = false;

  String _formatDate(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final target = DateUtils.dateOnly(d);
    if (target == today) return 'Today';
    if (target == tomorrow) return 'Tomorrow';
    final diff = target.difference(today).inDays;
    if (diff > 0 && diff <= 6) return DateFormat('EEEE').format(d);
    return DateFormat('EEE, d MMM yyyy').format(d);
  }

  bool get _isPast =>
      DateUtils.dateOnly(widget.date)
          .isBefore(DateUtils.dateOnly(DateTime.now()));

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header — same style as track screen
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            children: [
              Text(
                _formatDate(widget.date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              if (_isPast)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.errorContainer.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'overdue',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: cs.onErrorContainer),
                  ),
                ),
            ],
          ),
        ),

        // Card — same container style as track screen
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
              children: [
                // Planned transaction tiles
                ...widget.planned.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final pt = entry.value;
                  return Dismissible(
                    key: ValueKey(pt.id),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        widget.onDelete(pt);
                      } else {
                        widget.onConfirm(pt);
                      }
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                      child: const Icon(Icons.check_circle_outline_rounded,
                          color: Color(0xFF16A34A), size: 22),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red.withValues(alpha: 0.12),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Color(0xFFDC2626), size: 22),
                    ),
                    child: Column(
                      children: [
                        if (idx > 0)
                          Divider(
                              height: 0.5,
                              indent: 56,
                              color: cs.outlineVariant.withValues(alpha: 0.4)),
                        _PlannedTile(
                          pt: pt,
                          onTap: () => widget.onTap(pt),
                          onLongPress: () => widget.onEdit(pt),
                          showProjection: idx == widget.planned.length - 1
                              ? _showProjection
                              : false,
                          onToggleProjection: idx == widget.planned.length - 1
                              ? () => setState(
                                  () => _showProjection = !_showProjection)
                              : null,
                        ),
                      ],
                    ),
                  );
                }),

                // Projection panel
                if (_showProjection) ...[
                  Divider(
                      height: 0.5,
                      color: cs.outlineVariant.withValues(alpha: 0.4)),
                  _ProjectionPanel(
                    projectedBalances: widget.projectedBalances,
                    personal: personal,
                    individuals: individuals,
                    entities: entities,
                    gainIds: {
                      for (final pt in widget.planned)
                        if (pt.toAccount != null) pt.toAccount!.id,
                    },
                    loseIds: {
                      for (final pt in widget.planned)
                        if (pt.fromAccount != null) pt.fromAccount!.id,
                    },
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

class _ProjectionPanel extends StatelessWidget {
  final Map<String, double> projectedBalances;
  final List<Account> personal;
  final List<Account> individuals;
  final List<Account> entities;
  final Set<String> gainIds;
  final Set<String> loseIds;

  const _ProjectionPanel({
    required this.projectedBalances,
    required this.personal,
    required this.individuals,
    required this.entities,
    this.gainIds = const {},
    this.loseIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = proj.personalTotal(projectedBalances);
    final pos = total >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal total
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: pos
                  ? _kIncomeColor.withValues(alpha: 0.08)
                  : _kExpenseColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: pos
                    ? _kIncomeColor.withValues(alpha: 0.25)
                    : _kExpenseColor.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Text('Balance',
                    style: TextStyle(
                        fontSize: 12,
                        color: pos
                            ? _kIncomeColor
                            : _kExpenseColor,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  '${total > 0 ? '+' : ''}${total.toStringAsFixed(2)} KM',
                  style: TextStyle(
                      color: pos ? _kIncomeColor : _kExpenseColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ],
            ),
          ),

          if (personal.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('PERSONAL',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
            const SizedBox(height: 6),
            ...personal.map((a) => _BalanceChip(
                  name: a.name,
                  balance: projectedBalances[a.id] ?? a.balance,
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
            ...individuals.map((a) => _BalanceChip(
                  name: a.name,
                  balance: projectedBalances[a.id] ?? a.balance,
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
            ...entities.map((a) => _BalanceChip(
                  name: a.name,
                  balance: projectedBalances[a.id] ?? a.balance,
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

class _BalanceChip extends StatelessWidget {
  final String name;
  final double balance;
  final String currencyCode;
  final bool isPartner;
  final bool isGain;
  final bool isLose;

  const _BalanceChip({
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
    final color = isGain ? _kIncomeColor : isLose ? _kExpenseColor : null;

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

class _PlannedTile extends StatelessWidget {
  final PlannedTransaction pt;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool showProjection;
  final VoidCallback? onToggleProjection;

  const _PlannedTile({
    required this.pt,
    required this.onTap,
    required this.onLongPress,
    this.showProjection = false,
    this.onToggleProjection,
  });

  TxType get _type =>
      pt.txType ??
      classifyTransaction(from: pt.fromAccount, to: pt.toAccount);

  Color get _typeColor => txColor(_type);
  IconData get _typeIcon => txIcon(_type);

  String _buildTitle() {
    if (pt.description != null) return pt.description!;
    if (pt.category != null) return pt.category!;
    if (pt.fromAccount != null && pt.toAccount != null) {
      return '${pt.fromAccount!.name} → ${pt.toAccount!.name}';
    }
    if (pt.fromAccount != null) return pt.fromAccount!.name;
    if (pt.toAccount != null) return pt.toAccount!.name;
    return 'Planned transaction';
  }

  String? _buildSubtitle() {
    final parts = <String>[];
    if (pt.description != null && pt.category != null) parts.add(pt.category!);
    if (pt.fromAccount != null || pt.toAccount != null) {
      if (pt.description != null || pt.category != null) {
        if (pt.fromAccount != null && pt.toAccount != null) {
          parts.add('${pt.fromAccount!.name} → ${pt.toAccount!.name}');
        } else if (pt.fromAccount != null) {
          parts.add(pt.fromAccount!.name);
        } else if (pt.toAccount != null) {
          parts.add(pt.toAccount!.name);
        }
      }
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = _buildSubtitle();

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon, size: 18, color: _typeColor),
          ),
          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildTitle(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null || pt.repeatInterval != RepeatInterval.none) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (pt.repeatInterval != RepeatInterval.none) ...[
                        Icon(Icons.repeat_rounded,
                            size: 11, color: cs.primary),
                        const SizedBox(width: 3),
                        Text(
                          repeatLabel(pt.repeatInterval),
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        if (subtitle != null)
                          Text(' · ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant)),
                      ],
                      if (subtitle != null)
                        Expanded(
                          child: Text(
                            subtitle,
                            style: TextStyle(
                                fontSize: 11, color: cs.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Amount (inset from expand control so taps are easier to separate)
          if (pt.nativeAmount != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                txAmountDisplay(
                    _type, pt.nativeAmount!, pt.currencyCode ?? 'BAM'),
                style: TextStyle(
                  color: _typeColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          if (onToggleProjection != null)
            SizedBox(
              width: 48,
              height: 48,
              child: GestureDetector(
                onTap: onToggleProjection,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Icon(
                    showProjection
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
