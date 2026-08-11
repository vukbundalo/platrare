import AppIntents
import Foundation

/// Which figure the Numbers widget shows. Chosen per widget instance in the
/// configuration sheet.
///
/// Compiled into both targets: the extension builds the configuration UI, and
/// the app target needs the type to be present for the intents that reference
/// it. Availability is annotated because the app target still deploys to
/// iOS 13 while AppIntents starts at 16.
@available(iOS 16.0, *)
enum PlatrareMetric: String, AppEnum {
    /// Personal accounts including overdraft headroom — the app's "Balance".
    case spendableNow
    /// All accounts, book value only — the app's "Net".
    case netWorth
    /// The trough of projected spendable between today and month end. The one
    /// figure a planning app can show that a banking app cannot.
    case lowestPoint
    /// Projected value at a chosen horizon.
    case projected
    /// A single account's balance.
    case account

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: LocalizedStringResource("metric.type", defaultValue: "Metric")
    )

    static var caseDisplayRepresentations: [PlatrareMetric: DisplayRepresentation] = [
        .spendableNow: DisplayRepresentation(
            title: LocalizedStringResource("metric.spendable", defaultValue: "Balance")),
        .netWorth: DisplayRepresentation(
            title: LocalizedStringResource("metric.networth", defaultValue: "Net worth")),
        .lowestPoint: DisplayRepresentation(
            title: LocalizedStringResource("metric.lowest", defaultValue: "Lowest point")),
        .projected: DisplayRepresentation(
            title: LocalizedStringResource("metric.projected", defaultValue: "Projected")),
        .account: DisplayRepresentation(
            title: LocalizedStringResource("metric.account", defaultValue: "Account balance")),
    ]
}

/// How far ahead `PlatrareMetric.projected` looks.
@available(iOS 16.0, *)
enum PlatrareHorizon: String, AppEnum {
    case endOfToday
    case plus7d
    case endOfMonth

    static var typeDisplayRepresentation = TypeDisplayRepresentation(
        name: LocalizedStringResource("horizon.type", defaultValue: "Horizon")
    )

    static var caseDisplayRepresentations: [PlatrareHorizon: DisplayRepresentation] = [
        .endOfToday: DisplayRepresentation(
            title: LocalizedStringResource("horizon.today", defaultValue: "Today")),
        .plus7d: DisplayRepresentation(
            title: LocalizedStringResource("horizon.7d", defaultValue: "In 7 days")),
        .endOfMonth: DisplayRepresentation(
            title: LocalizedStringResource("horizon.eom", defaultValue: "End of month")),
    ]
}
