import 'package:flutter/material.dart';

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
