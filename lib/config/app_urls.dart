/// Public URLs for store listings and support (not used for the in-app policy UI).
///
/// The **Settings → Privacy policy** screen loads [docs/PRIVACY_POLICY.md] from
/// the app bundle. For App Store / Play, still host the same text at an **HTTPS**
/// URL and point your store listing there; keep this in sync when you change the doc.
abstract final class AppUrls {
  /// Canonical hosted policy URL for store consoles and marketing.
  static final Uri privacyPolicy = Uri.parse(
    'https://github.com/vukbundalo/platrare/blob/main/docs/PRIVACY_POLICY.md',
  );
}
