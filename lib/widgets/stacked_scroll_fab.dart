import 'package:flutter/material.dart';

// Geometry shared by [stackedFabScrollBottomInset] and snack bar margins.
const _kFabEdgeMargin = 16.0;
const _kSmallFabSize = 40.0;
const _kFabStackGap = 12.0;
const _kMainFabSize = 56.0;
const _kScrollClearanceBelowFab = 12.0;

/// Bottom space for scroll views whose [Scaffold] shows a floating action button
/// (e.g. [StackedScrollFab] with scroll-to-top + main FAB) so the last item is
/// not covered when scrolled to the end.
double stackedFabScrollBottomInset(BuildContext context) {
  final safe = MediaQuery.paddingOf(context).bottom;
  return _kFabEdgeMargin +
      _kSmallFabSize +
      _kFabStackGap +
      _kMainFabSize +
      _kFabEdgeMargin +
      _kScrollClearanceBelowFab +
      safe;
}

/// Horizontal width reserved on the [AxisDirection.end] side for a stacked FAB
/// column (small + gap + main, or the wider reset row) plus the scaffold margin.
double stackedFabEndReservedWidth() {
  return _kFabEdgeMargin + _kSmallFabSize + _kFabStackGap + _kMainFabSize;
}

/// [SnackBar.margin] for [SnackBarBehavior.floating]: sits on the **same bottom
/// row** as [StackedScrollFab], uses most of the width on the start side, and
/// leaves the trailing end clear so FABs stay visible (not full-width over FAB).
EdgeInsetsGeometry snackBarFloatingMarginBesideStackedFab(
    BuildContext context) {
  final safe = MediaQuery.paddingOf(context).bottom;
  final bottom = _kFabEdgeMargin + safe;
  return EdgeInsetsDirectional.fromSTEB(
    _kFabEdgeMargin,
    0,
    stackedFabEndReservedWidth(),
    bottom,
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
