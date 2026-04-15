import 'package:flutter/material.dart';

/// Bottom space for scroll views whose [Scaffold] shows a floating action button
/// (e.g. [StackedScrollFab] with scroll-to-top + main FAB) so the last item is
/// not covered when scrolled to the end.
double stackedFabScrollBottomInset(BuildContext context) {
  final safe = MediaQuery.paddingOf(context).bottom;
  // Scaffold FAB margin + stacked column (small 40 + gap + regular 56) + clearance.
  const margin = 16.0;
  const smallFab = 40.0;
  const gap = 12.0;
  const mainFab = 56.0;
  const clearance = 12.0;
  return margin + smallFab + gap + mainFab + margin + clearance + safe;
}

/// [SnackBar.margin] for [SnackBarBehavior.floating] so the bar clears a
/// [StackedScrollFab] column (main Track / Plan FABs) instead of covering it.
EdgeInsets snackBarFloatingMarginAboveStackedFab(BuildContext context) {
  const horizontal = 16.0;
  return EdgeInsets.fromLTRB(
    horizontal,
    0,
    horizontal,
    stackedFabScrollBottomInset(context),
  );
}

/// Stacks a small “scroll to top” [FloatingActionButton.small] above [mainFab]
/// when [showScrollToTop] is true. Use distinct [scrollHeroTag] per screen.
///
/// When [mainFab] is null and [showScrollToTop] is true, only the small FAB is
/// shown (e.g. Review statistics with no reset/add FAB).
class StackedScrollFab extends StatelessWidget {
  final bool showScrollToTop;
  final VoidCallback onScrollToTop;
  final String scrollToTopTooltip;
  final String scrollHeroTag;
  final Widget? mainFab;

  const StackedScrollFab({
    super.key,
    required this.showScrollToTop,
    required this.onScrollToTop,
    required this.scrollToTopTooltip,
    required this.scrollHeroTag,
    this.mainFab,
  });

  @override
  Widget build(BuildContext context) {
    final smallFab = FloatingActionButton.small(
      heroTag: scrollHeroTag,
      onPressed: onScrollToTop,
      tooltip: scrollToTopTooltip,
      child: const Icon(Icons.vertical_align_top_rounded),
    );
    if (showScrollToTop) {
      if (mainFab == null) return smallFab;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          smallFab,
          const SizedBox(height: 12),
          mainFab!,
        ],
      );
    }
    return mainFab ?? const SizedBox.shrink();
  }
}
