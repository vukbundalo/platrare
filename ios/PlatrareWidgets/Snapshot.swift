import Foundation

/// Decoded form of `widget_snapshot.json`, written by the Flutter app into the
/// App Group container.
///
/// The extension is a separate, sandboxed process: it cannot open the app's
/// SQLite database and cannot read the ARB translations. Everything it needs
/// is precomputed on the Dart side — including a 35-day projection series, so
/// the timeline can roll over day by day with the app never running.
struct Snapshot: Decodable {
    /// Highest `schemaVersion` this build knows how to render.
    static let supportedVersion = 1

    let schemaVersion: Int
    let generatedDay: String
    let staleAfterDay: String
    let localeTag: String
    let textDirection: String
    let baseCurrency: String
    let format: Format
    let formatSample: FormatSample
    let maskAmounts: Bool
    let maskPlaceholder: String
    let hasData: Bool
    let strings: [String: String]
    let series: Series
    let derived: Derived
    let accounts: [AccountInfo]

    struct Format: Decodable {
        let symbol: String
        let digits: Int
        let position: String
        let separator: String
    }

    struct FormatSample: Decodable {
        let v: Double
        let text: String
    }

    struct Series: Decodable {
        let dayCount: Int
        let days: [Day]
    }

    struct Day: Decodable {
        let d: String
        let dLabel: String
        let sp: Double
        let nw: Double
        let spText: String?
        let nwText: String?
    }

    struct Derived: Decodable {
        let plus7Index: Int
        let endOfMonthIndex: Int
        let lowestSpendable: Extreme
        let lowestNetWorth: Extreme
    }

    struct Extreme: Decodable {
        let index: Int
        let d: String
        let dLabel: String
        let dayOffset: Int
        let v: Double
        let vText: String
    }

    struct AccountInfo: Decodable, Identifiable {
        let id: String
        let name: String
        let institution: String
        let displayName: String
        let group: String
        let currency: String
        let symbol: String
        let digits: Int
        let colorArgb: Int?
        let iconCodePoint: Int
        let v0: Double
        let v0Base: Double
        let series: [Double]
    }

    // MARK: - Convenience

    func string(_ key: String, fallback: String = "") -> String {
        strings[key] ?? fallback
    }

    /// Day index for a calendar date, clamped into the series.
    /// Returns nil when the date is before the snapshot was generated.
    func index(for date: Date) -> Int? {
        guard let generated = Self.dayParser.date(from: generatedDay) else { return nil }
        let days = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: generated),
            to: Calendar.current.startOfDay(for: date)
        ).day ?? 0
        if days < 0 { return nil }
        return min(days, series.days.count - 1)
    }

    /// True once `date` is past the end of the precomputed series, i.e. the
    /// numbers are frozen at the last known day.
    func isStale(on date: Date) -> Bool {
        guard let stale = Self.dayParser.date(from: staleAfterDay) else { return false }
        return Calendar.current.startOfDay(for: date) >= Calendar.current.startOfDay(for: stale)
    }

    static let dayParser: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone.current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
