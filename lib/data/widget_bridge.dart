import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Thin wrapper over the native side of the home-screen widget feature.
///
/// Everything here is best-effort: on platforms without the bridge (Android
/// today, tests, simulator builds without entitlements) the calls no-op rather
/// than throwing, so no ledger write path can ever fail because of a widget.
class WidgetBridge {
  WidgetBridge._();

  static const _channel = MethodChannel('com.platrare.app/widget');

  /// Native-to-Dart channel for widget / quick-action / intent deep links.
  static const linksChannel = MethodChannel('com.platrare.app/widget_links');

  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// True once native has confirmed the App Group container is reachable.
  /// False on simulator builds, which are unsigned and therefore have no
  /// entitlements — the snapshot has nowhere to go there.
  static bool _containerAvailable = true;

  static bool get containerAvailable => _containerAvailable;

  /// Writes the snapshot JSON atomically into the App Group container.
  /// Returns false when the container is unavailable.
  static Future<bool> writeSnapshot(String json) async {
    if (!isSupported) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('writeSnapshot', {
        'json': json,
      });
      _containerAvailable = ok ?? false;
      return _containerAvailable;
    } on PlatformException catch (e) {
      _containerAvailable = false;
      debugPrint('[Widget] writeSnapshot failed: ${e.code} ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('[Widget] writeSnapshot: plugin not registered');
      return false;
    }
  }

  /// Asks WidgetKit to rebuild timelines. Rate-limited by the caller — iOS
  /// enforces a per-app daily reload budget and exhausting it silently freezes
  /// every widget for the rest of the day.
  static Future<void> reloadWidgets([List<String>? kinds]) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('reloadWidgets', {'kinds': kinds});
    } on PlatformException catch (e) {
      debugPrint('[Widget] reloadWidgets failed: ${e.code} ${e.message}');
    } on MissingPluginException {
      // no-op
    }
  }

  /// Registers localized app-icon long-press shortcuts.
  ///
  /// Registered dynamically rather than via Info.plist because static
  /// `UIApplicationShortcutItems` localize through per-language
  /// `InfoPlist.strings`, and this app ships only `Base.lproj` despite
  /// declaring 20 `CFBundleLocalizations`.
  static Future<void> setShortcutItems(
      List<Map<String, String>> items) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('setShortcutItems', {'items': items});
    } on PlatformException catch (e) {
      debugPrint('[Widget] setShortcutItems failed: ${e.code} ${e.message}');
    } on MissingPluginException {
      // no-op
    }
  }

  /// Tells native that Dart is ready to receive buffered launch links.
  static Future<void> signalLinksReady() async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod<void>('widgetLinksReady');
    } on PlatformException catch (e) {
      debugPrint('[Widget] widgetLinksReady failed: ${e.code} ${e.message}');
    } on MissingPluginException {
      // no-op
    }
  }
}
