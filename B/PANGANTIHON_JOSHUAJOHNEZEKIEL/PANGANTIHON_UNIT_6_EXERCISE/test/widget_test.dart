import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pangantihon_unit6_exercise/main.dart';

void main() {
  testWidgets('Profile shows hobbies and the class schedule', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.text('Exploring technology'), findsOneWidget);
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(
      find.text('CC 207B - Applications Development and Emerging Technologies'),
      findsNWidgets(2),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profile remains scrollable on a small phone', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('A gallery photo can be made the favorite', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.photo_library_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Lookout logo'), findsOneWidget);

    await tester.tap(find.text('My dog'));
    await tester.pumpAndSettle();
    expect(find.text('Make favorite'), findsOneWidget);

    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });

  testWidgets('Reset count is disabled when the bark count is zero', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.pets_outlined));
    await tester.pumpAndSettle();

    final resetButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Reset count'),
    );
    expect(resetButton.onPressed, isNull);
  });
}
