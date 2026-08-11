import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'security_prefs.dart';

const _kShowAmountsInWidgets = 'widget_show_amounts';

/// Opt-in for real amounts in home-screen widgets while app lock is enabled.
///
/// [AppLockGate] deliberately covers the app during backgrounding so the OS
/// app-switcher snapshot never contains ledger content. A widget showing the
/// same balances on an unlocked-but-unauthenticated home screen would undo
/// that, so amounts are masked by default whenever app lock is on.
final ValueNotifier<bool> widgetShowAmounts = ValueNotifier(false);

Future<void> initWidgetPrefs() async {
  final p = await SharedPreferences.getInstance();
  widgetShowAmounts.value = p.getBool(_kShowAmountsInWidgets) ?? false;
}

Future<void> setWidgetShowAmounts(bool show) async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kShowAmountsInWidgets, show);
  widgetShowAmounts.value = show;
}

/// Whether the snapshot must mask every amount.
///
/// Masks when the in-app privacy setting hides hero balances, or when app lock
/// is on and the user has not explicitly opted in. The session-only reveal
/// (`heroBalancesTemporarilyRevealed`) is deliberately ignored: it is scoped to
/// a foreground session and must never leak onto the home screen.
bool widgetAmountsMasked({required bool hideHeroBalances}) {
  if (hideHeroBalances) return true;
  if (appSecurityEnabled.value && !widgetShowAmounts.value) return true;
  return false;
}
