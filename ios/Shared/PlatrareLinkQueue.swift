import Foundation

/// Hand-off channel for App Intents (Siri, Shortcuts, Control Center, Action
/// Button) that need to open the app on a specific screen.
///
/// Widget taps carry their destination in a `platrare://` URL via `.widgetURL`
/// / `Link`, which the scene delegate receives directly. App Intents cannot do
/// that below iOS 18 (`OpenURLIntent` is 18+), so instead they append the very
/// same URL string here and set `openAppWhenRun`. The app drains the queue on
/// scene connect and activation and feeds it into `WidgetLinkRouter`, so both
/// ingress paths converge on one Dart handler.
///
/// Compiled into both targets.
enum PlatrareLinkQueue {
    static let appGroup = "group.com.platrare.app"
    private static let key = "pending_links"

    /// Bounded: a stuck queue must never grow without limit.
    private static let maxEntries = 8

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroup)
    }

    static func enqueue(_ urlString: String) {
        guard let defaults else { return }
        var pending = defaults.stringArray(forKey: key) ?? []
        pending.append(urlString)
        if pending.count > maxEntries {
            pending.removeFirst(pending.count - maxEntries)
        }
        defaults.set(pending, forKey: key)
    }

    /// Returns everything queued and clears it in one step.
    static func drain() -> [String] {
        guard let defaults else { return [] }
        let pending = defaults.stringArray(forKey: key) ?? []
        if !pending.isEmpty { defaults.removeObject(forKey: key) }
        return pending
    }
}
