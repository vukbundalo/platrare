import 'package:flutter/material.dart';

/// Shared metrics for Track / Plan / Review hero cards so top cards align in size
/// and the vertical divider sits on the same horizontal split.
abstract final class AppHeroConstants {
  /// [SliverAppBar.expandedHeight] for Plan / Track / Review and account history.
  /// Extra headroom keeps the hero below the title row on tall iOS toolbars and
  /// large phones without clipping the chip row.
  static const double mainSliverAppBarExpandedHeight = 236;

  /// [FlexibleSpaceBar.background] padding around the hero card. Non-zero top
  /// separates the card from the app bar title (avoids “stuck together” look).
  static const EdgeInsets mainFlexibleSpaceHeroOuterPadding =
      EdgeInsets.fromLTRB(16, 14, 16, 12);

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
