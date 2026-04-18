import 'package:flutter/material.dart';
import 'platrare_theme.dart';

/// Surfaces for light and dark mode.
///
/// Light mode keeps the subtle blue-forward gradient feel anchored to the
/// three brand colors (navy / primary-blue / highlight-blue).
/// Dark mode uses flat, neutral surfaces — no gradients, no blue wash.
abstract final class PlatrareSurfaces {
  static const double _heroRadius = 18;

  /// Full main shell behind tabs.
  static BoxDecoration scaffoldShell(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.28, 1.0],
          colors: [
            Color.alphaBlend(
              PlatrareColors.primary.withValues(alpha: 0.07),
              cs.surface,
            ),
            Color.alphaBlend(
              PlatrareColors.primary.withValues(alpha: 0.03),
              cs.surface,
            ),
            cs.surface,
          ],
        ),
      );
    }
    return BoxDecoration(color: cs.surface);
  }

  /// Bottom navigation bar decoration.
  static BoxDecoration bottomBarDecoration(
    ColorScheme cs,
    Brightness brightness, {
    required BorderSide topBorder,
  }) {
    if (brightness == Brightness.light) {
      final mist = Color.alphaBlend(
        PlatrareColors.primary.withValues(alpha: 0.055),
        cs.surface,
      );
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.35, 1.0],
          colors: [mist, cs.surface, cs.surface],
        ),
        border: Border(top: topBorder),
      );
    }
    return BoxDecoration(
      color: cs.surface,
      border: Border(top: topBorder),
    );
  }

  /// Track / Plan / Review / account history summary card.
  static BoxDecoration heroSummaryCard(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              PlatrareColors.primary.withValues(alpha: 0.15),
              cs.surfaceContainerHigh,
            ),
            Color.alphaBlend(
              PlatrareColors.highlight.withValues(alpha: 0.06),
              cs.surfaceContainerLow,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(_heroRadius),
        border: Border.all(
          color: PlatrareColors.primary.withValues(alpha: 0.22),
        ),
      );
    }
    // Dark: flat elevated surface, clear border, no blue wash.
    return BoxDecoration(
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(_heroRadius),
      border: Border.all(
        color: cs.outlineVariant.withValues(alpha: 0.40),
      ),
    );
  }

  /// App lock backdrop.
  static BoxDecoration lockBackdrop(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            Color.alphaBlend(
              PlatrareColors.navy.withValues(alpha: 0.12),
              cs.surface,
            ),
            Color.alphaBlend(
              PlatrareColors.primary.withValues(alpha: 0.06),
              cs.surface,
            ),
            cs.surface,
          ],
        ),
      );
    }
    return BoxDecoration(color: cs.surface);
  }

  /// Shell for pushed routes (settings, forms, etc.).
  static BoxDecoration routeShell(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.18, 1.0],
          colors: [
            Color.alphaBlend(
              PlatrareColors.primary.withValues(alpha: 0.05),
              cs.surface,
            ),
            cs.surface,
            cs.surface,
          ],
        ),
      );
    }
    return BoxDecoration(color: cs.surface);
  }
}
