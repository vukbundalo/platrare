#if DEBUG
import SwiftUI
import WidgetKit

/// Previews drive off `Fixtures/golden.json`, decoded through the *production*
/// `SnapshotStore`. That keeps this Codable model honest against the Dart
/// writer: if the schema drifts, the previews stop rendering.
///
/// Regenerate the fixture with `tool/dump_widget_fixture.sh`.
@available(iOS 17.0, *)
private func previewEntry(
    metric: PlatrareMetric,
    horizon: PlatrareHorizon = .endOfMonth,
    accountId: String? = nil,
    dayIndex: Int = 0
) -> NumbersEntry {
    let snapshot = SnapshotStore.fixture()
    let config = NumbersConfigurationIntent()
    config.metric = metric
    config.horizon = horizon
    if let accountId, let info = snapshot?.accounts.first(where: { $0.id == accountId }) {
        config.account = AccountEntity(info)
    }
    return NumbersEntry(date: Date(), snapshot: snapshot, config: config,
                        dayIndex: dayIndex, stale: false)
}

@available(iOS 17.0, *)
#Preview("Numbers · small · lowest point", as: .systemSmall) {
    PlatrareNumbersWidget()
} timeline: {
    previewEntry(metric: .lowestPoint)
    previewEntry(metric: .spendableNow)
    previewEntry(metric: .netWorth)
}

@available(iOS 17.0, *)
#Preview("Numbers · medium · sparkline", as: .systemMedium) {
    PlatrareNumbersWidget()
} timeline: {
    previewEntry(metric: .lowestPoint)
    previewEntry(metric: .projected, horizon: .plus7d)
    // Day rollover: the trough recomputes from the entry's own day forward.
    previewEntry(metric: .lowestPoint, dayIndex: 9)
}

@available(iOS 17.0, *)
#Preview("Numbers · lock screen", as: .accessoryRectangular) {
    PlatrareNumbersWidget()
} timeline: {
    previewEntry(metric: .lowestPoint)
    previewEntry(metric: .spendableNow)
}

@available(iOS 17.0, *)
#Preview("Numbers · circular", as: .accessoryCircular) {
    PlatrareNumbersWidget()
} timeline: {
    previewEntry(metric: .lowestPoint)
    previewEntry(metric: .netWorth)
}

@available(iOS 17.0, *)
#Preview("Quick add · medium", as: .systemMedium) {
    PlatrareQuickAddWidget()
} timeline: {
    QuickAddEntry(date: Date(), addTracked: "Add transaction", addPlanned: "Add plan")
}

@available(iOS 17.0, *)
#Preview("Quick add · small", as: .systemSmall) {
    PlatrareQuickAddWidget()
} timeline: {
    QuickAddEntry(date: Date(), addTracked: "Add transaction", addPlanned: "Add plan")
}
#endif
