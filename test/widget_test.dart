import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:platrare/main.dart';

void main() {
  testWidgets('PlatrareApp loads with bottom navigation', (tester) async {
    await tester.pumpWidget(const PlatrareApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
