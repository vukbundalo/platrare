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
  /// When true, the account filter strip is expanded (chip appears selected).
  final bool accountPanelOpen;
  /// When true, the category filter strip is expanded.
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
    final brightness = Theme.of(context).brightness;
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
          decoration: HeroFilterChipStyle.decoration(
            cs,
            brightness,
            selected: active,
          ),
          child: Icon(
            icon,
            size: 15,
            color: HeroFilterChipStyle.foreground(cs, selected: active),
          ),
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
          decoration: HeroFilterChipStyle.decoration(
            cs,
            brightness,
            selected: active,
          ),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: letter == null
                  ? Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color:
                          HeroFilterChipStyle.foreground(cs, selected: active),
                    )
                  : letter == '∞'
                      ? Icon(
                          Icons.all_inclusive_rounded,
                          size: 16,
                          color: HeroFilterChipStyle.foreground(
                              cs, selected: active),
                        )
                      : Text(
                          letter,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: HeroFilterChipStyle.foreground(
                                cs, selected: active),
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
                active: accountFilter != null || accountPanelOpen,
                onTap: onToggleAccountPanel,
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
                          decoration: HeroFilterChipStyle.decoration(
                            cs,
                            brightness,
                            selected: false,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 15,
                            color:
                                HeroFilterChipStyle.foreground(cs, selected: false),
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
          active: categoryFilter != null || categoryPanelOpen,
          onTap: onToggleCategoryPanel,
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
    final brightness = Theme.of(context).brightness;
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: enabled
            ? HeroFilterChipStyle.decoration(
                cs,
                brightness,
                selected: false,
                borderRadius: BorderRadius.circular(8),
              )
            : BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
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
  final brightness = Theme.of(context).brightness;
  const padH = 12.0;
  final style = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: HeroFilterChipStyle.foreground(cs, selected: selected),
    height: 1.1,
  );
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
        decoration: HeroFilterChipStyle.decoration(
          cs,
          brightness,
          selected: selected,
          borderRadius: radius,
        ),
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
  final bool showAccountSection;
  final bool showCategorySection;
  final List<Account> accounts;
  final Account? accountFilter;
  final void Function(Account?) onAccountFilter;
  final List<String> categories;
  final String? categoryFilter;
  final void Function(String?) onCategoryFilter;

  const TrackPlanFilterStrip({
    super.key,
    required this.showAccountSection,
    required this.showCategorySection,
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

    final children = <Widget>[];
    if (showAccountSection) {
      children.add(accountSection());
    }
    if (showAccountSection && showCategorySection) {
      children.add(const SizedBox(height: 8));
    }
    if (showCategorySection) {
      children.add(categorySection());
    }
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

/// Placed below a day-group card so rows keep full width; toggles projection/history panels.
class TrackPlanDayDetailExpandBar extends StatelessWidget {
  const TrackPlanDayDetailExpandBar({
    super.key,
    required this.expanded,
    required this.onTap,
    required this.semanticsLabelExpanded,
    required this.semanticsLabelCollapsed,
  });

  final bool expanded;
  final VoidCallback onTap;
  final String semanticsLabelExpanded;
  final String semanticsLabelCollapsed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      child: Material(
        color: Colors.transparent,
        child: Semantics(
          label: expanded ? semanticsLabelExpanded : semanticsLabelCollapsed,
          button: true,
          expanded: expanded,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 28,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.65),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
