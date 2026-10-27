import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaguin_unit6_exercise/main.dart';

void main() {
  testWidgets('Profile and pet destinations are available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Justin Jerrickho Amaguin'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.byType(InfoTile), findsNWidgets(4));

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('PopCat'), findsOneWidget);
    expect(find.text('PopCat is my favorite animal.'), findsOneWidget);
    expect(find.text('PopCat has meowed 0 times.'), findsOneWidget);
    expect(find.text('Play meow'), findsOneWidget);
    expect(find.bySemanticsLabel('Popcat with mouth closed'), findsOneWidget);

    final petPhoto = find.byType(Image);
    await tester.tap(petPhoto);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(petPhoto);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('My Biography'), findsOneWidget);
  });

  testWidgets('Reset requires confirmation and preserves count across tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    final resetButton = find.widgetWithText(OutlinedButton, 'Reset count');
    expect(tester.widget<OutlinedButton>(resetButton).onPressed, isNull);

    await tester.ensureVisible(find.text('Play meow'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play meow'));
    await tester.pump();
    expect(find.text('PopCat has meowed 1 time.'), findsOneWidget);
    expect(tester.widget<OutlinedButton>(resetButton).onPressed, isNotNull);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    expect(find.text('PopCat has meowed 1 time.'), findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('PopCat has meowed 1 time.'), findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('PopCat has meowed 1 time.'), findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
    await tester.pumpAndSettle();
    expect(find.text('PopCat has meowed 0 times.'), findsOneWidget);
    expect(tester.widget<OutlinedButton>(resetButton).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profile remains usable at a narrow screen width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('My Biography'), 250);
    expect(find.text('My Biography'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
