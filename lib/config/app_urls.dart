/// Public URLs and contact points for store listings, support and the policy.
///
/// The **Settings → Privacy policy** screen loads [docs/PRIVACY_POLICY.md] from
/// the app bundle. For App Store / Play, still host the same text at an **HTTPS**
/// URL and point your store listing there; keep this in sync when you change the doc.
abstract final class AppUrls {
  /// Canonical hosted policy URL for store consoles and marketing.
  static final Uri privacyPolicy = Uri.parse(
    'https://github.com/vukbundalo/platrare/blob/main/docs/PRIVACY_POLICY.md',
  );

  /// Support mailbox shown in About and used by the store listings and the
  /// privacy policy (GDPR requires a contact method inside the policy).
  ///
  /// Empty until the owner sets it: the About screen hides its contact button
  /// while this is empty so no placeholder address ever ships.
  static const String supportEmail = '';

  static bool get hasSupportEmail => supportEmail.trim().isNotEmpty;

  /// `mailto:` link with a prefilled subject so support threads are easy to
  /// find. [body] is the diagnostics bundle from the About screen.
  static Uri supportMailto({required String subject, String? body}) =>
      Uri(
        scheme: 'mailto',
        path: supportEmail,
        queryParameters: {
          'subject': subject,
          if (body != null && body.isNotEmpty) 'body': body,
        },
      );
}
