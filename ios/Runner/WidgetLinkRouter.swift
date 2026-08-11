import Foundation
import Flutter

/// Buffers deep links that arrive before Dart is ready to receive them.
///
/// `scene(_:willConnectTo:options:)` fires long before Dart `main()` finishes:
/// startup awaits the database open, `loadIntoMemory`, seven pref inits,
/// timezone setup, date formatting for 21 locales and the FX cache before
/// `runApp`. Without buffering, every cold-start widget tap would be dropped.
///
/// Native holds links until Dart calls `widgetLinksReady`, then switches to
/// push mode.
final class WidgetLinkRouter {
    static let shared = WidgetLinkRouter()
    private init() {}

    private var buffer: [String] = []
    private var channel: FlutterMethodChannel?
    private var dartReady = false

    /// Bounded so a pathological retry loop can't grow memory unchecked.
    private let maxBuffered = 16

    func attach(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    /// Called from Dart once its handler is installed. Flushes anything that
    /// arrived during startup.
    func markReadyAndFlush() {
        dartReady = true
        let pending = buffer
        buffer.removeAll()
        pending.forEach(send)
    }

    func enqueue(url: URL) {
        enqueue(urlString: url.absoluteString)
    }

    /// Shortcut items are mapped to the same URL shapes here so Dart only ever
    /// deals with one input format.
    func enqueue(shortcutType: String) {
        let nonce = UUID().uuidString
        let path: String
        switch shortcutType {
        case "com.platrare.app.addTracked":
            path = "add/tracked"
        case "com.platrare.app.addPlanned":
            path = "add/planned"
        default:
            return
        }
        enqueue(urlString: "platrare://\(path)?src=quickaction&n=\(nonce)")
    }

    private func enqueue(urlString: String) {
        guard dartReady else {
            if buffer.count >= maxBuffered { buffer.removeFirst() }
            buffer.append(urlString)
            return
        }
        send(urlString)
    }

    private func send(_ urlString: String) {
        guard let channel else {
            if buffer.count < maxBuffered { buffer.append(urlString) }
            return
        }
        channel.invokeMethod("onLink", arguments: ["url": urlString])
    }
}
