import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platrare/main.dart';
import 'package:platrare/screens/onboarding_screen.dart';

/// Large accessibility text must not throw layout overflows on the first
/// screens a user meets: onboarding and the three empty tabs.
void main() {
  Widget scaled(double factor, Widget child) => MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(factor)),
        child: child,
      );

  for (final factor in [1.5, 2.0]) {
    testWidgets('onboarding and empty tabs lay out at ${factor}x text',
        (tester) async {
      await tester.pumpWidget(scaled(factor, const PlatrareApp(showOnboarding: true)));
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Dismiss onboarding without persisting prefs (no plugin in tests).
      await tester.pumpWidget(scaled(factor, const PlatrareApp()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final bar = find.byType(NavigationBar);
      expect(bar, findsOneWidget);
      for (final destination in tester.widget<NavigationBar>(bar).destinations) {
        await tester.tap(find.byWidget(destination));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull,
            reason: 'tab overflowed at ${factor}x');
      }
    });
  }
}
