import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/platrare_theme.dart';

/// Full-screen branded splash shown on cold start.
///
/// Logo: [assets/branding/splash_logo.png] — used here and on the native
/// launch layer (iOS LaunchImage, Android `drawable-nodpi/splash_center`).
/// Refresh native bitmaps after changing the PNG: `bash tool/sync_splash_assets.sh`.
/// Launcher icons stay in AppIcon / `@mipmap/platrare` (separate assets).
///
/// Light mode: [platrare_splash]-tint background, wordmark, brand-blue spinner.
/// Dark mode: dark splash background, white wordmark, highlight-blue spinner.
///
/// [onComplete] fires when the exit animation ends so the caller can remove
/// this widget from the tree.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // 0.00 – 0.38 : content fades + slides up
  late final Animation<double> _contentFade;
  late final Animation<double> _contentSlide;

  // 0.42 – 0.60 : spinner appears
  late final Animation<double> _loaderFade;

  // 0.76 – 1.00 : whole screen fades out
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _contentFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.38, curve: Curves.easeOut),
    );

    _contentSlide = Tween<double>(begin: 22.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    _loaderFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.42, 0.60, curve: Curves.easeIn),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.76, 1.0, curve: Curves.easeInCubic),
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
          child: _SplashBody(
            brightness: brightness,
            contentFade: _contentFade,
            contentSlide: _contentSlide.value,
            loaderFade: _loaderFade,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _SplashBody extends StatelessWidget {
  const _SplashBody({
    required this.brightness,
    required this.contentFade,
    required this.contentSlide,
    required this.loaderFade,
  });

  final Brightness brightness;
  final Animation<double> contentFade;
  final double contentSlide;
  final Animation<double> loaderFade;

  @override
  Widget build(BuildContext context) {
    final isLight = brightness == Brightness.light;
    // Align with Android `platrare_splash` / iOS launch background (#F2F5F9 / #0F1419).
    const lightSplash = Color(0xFFF2F5F9);
    const darkSplash = Color(0xFF0F1419);
    final bgColor = isLight ? lightSplash : darkSplash;
    final wordmarkColor = isLight ? PlatrareColors.navy : Colors.white;
    final spinnerColor =
        isLight ? PlatrareColors.primary : PlatrareColors.highlight;

    return ColoredBox(
      color: bgColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Upper breathing room: ~38% of available height
            const Spacer(flex: 38),

            // ── Splash mark (transparent RGBA PNG in assets/branding/) ──
            FadeTransition(
              opacity: contentFade,
              child: Transform.translate(
                offset: Offset(0, contentSlide),
                child: Image.asset(
                  'assets/branding/splash_logo.png',
                  width: 110,
                  height: 110,
                  filterQuality: FilterQuality.high,
                  semanticLabel: 'Platrare',
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Wordmark ──
            FadeTransition(
              opacity: contentFade,
              child: Transform.translate(
                offset: Offset(0, contentSlide),
                child: Text(
                  'Platrare',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: wordmarkColor,
                    letterSpacing: -1.5,
                  ),
                ),
              ),
            ),

            // ── Lower breathing room: ~50% of available height
            const Spacer(flex: 50),

            // ── Subtle spinner ──
            FadeTransition(
              opacity: loaderFade,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    spinnerColor.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 52),
          ],
        ),
      ),
    );
  }
}

