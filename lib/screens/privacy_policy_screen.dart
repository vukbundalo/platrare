import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../l10n/app_localizations.dart';
import '../theme/platrare_surfaces.dart';

/// Renders the privacy policy markdown from the app bundle.
///
/// Loads the locale-specific file (e.g. `docs/PRIVACY_POLICY_fr.md`) when
/// available, falling back to the English `docs/PRIVACY_POLICY.md`.
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  static const _fallbackAsset = 'docs/PRIVACY_POLICY.md';

  /// Returns the asset path for [locale], or null if the locale maps to the
  /// English fallback.
  static String? _assetForLocale(Locale locale) {
    final lang = locale.languageCode;
    final script = locale.scriptCode;

    if (lang == 'en') return null;

    // Script-differentiated locales
    if (lang == 'sr') {
      if (script == 'Cyrl') return 'docs/PRIVACY_POLICY_sr_Cyrl.md';
      return 'docs/PRIVACY_POLICY_sr_Latn.md';
    }
    if (lang == 'zh') return 'docs/PRIVACY_POLICY_zh_Hans.md';

    // Country-differentiated locales
    if (lang == 'pt') return 'docs/PRIVACY_POLICY_pt_BR.md';

    // Simple language codes
    const supported = {
      'ar', 'bs', 'de', 'es', 'fr', 'hi', 'hr', 'it',
      'ja', 'ko', 'nl', 'pl', 'ru', 'sv', 'tr', 'uk',
    };
    if (supported.contains(lang)) return 'docs/PRIVACY_POLICY_$lang.md';

    return null;
  }

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<String> _markdownFuture;
  Locale? _loadedLocale;

  Future<String> _load(Locale locale) async {
    final localePath = PrivacyPolicyScreen._assetForLocale(locale);
    if (localePath != null) {
      try {
        return await rootBundle.loadString(localePath);
      } catch (_) {
        // Locale-specific file missing — fall back to English.
      }
    }
    return rootBundle.loadString(PrivacyPolicyScreen._fallbackAsset);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (locale != _loadedLocale) {
      _loadedLocale = locale;
      _markdownFuture = _load(locale);
    }
  }

  void _retry() {
    setState(() {
      _loadedLocale = null; // force reload on next didChangeDependencies
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(l10n.settingsPrivacyPolicyTitle)),
      body: DecoratedBox(
        decoration: PlatrareSurfaces.routeShell(cs, brightness),
        child: FutureBuilder<String>(
          future: _markdownFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.settingsPrivacyOpenFailed,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _retry,
                        child: Text(l10n.settingsPrivacyRetry),
                      ),
                    ],
                  ),
                ),
              );
            }
            final data = snapshot.data ?? '';
            final styleSheet = MarkdownStyleSheet.fromTheme(
              Theme.of(context),
            ).copyWith(blockSpacing: 12);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsPrivacyFxDisclosure,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: data,
                    selectable: true,
                    styleSheet: styleSheet,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
