import 'package:flutter/material.dart';

import '../theme/platrare_surfaces.dart';

/// Shared metrics for Track / Plan / Review hero cards so top cards align in size
/// and the vertical divider sits on the same horizontal split.
abstract final class AppHeroConstants {
  /// [SliverAppBar.expandedHeight] for account history (still uses collapsing style).
  static const double mainSliverAppBarExpandedHeight = 210;

  /// Height of the pinned hero [SliverPersistentHeader] on Track / Plan / Review.
  /// Equals the old expanded area minus the toolbar height so cards appear identical.
  static const double heroHeaderExtent = mainSliverAppBarExpandedHeight - kToolbarHeight;

  /// Padding around the hero card (used by both the old FlexibleSpaceBar path
  /// and the new [HeroPinnedDelegate]).
  static const EdgeInsets mainFlexibleSpaceHeroOuterPadding =
      EdgeInsets.fromLTRB(16, 0, 16, 12);

  static const EdgeInsets cardPadding =
      EdgeInsets.fromLTRB(16, 10, 16, 10);
  static const double dividerHeight = 44;
  static const double dividerMarginH = 16;
  static const double chipGapBelowMetrics = 10;
  /// Hero filter row, Review stats row, Track/Plan strips — same tap height.
  static const double filterChipHeight = 30;
  static const int leftColumnFlex = 3;
  static const int rightColumnFlex = 2;

  /// Primary label line (In / Balance / projection date).
  static const double labelFontSize = 12;
  /// Large amount on the left.
  static const double primaryAmountFontSize = 26;
  /// Right column label (Out / Net).
  static const double secondaryLabelFontSize = 11;
  static const double secondaryAmountFontSize = 16;
  static const double labelToAmountGap = 2;
}

/// Summary heroes delegate to [PlatrareSurfaces.heroSummaryCard] (blue glass
/// gradient). Amounts keep [LedgerColors] semantics on the figures only.
abstract final class AppHeroChrome {
  static BoxDecoration cardDecoration(ColorScheme cs, Brightness brightness) =>
      PlatrareSurfaces.heroSummaryCard(cs, brightness);

  static Color metricsDividerColor(ColorScheme cs, Brightness brightness) =>
      Color.alphaBlend(
        cs.primary.withValues(
          alpha: brightness == Brightness.dark ? 0.14 : 0.09,
        ),
        cs.outlineVariant.withValues(
          alpha: brightness == Brightness.dark ? 0.52 : 0.64,
        ),
      );
}

/// [SliverPersistentHeaderDelegate] that pins the hero card at a fixed height.
///
/// The card is bottom-aligned to mirror the previous [FlexibleSpaceBar] layout
/// where the hero always sat at the bottom of the expanded area. A subtle
/// bottom shadow appears once content has scrolled underneath.
///
/// [showOverlapShadow]: when false, the bottom shadow is never drawn. Use this
/// for [NestedScrollView] headers where [overlapsContent] stays true because of
/// [SliverOverlapInjector] even when nothing has visibly scrolled under the hero.
class HeroPinnedDelegate extends SliverPersistentHeaderDelegate {
  const HeroPinnedDelegate({
    required this.child,
    this.showOverlapShadow = true,
  });
  final Widget child;
  final bool showOverlapShadow;

  @override
  double get minExtent => AppHeroConstants.heroHeaderExtent;

  @override
  double get maxExtent => AppHeroConstants.heroHeaderExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final cs = Theme.of(context).colorScheme;
    final drawOverlapShadow =
        showOverlapShadow && overlapsContent;
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: drawOverlapShadow
            ? [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : const [],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: AppHeroConstants.mainFlexibleSpaceHeroOuterPadding,
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(HeroPinnedDelegate old) =>
      old.child != child || old.showOverlapShadow != showOverlapShadow;
}

/// Filter icons in hero cards: [AppHeroChrome] backgrounds are primary-tinted
/// containers, so pills need a contrasting fill + outline (not faint
/// primaryContainer washes).
abstract final class HeroFilterChipStyle {
  static BoxDecoration decoration(
    ColorScheme cs,
    Brightness brightness, {
    required bool selected,
    BorderRadius? borderRadius,
  }) {
    final radius = borderRadius ?? BorderRadius.circular(20);
    final idleBorder = cs.outlineVariant.withValues(
      alpha: brightness == Brightness.dark ? 0.58 : 0.88,
    );
    if (selected) {
      return BoxDecoration(
        color: Color.alphaBlend(
          cs.primary.withValues(
            alpha: brightness == Brightness.dark ? 0.34 : 0.26,
          ),
          cs.surface,
        ),
        borderRadius: radius,
        border: Border.all(
          color: cs.primary.withValues(
            alpha: brightness == Brightness.dark ? 0.72 : 0.60,
          ),
        ),
      );
    }
    return BoxDecoration(
      color: cs.surface,
      borderRadius: radius,
      border: Border.all(color: idleBorder),
    );
  }

  /// Icon / label on hero filter pills.
  static Color foreground(ColorScheme cs, {required bool selected}) =>
      selected ? cs.primary : cs.onSurface.withValues(alpha: 0.72);
}

/// Two-column metrics row: [flex 3 | divider | flex 2], same on all main tabs.
class HeroTwoColumnMetricsRow extends StatelessWidget {
  final Widget leftColumn;
  final Widget rightColumn;
  final Color dividerColor;

  const HeroTwoColumnMetricsRow({
    super.key,
    required this.leftColumn,
    required this.rightColumn,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: AppHeroConstants.leftColumnFlex,
          child: Align(
            alignment: Alignment.centerLeft,
            child: leftColumn,
          ),
        ),
        Container(
          width: 1,
          height: AppHeroConstants.dividerHeight,
          margin: const EdgeInsets.symmetric(
            horizontal: AppHeroConstants.dividerMarginH,
          ),
          color: dividerColor,
        ),
        Expanded(
          flex: AppHeroConstants.rightColumnFlex,
          child: Align(
            alignment: Alignment.centerLeft,
            child: rightColumn,
          ),
        ),
      ],
    );
  }
}

/// Single-line currency/amount in hero metrics: scales down to fit column width
/// instead of wrapping to a second row.
class HeroFittedAmount extends StatelessWidget {
  const HeroFittedAmount({
    super.key,
    required this.text,
    required this.style,
    this.alignment = Alignment.centerLeft,
  });

  final String text;
  final TextStyle style;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (!w.isFinite || w <= 0) {
          return Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          );
        }
        return SizedBox(
          width: w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: alignment,
            child: Text(
              text,
              maxLines: 1,
              softWrap: false,
              style: style,
            ),
          ),
        );
      },
    );
  }
}
