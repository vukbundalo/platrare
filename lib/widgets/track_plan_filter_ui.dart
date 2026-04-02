import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/account.dart';

/// Shared by Track and Plan: account/category strip + main chip row.
enum TrackPlanFilterPanel { none, account, category }

// ─── Main filter chip row (matches Track hero bottom row) ─────────────────────

class TrackPlanFilterChipRow extends StatelessWidget {
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
  /// When false (Track), filled chip when oldest-first. When true (Plan), filled
  /// only when newest-first so default oldest-first + arrow up stays neutral.
  final bool invertSortChipActive;
  /// When false, chips stay visible but do not respond (e.g. Plan future snapshot).
  final bool enabled;

  const TrackPlanFilterChipRow({
    super.key,
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
    this.invertSortChipActive = false,
    this.enabled = true,
  });

  IconData _typeMainIcon() {
    if (typeFilter == null) return Icons.filter_list_rounded;
    if (typeFilter == 'income') return Icons.south_west_rounded;
    if (typeFilter == 'expense') return Icons.north_east_rounded;
    return Icons.swap_horiz_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget mainChip({
      required IconData icon,
      required bool active,
      required VoidCallback onTap,
      String? semanticsLabel,
    }) {
      final chip = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
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
      return Expanded(
        child: semanticsLabel == null
            ? chip
            : Semantics(
                label: semanticsLabel,
                button: true,
                child: chip,
              ),
      );
    }

    Widget mainDateChip() {
      final active = dateFilterActive;
      final letter = dateModeLetter;
      final chip = GestureDetector(
        onTap: onCycleDate,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: letter != null
              ? Text(
                  letter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: active ? cs.primary : cs.onSurfaceVariant,
                  ),
                )
              : Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: active ? cs.primary : cs.onSurfaceVariant,
                ),
        ),
      );
      final semantics = letter != null
          ? 'Date: ${letter == 'M' ? 'month' : letter == 'W' ? 'week' : 'year'} — tap to change mode'
          : 'Date: this month — tap for month, week, or year mode';
      return Expanded(
        child: Semantics(
          label: semantics,
          button: true,
          child: chip,
        ),
      );
    }

    final row = Row(
      children: [
        mainChip(
          icon: _typeMainIcon(),
          active: typeFilter != null,
          onTap: onCycleType,
          semanticsLabel:
              'Transaction type: cycle all, income, expense, transfer',
        ),
        const SizedBox(width: 6),
        mainDateChip(),
        const SizedBox(width: 6),
        mainChip(
          icon: Icons.account_balance_wallet_outlined,
          active: accountFilter != null ||
              panel == TrackPlanFilterPanel.account,
          onTap: () => onTogglePanel(TrackPlanFilterPanel.account),
          semanticsLabel: 'Account filter',
        ),
        const SizedBox(width: 6),
        mainChip(
          icon: Icons.label_outline_rounded,
          active: categoryFilter != null ||
              panel == TrackPlanFilterPanel.category,
          onTap: () => onTogglePanel(TrackPlanFilterPanel.category),
          semanticsLabel: 'Category filter',
        ),
        const SizedBox(width: 6),
        mainChip(
          icon: newestFirst
              ? Icons.arrow_downward_rounded
              : Icons.arrow_upward_rounded,
          active: invertSortChipActive ? newestFirst : !newestFirst,
          onTap: onToggleSort,
          semanticsLabel: 'Sort: toggle newest or oldest first',
        ),
      ],
    );

    if (!enabled) {
      return Semantics(
        enabled: false,
        label:
            'List filters disabled while viewing a future projection date. Clear projections to use filters.',
        child: Opacity(
          opacity: 0.5,
          child: IgnorePointer(
            child: ExcludeSemantics(child: row),
          ),
        ),
      );
    }
    return row;
  }
}

// ─── Date nav (arrows only; label not interactive) ───────────────────────────

class TrackPlanDateNavBar extends StatelessWidget {
  final String label;
  final VoidCallback onNavigateBack;
  final VoidCallback? onNavigateForward;

  const TrackPlanDateNavBar({
    super.key,
    required this.label,
    required this.onNavigateBack,
    required this.onNavigateForward,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        TrackPlanNavButton(
          icon: Icons.chevron_left_rounded,
          onTap: onNavigateBack,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
        TrackPlanNavButton(
          icon: Icons.chevron_right_rounded,
          onTap: onNavigateForward,
        ),
      ],
    );
  }
}

class TrackPlanNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const TrackPlanNavButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

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
          color: enabled
              ? cs.primary
              : cs.onSurfaceVariant.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

// ─── Account / category pills ───────────────────────────────────────────────

const kTrackPlanChipTextSlop = 5.0;

Widget trackPlanNamePill(
  BuildContext context, {
  required String label,
  required bool selected,
  required VoidCallback onTap,
  required double stripMaxWidth,
  String? semanticsLabel,
}) {
  final cs = Theme.of(context).colorScheme;
  const padH = 12.0;
  final style = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: selected ? cs.primary : cs.onSurfaceVariant,
    height: 1.1,
  );
  final fill = selected
      ? cs.primary.withValues(alpha: 0.15)
      : cs.primaryContainer.withValues(alpha: 0.5);
  final radius = BorderRadius.circular(20);

  final oneLine = TextPainter(
    text: TextSpan(text: label, style: style),
    maxLines: 1,
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout(maxWidth: double.infinity);

  final chipWOneLine =
      oneLine.width.ceilToDouble() + 2 * padH + kTrackPlanChipTextSlop;
  final fitsOneLine = chipWOneLine <= stripMaxWidth;

  late final Widget inner;
  if (fitsOneLine) {
    inner = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: math.max(36.0, chipWOneLine),
        height: 30,
        child: DecoratedBox(
          decoration: BoxDecoration(color: fill, borderRadius: radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: padH),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: style,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  } else {
    inner = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: stripMaxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(color: fill, borderRadius: radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: padH, vertical: 7),
            child: Text(
              label,
              style: style,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  if (semanticsLabel == null) return inner;
  return Semantics(
    label: semanticsLabel,
    button: true,
    selected: selected,
    child: inner,
  );
}

class TrackPlanFilterStrip extends StatelessWidget {
  final TrackPlanFilterPanel panel;
  final List<Account> accounts;
  final Account? accountFilter;
  final void Function(Account?) onAccountFilter;
  final List<String> categories;
  final String? categoryFilter;
  final void Function(String?) onCategoryFilter;

  const TrackPlanFilterStrip({
    super.key,
    required this.panel,
    required this.accounts,
    required this.accountFilter,
    required this.onAccountFilter,
    required this.categories,
    required this.categoryFilter,
    required this.onCategoryFilter,
  });

  @override
  Widget build(BuildContext context) {
    final accountsSorted = List<Account>.from(accounts)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    Widget accountSection() {
      return LayoutBuilder(
        builder: (context, c) {
          final stripW = c.maxWidth;
          return Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              trackPlanNamePill(
                context,
                label: 'All',
                selected: accountFilter == null,
                stripMaxWidth: stripW,
                onTap: () => onAccountFilter(null),
                semanticsLabel: 'All accounts',
              ),
              for (final a in accountsSorted)
                trackPlanNamePill(
                  context,
                  label: a.name,
                  selected: accountFilter?.id == a.id,
                  stripMaxWidth: stripW,
                  onTap: () {
                    if (accountFilter?.id == a.id) {
                      onAccountFilter(null);
                    } else {
                      onAccountFilter(a);
                    }
                  },
                  semanticsLabel: a.name,
                ),
            ],
          );
        },
      );
    }

    Widget categorySection() {
      return LayoutBuilder(
        builder: (context, c) {
          final stripW = c.maxWidth;
          return Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              trackPlanNamePill(
                context,
                label: 'All',
                selected: categoryFilter == null,
                stripMaxWidth: stripW,
                onTap: () => onCategoryFilter(null),
                semanticsLabel: 'All categories',
              ),
              for (final cat in categories)
                trackPlanNamePill(
                  context,
                  label: cat,
                  selected: categoryFilter == cat,
                  stripMaxWidth: stripW,
                  onTap: () {
                    if (categoryFilter == cat) {
                      onCategoryFilter(null);
                    } else {
                      onCategoryFilter(cat);
                    }
                  },
                  semanticsLabel: cat,
                ),
            ],
          );
        },
      );
    }

    return switch (panel) {
      TrackPlanFilterPanel.account => accountSection(),
      TrackPlanFilterPanel.category => categorySection(),
      TrackPlanFilterPanel.none => const SizedBox.shrink(),
    };
  }
}
