/// Public URLs used by the app. Update [privacyPolicy] when you host
/// [docs/PRIVACY_POLICY.md] (HTTPS recommended).
abstract final class AppUrls {
  /// Default: GitHub-rendered policy in this repo. Replace with your hosted
  /// canonical URL before App Store / Play production if different.
  static final Uri privacyPolicy = Uri.parse(
    'https://github.com/vukbundalo/platrare/blob/main/docs/PRIVACY_POLICY.md',
  );
}
