import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart' as data;
import '../data/user_settings.dart' as settings;
import '../models/account.dart';
import '../models/transaction.dart';
import '../utils/fx.dart' as fx;
import '../utils/tx_display.dart';
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
  bool _filtersExpanded = false;

  List<Transaction> get _allTx => data.transactions
      .where((t) =>
          t.fromAccount?.id == widget.account.id ||
          t.toAccount?.id == widget.account.id)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  (DateTime, DateTime) get _dateRange {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'week'  => () {
          final mon = DateTime(a.year, a.month, a.day - (a.weekday - 1));
          return (mon, DateTime(mon.year, mon.month, mon.day + 7));
        }(),
      'month' => (DateTime(a.year, a.month), DateTime(a.year, a.month + 1)),
      'year'  => (DateTime(a.year), DateTime(a.year + 1)),
      _       => (DateTime(0), DateTime(9999)),
    };
  }

  String get _dateLabel {
    final a = _dateAnchor;
    return switch (_dateFilter) {
      'week' => () {
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

  List<Transaction> get _filteredTx {
    Iterable<Transaction> source = _allTx;

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

    if (_dateFilter != null) {
      final (start, end) = _dateRange;
      source = source.where(
          (t) => !t.date.isBefore(start) && t.date.isBefore(end));
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

  void _navigateDate(int direction) {
    setState(() {
      _dateAnchor = switch (_dateFilter) {
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

  void _openDetail(Transaction t) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: t)),
    );
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
    final cs = Theme.of(context).colorScheme;
    final account = widget.account;
    final displayTx = _filteredTx;
    final totals = _totals;

    final grouped = <String, List<Transaction>>{};
    for (final t in displayTx) {
      final key = DateFormat('yyyy-MM-dd').format(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final allCategories = [
      ...data.incomeCategories,
      ...data.expenseCategories,
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
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
                    _AccountHero(
                      account: account,
                      totals: totals,
                      typeFilter: _typeFilter,
                      onTypeFilter: (v) => setState(() => _typeFilter = v),
                      filtersExpanded: _filtersExpanded,
                      hasActiveFilter: _categoryFilter != null || _dateFilter != null,
                      onToggleFilters: () =>
                          setState(() => _filtersExpanded = !_filtersExpanded),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filters panel
          if (_filtersExpanded)
            SliverToBoxAdapter(
              child: _AccountFiltersPanel(
                dateFilter: _dateFilter,
                dateLabel: _dateLabel,
                onDateFilter: (v) => setState(() {
                  _dateFilter = v;
                  _dateAnchor = DateTime.now();
                }),
                onNavigateDate: _navigateDate,
                categoryFilter: _categoryFilter,
                onCategoryFilter: (v) =>
                    setState(() => _categoryFilter = v),
                allCategories: allCategories,
              ),
            ),

          if (displayTx.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 48, color: cs.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      'No transactions',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SliverList(
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
                  childCount: days.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Hero card ────────────────────────────────────────────────────────────────

class _AccountHero extends StatelessWidget {
  final Account account;
  final ({double totalIn, double totalOut}) totals;
  final String? typeFilter;
  final ValueChanged<String?> onTypeFilter;
  final bool filtersExpanded;
  final bool hasActiveFilter;
  final VoidCallback onToggleFilters;

  const _AccountHero({
    required this.account,
    required this.totals,
    required this.typeFilter,
    required this.onTypeFilter,
    required this.filtersExpanded,
    required this.hasActiveFilter,
    required this.onToggleFilters,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sym = fx.currencySymbol(account.currencyCode);
    final balPos = account.balance >= 0;
    final balColor =
        balPos ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final avail = account.hasOverdraftFacility ? account.availableToSpend : null;
    final availPos = avail != null && avail >= 0;
    final availColor = avail == null
        ? balColor
        : (availPos
            ? const Color(0xFF16A34A)
            : const Color(0xFFDC2626));
    final outColor = const Color(0xFFDC2626);
    final filterActive = filtersExpanded || hasActiveFilter;

    Widget filterChip(String key, IconData icon) {
      final active = typeFilter == key;
      return GestureDetector(
        onTap: () => onTypeFilter(active ? null : key),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 15,
              color: active ? cs.primary : cs.onSurfaceVariant),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: balColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: balColor.withValues(alpha: 0.2)),
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
                    Text(
                        account.hasOverdraftFacility
                            ? 'Book balance'
                            : 'Balance',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      '${account.balance > 0 ? '+' : ''}${account.balance.toStringAsFixed(2)} $sym',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: balColor,
                        letterSpacing: -1,
                      ),
                    ),
                    if (avail != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Available to spend',
                        style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(
                        '${avail > 0 ? '+' : ''}${avail.toStringAsFixed(2)} $sym',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: availColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: balColor.withValues(alpha: 0.2),
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
                    '-${totals.totalOut.toStringAsFixed(2)} ${fx.currencySymbol(settings.baseCurrency)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: outColor,
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
              Expanded(child: filterChip(_kTypeIncome, Icons.arrow_downward_rounded)),
              const SizedBox(width: 6),
              Expanded(child: filterChip(_kTypeExpense, Icons.arrow_upward_rounded)),
              const SizedBox(width: 6),
              Expanded(child: filterChip(_kTypeTransfer, Icons.swap_horiz_rounded)),
              const SizedBox(width: 6),
              // Spacer chip (empty, no accounts filter needed)
              Expanded(child: SizedBox(height: 30)),
              const SizedBox(width: 6),
              // Filters toggle
              Expanded(
                child: GestureDetector(
                  onTap: onToggleFilters,
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: filterActive
                          ? cs.primary.withValues(alpha: 0.15)
                          : cs.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      filtersExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 15,
                      color: filterActive ? cs.primary : cs.onSurfaceVariant,
                    ),
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

// ─── Filters panel ────────────────────────────────────────────────────────────

class _AccountFiltersPanel extends StatelessWidget {
  final String? dateFilter;
  final String dateLabel;
  final ValueChanged<String?> onDateFilter;
  final ValueChanged<int> onNavigateDate;
  final String? categoryFilter;
  final ValueChanged<String?> onCategoryFilter;
  final List<String> allCategories;

  const _AccountFiltersPanel({
    required this.dateFilter,
    required this.dateLabel,
    required this.onDateFilter,
    required this.onNavigateDate,
    required this.categoryFilter,
    required this.onCategoryFilter,
    required this.allCategories,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget chip({required String label, required bool active, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.12)
                : cs.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active
                  ? cs.primary.withValues(alpha: 0.35)
                  : cs.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    Widget sectionLabel(String label) => Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionLabel('DATE PERIOD'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                chip(label: 'Week', active: dateFilter == 'week', onTap: () => onDateFilter(dateFilter == 'week' ? null : 'week')),
                chip(label: 'Month', active: dateFilter == 'month', onTap: () => onDateFilter(dateFilter == 'month' ? null : 'month')),
                chip(label: 'Year', active: dateFilter == 'year', onTap: () => onDateFilter(dateFilter == 'year' ? null : 'year')),
              ],
            ),
            if (dateFilter != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  _NavBtn(icon: Icons.chevron_left_rounded, onTap: () => onNavigateDate(-1)),
                  const SizedBox(width: 10),
                  Text(dateLabel,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.onSurface)),
                  const SizedBox(width: 10),
                  _NavBtn(icon: Icons.chevron_right_rounded, onTap: () => onNavigateDate(1)),
                ],
              ),
            ],
            if (allCategories.isNotEmpty) ...[
              const SizedBox(height: 14),
              sectionLabel('CATEGORY'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: allCategories
                    .map((cat) => chip(
                          label: cat,
                          active: categoryFilter == cat,
                          onTap: () => onCategoryFilter(categoryFilter == cat ? null : cat),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: cs.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, size: 18, color: cs.primary),
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

  String _dayLabel() {
    final today = DateUtils.dateOnly(DateTime.now());
    final target = DateUtils.dateOnly(date);
    if (target == today) return 'Today';
    if (target == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEEE, d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 6),
          child: Text(
            _dayLabel(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
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
                    _title(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (counterpart != null)
                        Expanded(
                          child: Text(
                            counterpart,
                            style: TextStyle(
                                fontSize: 11, color: cs.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (transaction.nativeAmount != null)
              Text(
                txAmountDisplay(
                    _type, transaction.nativeAmount!, transaction.currencyCode ?? 'BAM'),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: typeColor),
              ),
          ],
        ),
      ),
    );
  }
}
