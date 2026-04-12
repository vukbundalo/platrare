import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kHideHeroBalancesByDefault = 'hide_hero_balances_by_default';

/// When true, summary amounts in Plan / Track / Review hero cards are masked
/// until the user taps the visibility control (session-only reveal).
final ValueNotifier<bool> balancePrivacyHideByDefault = ValueNotifier(false);

/// Effective only while [balancePrivacyHideByDefault] is true.
final ValueNotifier<bool> heroBalancesTemporarilyRevealed = ValueNotifier(false);

Listenable get balancePrivacyListenable => Listenable.merge([
      balancePrivacyHideByDefault,
      heroBalancesTemporarilyRevealed,
    ]);

/// Whether hero card amounts should show real figures (not privacy mask).
bool get heroBalancesVisible =>
    !balancePrivacyHideByDefault.value || heroBalancesTemporarilyRevealed.value;

Future<void> initBalancePrivacyPrefs() async {
  final p = await SharedPreferences.getInstance();
  balancePrivacyHideByDefault.value =
      p.getBool(_kHideHeroBalancesByDefault) ?? false;
  heroBalancesTemporarilyRevealed.value = false;
}

Future<void> setBalancePrivacyHideByDefault(bool hide) async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kHideHeroBalancesByDefault, hide);
  balancePrivacyHideByDefault.value = hide;
  if (hide) {
    heroBalancesTemporarilyRevealed.value = false;
  }
}

void toggleHeroBalancesRevealed() {
  heroBalancesTemporarilyRevealed.value =
      !heroBalancesTemporarilyRevealed.value;
}
