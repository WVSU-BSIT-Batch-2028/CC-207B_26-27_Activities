import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaguin_unit5_exercise/main.dart';

void main() {
  testWidgets('Profile and pet destinations are available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Justin Jerrickho Amaguin'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.byType(InfoTile), findsNWidgets(5));

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
