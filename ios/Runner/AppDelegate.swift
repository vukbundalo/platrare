import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Planned-transaction reminders: route notification callbacks through the
    // flutter_local_notifications delegate (foreground presentation, taps).
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Home-screen widgets: snapshot writes, WidgetKit reloads, quick actions,
    // and the Dart end of the deep-link channel.
    if let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "PlatrareWidgetBridge")
    {
      PlatrareWidgetBridge.register(with: registrar)
    } else {
      NSLog("[PlatrareWidget] registrar was nil!")
    }
  }
}
