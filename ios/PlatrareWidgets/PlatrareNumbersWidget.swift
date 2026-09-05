import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Timeline

@available(iOS 17.0, *)
struct NumbersEntry: TimelineEntry {
    let date: Date
    let snapshot: Snapshot?
    let config: NumbersConfigurationIntent
    let dayIndex: Int
    let stale: Bool
}

@available(iOS 17.0, *)
struct NumbersProvider: AppIntentTimelineProvider {

    func placeholder(in context: Context) -> NumbersEntry {
        NumbersEntry(date: Date(), snapshot: SnapshotStore.load(),
                     config: NumbersConfigurationIntent(), dayIndex: 0, stale: false)
    }

    func snapshot(for configuration: NumbersConfigurationIntent,
                  in context: Context) async -> NumbersEntry {
        entry(at: Date(), config: configuration, snapshot: SnapshotStore.load())
    }

    /// One entry per day for the whole precomputed series.
    ///
    /// This is the point of shipping 35 days in the snapshot: the widget keeps
    /// showing correct, rolling figures even if the app is never launched
    /// again. `.atEnd` asks WidgetKit for a refresh once the series runs out.
    func timeline(for configuration: NumbersConfigurationIntent,
                  in context: Context) async -> Timeline<NumbersEntry> {
        let snap = SnapshotStore.load()
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        guard let snap else {
            return Timeline(entries: [entry(at: Date(), config: configuration, snapshot: nil)],
                            policy: .after(Date().addingTimeInterval(3600)))
        }

        var entries: [NumbersEntry] = []
        let count = min(snap.series.days.count, 35)
        for offset in 0..<count {
            guard let date = cal.date(byAdding: .day, value: offset, to: today) else { continue }
            // First entry must be "now" so the widget renders immediately.
            let when = offset == 0 ? Date() : date
            entries.append(entry(at: when, config: configuration, snapshot: snap))
        }
        if entries.isEmpty {
            entries = [entry(at: Date(), config: configuration, snapshot: snap)]
        }
        return Timeline(entries: entries, policy: .atEnd)
    }

    private func entry(at date: Date,
                       config: NumbersConfigurationIntent,
                       snapshot: Snapshot?) -> NumbersEntry {
        let idx = snapshot?.index(for: date) ?? 0
        return NumbersEntry(
            date: date,
            snapshot: snapshot,
            config: config,
            dayIndex: idx,
            stale: snapshot?.isStale(on: date) ?? false
        )
    }
}

// MARK: - View

@available(iOS 17.0, *)
struct NumbersView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) private var mode

    let entry: NumbersEntry

    private var resolved: ResolvedMetric? {
        guard let snap = entry.snapshot, snap.hasData else { return nil }
        return MetricResolver.resolve(
            snapshot: snap,
            metric: entry.config.metric,
            horizon: entry.config.horizon,
            accountId: entry.config.account?.id,
            dayIndex: entry.dayIndex
        )
    }

    var body: some View {
        Group {
            if let snap = entry.snapshot, let r = resolved {
                content(snap: snap, r: r)
            } else {
                WidgetEmptyState()
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .widgetURL(MetricResolver.url(metric: entry.config.metric,
                                      accountId: entry.config.account?.id))
    }

    @ViewBuilder
    private func content(snap: Snapshot, r: ResolvedMetric) -> some View {
        switch family {
        case .accessoryInline:
            // Single system-styled line; no custom colours are honoured here.
            Text("\(r.label) \(r.valueText)")
                .privacySensitive()

        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                if let range = r.gaugeRange, let gv = r.gaugeValue, range.lowerBound < range.upperBound {
                    Gauge(value: min(max(gv, range.lowerBound), range.upperBound), in: range) {
                        Text(r.label)
                    } currentValueLabel: {
                        Text(AmountFormatter.compact(r.rawValue, snapshot: snap))
                            .minimumScaleFactor(0.5)
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .privacySensitive()
                } else {
                    VStack(spacing: 0) {
                        Text(AmountFormatter.compact(r.rawValue, snapshot: snap))
                            .font(.headline)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .privacySensitive()
                        Text(r.label)
                            .font(.system(size: 9))
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                    }
                    .padding(2)
                }
            }

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 1) {
                Text(r.label)
                    .font(.caption2)
                    .widgetAccentable()
                    .lineLimit(1)
                Text(r.valueText)
                    .font(.headline)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .privacySensitive()
                if !r.subLabel.isEmpty {
                    Text(r.subLabel)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        case .systemMedium:
            HStack(alignment: .top, spacing: 12) {
                figure(snap: snap, r: r)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .trailing, spacing: 6) {
                    Sparkline(values: r.series, markerIndex: r.markerIndex,
                              masked: snap.maskAmounts, mode: mode)
                        .frame(height: 46)
                    HStack(spacing: 10) {
                        footerCell(snap.string("horizonToday"),
                                   value: snap.series.days[safe: entry.dayIndex]?.sp,
                                   snap: snap)
                        footerCell(snap.string("horizonEndOfMonth"),
                                   value: snap.series.days[safe: snap.derived.endOfMonthIndex]?.sp,
                                   snap: snap)
                    }
                }
                .frame(maxWidth: .infinity)
            }

        default: // .systemSmall and anything new
            figure(snap: snap, r: r)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func figure(snap: Snapshot, r: ResolvedMetric) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(r.label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Text(r.valueText)
                .font(.title2.weight(.semibold))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .foregroundStyle(WidgetTheme.valueColor(r.rawValue, mode: mode))
                .privacySensitive()
            if !r.subLabel.isEmpty {
                Text(r.subLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            if entry.stale {
                Text(snap.string("stale"))
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
        }
    }

    private func footerCell(_ title: String, value: Double?, snap: Snapshot) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Text(value.map { AmountFormatter.display($0, snapshot: snap) } ?? "—")
                .font(.caption2.weight(.medium))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .privacySensitive()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Widget

@available(iOS 17.0, *)
struct PlatrareNumbersWidget: Widget {
    static let kind = "PlatrareNumbers"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: Self.kind,
            intent: NumbersConfigurationIntent.self,
            provider: NumbersProvider()
        ) { entry in
            NumbersView(entry: entry)
        }
        .configurationDisplayName(
            String(localized: LocalizedStringResource("widget.numbers.name", defaultValue: "Balance")))
        .description(
            String(localized: LocalizedStringResource("widget.numbers.desc",
                                                      defaultValue: "Show one figure: spendable, net worth, or your lowest point this month.")))
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryRectangular,
            .accessoryCircular,
            .accessoryInline,
        ])
    }
}
