import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../data/account_lifecycle.dart' show compareAccountsStorageOrder;
import '../models/account.dart';
import '../utils/account_display.dart';
import '../utils/app_format.dart';
import 'app_hero_layout.dart';

/// Shared by Track and Plan: account/category strip + main chip row.
enum TrackPlanFilterPanel { none, account, category }

String _semanticsDateModeWord(AppLocalizations l10n, String letter) {
  return switch (letter) {
    'M' => l10n.repeatMonthly,
    'W' => l10n.repeatWeekly,
    'Y' => l10n.repeatYearly,
    _ => l10n.repeatYearly,
  };
}

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

  /// Screen reader label when [enabled] is false. Defaults to [AppLocalizations.semanticsFiltersDisabled].
  final String? disabledSemanticsLabel;

  /// When false, the wallet chip is shown muted and non-interactive (single-account views).
  final bool accountChipEnabled;

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
    this.disabledSemanticsLabel,
    this.accountChipEnabled = true,
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
    final l10n = AppLocalizations.of(context);

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
          height: AppHeroConstants.filterChipHeight,
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
          height: AppHeroConstants.filterChipHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? cs.primary.withValues(alpha: 0.15)
                : cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: letter == null
                  ? Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: active ? cs.primary : cs.onSurfaceVariant,
                    )
                  : letter == '∞'
                      ? Icon(
                          Icons.all_inclusive_rounded,
                          size: 16,
                          color: active ? cs.primary : cs.onSurfaceVariant,
                        )
                      : Text(
                          letter,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: active ? cs.primary : cs.onSurfaceVariant,
                          ),
                        ),
            ),
          ),
        ),
      );
      final semantics = letter != null
          ? letter == '∞'
              ? l10n.semanticsDateAllTime
              : l10n.semanticsDateMode(_semanticsDateModeWord(l10n, letter))
          : l10n.semanticsDateThisMonth;
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
          semanticsLabel: l10n.semanticsTxTypeCycle,
        ),
        const SizedBox(width: 6),
        mainDateChip(),
        const SizedBox(width: 6),
        accountChipEnabled
            ? mainChip(
                icon: Icons.account_balance_wallet_outlined,
                active: accountFilter != null ||
                    panel == TrackPlanFilterPanel.account,
                onTap: () => onTogglePanel(TrackPlanFilterPanel.account),
                semanticsLabel: l10n.semanticsAccountFilter,
              )
            : Expanded(
                child: Tooltip(
                  message: l10n.semanticsAlreadyFiltered,
                  child: Opacity(
                    opacity: 0.45,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: Container(
                          height: AppHeroConstants.filterChipHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                cs.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 15,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        const SizedBox(width: 6),
        mainChip(
          icon: Icons.label_outline_rounded,
          active: categoryFilter != null ||
              panel == TrackPlanFilterPanel.category,
          onTap: () => onTogglePanel(TrackPlanFilterPanel.category),
          semanticsLabel: l10n.semanticsCategoryFilter,
        ),
        const SizedBox(width: 6),
        mainChip(
          icon: newestFirst
              ? Icons.arrow_downward_rounded
              : Icons.arrow_upward_rounded,
          active: invertSortChipActive ? newestFirst : !newestFirst,
          onTap: onToggleSort,
          semanticsLabel: l10n.semanticsSortToggle,
        ),
      ],
    );

    if (!enabled) {
      return Semantics(
        enabled: false,
        label: disabledSemanticsLabel ?? l10n.semanticsFiltersDisabled,
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

/// Max width per pill in horizontal strips (matches Review compare chips).
const kTrackPlanFilterStripChipMaxWidth = 220.0;


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
  final chipW =
      math.min(stripMaxWidth, math.max(36.0, chipWOneLine));

  final inner = GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: SizedBox(
      width: chipW,
      height: AppHeroConstants.filterChipHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(color: fill, borderRadius: radius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padH),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );

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
    final l10n = AppLocalizations.of(context);
    final accountsSorted = List<Account>.from(accounts)
      ..sort(compareAccountsStorageOrder);

    Widget accountSection() {
      final items = <Widget>[
        trackPlanNamePill(
          context,
          label: l10n.filterAll,
          selected: accountFilter == null,
          stripMaxWidth: kTrackPlanFilterStripChipMaxWidth,
          onTap: () => onAccountFilter(null),
          semanticsLabel: l10n.filterAllAccounts,
        ),
        ...accountsSorted.map(
          (a) => trackPlanNamePill(
            context,
            label: accountDisplayName(a),
            selected: accountFilter?.id == a.id,
            stripMaxWidth: kTrackPlanFilterStripChipMaxWidth,
            onTap: () {
              if (accountFilter?.id == a.id) {
                onAccountFilter(null);
              } else {
                onAccountFilter(a);
              }
            },
            semanticsLabel: accountDisplayName(a),
          ),
        ),
      ];
      return SizedBox(
        height: AppHeroConstants.filterChipHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) =>
              Center(child: items[index]),
        ),
      );
    }

    Widget categorySection() {
      final items = <Widget>[
        trackPlanNamePill(
          context,
          label: l10n.filterAll,
          selected: categoryFilter == null,
          stripMaxWidth: kTrackPlanFilterStripChipMaxWidth,
          onTap: () => onCategoryFilter(null),
          semanticsLabel: l10n.filterAllCategories,
        ),
        ...categories.map(
          (cat) {
            final catLabel = l10nCategoryName(context, cat);
            return trackPlanNamePill(
              context,
              label: catLabel,
              selected: categoryFilter == cat,
              stripMaxWidth: kTrackPlanFilterStripChipMaxWidth,
              onTap: () {
                if (categoryFilter == cat) {
                  onCategoryFilter(null);
                } else {
                  onCategoryFilter(cat);
                }
              },
              semanticsLabel: catLabel,
            );
          },
        ),
      ];
      return SizedBox(
        height: AppHeroConstants.filterChipHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) =>
              Center(child: items[index]),
        ),
      );
    }

    return switch (panel) {
      TrackPlanFilterPanel.account => accountSection(),
      TrackPlanFilterPanel.category => categorySection(),
      TrackPlanFilterPanel.none => const SizedBox.shrink(),
    };
  }
}
