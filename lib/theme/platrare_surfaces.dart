import 'package:flutter/material.dart';

/// Subtle blue-forward surfaces and gradients for a stable, private, institutional
/// feel—never loud “crypto” gradients.
abstract final class PlatrareSurfaces {
  static const double _heroRadius = 18;

  /// Full main shell behind tabs: cool blue mist fading into the base surface.
  static BoxDecoration scaffoldShell(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.28, 1.0],
          colors: [
            Color.alphaBlend(cs.primary.withValues(alpha: 0.07), cs.surface),
            Color.alphaBlend(cs.primary.withValues(alpha: 0.03), cs.surface),
            cs.surface,
          ],
        ),
      );
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.5, 1.0],
        colors: [
          Color.alphaBlend(cs.primary.withValues(alpha: 0.16), cs.surface),
          Color.alphaBlend(cs.primary.withValues(alpha: 0.07), cs.surface),
          cs.surface,
        ],
      ),
    );
  }

  /// Bottom navigation: slight blue lift at the top edge, then solid surface.
  static BoxDecoration bottomBarDecoration(
    ColorScheme cs,
    Brightness brightness, {
    required BorderSide topBorder,
  }) {
    final mist = Color.alphaBlend(
      cs.primary.withValues(
        alpha: brightness == Brightness.light ? 0.055 : 0.11,
      ),
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

  /// Track / Plan / Review / account history summary card (“vault glass”).
  static BoxDecoration heroSummaryCard(ColorScheme cs, Brightness brightness) {
    final border = cs.outlineVariant.withValues(
      alpha: brightness == Brightness.dark ? 0.55 : 0.72,
    );
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              cs.primary.withValues(alpha: 0.13),
              cs.surfaceContainerHigh,
            ),
            Color.alphaBlend(
              cs.primary.withValues(alpha: 0.05),
              cs.surfaceContainerLow,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(_heroRadius),
        border: Border.all(color: border),
      );
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.alphaBlend(
            cs.primary.withValues(alpha: 0.22),
            cs.surfaceContainerHigh,
          ),
          Color.alphaBlend(
            cs.primary.withValues(alpha: 0.09),
            cs.surfaceContainerLow,
          ),
        ],
      ),
      borderRadius: BorderRadius.circular(_heroRadius),
      border: Border.all(color: border),
    );
  }

  /// App lock: slightly stronger blue veil (security / focus).
  static BoxDecoration lockBackdrop(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: [
            Color.alphaBlend(cs.primary.withValues(alpha: 0.18), cs.surface),
            Color.alphaBlend(cs.primary.withValues(alpha: 0.08), cs.surface),
            cs.surface,
          ],
        ),
      );
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.alphaBlend(cs.primary.withValues(alpha: 0.28), cs.surface),
          Color.alphaBlend(cs.primary.withValues(alpha: 0.12), cs.surface),
        ],
      ),
    );
  }

  /// Optional: full-screen shell for pushed routes (settings, forms, etc.).
  static BoxDecoration routeShell(ColorScheme cs, Brightness brightness) {
    if (brightness == Brightness.light) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.18, 1.0],
          colors: [
            Color.alphaBlend(cs.primary.withValues(alpha: 0.05), cs.surface),
            cs.surface,
            cs.surface,
          ],
        ),
      );
    }
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.alphaBlend(cs.primary.withValues(alpha: 0.12), cs.surface),
          cs.surface,
        ],
      ),
    );
  }
}
