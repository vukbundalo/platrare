import 'package:flutter/material.dart';

import '../data/currency_localized_names.dart';
import '../data/currency_prefs.dart';
import '../data/onboarding_prefs.dart';
import '../data/user_settings.dart' as settings;
import '../l10n/app_localizations.dart';
import '../theme/platrare_surfaces.dart';
import '../utils/fx.dart' as fx;
import '../widgets/currency_picker_sheet.dart';

/// First-run screen: privacy promise, the three tabs in one sentence each,
/// and the base currency (suggested from the device locale, changeable).
///
/// Shown once, as an overlay above Home after the splash. [onDone] receives
/// `true` when the user asked to be shown around.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.suggestedCurrency,
    required this.onDone,
  });

  final String suggestedCurrency;
  final void Function(bool startTour) onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late String _currency = widget.suggestedCurrency;
  bool _busy = false;

  Future<void> _pickCurrency() async {
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CurrencyPickerSheet(current: _currency),
    );
    if (code != null && mounted) setState(() => _currency = code);
  }

  Future<void> _finish({required bool startTour}) async {
    if (_busy) return;
    setState(() => _busy = true);
    settings.baseCurrency = _currency;
    if (settings.secondaryCurrency == _currency) {
      settings.secondaryCurrency = _currency == 'USD' ? 'EUR' : 'USD';
    }
    await saveCurrencyPreferences();
    await markOnboardingDone();
    if (!mounted) return;
    widget.onDone(startTour);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: PlatrareSurfaces.routeShell(cs, brightness),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                children: [
                  Center(
                    child: Image.asset(
                      'assets/branding/splash_logo.png',
                      width: 88,
                      height: 88,
                      semanticLabel: 'Platrare',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.onboardingWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingWelcomeBody,
                    textAlign: TextAlign.center,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _FeatureRow(
                    icon: Icons.event_note_rounded,
                    title: l10n.navPlan,
                    body: l10n.onboardingPlanBody,
                  ),
                  const SizedBox(height: 14),
                  _FeatureRow(
                    icon: Icons.receipt_long_rounded,
                    title: l10n.navTrack,
                    body: l10n.onboardingTrackBody,
                  ),
                  const SizedBox(height: 14),
                  _FeatureRow(
                    icon: Icons.analytics_rounded,
                    title: l10n.navReview,
                    body: l10n.onboardingReviewBody,
                  ),
                  const SizedBox(height: 28),
                  Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      onTap: _busy ? null : _pickCurrency,
                      leading: Container(
                        width: 44,
                        height: 34,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            fx.currencySymbol(_currency),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                      title: Text(l10n.onboardingCurrencyLabel),
                      subtitle: Text(
                        '$_currency · ${currencyDisplayName(_currency, locale)}',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      l10n.onboardingCurrencyHint,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _busy ? null : () => _finish(startTour: false),
                    child: Text(l10n.onboardingStart),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _busy ? null : () => _finish(startTour: true),
                    child: Text(l10n.onboardingTour),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cs.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
