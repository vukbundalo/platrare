import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../theme/platrare_surfaces.dart';
import '../utils/about_platform.dart';
import 'privacy_policy_screen.dart';

/// Settings entry point: version, product context, privacy link, diagnostics copy.
class AppAboutScreen extends StatelessWidget {
  const AppAboutScreen({super.key});

  Future<void> _copySupportBundle(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final pkg = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final text = [
      'Platrare',
      '${l10n.aboutVersionLabel}: ${pkg.version}',
      '${l10n.aboutBuildLabel}: ${pkg.buildNumber}',
      '${l10n.aboutSupportBundleLocaleLabel}: $locale',
      aboutPlatformSupportLine(),
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsSupportInfoCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.aboutScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_outlined),
            tooltip: l10n.aboutCopySupportDetails,
            onPressed: () => _copySupportBundle(context),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: PlatrareSurfaces.routeShell(cs, brightness),
        child: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snap) {
            final version = snap.data?.version ?? '—';
            final build = snap.data?.buildNumber ?? '—';
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Text(
                  'Platrare',
                  textAlign: TextAlign.center,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.aboutAppTagline,
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(l10n.aboutVersionLabel),
                          trailing: Text(
                            version,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                        ),
                        ListTile(
                          title: Text(l10n.aboutBuildLabel),
                          trailing: Text(
                            build,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.aboutDescriptionBody,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _copySupportBundle(context),
                  icon: const Icon(Icons.copy_all_outlined, size: 20),
                  label: Text(l10n.aboutCopySupportDetails),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.policy_outlined, size: 20),
                  label: Text(l10n.settingsPrivacyPolicyTitle),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    l10n.aboutOpenPrivacySubtitle,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
