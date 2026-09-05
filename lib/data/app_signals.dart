import 'package:flutter/foundation.dart';

/// Cross-cutting UI state that lives outside any one widget's State.
///
/// Deliberately tiny and dependency-free: these exist so the deep-link
/// dispatcher can wait for the right moment without reaching into private
/// State fields.

/// True once the cold-start splash overlay has finished fading.
///
/// A widget-launched deep link must not push a route while the splash is still
/// covering the screen — the user would land on a screen they never saw open.
final ValueNotifier<bool> splashCompleted = ValueNotifier(false);

/// Mirrors [AppLockGate]'s internal unlock state.
///
/// The lock is a `Stack` overlay *inside* the `home:` route, not a route of its
/// own, so anything pushed with `Navigator.push` renders **above** it. Without
/// this signal a widget deep link would show the account picker — names,
/// balances, currencies — over the lock screen.
///
/// Defaults to true so builds with app lock disabled are unaffected.
final ValueNotifier<bool> appUnlocked = ValueNotifier(true);

/// Bumped by the first-run screen when the user asks to be shown around.
/// [PlanScreen] listens and starts its help tour on the next frame.
final ValueNotifier<int> requestPlanHelpTour = ValueNotifier(0);
