import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// One step of a screen help tour.
///
/// [targetKey] points at the widget to spotlight. When null — or when the
/// target is not built right now (e.g. a FAB hidden on an empty screen) — the
/// step shows as a centered card without a spotlight, or is dropped entirely
/// if [requiresTarget] is true.
class HelpStep {
  const HelpStep({
    required this.title,
    required this.body,
    this.targetKey,
    this.requiresTarget = true,
  });

  final String title;
  final String body;
  final GlobalKey? targetKey;

  /// Drop the step (instead of showing it centered) when [targetKey] is set
  /// but its widget is not currently in the tree.
  final bool requiresTarget;
}

/// "?" app-bar button that starts the spotlight tour for the current screen.
///
/// [steps] is resolved lazily at tap time so it can read localized strings and
/// so target keys reflect what is actually on screen.
class HelpTourButton extends StatelessWidget {
  const HelpTourButton({super.key, required this.steps});

  final List<HelpStep> Function() steps;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline_rounded),
      tooltip: AppLocalizations.of(context).helpTooltip,
      onPressed: () => showHelpTour(context, steps()),
    );
  }
}

/// Shows a spotlight walkthrough over the current screen.
///
/// Uses the root navigator so the scrim covers the bottom navigation bar and
/// any FABs; the hardware back button dismisses the tour.
Future<void> showHelpTour(BuildContext context, List<HelpStep> steps) {
  final visibleSteps = steps
      .where((s) =>
          s.targetKey == null ||
          !s.requiresTarget ||
          s.targetKey!.currentContext != null)
      .toList();
  if (visibleSteps.isEmpty) return Future.value();
  return showGeneralDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => _HelpTourOverlay(steps: visibleSteps),
    transitionBuilder: (context, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
  );
}

class _HelpTourOverlay extends StatefulWidget {
  const _HelpTourOverlay({required this.steps});

  final List<HelpStep> steps;

  @override
  State<_HelpTourOverlay> createState() => _HelpTourOverlayState();
}

class _HelpTourOverlayState extends State<_HelpTourOverlay> {
  int _index = 0;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    // Targets are measured after the first overlay frame so the spotlight
    // grows out from the scrim instead of popping in.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _targetRect = _measure(_index));
    });
  }

  Rect? _measure(int index) {
    final ctx = widget.steps[index].targetKey?.currentContext;
    final box = ctx?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _goTo(int index) async {
    if (index < 0) return;
    if (index >= widget.steps.length) {
      Navigator.of(context).pop();
      return;
    }
    final ctx = widget.steps[index].targetKey?.currentContext;
    if (ctx != null) {
      // Bring scrollable targets (e.g. Settings sections) into view first.
      try {
        await Scrollable.ensureVisible(
          ctx,
          alignment: 0.4,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        // Pinned headers / non-scrollable targets: measure where they are.
      }
    }
    if (!mounted) return;
    setState(() {
      _index = index;
      _targetRect = _measure(index);
    });
  }

  void _next() => _goTo(_index + 1);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final safe = MediaQuery.paddingOf(context);
    final step = widget.steps[_index];
    final rect = _targetRect;
    final isLast = _index == widget.steps.length - 1;

    // Collapsed hole in the screen center for steps without a target.
    final holeTarget = rect ??
        Rect.fromCenter(
            center: size.center(Offset.zero), width: 0, height: 0);

    // Card above or below the spotlight, centered when there is none.
    final EdgeInsets cardInsets;
    final Alignment cardAlignment;
    if (rect == null) {
      cardInsets = EdgeInsets.fromLTRB(
          20, safe.top + 20, 20, safe.bottom + 20);
      cardAlignment = Alignment.center;
    } else if (rect.center.dy < size.height / 2) {
      cardInsets = EdgeInsets.fromLTRB(
          20, rect.bottom + 24, 20, safe.bottom + 20);
      cardAlignment = Alignment.topCenter;
    } else {
      cardInsets = EdgeInsets.fromLTRB(
          20, safe.top + 20, 20, size.height - rect.top + 24);
      cardAlignment = Alignment.bottomCenter;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _next,
      child: Stack(
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder<Rect?>(
              tween: RectTween(end: holeTarget),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutCubic,
              builder: (context, hole, _) => CustomPaint(
                painter: _SpotlightPainter(
                  hole: hole,
                  scrimColor: Colors.black.withValues(alpha: 0.72),
                  borderColor: cs.primary.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedPadding(
              padding: cardInsets,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutCubic,
              child: Align(
                alignment: cardAlignment,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _HelpCard(
                    key: ValueKey(_index),
                    step: step,
                    index: _index,
                    count: widget.steps.length,
                    nextLabel: isLast ? l10n.helpDone : l10n.helpNext,
                    backLabel: l10n.helpBack,
                    skipLabel: l10n.helpSkip,
                    showSkip: !isLast,
                    showBack: _index > 0,
                    onSkip: () => Navigator.of(context).pop(),
                    onBack: () => _goTo(_index - 1),
                    onNext: _next,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    super.key,
    required this.step,
    required this.index,
    required this.count,
    required this.nextLabel,
    required this.backLabel,
    required this.skipLabel,
    required this.showSkip,
    required this.showBack,
    required this.onSkip,
    required this.onBack,
    required this.onNext,
  });

  final HelpStep step;
  final int index;
  final int count;
  final String nextLabel;
  final String backLabel;
  final String skipLabel;
  final bool showSkip;
  final bool showBack;
  final VoidCallback onSkip;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      // Absorb taps so touching the card doesn't advance the tour.
      onTap: () {},
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Material(
          color: cs.surface,
          elevation: 6,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var i = 0; i < count; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsetsDirectional.only(end: 5),
                        width: i == index ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == index
                              ? cs.primary
                              : cs.outlineVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  step.title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  step.body,
                  style: textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (showSkip)
                      TextButton(
                        onPressed: onSkip,
                        child: Text(skipLabel),
                      ),
                    const Spacer(),
                    if (showBack)
                      TextButton(
                        onPressed: onBack,
                        child: Text(backLabel),
                      ),
                    const SizedBox(width: 4),
                    FilledButton(
                      onPressed: onNext,
                      child: Text(nextLabel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter({
    required this.hole,
    required this.scrimColor,
    required this.borderColor,
  });

  final Rect? hole;
  final Color scrimColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Paint()..color = scrimColor;
    final h = hole;
    if (h == null || h.width < 4 || h.height < 4) {
      canvas.drawRect(Offset.zero & size, scrim);
      return;
    }
    final rrect = RRect.fromRectAndRadius(
      h.inflate(6),
      const Radius.circular(16),
    );
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRRect(rrect),
    );
    canvas.drawPath(path, scrim);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      old.hole != hole ||
      old.scrimColor != scrimColor ||
      old.borderColor != borderColor;
}
