import 'package:flutter/foundation.dart';

import 'widget_bridge.dart';

/// A navigation request that arrived from outside the app: a home-screen
/// widget, an app-icon quick action, Siri / Shortcuts, Control Center, or the
/// Action Button.
sealed class PendingWidgetAction {
  const PendingWidgetAction(this.nonce, this.source);

  /// Per-invocation id. Cold start can deliver the same URL through
  /// `willConnectTo` *and* a subsequent `openURLContexts`, so the dispatcher
  /// records handled nonces and ignores repeats.
  final String nonce;

  /// Diagnostics only (`widget`, `quickaction`, `intent`, …).
  final String source;
}

class AddTrackedAction extends PendingWidgetAction {
  const AddTrackedAction(super.nonce, super.source);
}

class AddPlannedAction extends PendingWidgetAction {
  const AddPlannedAction(super.nonce, super.source);
}

class OpenTabAction extends PendingWidgetAction {
  const OpenTabAction(super.nonce, super.source, this.tabIndex);

  /// 0 = Plan, 1 = Track, 2 = Review.
  final int tabIndex;
}

class OpenAccountAction extends PendingWidgetAction {
  const OpenAccountAction(super.nonce, super.source, this.accountId);

  final String accountId;
}

/// Set when a link arrives; cleared by the dispatcher once handled.
final ValueNotifier<PendingWidgetAction?> pendingWidgetAction =
    ValueNotifier(null);

/// Installs the native→Dart handler and flushes anything buffered during
/// startup. Call just before `runApp`; native buffering makes the exact
/// ordering irrelevant.
Future<void> initWidgetLinks() async {
  if (!WidgetBridge.isSupported) return;
  WidgetBridge.linksChannel.setMethodCallHandler((call) async {
    if (call.method != 'onLink') return null;
    final url = (call.arguments as Map?)?['url'] as String?;
    if (url != null) handleWidgetLink(url);
    return null;
  });
  await WidgetBridge.signalLinksReady();
}

/// Parses a `platrare://` URL into a [PendingWidgetAction].
///
/// Unknown shapes are ignored rather than throwing — a malformed link must
/// never crash startup.
@visibleForTesting
PendingWidgetAction? parseWidgetLink(String raw) {
  final uri = Uri.tryParse(raw);
  if (uri == null || uri.scheme != 'platrare') return null;

  final nonce = uri.queryParameters['n'] ?? raw;
  final source = uri.queryParameters['src'] ?? 'unknown';

  // For platrare://add/tracked, host == 'add' and pathSegments == ['tracked'].
  final host = uri.host;
  final segments = uri.pathSegments;

  switch (host) {
    case 'add':
      final what = segments.isNotEmpty ? segments.first : '';
      if (what == 'tracked') return AddTrackedAction(nonce, source);
      if (what == 'planned') return AddPlannedAction(nonce, source);
      return null;

    case 'open':
      final tab = uri.queryParameters['tab'];
      final index = switch (tab) {
        'plan' => 0,
        'track' => 1,
        'review' => 2,
        _ => null,
      };
      return index == null ? null : OpenTabAction(nonce, source, index);

    case 'account':
      if (segments.isEmpty || segments.first.isEmpty) return null;
      return OpenAccountAction(nonce, source, segments.first);

    default:
      return null;
  }
}

void handleWidgetLink(String raw) {
  final action = parseWidgetLink(raw);
  if (action == null) {
    debugPrint('[WidgetLink] ignored unrecognised link: $raw');
    return;
  }
  pendingWidgetAction.value = action;
}
