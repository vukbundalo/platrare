import 'package:flutter/material.dart';

/// Stacks a small “scroll to top” [FloatingActionButton.small] above [mainFab]
/// when [showScrollToTop] is true. Use distinct [scrollHeroTag] per screen.
class StackedScrollFab extends StatelessWidget {
  final bool showScrollToTop;
  final VoidCallback onScrollToTop;
  final String scrollToTopTooltip;
  final String scrollHeroTag;
  final Widget mainFab;

  const StackedScrollFab({
    super.key,
    required this.showScrollToTop,
    required this.onScrollToTop,
    required this.scrollToTopTooltip,
    required this.scrollHeroTag,
    required this.mainFab,
  });

  @override
  Widget build(BuildContext context) {
    if (!showScrollToTop) return mainFab;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: scrollHeroTag,
          onPressed: onScrollToTop,
          tooltip: scrollToTopTooltip,
          child: const Icon(Icons.vertical_align_top_rounded),
        ),
        const SizedBox(height: 12),
        mainFab,
      ],
    );
  }
}
