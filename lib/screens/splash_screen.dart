import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Cold-start overlay that matches the **native** launch screen pixel-for-pixel
/// in layout: solid fill + centered [splash_logo] only (same as iOS
/// `LaunchScreen.storyboard` + Android `launch_background`).
///
/// - Light: storyboard sRGB `rgb(0.949, 0.961, 0.976)` → `#F2F5F9` (see
///   `values/colors.xml` `platrare_splash`).
/// - Dark: `values-night` `platrare_splash` `#0F1419`.
/// - Logo: 220×220 logical points — matches `LaunchScreen` LaunchImage slot.
///
/// Asset: [assets/branding/splash_logo.png]. Native bitmaps:
/// `bash tool/sync_splash_assets.sh`. No SafeArea — centered in full view like
/// native.
///
/// [onComplete] runs after a short exit fade so handoff to [HomePage] has no
/// hard cut.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Same duration feel as before; only the tail is used for exit fade.
  static const _totalDuration = Duration(milliseconds: 2200);

  late final AnimationController _ctrl;

  /// Fades the whole layer out only at the very end (native has no fade-in).
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: _totalDuration);

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.82, 1.0, curve: Curves.easeInCubic),
      ),
    );

    _ctrl.forward().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => FadeTransition(
          opacity: _exitFade,
          child: const _SplashBody(),
        ),
      ),
    );
  }
}

/// iOS `LaunchScreen` uses 220×220 for LaunchImage; Android centers the same art.
const double _kSplashLogoLogical = 220;

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    // Must match native: Android `platrare_splash` / iOS storyboard fill.
    final Color bg;
    if (isLight) {
      // LaunchScreen.storyboard: red 0.949, green 0.961, blue 0.976
      bg = const Color.fromRGBO(242, 245, 249, 1);
    } else {
      bg = const Color(0xFF0F1419);
    }

    return ColoredBox(
      color: bg,
      child: Center(
        child: Image.asset(
          'assets/branding/splash_logo.png',
          width: _kSplashLogoLogical,
          height: _kSplashLogoLogical,
          filterQuality: FilterQuality.high,
          semanticLabel: 'Platrare',
        ),
      ),
    );
  }
}
