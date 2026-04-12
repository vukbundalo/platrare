import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/account_lifecycle.dart';
import '../data/app_data.dart' as data;
import '../data/balance_privacy_prefs.dart';
import '../data/data_repository.dart';
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/planned_transaction.dart';
import '../models/transaction.dart';
import '../l10n/app_localizations.dart';
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import '../utils/day_grouped_list.dart';
import '../utils/fx.dart' as fx;
import '../widgets/account_avatar.dart';
import '../utils/persistence_guard.dart';
import '../utils/projections.dart' as proj;
import '../theme/ledger_colors.dart';
import '../utils/tx_display.dart';
import 'new_planned_transaction_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';
import 'transaction_detail_screen.dart';
import '../widgets/app_hero_layout.dart';
import '../widgets/stacked_scroll_fab.dart';
import '../widgets/track_plan_filter_ui.dart';

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
  bool _accountStripOpen = false;
  bool _categoryStripOpen = false;
  bool _detailExpanded = false;
  /// Calendar day whose last planned row has per-day projection panel expanded.
  DateTime? _expandedPlanProjectionDay;

  final _planScrollController = ScrollController();
  final _planSearchController = TextEditingController();
  String _planSearchQuery = '';
  int _planVisibleDaySlots = kLazyDayInitialCount;
  int? _planLazyListSig;
  bool _showPlanScrollToTopFab = false;

  bool get _hasActiveFilter =>
      _typeFilter != null ||
      _accountFilter != null ||
      _categoryFilter != null ||
      _dateFilter != null ||
      _newestFirst ||
      _planSearchQuery.trim().isNotEmpty;

  void _clearFilters() => setState(() {
        _typeFilter = null;
        _accountFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
        _newestFirst = false;
        _accountStripOpen = false;
        _categoryStripOpen = false;
        _planSearchQuery = '';
        _planSearchController.clear();
        _expandedPlanProjectionDay = null;
      });

  Future<void> _onReorderProjectionAccounts(
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
    widget.onChanged?.call();
  }

  void _toggleAccountStrip() => setState(() {
        _accountStripOpen = !_accountStripOpen;
      });

  void _toggleCategoryStrip() => setState(() {
        _categoryStripOpen = !_categoryStripOpen;
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

  String? get _dateChipModeLetter => switch (_dateFilter) {
        'month' => 'M',
        'week' => 'W',
        'year' => 'Y',
        'all' => '∞',
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

  /// Default date when opening “new planned” from the list’s visible period.
  DateTime? get _defaultDateForNewPlanned {
    if (_isFutureProjection || _detailExpanded) return null;
    final (start, end) = _dateFilter != null && _dateFilter != 'all'
        ? _dateRange
        : _currentMonthRange;
    final s = DateUtils.dateOnly(start);
    final lastInclusive =
        DateUtils.dateOnly(end.subtract(const Duration(days: 1)));
    var d = DateUtils.dateOnly(_dateAnchor);
    if (d.isBefore(s)) d = s;
    if (d.isAfter(lastInclusive)) d = lastInclusive;
    return d;
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
        _expandedPlanProjectionDay = null;
      });

  void _togglePlanProjectionDay(DateTime date) {
    setState(() {
      final d = DateUtils.dateOnly(date);
      if (_expandedPlanProjectionDay != null &&
          DateUtils.isSameDay(_expandedPlanProjectionDay!, d)) {
        _expandedPlanProjectionDay = null;
      } else {
        _expandedPlanProjectionDay = d;
      }
    });
  }

  void _planFabReset() {
    if (_isFutureProjection) {
      _clearProjectionToToday();
      _scheduleSyncPlanScrollToTopFab();
      return;
    }
    setState(() {
      _expandedPlanProjectionDay = null;
      _detailExpanded = false;
      _accountStripOpen = false;
      _categoryStripOpen = false;
      if (_hasActiveFilter) {
        _typeFilter = null;
        _accountFilter = null;
        _categoryFilter = null;
        _dateFilter = null;
        _dateAnchor = DateTime.now();
        _newestFirst = false;
        _planSearchQuery = '';
        _planSearchController.clear();
      }
    });
    _scheduleSyncPlanScrollToTopFab();
  }

  /// After list height / scroll extent changes without a user scroll (e.g. reset
  /// filters), [ScrollController] listeners may not run; recompute FAB visibility.
  void _scheduleSyncPlanScrollToTopFab() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncPlanScrollToTopFab();
    });
  }

  List<PlannedTransaction> _applyPlannedSearch(List<PlannedTransaction> pts) {
    final q = _planSearchQuery.trim().toLowerCase();
    if (q.isEmpty) return pts;
    return pts.where((pt) {
      if (pt.description?.toLowerCase().contains(q) ?? false) return true;
      final cat = pt.category;
      if (cat != null) {
        if (cat.toLowerCase().contains(q)) return true;
        if (l10nCategoryName(context, cat).toLowerCase().contains(q)) {
          return true;
        }
      }
      if (pt.fromAccount != null &&
          accountDisplayName(pt.fromAccount!).toLowerCase().contains(q)) {
        return true;
      }
      if (pt.toAccount != null &&
          accountDisplayName(pt.toAccount!).toLowerCase().contains(q)) {
        return true;
      }
      final amt = pt.nativeAmount;
      if (amt != null && amt.toString().contains(q)) return true;
      return false;
    }).toList();
  }

  List<PlannedTransaction> get _filteredPlanned {
    Iterable<PlannedTransaction> source = data.plannedTransactions;
    if (_dateFilter != null && _dateFilter != 'all') {
      final (start, end) = _dateRange;
      source = source.where(
          (pt) => !pt.date.isBefore(start) && pt.date.isBefore(end));
    } else if (_dateFilter == null) {
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
    if (_accountFilter != null && !_accountFilter!.archived) {
      final id = _accountFilter!.id;
      source = source.where(
          (pt) => pt.fromAccount?.id == id || pt.toAccount?.id == id);
    }
    if (_categoryFilter != null) {
      source = source.where((pt) => pt.category == _categoryFilter);
    }
    return source.toList();
  }

  static const double _kPlanScrollToTopFabThreshold = 280;

  @override
  void initState() {
    super.initState();
    _planScrollController.addListener(_onPlanScrollControllerChanged);
  }

  void _onPlanScrollControllerChanged() {
    _onPlanScrollLoadMoreDays();
    _syncPlanScrollToTopFab();
  }

  void _syncPlanScrollToTopFab() {
    if (!mounted) return;
    if (!_planScrollController.hasClients) {
      if (_showPlanScrollToTopFab) {
        setState(() => _showPlanScrollToTopFab = false);
      }
      return;
    }
    final pos = _planScrollController.position;
    if (!pos.hasPixels) return;
    final show = pos.pixels > _kPlanScrollToTopFabThreshold;
    if (show != _showPlanScrollToTopFab) {
      setState(() => _showPlanScrollToTopFab = show);
    }
  }

  void _scrollPlanToTop() {
    if (!_planScrollController.hasClients) return;
    _planScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPlanScrollLoadMoreDays() {
    if (_dateFilter != 'all') return;
    if (!_planScrollController.hasClients) return;
    final pos = _planScrollController.position;
    if (!pos.hasPixels || !pos.hasContentDimensions) return;
    if (pos.pixels < pos.maxScrollExtent - 360) return;

    final bundle = DayGroupedPlanned.build(
        _applyPlannedSearch(_filteredPlanned), _newestFirst);
    if (!shouldLazyLoadDaySections(_dateFilter, bundle.dayKeys.length)) return;
    if (_planVisibleDaySlots >= bundle.dayKeys.length) return;

    setState(() {
      _planVisibleDaySlots = math.min(
        _planVisibleDaySlots + kLazyDayLoadBatch,
        bundle.dayKeys.length,
      );
    });
  }

  void _syncPlanLazyWindowSignature() {
    final sig = Object.hash(
      _dateFilter,
      _typeFilter,
      _accountFilter?.id,
      _categoryFilter,
      _newestFirst,
      _planSearchQuery,
      _filteredPlanned.length,
      data.plannedTransactions.length,
    );
    if (_planLazyListSig != sig) {
      _planLazyListSig = sig;
      _planVisibleDaySlots = kLazyDayInitialCount;
    }
  }

  @override
  void dispose() {
    _planScrollController.removeListener(_onPlanScrollControllerChanged);
    _planScrollController.dispose();
    _planSearchController.dispose();
    super.dispose();
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
        title: Text(AppLocalizations.of(ctx).planConfirmTitle),
        content: Text(
          earlyRepeat
              ? AppLocalizations.of(ctx).planConfirmBodyEarly(
                  formatAppDate(ctx, 'd MMM y', pt.date),
                  formatAppDate(ctx, 'd MMM y', today),
                  formatAppDate(ctx, 'd MMM y', nextAfterScheduled!),
                )
              : AppLocalizations.of(ctx).planConfirmBodyNormal,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(ctx).cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _realize(pt, realizationDate: today);
            },
            child: Text(AppLocalizations.of(ctx).confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _realize(PlannedTransaction pt, {DateTime? realizationDate}) async {
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

    final persisted = await guardPersist(context, () async {
      await DataRepository.addTransaction(
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
          attachments: List<String>.from(pt.attachments),
        ),
      );

      await DataRepository.removePlanned(pt);

      if (pt.repeatInterval != RepeatInterval.none) {
        final nextDate = nextPlannedEffectiveDate(pt, pt.date);
        final nextCount = pt.repeatConfirmedCount + 1;
        if (shouldSpawnNextOccurrence(pt, nextDate)) {
          await DataRepository.addPlanned(
            PlannedTransaction(
              nativeAmount: pt.nativeAmount,
              currencyCode: pt.currencyCode,
              destinationAmount: pt.destinationAmount,
              fromAccount: pt.fromAccount,
              toAccount: pt.toAccount,
              fromAccountId: pt.fromAccountId,
              toAccountId: pt.toAccountId,
              category: pt.category,
              description: pt.description,
              date: nextDate,
              txType: pt.txType,
              repeatInterval: pt.repeatInterval,
              repeatEvery: pt.repeatEvery,
              repeatDayOfMonth: pt.repeatDayOfMonth,
              weekendAdjustment: pt.weekendAdjustment,
              repeatEndDate: pt.repeatEndDate,
              repeatEndAfter: pt.repeatEndAfter,
              repeatConfirmedCount: nextCount,
              createdAt: pt.createdAt,
              attachments: List<String>.from(pt.attachments),
            ),
          );
        }
      }
    });

    if (mounted) setState(() {});
    widget.onChanged?.call();

    if (!persisted || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).planTransactionConfirmed),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      ),
    );
  }

  Future<void> _delete(PlannedTransaction pt) async {
    HapticFeedback.lightImpact();
    if (!await guardPersist(context, () => DataRepository.removePlanned(pt))) {
      if (mounted) {
        setState(() {});
        widget.onChanged?.call();
      }
      return;
    }
    if (!mounted) return;
    setState(() {});
    widget.onChanged?.call();
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).planTransactionRemoved),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        duration: const Duration(seconds: 5),
        persist: false,
        action: SnackBarAction(
          label: AppLocalizations.of(context).undo,
          onPressed: () async {
            messenger.clearSnackBars();
            if (!await guardPersist(context, () => DataRepository.addPlanned(pt))) {
              if (mounted) {
                setState(() {});
                widget.onChanged?.call();
              }
              return;
            }
            if (mounted) setState(() {});
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
          title: Text(AppLocalizations.of(ctx).planRepeatingTitle),
          content: Text(AppLocalizations.of(ctx).planRepeatingBody),
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
                      child: Text(AppLocalizations.of(ctx).cancel),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx, 'all'),
                      style: TextButton.styleFrom(foregroundColor: error),
                      child: Text(AppLocalizations.of(ctx).planDeleteAll),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, 'this'),
                      child: Text(AppLocalizations.of(ctx).planSkipThisOnly),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((choice) async {
      if (choice == null || !mounted) return;
      if (choice == 'all') {
        await _delete(pt);
      } else {
        final nextDate = nextPlannedEffectiveDate(pt, pt.date);
        if (!shouldSpawnNextOccurrence(pt, nextDate)) {
          await _delete(pt);
          return;
        }
        final spawned = PlannedTransaction(
          nativeAmount: pt.nativeAmount,
          currencyCode: pt.currencyCode,
          destinationAmount: pt.destinationAmount,
          fromAccount: pt.fromAccount,
          toAccount: pt.toAccount,
          fromAccountId: pt.fromAccountId,
          toAccountId: pt.toAccountId,
          category: pt.category,
          description: pt.description,
          date: nextDate,
          txType: pt.txType,
          repeatInterval: pt.repeatInterval,
          repeatEvery: pt.repeatEvery,
          repeatDayOfMonth: pt.repeatDayOfMonth,
          weekendAdjustment: pt.weekendAdjustment,
          repeatEndDate: pt.repeatEndDate,
          repeatEndAfter: pt.repeatEndAfter,
          repeatConfirmedCount: pt.repeatConfirmedCount,
          createdAt: pt.createdAt,
          attachments: List<String>.from(pt.attachments),
        );
        final skippedOk = await guardPersist(context, () async {
          await DataRepository.removePlanned(pt);
          await DataRepository.addPlanned(spawned);
        });
        if (!mounted) return;
        if (!skippedOk) {
          setState(() {});
          widget.onChanged?.call();
          return;
        }
        setState(() {});
        widget.onChanged?.call();
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).planOccurrenceSkipped),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            duration: const Duration(seconds: 5),
            persist: false,
            action: SnackBarAction(
              label: AppLocalizations.of(context).undo,
              onPressed: () async {
                messenger.clearSnackBars();
                final undoOk = await guardPersist(context, () async {
                  await DataRepository.removePlanned(spawned);
                  await DataRepository.addPlanned(pt);
                });
                if (mounted) {
                  setState(() {});
                  widget.onChanged?.call();
                }
                if (!undoOk) return;
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
      MaterialPageRoute(
        builder: (_) => NewPlannedTransactionScreen(
          defaultDateForNew: _defaultDateForNewPlanned,
        ),
      ),
    );
    if (result != null) {
      if (!mounted) return;
      if (!await guardPersist(context, () => DataRepository.addPlanned(result))) {
        if (mounted) {
          setState(() {});
          widget.onChanged?.call();
        }
        return;
      }
      if (mounted) setState(() {});
    }
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
      if (!mounted) return;
      if (!await guardPersist(context, () => DataRepository.addAccount(result))) {
        if (mounted) {
          setState(() {});
          widget.onChanged?.call();
        }
        return;
      }
      if (mounted) setState(() {});
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
      if (!mounted) return;
      if (!await guardPersist(
          context, () => DataRepository.replacePlanned(pt, result))) {
        if (mounted) {
          setState(() {});
          widget.onChanged?.call();
        }
        return;
      }
      if (mounted) setState(() {});
    }
  }

  void _openPlannedDetail(PlannedTransaction pt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlannedTransactionDetailScreen(
          pt: pt,
          onConfirm: () => _confirm(pt),
          onEdit: () => _edit(pt),
          onDelete: () => _deleteWithRepeatChoice(pt),
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
    final l10n = AppLocalizations.of(context);
    final hasAccounts = activeAccounts(data.accounts).isNotEmpty;
    final hasPlanned = data.plannedTransactions.isNotEmpty;
    final planChipsEnabled =
        !_isFutureProjection && hasAccounts && hasPlanned;
    // Clear stale filters only when Plan chips cannot work (no accounts or no
    // planned txs). Do not clear when chips are hidden because the user is in
    // future projection — that would drop date navigation and feel like a reset.
    if ((!hasAccounts || !hasPlanned) &&
        (_accountStripOpen ||
            _categoryStripOpen ||
            _hasActiveFilter)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _clearFilters();
      });
    }
    final planFilterDisabledSemantics = _isFutureProjection
        ? l10n.semanticsFiltersDisabled
        : !hasAccounts
            ? l10n.semanticsFiltersDisabledNeedAccount
            : !hasPlanned
                ? l10n.semanticsFiltersDisabledNeedPlannedTransaction
                : l10n.semanticsFiltersDisabled;
    final planHeroInteractive = hasAccounts && hasPlanned;
    if (!planHeroInteractive && _detailExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _detailExpanded = false;
            _expandedPlanProjectionDay = null;
          });
        }
      });
    }
    if (!planHeroInteractive && _isFutureProjection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _snapshotDate = DateUtils.dateOnly(DateTime.now());
          });
        }
      });
    }
    final planned = _filteredPlanned;
    final displayPlanned = _applyPlannedSearch(planned);
    _syncPlanLazyWindowSignature();
    final planDayBundle =
        DayGroupedPlanned.build(displayPlanned, _newestFirst);
    final lazyPlanDays =
        shouldLazyLoadDaySections(_dateFilter, planDayBundle.dayKeys.length);
    final planVisibleDayGroups = lazyPlanDays
        ? math.min(_planVisibleDaySlots, planDayBundle.dayKeys.length)
        : planDayBundle.dayKeys.length;

    // Compute once per build — used by both hero and detail card.
    final balances = proj.projectBalances(_snapshotDate);
    final snapshotPersonal = proj.personalTotal(balances);
    final snapshotNet = proj.netWorthInBase(balances);
    final projectionActive = activeAccounts(data.accounts);
    final projPersonal = projectionActive
        .where((a) => a.group == AccountGroup.personal)
        .toList();
    final projIndividuals = projectionActive
        .where((a) => a.group == AccountGroup.individuals)
        .toList();
    final projEntities = projectionActive
        .where((a) => a.group == AccountGroup.entities)
        .toList();

    Widget? fab;
    if (activeAccounts(data.accounts).isNotEmpty) {
      final showPlanResetFab = _isFutureProjection ||
          _hasActiveFilter ||
          _detailExpanded ||
          _expandedPlanProjectionDay != null ||
          _accountStripOpen ||
          _categoryStripOpen;
      final showPlanAddFab =
          displayPlanned.isNotEmpty || showPlanResetFab;
      if (showPlanAddFab) {
        final addFab = FloatingActionButton(
          heroTag: 'plan_fab_add',
          onPressed: _addPlanned,
          child: const Icon(Icons.add_rounded),
        );
        fab = showPlanResetFab
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'plan_fab_reset',
                    onPressed: _planFabReset,
                    tooltip: l10n.heroResetButton,
                    child: const Icon(Icons.restart_alt_rounded),
                  ),
                  const SizedBox(width: 12),
                  addFab,
                ],
              )
            : addFab;
      }
    }
    final mainFab = fab;
    if (mainFab != null) {
      fab = StackedScrollFab(
        showScrollToTop: _showPlanScrollToTopFab,
        onScrollToTop: _scrollPlanToTop,
        scrollToTopTooltip: l10n.fabScrollToTop,
        scrollHeroTag: 'plan_scroll_top',
        mainFab: mainFab,
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollMetricsNotification>(
        onNotification: (ScrollMetricsNotification n) {
          if (n.metrics.axis == Axis.vertical) {
            _scheduleSyncPlanScrollToTopFab();
          }
          return false;
        },
        child: CustomScrollView(
          controller: _planScrollController,
          slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Text(AppLocalizations.of(context).navPlan),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: AppLocalizations.of(context).tooltipSettings,
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
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: HeroPinnedDelegate(
              child: _ProjectionHero(
                personal: snapshotPersonal,
                net: snapshotNet,
                snapshotDate: _snapshotDate,
                isFutureSnapshot: _isFutureProjection,
                detailExpanded: _detailExpanded,
                projectionHeroInteractive: planHeroInteractive,
                filterChipsEnabled: planChipsEnabled,
                filterChipsDisabledSemantics: planFilterDisabledSemantics,
                onPickSnapshotDate: _pickSnapshotDate,
                onTapBalance: () =>
                    setState(() => _detailExpanded = !_detailExpanded),
                accountPanelOpen: _accountStripOpen,
                categoryPanelOpen: _categoryStripOpen,
                onToggleAccountPanel: _toggleAccountStrip,
                onToggleCategoryPanel: _toggleCategoryStrip,
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
            ),
          ),

          if (planChipsEnabled && _hasNavigableDateFilter)
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
          if (planChipsEnabled &&
              (_accountStripOpen || _categoryStripOpen))
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                child: TrackPlanFilterStrip(
                  showAccountSection: _accountStripOpen,
                  showCategorySection: _categoryStripOpen,
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
          if (planChipsEnabled &&
              !_isFutureProjection &&
              !_detailExpanded)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: TextField(
                  controller: _planSearchController,
                  onChanged: (v) => setState(() => _planSearchQuery = v),
                  decoration: InputDecoration(
                    hintText: l10n.trackSearchHint,
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: _planSearchQuery.isNotEmpty
                        ? IconButton(
                            tooltip: l10n.trackSearchClear,
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _planSearchController.clear();
                              setState(() => _planSearchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),

          if (planHeroInteractive &&
              (_isFutureProjection || _detailExpanded)) ...[
            if (projPersonal.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _PlanProjectionSectionLabel(
                    l10nAccountSectionTitle(context, AccountGroup.personal)),
              ),
              SliverReorderableList(
                itemCount: projPersonal.length,
                onReorder: (oldIndex, newIndex) =>
                    _onReorderProjectionAccounts(
                  projPersonal,
                  oldIndex,
                  newIndex,
                ),
                itemBuilder: (context, index) {
                  final a = projPersonal[index];
                  return _ProjectionAccountCard(
                    key: ValueKey(a.id),
                    account: a,
                    projectedBookNative: balances[a.id] ?? a.balance,
                    reorderListIndex: index,
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 4)),
            ],
            if (projIndividuals.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _PlanProjectionSectionLabel(l10nAccountSectionTitle(
                    context, AccountGroup.individuals)),
              ),
              SliverReorderableList(
                itemCount: projIndividuals.length,
                onReorder: (oldIndex, newIndex) =>
                    _onReorderProjectionAccounts(
                  projIndividuals,
                  oldIndex,
                  newIndex,
                ),
                itemBuilder: (context, index) {
                  final a = projIndividuals[index];
                  return _ProjectionAccountCard(
                    key: ValueKey(a.id),
                    account: a,
                    projectedBookNative: balances[a.id] ?? a.balance,
                    reorderListIndex: index,
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 4)),
            ],
            if (projEntities.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: _PlanProjectionSectionLabel(
                    l10nAccountSectionTitle(context, AccountGroup.entities)),
              ),
              SliverReorderableList(
                itemCount: projEntities.length,
                onReorder: (oldIndex, newIndex) =>
                    _onReorderProjectionAccounts(
                  projEntities,
                  oldIndex,
                  newIndex,
                ),
                itemBuilder: (context, index) {
                  final a = projEntities[index];
                  return _ProjectionAccountCard(
                    key: ValueKey(a.id),
                    account: a,
                    projectedBookNative: balances[a.id] ?? a.balance,
                    reorderListIndex: index,
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 4)),
            ],
            SliverToBoxAdapter(
              child: SizedBox(height: stackedFabScrollBottomInset(context)),
            ),
          ],
          if (!_isFutureProjection && !_detailExpanded)
            if (displayPlanned.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: activeAccounts(data.accounts).isEmpty
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
                bundle: planDayBundle,
                visibleDayGroupCount: planVisibleDayGroups,
                expandedProjectionDay: _expandedPlanProjectionDay,
                onToggleProjectionDay: _togglePlanProjectionDay,
                onConfirm: _confirm,
                onDelete: _deleteWithRepeatChoice,
                onEdit: _edit,
                onTap: _openPlannedDetail,
              ),
        ],
        ),
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
  /// Date picker and personal-balance expand/collapse (non-future) require setup.
  final bool projectionHeroInteractive;
  /// Hero chips stay visible; when false they are dimmed and non-interactive.
  final bool filterChipsEnabled;
  final String filterChipsDisabledSemantics;
  final VoidCallback onPickSnapshotDate;
  final VoidCallback onTapBalance;
  final bool accountPanelOpen;
  final bool categoryPanelOpen;
  final VoidCallback onToggleAccountPanel;
  final VoidCallback onToggleCategoryPanel;
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
    required this.projectionHeroInteractive,
    required this.filterChipsEnabled,
    required this.filterChipsDisabledSemantics,
    required this.onPickSnapshotDate,
    required this.onTapBalance,
    required this.accountPanelOpen,
    required this.categoryPanelOpen,
    required this.onToggleAccountPanel,
    required this.onToggleCategoryPanel,
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
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
    final sym = fx.currencySymbol(settings.baseCurrency);
    final personalPos = personal >= 0;
    final netPos = net >= 0;
    final brightness = Theme.of(context).brightness;
    final personalColor = personalPos ? lc.positive : lc.negative;
    final netColor = netPos ? lc.positive : lc.negative;
    final personalStr = '${formatBalanceAmount(personal)} $sym';
    final netStr = '${formatBalanceAmount(net)} $sym';
    final personalAmountStyle = TextStyle(
      fontSize: AppHeroConstants.primaryAmountFontSize,
      fontWeight: FontWeight.w800,
      color: personalColor,
      letterSpacing: -1,
    );
    final netAmountStyle = TextStyle(
      fontSize: AppHeroConstants.secondaryAmountFontSize,
      fontWeight: FontWeight.w700,
      color: netColor,
      letterSpacing: -0.5,
    );

    final dateStr =
        formatAppDate(context, 'EEE, d MMM yyyy', snapshotDate);
    final dateText = Text(
      dateStr,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: AppHeroConstants.labelFontSize,
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
      ),
    );
    final projectionDateControl = projectionHeroInteractive
        ? Semantics(
            label: l10n.semanticsProjectionDate(dateStr),
            button: true,
            child: InkWell(
              onTap: onPickSnapshotDate,
              borderRadius: BorderRadius.circular(8),
              child: dateText,
            ),
          )
        : Semantics(
            enabled: false,
            label: l10n.semanticsPlanProjectionControlsDisabled,
            child: Opacity(
              opacity: 0.5,
              child: ExcludeSemantics(child: dateText),
            ),
          );

    return ListenableBuilder(
      listenable: balancePrivacyListenable,
      builder: (context, _) {
        final showAmounts = heroBalancesVisible;
        final personalDisplay =
            showAmounts ? personalStr : kHeroBalanceMasked;
        final netDisplay = showAmounts ? netStr : kHeroBalanceMasked;
        final personalStyle = showAmounts
            ? personalAmountStyle
            : heroPrivacyMaskedAmountStyle(
                personalAmountStyle, cs, brightness);
        final netStyle = showAmounts
            ? netAmountStyle
            : heroPrivacyMaskedAmountStyle(netAmountStyle, cs, brightness);

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
                        projectionDateControl,
                        const SizedBox(
                            height: AppHeroConstants.labelToAmountGap),
                        if (isFutureSnapshot)
                          Semantics(
                            label: showAmounts
                                ? l10n.semanticsProjectedBalance(personalStr)
                                : l10n.semanticsHeroBalanceHidden,
                            child: Opacity(
                              opacity: projectionHeroInteractive ? 1 : 0.5,
                              child: HeroFittedAmount(
                                text: personalDisplay,
                                style: personalStyle,
                              ),
                            ),
                          )
                        else if (projectionHeroInteractive)
                          Semantics(
                            label: showAmounts
                                ? (detailExpanded
                                    ? l10n.semanticsHideProjections
                                    : l10n.semanticsShowProjections)
                                : l10n.semanticsHeroBalanceHidden,
                            button: true,
                            child: InkWell(
                              onTap: onTapBalance,
                              borderRadius: BorderRadius.circular(8),
                              child: HeroFittedAmount(
                                text: personalDisplay,
                                style: personalStyle,
                              ),
                            ),
                          )
                        else
                          Semantics(
                            enabled: false,
                            label: l10n.semanticsPlanProjectionControlsDisabled,
                            child: Opacity(
                              opacity: 0.5,
                              child: ExcludeSemantics(
                                child: HeroFittedAmount(
                                  text: personalDisplay,
                                  style: personalStyle,
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
                          AppLocalizations.of(context).heroNet,
                          style: TextStyle(
                            fontSize: AppHeroConstants.secondaryLabelFontSize,
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
                            style: netStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppHeroConstants.chipGapBelowMetrics),
                  TrackPlanFilterChipRow(
                    accountPanelOpen: accountPanelOpen,
                    categoryPanelOpen: categoryPanelOpen,
                    onToggleAccountPanel: onToggleAccountPanel,
                    onToggleCategoryPanel: onToggleCategoryPanel,
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
                    disabledSemanticsLabel: filterChipsDisabledSemantics,
                  ),
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
  final int? reorderListIndex;

  const _ProjectionAccountCard({
    super.key,
    required this.account,
    required this.projectedBookNative,
    this.reorderListIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
    final shownBook = projectedBookNative;
    final shownMain = account.hasOverdraftFacility
        ? account.personalHeadroomNative(projectedBookNative)
        : projectedBookNative;
    final shownSymbol = fx.currencySymbol(account.currencyCode);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                          TextSpan(
                              text:
                                  '${AppLocalizations.of(context).realBalance} '),
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

/// Shown when filters (or the default month window) hide all planned items but
/// some exist at other dates — mirrors Track’s “no results” pattern.
class _PlanFilteredEmpty extends StatelessWidget {
  final bool hasExplicitFilters;

  const _PlanFilteredEmpty({required this.hasExplicitFilters});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final monthLabel =
        formatAppDate(context, 'MMMM yyyy', DateTime.now());
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
                  ? AppLocalizations.of(context).planNoPlannedForFilters
                  : AppLocalizations.of(context)
                      .planNoPlannedInMonth(monthLabel),
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
            hasAccounts ? l10n.planNothingPlanned : l10n.emptyNoAccountsYet,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            hasAccounts ? l10n.planPlanBody : l10n.emptyAddFirstAccountPlan,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(hasAccounts ? l10n.planAddPlan : l10n.emptyAddAccount),
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
  final DayGroupedPlanned bundle;
  final int visibleDayGroupCount;
  final DateTime? expandedProjectionDay;
  final void Function(DateTime) onToggleProjectionDay;
  final void Function(PlannedTransaction) onConfirm;
  final void Function(PlannedTransaction) onDelete;
  final void Function(PlannedTransaction) onEdit;
  final void Function(PlannedTransaction) onTap;

  const _PlanTimeline({
    required this.bundle,
    required this.visibleDayGroupCount,
    required this.expandedProjectionDay,
    required this.onToggleProjectionDay,
    required this.onConfirm,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final keys = bundle.dayKeys;
    final n = math.min(visibleDayGroupCount, keys.length);
    final grouped = bundle.grouped;

    return SliverPadding(
      padding: EdgeInsets.only(bottom: stackedFabScrollBottomInset(context)),
      sliver: SliverList.builder(
        itemCount: n,
        itemBuilder: (ctx, i) {
          final day = keys[i];
          final date = DateTime.parse(day);
          final dayPlanned = grouped[day]!;
          final projectedBalances = proj.projectBalances(date);
          final projectionOpen = expandedProjectionDay != null &&
              DateUtils.isSameDay(expandedProjectionDay!, date);
          return _DayGroup(
            date: date,
            planned: dayPlanned,
            projectedBalances: projectedBalances,
            projectionExpanded: projectionOpen,
            onToggleLastProjection: () => onToggleProjectionDay(date),
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

class _DayGroup extends StatelessWidget {
  final DateTime date;
  final List<PlannedTransaction> planned;
  final Map<String, double> projectedBalances;
  final bool projectionExpanded;
  final VoidCallback onToggleLastProjection;
  final void Function(PlannedTransaction) onConfirm;
  final void Function(PlannedTransaction) onDelete;
  final void Function(PlannedTransaction) onEdit;
  final void Function(PlannedTransaction) onTap;

  const _DayGroup({
    required this.date,
    required this.planned,
    required this.projectedBalances,
    required this.projectionExpanded,
    required this.onToggleLastProjection,
    required this.onConfirm,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  String _formatDate(BuildContext context, DateTime d) {
    final l10n = AppLocalizations.of(context);
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final target = DateUtils.dateOnly(d);
    if (target == today) return l10n.dateToday;
    if (target == tomorrow) return l10n.dateTomorrow;
    final diff = target.difference(today).inDays;
    if (diff > 0 && diff <= 6) {
      return formatAppDate(context, 'EEEE', d);
    }
    return formatAppDate(context, 'EEE, d MMM yyyy', d);
  }

  bool _isPastFor(DateTime d) =>
      DateUtils.dateOnly(d).isBefore(DateUtils.dateOnly(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lc = context.ledgerColors;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header — same style as track screen
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            children: [
              Text(
                _formatDate(context, date),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              if (_isPastFor(date))
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.errorContainer.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context).planOverdue,
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
                ...planned.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final pt = entry.value;
                  return Dismissible(
                    key: ValueKey(pt.id),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        onDelete(pt);
                      } else {
                        onConfirm(pt);
                      }
                      return false;
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: lc.positive.withValues(alpha: 0.12),
                      child: Icon(Icons.check_circle_outline_rounded,
                          color: lc.positive, size: 22),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: lc.negative.withValues(alpha: 0.12),
                      child: Icon(Icons.delete_outline_rounded,
                          color: lc.negative, size: 22),
                    ),
                    child: Column(
                      children: [
                        if (idx > 0)
                          Divider(
                              height: 0.5,
                              indent: 68,
                              color: cs.outlineVariant.withValues(alpha: 0.4)),
                        _PlannedTile(
                          pt: pt,
                          onTap: () => onTap(pt),
                          onLongPress: () => onEdit(pt),
                          showProjection: idx == planned.length - 1
                              ? projectionExpanded
                              : false,
                          onToggleProjection: idx == planned.length - 1
                              ? onToggleLastProjection
                              : null,
                        ),
                      ],
                    ),
                  );
                }),

                // Projection panel
                if (projectionExpanded) ...[
                  Divider(
                      height: 0.5,
                      color: cs.outlineVariant.withValues(alpha: 0.4)),
                  _ProjectionPanel(
                    projectedBalances: projectedBalances,
                    personal: personal,
                    individuals: individuals,
                    entities: entities,
                    gainIds: {
                      for (final pt in planned)
                        if (pt.toAccount != null) pt.toAccount!.id,
                    },
                    loseIds: {
                      for (final pt in planned)
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
    final lc = context.ledgerColors;
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
                  ? lc.positive.withValues(alpha: 0.08)
                  : lc.negative.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: pos
                    ? lc.positive.withValues(alpha: 0.25)
                    : lc.negative.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Text(AppLocalizations.of(context).heroBalance,
                    style: TextStyle(
                        fontSize: 12,
                        color: pos ? lc.positive : lc.negative,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  '${formatBalanceAmount(total)} ${fx.currencySymbol(settings.baseCurrency)}',
                  style: TextStyle(
                      color: pos ? lc.positive : lc.negative,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ],
            ),
          ),

          if (personal.isNotEmpty) ...[
            const SizedBox(height: 10),
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
              final book = projectedBalances[a.id] ?? a.balance;
              return _BalanceChip(
                name: accountDisplayName(a),
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
              final book = projectedBalances[a.id] ?? a.balance;
              return _BalanceChip(
                name: accountDisplayName(a),
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
              final book = projectedBalances[a.id] ?? a.balance;
              return _BalanceChip(
                name: accountDisplayName(a),
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
    final lc = context.ledgerColors;
    final isAffected = isGain || isLose;
    final color = isGain ? lc.positive : isLose ? lc.negative : null;

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
            '${formatBalanceAmount(balance)} ${fx.currencySymbol(currencyCode)}',
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

  Color _typeColor(BuildContext context) => txColor(context, _type);
  IconData get _typeIcon => txIcon(_type);

  String _buildTitle(BuildContext context) {
    if (pt.description != null) {
      return l10nSentinel(pt.description, AppLocalizations.of(context));
    }
    if (pt.category != null) return l10nCategoryName(context, pt.category!);
    if (pt.fromAccount != null && pt.toAccount != null) {
      return '${accountDisplayName(pt.fromAccount!)} → ${accountDisplayName(pt.toAccount!)}';
    }
    if (pt.fromAccount != null) return accountDisplayName(pt.fromAccount!);
    if (pt.toAccount != null) return accountDisplayName(pt.toAccount!);
    return AppLocalizations.of(context).planPlannedTransaction;
  }

  String? _buildSubtitle(BuildContext context) {
    final parts = <String>[];
    if (pt.description != null && pt.category != null) {
      parts.add(l10nCategoryName(context, pt.category!));
    }
    if (pt.fromAccount != null || pt.toAccount != null) {
      if (pt.description != null || pt.category != null) {
        if (pt.fromAccount != null && pt.toAccount != null) {
          parts.add(
              '${accountDisplayName(pt.fromAccount!)} → ${accountDisplayName(pt.toAccount!)}');
        } else if (pt.fromAccount != null) {
          parts.add(accountDisplayName(pt.fromAccount!));
        } else if (pt.toAccount != null) {
          parts.add(accountDisplayName(pt.toAccount!));
        }
      }
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final subtitle = _buildSubtitle(context);

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
              color: _typeColor(context).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_typeIcon, size: 18, color: _typeColor(context)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _buildTitle(context),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null || pt.repeatInterval != RepeatInterval.none) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (pt.repeatInterval != RepeatInterval.none) ...[
                        Icon(Icons.repeat_rounded,
                            size: 11, color: cs.primary),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            l10nRepeatSummary(context, pt),
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.primary,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (subtitle != null)
                          Text(' · ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w400)),
                      ],
                      if (subtitle != null)
                        Expanded(
                          child: Text(
                            subtitle,
                            style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w400),
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

          if (pt.nativeAmount != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                txAmountDisplay(
                    _type, pt.nativeAmount!, pt.currencyCode ?? 'BAM'),
                style: TextStyle(
                  color: _typeColor(context),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
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
    );
  }
}
