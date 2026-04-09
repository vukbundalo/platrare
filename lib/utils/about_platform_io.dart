import 'dart:io' show Platform;

/// OS line for support bundles (mobile/desktop).
String aboutPlatformSupportLine() {
  final os = Platform.operatingSystem;
  final ver = Platform.operatingSystemVersion;
  return 'OS: $os ($ver)';
}
