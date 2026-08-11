import SwiftUI
import WidgetKit

enum WidgetTheme {
    /// PlatrareColors.primary — lib/theme/platrare_theme.dart.
    static let primary = Color(red: 0.184, green: 0.490, blue: 0.820)
    /// Ledger red used for negative positions in the app.
    static let negative = Color(red: 0.788, green: 0.243, blue: 0.243)

    /// Colour for a value, respecting the widget rendering mode.
    ///
    /// `.accented` (tinted home screen, iOS 18) and `.vibrant` (lock screen)
    /// flatten everything to a system-driven monochrome; applying brand colours
    /// there produces muddy, low-contrast results. In those modes the sign
    /// carries the meaning instead.
    static func valueColor(_ value: Double, mode: WidgetRenderingMode) -> Color {
        guard mode == .fullColor else { return .primary }
        return value < 0 ? negative : .primary
    }

    static func accentColor(_ mode: WidgetRenderingMode) -> Color {
        mode == .fullColor ? primary : .primary
    }
}

/// Sparkline over the projected series.
///
/// Deliberately unlabelled — at widget size the shape is the message, and the
/// exact figures are on the left half of the tile.
struct Sparkline: View {
    let values: [Double]
    let markerIndex: Int?
    let masked: Bool
    let mode: WidgetRenderingMode

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            if masked || values.count < 2 {
                // A flat bar rather than the real shape: the curve itself
                // leaks spending patterns even without numbers.
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.secondary.opacity(0.25))
                    .frame(height: 3)
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                let lo = values.min() ?? 0
                let hi = values.max() ?? 1
                let span = (hi - lo) == 0 ? 1 : (hi - lo)
                let pts: [CGPoint] = values.enumerated().map { idx, v in
                    CGPoint(
                        x: w * CGFloat(idx) / CGFloat(max(values.count - 1, 1)),
                        y: h - h * CGFloat((v - lo) / span)
                    )
                }

                ZStack {
                    // Zero line, only when the range actually crosses zero.
                    if lo < 0 && hi > 0 {
                        let zeroY = h - h * CGFloat((0 - lo) / span)
                        Path { p in
                            p.move(to: CGPoint(x: 0, y: zeroY))
                            p.addLine(to: CGPoint(x: w, y: zeroY))
                        }
                        .stroke(Color.secondary.opacity(0.35),
                                style: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                    }

                    Path { p in
                        guard let first = pts.first else { return }
                        p.move(to: first)
                        for pt in pts.dropFirst() { p.addLine(to: pt) }
                    }
                    .stroke(WidgetTheme.accentColor(mode),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                    if let m = markerIndex, m >= 0, m < pts.count {
                        Circle()
                            .fill(WidgetTheme.accentColor(mode))
                            .frame(width: 5, height: 5)
                            .position(pts[m])
                    }
                }
            }
        }
    }
}

/// Shown when there is no snapshot yet, or the ledger is empty.
struct WidgetEmptyState: View {
    /// Hardcoded because there is no snapshot to read localized strings from.
    var title: String = String(
        localized: "empty.title", defaultValue: "No accounts yet")
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(4)
    }
}
