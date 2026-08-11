import Foundation

/// Loads the snapshot from the App Group container.
///
/// Everything is best-effort: a missing, unreadable or future-versioned file
/// yields nil and the widgets fall back to their "open the app" state rather
/// than rendering something wrong.
enum SnapshotStore {
    static let appGroup = "group.com.platrare.app"
    static let fileName = "widget_snapshot.json"

    static func url() -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent(fileName, isDirectory: false)
    }

    static func load() -> Snapshot? {
        guard let url = url(),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return decode(data)
    }

    static func decode(_ data: Data) -> Snapshot? {
        do {
            let snapshot = try JSONDecoder().decode(Snapshot.self, from: data)
            // Refuse a schema we do not understand rather than rendering
            // fields that may have changed meaning.
            guard snapshot.schemaVersion <= Snapshot.supportedVersion else { return nil }
            return snapshot
        } catch {
            return nil
        }
    }

    /// Bundled fixture used by SwiftUI previews. Keeping previews on the same
    /// decoder as production is what keeps this Codable model honest against
    /// the Dart writer.
    static func fixture(_ name: String = "golden") -> Snapshot? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else { return nil }
        return decode(data)
    }
}
