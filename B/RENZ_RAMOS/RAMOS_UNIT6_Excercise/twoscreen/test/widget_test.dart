import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ramos_unit5_excercise/main.dart';

void main() {
  testWidgets('shows the three Unit 6 navigation destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });

  testWidgets('resetting the meow count requires confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byTooltip('Reset meow count'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byTooltip('Reset meow count'));
    await tester.pumpAndSettle();

    expect(find.text('Reset meow count?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });

  testWidgets('gallery opens a photo detail screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ming says hello'));
    await tester.pumpAndSettle();

    expect(find.text('Send answer back'), findsOneWidget);
  });
}
