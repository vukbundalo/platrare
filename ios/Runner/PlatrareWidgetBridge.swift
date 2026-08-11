import Flutter
import Foundation
import UIKit
import WidgetKit

/// Dart <-> WidgetKit bridge.
///
/// Hand-rolled rather than using a pub package: the snapshot is a ~40 KB JSON
/// *file* (App Group `UserDefaults` is the wrong medium and gives no atomic
/// replace), and this project deliberately avoids adding plugins that touch
/// iOS app lifecycle — see the `path_provider_foundation` pin in pubspec.yaml.
final class PlatrareWidgetBridge: NSObject, FlutterPlugin {

    private static let channelName = "com.platrare.app/widget"
    private static let linksChannelName = "com.platrare.app/widget_links"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName, binaryMessenger: registrar.messenger())
        let instance = PlatrareWidgetBridge()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let links = FlutterMethodChannel(
            name: linksChannelName, binaryMessenger: registrar.messenger())
        WidgetLinkRouter.shared.attach(channel: links)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "writeSnapshot":
            guard let args = call.arguments as? [String: Any],
                  let json = args["json"] as? String
            else {
                result(FlutterError(code: "bad_args",
                                    message: "writeSnapshot expects { json }",
                                    details: nil))
                return
            }
            result(Self.writeSnapshot(json))

        case "reloadWidgets":
            let kinds = (call.arguments as? [String: Any])?["kinds"] as? [String]
            Self.reloadWidgets(kinds: kinds)
            result(nil)

        case "setShortcutItems":
            let items = (call.arguments as? [String: Any])?["items"] as? [[String: String]]
            Self.setShortcutItems(items ?? [])
            result(nil)

        case "widgetLinksReady":
            WidgetLinkRouter.shared.markReadyAndFlush()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Snapshot

    /// Returns false when the App Group container is unreachable, which is the
    /// expected state on unsigned simulator builds. Dart treats false as
    /// "widgets unavailable" and stops trying.
    private static func writeSnapshot(_ json: String) -> Bool {
        guard let url = PlatrareWidgetShared.snapshotURL(),
              let data = json.data(using: .utf8)
        else { return false }

        do {
            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true)

            // .completeUntilFirstUserAuthentication, NOT .complete: with
            // .complete the file is unreadable while the device is locked,
            // which breaks lock-screen accessory widgets.
            try data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
            return true
        } catch {
            NSLog("[PlatrareWidget] snapshot write failed: \(error)")
            return false
        }
    }

    private static func reloadWidgets(kinds: [String]?) {
        // The app target deploys to iOS 13; WidgetKit starts at 14 and our
        // extension at 17. On older systems this is simply a no-op.
        guard #available(iOS 14.0, *) else { return }
        guard let kinds, !kinds.isEmpty else {
            WidgetCenter.shared.reloadAllTimelines()
            return
        }
        for kind in kinds {
            WidgetCenter.shared.reloadTimelines(ofKind: kind)
        }
    }

    // MARK: - Home-screen quick actions

    /// Registered dynamically from Dart rather than declared in Info.plist:
    /// static `UIApplicationShortcutItems` localize through per-language
    /// `InfoPlist.strings`, and this app ships only `Base.lproj` despite
    /// declaring 20 `CFBundleLocalizations`.
    private static func setShortcutItems(_ items: [[String: String]]) {
        let shortcuts: [UIApplicationShortcutItem] = items.compactMap { item in
            guard let type = item["type"], let title = item["title"] else { return nil }
            let icon = item["icon"].map { UIApplicationShortcutIcon(systemImageName: $0) }
            return UIApplicationShortcutItem(
                type: type,
                localizedTitle: title,
                localizedSubtitle: nil,
                icon: icon,
                userInfo: nil)
        }
        DispatchQueue.main.async {
            UIApplication.shared.shortcutItems = shortcuts
        }
    }
}
