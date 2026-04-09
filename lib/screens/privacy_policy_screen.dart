import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../l10n/app_localizations.dart';
import '../theme/platrare_surfaces.dart';

/// Renders [docs/PRIVACY_POLICY.md] from the app bundle (see `pubspec.yaml` assets).
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  static const assetPath = 'docs/PRIVACY_POLICY.md';

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<String> _markdownFuture;

  @override
  void initState() {
    super.initState();
    _markdownFuture = rootBundle.loadString(PrivacyPolicyScreen.assetPath);
  }

  void _retry() {
    setState(() {
      _markdownFuture = rootBundle.loadString(PrivacyPolicyScreen.assetPath);
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
            return Markdown(
              data: data,
              selectable: true,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              styleSheet: MarkdownStyleSheet.fromTheme(
                Theme.of(context),
              ).copyWith(blockSpacing: 12),
            );
          },
        ),
      ),
    );
  }
}
