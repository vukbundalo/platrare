import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../utils/fx.dart' as fx;
import 'account_transactions_screen.dart';
import 'settings_screen.dart';

class ReviewScreen extends StatefulWidget {
  final VoidCallback? onChanged;
  const ReviewScreen({super.key, this.onChanged});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _displayCurrency = settings.baseCurrency;
  // 'personal' | 'individuals' | 'entities' | 'statistics' | null
  String? _activeSection;
  // 'expense' | 'income' | null
  String? _activeStats;
  // 0 = all time, 1 = this month, 3 = 3 months, 6 = 6 months, 12 = 1 year
  int _spendingMonths = 1;
  // 0 = bars, 1 = donut
  int _vizMode = 0;
  // how many periods back from current (0 = most recent)
  int _dateOffset = 0;

  String get _periodLabel => switch (_spendingMonths) {
    1 => '1M', 3 => '3M', 6 => '6M', 12 => '1Y', _ => 'ALL',
  };

  void _cyclePeriod() => setState(() {
    _dateOffset = 0;
    _spendingMonths = switch (_spendingMonths) {
      1 => 3, 3 => 6, 6 => 12, 12 => 0, _ => 1,
    };
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
    final endM = now.month + 1 - _dateOffset * _spendingMonths;
    return (
      start: DateTime(now.year, endM - _spendingMonths, 1),
      end: DateTime(now.year, endM, 1),
    );
  }

  DateTime? get _earliestTxDate => data.transactions.isEmpty
      ? null
      : data.transactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);

  String get _dateRangeLabel {
    final now = DateTime.now();
    if (_spendingMonths == 0) {
      final earliest = _earliestTxDate;
      if (earliest == null) return 'All time';
      return '${DateFormat('MMM yyyy').format(earliest)} – ${DateFormat('MMM yyyy').format(now)}';
    }
    if (_spendingMonths == 12) return '${now.year - _dateOffset}';
    final range = _dateRange;
    final s = range.start!;
    final lastMonth = DateTime(range.end!.year, range.end!.month - 1, 1);
    if (_spendingMonths == 1) return DateFormat('MMMM yyyy').format(s);
    if (s.year == lastMonth.year) {
      return '${DateFormat('MMM').format(s)} – ${DateFormat('MMM yyyy').format(lastMonth)}';
    }
    return '${DateFormat('MMM yyyy').format(s)} – ${DateFormat('MMM yyyy').format(lastMonth)}';
  }

  // ── Account mutations ──────────────────────────────────────────────────────

  Future<void> _addAccount() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AccountFormScreen()),
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
  double get _personalTotal => data.accounts
      .where((a) => a.group == AccountGroup.personal && a.includeInBalance)
      .fold(0.0, (sum, a) => sum + fx.toBase(a.balance, a.currencyCode));

  double get _netTotal => data.accounts
      .where((a) => a.includeInBalance)
      .fold(0.0, (sum, a) => sum + fx.toBase(a.balance, a.currencyCode));

  // Returns {category: total} for income transactions, filtered by period
  Map<String, ({double total, int count})> get _categoryIncome {
    final range = _dateRange;
    final result = <String, ({double total, int count})>{};

    for (final t in data.transactions) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      const incomeTypes = {
        TxType.income, TxType.invoice, TxType.collection, TxType.loan,
      };
      if (!incomeTypes.contains(type)) continue;
      if (t.nativeAmount == null) continue;
      if (range.start != null && t.date.isBefore(range.start!)) continue;
      if (range.end != null && !t.date.isBefore(range.end!)) continue;

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

  // Returns {category: total} for expense transactions, filtered by period
  Map<String, ({double total, int count})> get _categorySpending {
    final range = _dateRange;
    final result = <String, ({double total, int count})>{};

    for (final t in data.transactions) {
      final type = t.txType ??
          classifyTransaction(from: t.fromAccount, to: t.toAccount);
      const expenseTypes = {
        TxType.expense, TxType.settlement, TxType.advance,
      };
      if (!expenseTypes.contains(type)) continue;
      if (t.nativeAmount == null) continue;
      if (range.start != null && t.date.isBefore(range.start!)) continue;
      if (range.end != null && !t.date.isBefore(range.end!)) continue;

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

    return Scaffold(
      floatingActionButton: data.accounts.isEmpty
          ? null
          : FloatingActionButton(
              heroTag: 'review_fab',
              onPressed: _addAccount,
              tooltip: 'Add account',
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
            title: const Text('Review'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
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

          if (data.accounts.isEmpty)
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
                    _SectionLabel('Personal'),
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
                    _SectionLabel('Individuals'),
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
                    _SectionLabel('Entities'),
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
                  if (_activeSection == 'statistics' && data.transactions.isNotEmpty) ...[
                    _StatsHeader(
                      activeStats: _activeStats,
                      onSelectStats: (s) => setState(() =>
                          _activeStats = _activeStats == s ? null : s),
                      periodLabel: _periodLabel,
                      dateRangeLabel: _dateRangeLabel,
                      onCyclePeriod: _cyclePeriod,
                      canNavigateForward: _dateOffset > 0,
                      onNavigateBack: _navigateBack,
                      onNavigateForward: _navigateForward,
                      vizMode: _vizMode,
                      onCycleViz: _cycleViz,
                    ),
                    if (_activeStats == 'expense')
                      _SpendingBody(
                        spending: _categorySpending,
                        periodLabel: _periodLabel,
                        vizMode: _vizMode,
                        displayCurrency: _displayCurrency,
                      ),
                    if (_activeStats == 'income')
                      _IncomeBody(
                        income: _categoryIncome,
                        periodLabel: _periodLabel,
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
  final String? activeSection;
  final void Function(String section) onSelectSection;
  final VoidCallback onToggleCurrency;

  const _NetWorthHero({
    required this.personal,
    required this.net,
    required this.displayCurrency,
    required this.activeSection,
    required this.onSelectSection,
    required this.onToggleCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
          height: 30,
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: balanceColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: balanceColor.withValues(alpha: 0.2)),
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
                    Text('Balance',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      '${displayPersonal > 0 ? '+' : ''}${displayPersonal.toStringAsFixed(2)} $sym',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: balanceColor,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: netColor.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Net',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    '${displayNet > 0 ? '+' : ''}${displayNet.toStringAsFixed(2)} $sym',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: netColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 4 section chips (mutually exclusive) + currency (independent)
          Row(
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
          ),
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
  final String dateRangeLabel;
  final VoidCallback onCyclePeriod;
  final bool canNavigateForward;
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateForward;
  final int vizMode;
  final VoidCallback onCycleViz;

  const _StatsHeader({
    required this.activeStats,
    required this.onSelectStats,
    required this.periodLabel,
    required this.dateRangeLabel,
    required this.onCyclePeriod,
    required this.canNavigateForward,
    required this.onNavigateBack,
    required this.onNavigateForward,
    required this.vizMode,
    required this.onCycleViz,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAllTime = periodLabel == 'ALL';
    final vizIcon = vizMode == 1 ? Icons.donut_large_rounded : Icons.bar_chart_rounded;

    Widget chip({required IconData icon, required bool active, required VoidCallback onTap, String? label}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: label != null
              ? Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: active ? cs.primary : cs.onSurfaceVariant))
              : Icon(icon, size: 15,
                  color: active ? cs.primary : cs.onSurfaceVariant),
        ),
      );

    Widget navBtn({required IconData icon, required bool enabled, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 16,
              color: enabled ? cs.primary : cs.onSurfaceVariant.withValues(alpha: 0.4)),
        ),
      );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          // Chip row: [expense] [income]  ←spacer→  [period] [viz]
          Row(
            children: [
              chip(
                icon: Icons.arrow_upward_rounded,
                active: activeStats == 'expense',
                onTap: () => onSelectStats('expense'),
              ),
              const SizedBox(width: 6),
              chip(
                icon: Icons.arrow_downward_rounded,
                active: activeStats == 'income',
                onTap: () => onSelectStats('income'),
              ),
              const Spacer(),
              chip(
                icon: Icons.calendar_today_outlined,
                active: true,
                onTap: onCyclePeriod,
                label: periodLabel,
              ),
              const SizedBox(width: 6),
              chip(
                icon: vizIcon,
                active: true,
                onTap: onCycleViz,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Date navigator row
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

// ─── Spending body ────────────────────────────────────────────────────────────

class _SpendingBody extends StatelessWidget {
  final Map<String, ({double total, int count})> spending;
  final String periodLabel;
  final int vizMode;
  final String displayCurrency;

  const _SpendingBody({
    required this.spending,
    required this.periodLabel,
    required this.vizMode,
    required this.displayCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const expenseColor = Color(0xFFDC2626);
    final sorted = spending.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalSpentBase = sorted.fold(0.0, (s, e) => s + e.value.total);
    final totalSpent = fx.convert(totalSpentBase, settings.baseCurrency, displayCurrency);
    final sym = fx.currencySymbol(displayCurrency);

    final emptyMsg = switch (periodLabel) {
      '1M' => 'No expenses this month',
      'ALL' => 'No expenses recorded',
      _ => 'No expenses in the last $periodLabel',
    };

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.arrow_upward_rounded, size: 16, color: expenseColor),
                  const SizedBox(width: 8),
                  Text('Total spent',
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  const Spacer(),
                  Text(
                    '-${totalSpent.toStringAsFixed(2)} $sym',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, color: expenseColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vizMode == 1)
          _DonutView(sorted: sorted, displayCurrency: displayCurrency)
        else
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
  final int vizMode;
  final String displayCurrency;

  const _IncomeBody({
    required this.income,
    required this.periodLabel,
    required this.vizMode,
    required this.displayCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const incomeColor = Color(0xFF16A34A);
    final sorted = income.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));
    final maxAmount = sorted.isEmpty ? 1.0 : sorted.first.value.total;
    final totalReceivedBase = sorted.fold(0.0, (s, e) => s + e.value.total);
    final totalReceived = fx.convert(totalReceivedBase, settings.baseCurrency, displayCurrency);
    final sym = fx.currencySymbol(displayCurrency);

    final emptyMsg = switch (periodLabel) {
      '1M' => 'No income this month',
      'ALL' => 'No income recorded',
      _ => 'No income in the last $periodLabel',
    };

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.arrow_downward_rounded, size: 16, color: incomeColor),
                  const SizedBox(width: 8),
                  Text('Total received',
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  const Spacer(),
                  Text(
                    '+${totalReceived.toStringAsFixed(2)} $sym',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, color: incomeColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vizMode == 1)
          _DonutView(sorted: sorted, displayCurrency: displayCurrency)
        else
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

  const _BarsView({
    required this.sorted,
    required this.maxAmount,
    required this.displayCurrency,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: sorted.asMap().entries.map((entry) {
              final isLast = entry.key == sorted.length - 1;
              final cat = entry.value.key;
              final info = entry.value.value;
              final frac = maxAmount > 0 ? info.total / maxAmount : 0.0;
              final amount = fx.convert(info.total, settings.baseCurrency, displayCurrency);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(cat,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${amount.toStringAsFixed(2)} ${fx.currencySymbol(displayCurrency)}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: barColor),
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
                        indent: 14,
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

  const _DonutView({required this.sorted, required this.displayCurrency});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = sorted.fold(0.0, (s, e) => s + e.value.total);
    final fractions =
        sorted.map((e) => total > 0 ? e.value.total / total : 0.0).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            children: [
              SizedBox(
                height: 170,
                child: CustomPaint(
                  painter: _DonutPainter(fractions: fractions),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${sorted.length}',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w800)),
                        Text(
                          sorted.length == 1 ? 'category' : 'categories',
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
                final info = entry.value.value;
                final color = _kChartColors[idx % _kChartColors.length];
                final amount = fx.convert(
                    info.total, settings.baseCurrency, displayCurrency);
                final pct = total > 0 ? info.total / total * 100 : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration:
                            BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(cat,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text('${pct.toStringAsFixed(1)}%',
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant)),
                      const SizedBox(width: 12),
                      Text(
                        '${amount.toStringAsFixed(2)} ${fx.currencySymbol(displayCurrency)}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
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
  _DonutPainter({required this.fractions});

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
        ..color = _kChartColors[i % _kChartColors.length]
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
  bool shouldRepaint(_DonutPainter old) => old.fractions != fractions;
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
    final shownBalance = isSecondary
        ? fx.convert(account.balance, account.currencyCode, displayCurrency)
        : account.balance;
    final shownSymbol = isSecondary
        ? fx.currencySymbol(displayCurrency)
        : fx.currencySymbol(account.currencyCode);
    final isPositive = shownBalance >= 0;
    final balanceColor =
        isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

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
                      '${shownBalance > 0 ? '+' : ''}${shownBalance.toStringAsFixed(2)} $shownSymbol',
                      style: TextStyle(
                          color: balanceColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                    if (!account.includeInBalance)
                      Text('excluded',
                          style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant)),
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
          Text('No accounts yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Add your first account to start tracking your finances.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add account'),
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

class AccountFormSheet extends StatefulWidget {
  final Account? account;
  const AccountFormSheet({super.key, this.account});

  @override
  State<AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountGroup _group;
  late bool _includeInBalance;
  late String _currencyCode;
  bool _forceClose = false;

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
    _group = widget.account?.group ?? AccountGroup.personal;
    _includeInBalance = widget.account?.includeInBalance ?? true;
    _currencyCode = widget.account?.currencyCode ?? settings.baseCurrency;
  }

  bool get _isDirty {
    if (widget.account != null) {
      return _nameController.text.trim() != widget.account!.name ||
          _balanceController.text.trim() !=
              widget.account!.balance.toStringAsFixed(2) ||
          _group != widget.account!.group ||
          _includeInBalance != widget.account!.includeInBalance ||
          _currencyCode != widget.account!.currencyCode;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal ||
        !_includeInBalance;
  }

  void _showDiscardDialog() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. They will be lost if you leave now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Discard'),
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

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final balance = double.tryParse(
            _balanceController.text.trim().replaceAll(',', '.')) ??
        0.0;
    if (widget.account != null) {
      widget.account!.name = name;
      widget.account!.balance = balance;
      widget.account!.group = _group;
      widget.account!.includeInBalance = _includeInBalance;
      Navigator.pop(context, false);
    } else {
      Navigator.pop(
        context,
        Account(
          name: name,
          group: _group,
          balance: balance,
          includeInBalance: _includeInBalance,
          currencyCode: _currencyCode,
        ),
      );
    }
  }

  String get _groupDescription => switch (_group) {
        AccountGroup.personal => 'Your own wallets & bank accounts',
        AccountGroup.individuals => 'Family, friends, individuals',
        AccountGroup.entities => 'Entities, utilities, organisations',
      };

  void _delete() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete account?'),
        content:
            const Text('This account will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
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
                    child: Text(isEdit ? 'Edit Account' : 'New Account',
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
                segments: const [
                  ButtonSegment(
                    value: AccountGroup.personal,
                    icon: Icon(Icons.account_balance_wallet_outlined,
                        size: 16),
                    label: Text('Personal'),
                  ),
                  ButtonSegment(
                    value: AccountGroup.individuals,
                    icon: Icon(Icons.person_outline_rounded, size: 16),
                    label: Text('Individual'),
                  ),
                  ButtonSegment(
                    value: AccountGroup.entities,
                    icon: Icon(Icons.business_outlined, size: 16),
                    label: Text('Entity'),
                  ),
                ],
                selected: {_group},
                onSelectionChanged: (s) =>
                    setState(() => _group = s.first),
              ),
              const SizedBox(height: 6),
              Text(
                _groupDescription,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                autofocus: !isEdit,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Account name',
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
                  labelText: 'Current balance',
                  suffixText: ' ${fx.currencySymbol(_currencyCode)}',
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                child: SwitchListTile.adaptive(
                  value: _includeInBalance,
                  onChanged: (v) =>
                      setState(() => _includeInBalance = v),
                  title: const Text('Include in net worth',
                      style: TextStyle(fontSize: 14)),
                  subtitle: Text(
                    'Toggle off for credit cards or excluded accounts',
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(isEdit ? 'Save Changes' : 'Add Account',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              if (isEdit) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18),
                  label: const Text('Delete Account'),
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
  const AccountFormScreen({super.key, this.existing});

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late AccountGroup _group;
  late bool _includeInBalance;
  late String _currencyCode;
  bool _forceClose = false;

  bool get _isEdit => widget.existing != null;

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
    _group = widget.existing?.group ?? AccountGroup.personal;
    _includeInBalance = widget.existing?.includeInBalance ?? true;
    _currencyCode =
        widget.existing?.currencyCode ?? settings.baseCurrency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    if (_isEdit) {
      return _nameController.text.trim() != widget.existing!.name ||
          _balanceController.text.trim() !=
              widget.existing!.balance.toStringAsFixed(2) ||
          _group != widget.existing!.group ||
          _includeInBalance != widget.existing!.includeInBalance;
    }
    return _nameController.text.trim().isNotEmpty ||
        _balanceController.text.trim().isNotEmpty ||
        _currencyCode != settings.baseCurrency ||
        _group != AccountGroup.personal ||
        !_includeInBalance;
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _showDiscardDialog() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Discard changes?'),
        content: const Text(
            'You have unsaved changes. They will be lost if you leave now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Discard'),
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

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final balance =
        double.tryParse(_balanceController.text.trim().replaceAll(',', '.')) ??
            0.0;
    if (_isEdit) {
      widget.existing!.name = name;
      widget.existing!.balance = balance;
      widget.existing!.group = _group;
      widget.existing!.includeInBalance = _includeInBalance;
    } else {
      data.accounts.add(Account(
        name: name,
        group: _group,
        balance: balance,
        includeInBalance: _includeInBalance,
        currencyCode: _currencyCode,
      ));
    }
    HapticFeedback.lightImpact();
    Navigator.pop(context, true);
  }

  void _confirmDelete() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete account?'),
        content: const Text('This account will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              data.accounts.remove(widget.existing);
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
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

  String get _groupDescription => switch (_group) {
        AccountGroup.personal => 'Your own wallets & bank accounts',
        AccountGroup.individuals => 'Family, friends, individuals',
        AccountGroup.entities => 'Entities, utilities, organisations',
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_isDirty || _forceClose,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDiscardDialog();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Account' : 'New Account'),
          centerTitle: false,
          backgroundColor: cs.surface,
          surfaceTintColor: Colors.transparent,
          actions: _isEdit
              ? [
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: cs.error),
                    tooltip: 'Delete account',
                    onPressed: _confirmDelete,
                  ),
                  const SizedBox(width: 4),
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
                    SegmentedButton<AccountGroup>(
                      segments: const [
                        ButtonSegment(
                          value: AccountGroup.personal,
                          icon: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16),
                          label: Text('Personal'),
                        ),
                        ButtonSegment(
                          value: AccountGroup.individuals,
                          icon: Icon(Icons.person_outline_rounded, size: 16),
                          label: Text('Individual'),
                        ),
                        ButtonSegment(
                          value: AccountGroup.entities,
                          icon: Icon(Icons.business_outlined, size: 16),
                          label: Text('Entity'),
                        ),
                      ],
                      selected: {_group},
                      onSelectionChanged: (s) =>
                          setState(() => _group = s.first),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _groupDescription,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      autofocus: !_isEdit,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          const InputDecoration(labelText: 'Account name'),
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
                        labelText: 'Current balance',
                        suffixText:
                            '  ${fx.currencySymbol(_currencyCode)}',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Material(
                      color: cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      child: SwitchListTile.adaptive(
                        value: _includeInBalance,
                        onChanged: (v) =>
                            setState(() => _includeInBalance = v),
                        title: const Text('Include in net worth',
                            style: TextStyle(fontSize: 14)),
                        subtitle: Text(
                          'Toggle off for credit cards or excluded accounts',
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant),
                        ),
                        dense: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
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
                onPressed: _canSave ? _save : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_isEdit ? 'Save Changes' : 'Add Account',
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
    final name = settings.currencyNames[currencyCode] ?? currencyCode;
    final symbol = fx.currencySymbol(currencyCode);
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Currency',
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
    setState(() {
      _filtered = q.isEmpty
          ? settings.supportedCurrencies
          : settings.supportedCurrencies.where((code) {
              final name =
                  (settings.currencyNames[code] ?? '').toLowerCase();
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
                  hintText: 'Search currency…',
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
                  final name = settings.currencyNames[code] ?? code;
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
