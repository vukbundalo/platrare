import 'package:flutter/material.dart';

/// Shared metrics for Track / Plan / Review hero cards so top cards align in size
/// and the vertical divider sits on the same horizontal split.
abstract final class AppHeroConstants {
  /// [SliverAppBar.expandedHeight] for Plan / Track / Review and account history.
  static const double mainSliverAppBarExpandedHeight = 210;

  /// [FlexibleSpaceBar.background] padding around the hero card.
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

/// Neutral elevated surface for summary heroes (Track / Plan / Review / account
/// history). Amounts keep [LedgerColors] positive/negative; the card chrome does
/// not tint green/red from net or balance (institutional clarity).
abstract final class AppHeroChrome {
  static const double _radius = 18;

  static BoxDecoration cardDecoration(ColorScheme cs, Brightness brightness) {
    final base = cs.surfaceContainerHigh;
    final tint = brightness == Brightness.dark
        ? cs.primary.withValues(alpha: 0.10)
        : cs.primary.withValues(alpha: 0.042);
    return BoxDecoration(
      color: Color.alphaBlend(tint, base),
      borderRadius: BorderRadius.circular(_radius),
      border: Border.all(
        color: cs.outlineVariant.withValues(
          alpha: brightness == Brightness.dark ? 0.55 : 0.72,
        ),
      ),
    );
  }

  static Color metricsDividerColor(ColorScheme cs, Brightness brightness) =>
      cs.outlineVariant.withValues(
        alpha: brightness == Brightness.dark ? 0.50 : 0.62,
      );
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
