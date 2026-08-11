import Flutter
import UIKit

/// Routes widget / quick-action / App Intent URLs into Dart.
///
/// The app runs the scene-based Flutter engine (`UISceneDelegateClassName` is
/// set to this class in Info.plist), so UIKit never calls the app delegate's
/// `application(_:open:options:)`. URL handling has to live on the scene.
///
/// `super` is called first in every override so Flutter's own plugin
/// lifecycle chain keeps working — several plugins depend on it.
///
/// Note `FlutterDeepLinkingEnabled` is set to false in Info.plist. Otherwise
/// the engine would push `platrare://...` as a *named route* into a
/// `MaterialApp` that has no route table, tripping its unknown-route assertion
/// and, on the cold-start path, re-opening our own scheme on failure.
@objc(PlatrareSceneDelegate)
class PlatrareSceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        // Cold start: Dart is not up yet, so these are buffered natively.
        for context in connectionOptions.urlContexts {
            WidgetLinkRouter.shared.enqueue(url: context.url)
        }
        if let item = connectionOptions.shortcutItem {
            WidgetLinkRouter.shared.enqueue(shortcutType: item.type)
        }
        drainIntentQueue()
    }

    override func sceneDidBecomeActive(_ scene: UIScene) {
        super.sceneDidBecomeActive(scene)
        // App Intents that ran while the app was backgrounded (Siri, Shortcuts,
        // Control Center, Action Button) left their destination here.
        drainIntentQueue()
    }

    /// App Intents cannot open a URL directly below iOS 18, so they append the
    /// same `platrare://` string to a shared queue instead. Both ingress paths
    /// converge on one Dart handler.
    private func drainIntentQueue() {
        for urlString in PlatrareLinkQueue.drain() {
            if let url = URL(string: urlString) {
                WidgetLinkRouter.shared.enqueue(url: url)
            }
        }
    }

    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)
        for context in URLContexts {
            WidgetLinkRouter.shared.enqueue(url: context.url)
        }
    }

    override func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        WidgetLinkRouter.shared.enqueue(shortcutType: shortcutItem.type)
        completionHandler(true)
    }
}
