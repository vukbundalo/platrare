import Foundation

/// Names shared by the app and the widget extension.
///
/// The extension has its own copy of the constants it needs (see
/// `PlatrareWidgets/SnapshotStore.swift`); keeping the app-side definition here
/// avoids adding the whole file to both targets just for two strings.
enum PlatrareWidgetShared {
    static let appGroup = "group.com.platrare.app"
    static let snapshotFileName = "widget_snapshot.json"

    /// `<AppGroup>/Library/Application Support/widget_snapshot.json`.
    ///
    /// Returns nil when the App Group container is unreachable — which is the
    /// normal case for unsigned simulator builds, since those carry no
    /// entitlements. Callers treat nil as "widgets unavailable", never as an
    /// error worth failing a ledger write over.
    static func snapshotURL() -> URL? {
        guard let container = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)
        else { return nil }

        let dir = container
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
        return dir.appendingPathComponent(snapshotFileName, isDirectory: false)
    }
}
