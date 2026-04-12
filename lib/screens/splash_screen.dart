import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Full-screen branded splash shown on cold start.
///
/// Design language: flat brand-primary blue (#1A56DB), single white delta (Δ)
/// mark, Inter 800 wordmark. No decoration beyond that.
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => FadeTransition(
          opacity: _exitFade,
          child: _SplashBody(
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
    required this.contentFade,
    required this.contentSlide,
    required this.loaderFade,
  });

  final Animation<double> contentFade;
  final double contentSlide;
  final Animation<double> loaderFade;

  // The exact brand seed used in platrare_theme.dart.
  static const Color _bg = Color(0xFF1A56DB);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Upper breathing room: ~38% of available height
            const Spacer(flex: 38),

            // ── Logo mark ──
            FadeTransition(
              opacity: contentFade,
              child: Transform.translate(
                offset: Offset(0, contentSlide),
                child: const _LogoMark(),
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
                    color: Colors.white,
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
                    Colors.white.withValues(alpha: 0.38),
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

// ---------------------------------------------------------------------------
// Logo mark — frosted glass tile + white delta (Δ)
// ---------------------------------------------------------------------------

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        // Frosted glass feel: white at very low opacity over the brand blue
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 1.5,
        ),
        boxShadow: [
          // Inner-facing shadow: deeper blue — gives tile depth without noise
          BoxShadow(
            color: const Color(0xFF0E35A0).withValues(alpha: 0.50),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(50, 50),
          painter: _DeltaPainter(),
        ),
      ),
    );
  }
}

/// Draws a clean, filled, upward-pointing equilateral delta (Δ) with
/// softly rounded corners. One shape. Maximum clarity.
class _DeltaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Three vertices: apex at top-center, base-right, base-left.
    // Nudge apex slightly above true equilateral for optical balance.
    final vertices = <Offset>[
      Offset(size.width * 0.500, size.height * 0.055), // apex
      Offset(size.width * 0.965, size.height * 0.930), // base-right
      Offset(size.width * 0.035, size.height * 0.930), // base-left
    ];

    canvas.drawPath(_roundedPolygon(vertices, 5.5), paint);
  }

  /// Builds a Path for a convex polygon with rounded corners of radius [r].
  Path _roundedPolygon(List<Offset> verts, double r) {
    final n = verts.length;
    final path = Path();

    for (int i = 0; i < n; i++) {
      final prev = verts[(i - 1 + n) % n];
      final curr = verts[i];
      final next = verts[(i + 1) % n];

      final toPrev = prev - curr;
      final toNext = next - curr;

      // Points at distance r from the vertex along each adjacent edge
      final p1 = curr + toPrev / toPrev.distance * r;
      final p2 = curr + toNext / toNext.distance * r;

      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      // Round the corner with a quadratic bezier through the vertex
      path.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
