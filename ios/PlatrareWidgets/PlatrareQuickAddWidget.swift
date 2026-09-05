import SwiftUI
import WidgetKit

/// Quick-add has no snapshot dependency, so it renders correctly the moment
/// it is placed — before the app has ever written a snapshot. Only the button
/// titles come from the snapshot, with English defaults as a fallback.
@available(iOS 17.0, *)
struct QuickAddEntry: TimelineEntry {
    let date: Date
    let addTracked: String
    let addPlanned: String
}

@available(iOS 17.0, *)
struct QuickAddProvider: TimelineProvider {
    private func current() -> QuickAddEntry {
        let snap = SnapshotStore.load()
        return QuickAddEntry(
            date: Date(),
            addTracked: snap?.string("addTracked", fallback: defaultTracked)
                ?? defaultTracked,
            addPlanned: snap?.string("addPlanned", fallback: defaultPlanned)
                ?? defaultPlanned
        )
    }

    private var defaultTracked: String {
        String(localized: "quickadd.tracked", defaultValue: "Add transaction")
    }

    private var defaultPlanned: String {
        String(localized: "quickadd.planned", defaultValue: "Add plan")
    }

    func placeholder(in context: Context) -> QuickAddEntry { current() }

    func getSnapshot(in context: Context, completion: @escaping (QuickAddEntry) -> Void) {
        completion(current())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuickAddEntry>) -> Void) {
        // Nothing time-dependent here; only a language change alters the
        // titles, and that triggers an explicit reload from the app.
        completion(Timeline(entries: [current()], policy: .never))
    }
}

@available(iOS 17.0, *)
struct QuickAddView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) private var mode

    let entry: QuickAddEntry

    private var trackedURL: URL? { URL(string: PlatrareLink.addTracked(src: "widget")) }
    private var plannedURL: URL? { URL(string: PlatrareLink.addPlanned(src: "widget")) }

    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                }

            case .systemMedium:
                // Two independent tap targets. `Link` rather than `Button` —
                // no AppIntent needed, and it works on every supported family.
                HStack(spacing: 0) {
                    Link(destination: plannedURL ?? URL(string: "platrare://open")!) {
                        tile(icon: "calendar.badge.plus", title: entry.addPlanned)
                    }
                    Divider()
                    Link(destination: trackedURL ?? URL(string: "platrare://open")!) {
                        tile(icon: "plus.circle.fill", title: entry.addTracked)
                    }
                }

            default: // .systemSmall
                tile(icon: "plus.circle.fill", title: entry.addTracked)
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
        // Small and circular have no inner Links, so the whole widget is the
        // target. On medium this is ignored in favour of the two Links.
        .widgetURL(family == .systemMedium ? nil : trackedURL)
    }

    private func tile(icon: String, title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(WidgetTheme.accentColor(mode))
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
}

@available(iOS 17.0, *)
struct PlatrareQuickAddWidget: Widget {
    static let kind = "PlatrareQuickAdd"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Self.kind, provider: QuickAddProvider()) { entry in
            QuickAddView(entry: entry)
        }
        .configurationDisplayName(
            String(localized: LocalizedStringResource("widget.quickadd.name", defaultValue: "Quick add")))
        .description(
            String(localized: LocalizedStringResource("widget.quickadd.desc",
                                                      defaultValue: "Add a transaction or a plan in one tap.")))
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}
