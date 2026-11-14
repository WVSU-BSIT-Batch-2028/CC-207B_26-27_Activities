import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tamano_unit5_exercise/main.dart';

void main() {
  testWidgets('App loads Profile screen and navigates to Pet screen',
      (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());

    // Verify Profile screen components
    expect(find.text('Vincent John Tamaño'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('Degree & Track'), findsOneWidget);

    // Switch to Pet screen via NavigationBar destination icon
    await tester.tap(find.byIcon(Icons.pets_outlined));
    await tester.pumpAndSettle();

    // Verify Pet screen components
    expect(find.widgetWithText(AppBar, 'My Pet'), findsOneWidget);
    expect(find.textContaining('has meowed'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Play Sound'), findsOneWidget);

    // Double tap photo gesture test
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    // Verify heart icon appears
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
