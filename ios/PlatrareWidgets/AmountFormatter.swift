import Foundation

/// Reproduces the app's amount formatting exactly.
///
/// The Dart formatter (`fx.formatNative`, lib/utils/fx.dart) is deliberately
/// locale-independent — `toStringAsFixed(digits)` + a space + the symbol — so
/// it can be mirrored arithmetically here. `Snapshot.formatSample` is the
/// tripwire: if the two ever diverge, callers fall back to the pre-formatted
/// strings the app ships in the payload.
enum AmountFormatter {

    static func format(_ value: Double, digits: Int, symbol: String) -> String {
        String(format: "%.\(digits)f", value) + " " + symbol
    }

    static func format(_ value: Double, snapshot: Snapshot) -> String {
        format(value, digits: snapshot.format.digits, symbol: snapshot.format.symbol)
    }

    /// True when this formatter still agrees with the app that produced the
    /// snapshot. False means fall back to `*Text` fields.
    static func matchesSample(_ snapshot: Snapshot) -> Bool {
        format(snapshot.formatSample.v, snapshot: snapshot) == snapshot.formatSample.text
    }

    /// Value string honouring the user's masking preference.
    static func display(_ value: Double, snapshot: Snapshot, preformatted: String? = nil) -> String {
        if snapshot.maskAmounts { return snapshot.maskPlaceholder }
        if let preformatted, !matchesSample(snapshot) { return preformatted }
        return format(value, snapshot: snapshot)
    }

    /// Compact form for the circular accessory family, where a full amount
    /// never fits: 12 345 -> "12.3k". Suffixes are localized in the extension's
    /// string catalog because they cannot be derived from the snapshot.
    static func compact(_ value: Double, snapshot: Snapshot) -> String {
        if snapshot.maskAmounts { return snapshot.maskPlaceholder }
        let sign = value < 0 ? "-" : ""
        let a = abs(value)
        switch a {
        case 0..<1_000:
            return sign + String(format: "%.0f", a)
        case 1_000..<1_000_000:
            let v = a / 1_000
            let s = v < 10 ? String(format: "%.1f", v) : String(format: "%.0f", v)
            return sign + s + String(localized: "unit.thousand", defaultValue: "k")
        default:
            let v = a / 1_000_000
            let s = v < 10 ? String(format: "%.1f", v) : String(format: "%.0f", v)
            return sign + s + String(localized: "unit.million", defaultValue: "M")
        }
    }
}
