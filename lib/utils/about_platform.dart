import 'about_platform_stub.dart'
    if (dart.library.io) 'about_platform_io.dart' as impl;

/// Short platform description for pasted support diagnostics.
String aboutPlatformSupportLine() => impl.aboutPlatformSupportLine();
