import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tamano_unit6_exercise/main.dart';
import 'package:tamano_unit6_exercise/screens/photo_screen.dart';

void main() {
  testWidgets(
      'Unit 6 Exercise: Profile, Pet, Gallery, IndexedStack, and Dialogs test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // 1. Build app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // --- Profile Screen Checks ---
    expect(find.text('Vincent John Tamaño'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(Chip), findsAtLeastNWidgets(5));
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.byType(Table), findsOneWidget);
    expect(find.textContaining('CC 207B'), findsAtLeastNWidgets(1));

    // --- Tab Navigation & IndexedStack Checks ---
    // Switch to Pet tab by tapping label
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'My Pet'), findsOneWidget);
    expect(find.textContaining('has meowed 0 times'), findsOneWidget);

    // Reset button is disabled when count is 0
    final resetButtonFinder = find.widgetWithText(OutlinedButton, 'Reset count');
    expect(resetButtonFinder, findsOneWidget);
    expect(tester.widget<OutlinedButton>(resetButtonFinder).enabled, isFalse);

    // Tap Play Sound
    await tester.tap(find.widgetWithText(FilledButton, 'Play Sound'));
    await tester.pump();
    expect(find.textContaining('has meowed 1 time'), findsOneWidget);
    expect(tester.widget<OutlinedButton>(resetButtonFinder).enabled, isTrue);

    // Switch to Profile tab and then back to Pet tab (IndexedStack retains state)
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Vincent John Tamaño'), findsWidgets);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    // Count should STILL be 1 because of IndexedStack!
    expect(find.textContaining('has meowed 1 time'), findsOneWidget);

    // --- Reset Dialog Checks ---
    await tester.tap(find.widgetWithText(OutlinedButton, 'Reset count'));
    await tester.pumpAndSettle();
    expect(find.text('Reset the count?'), findsOneWidget);

    // Tap Cancel -> count stays 1
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.textContaining('has meowed 1 time'), findsOneWidget);

    // Tap Reset count again -> Tap Reset -> count goes to 0
    await tester.tap(find.widgetWithText(OutlinedButton, 'Reset count'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
    await tester.pumpAndSettle();
    expect(find.textContaining('has meowed 0 times'), findsOneWidget);

    // --- Gallery Screen Checks ---
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'My Gallery'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    // Tap first gallery tile
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    // Verify PhotoScreen
    expect(find.byType(PhotoScreen), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Make favorite'), findsOneWidget);

    // Tap "Make favorite"
    await tester.tap(find.widgetWithText(FilledButton, 'Make favorite'));
    await tester.pumpAndSettle();

    // Back on Gallery, favorite star should now be visible!
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
