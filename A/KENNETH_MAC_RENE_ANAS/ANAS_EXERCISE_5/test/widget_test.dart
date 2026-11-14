// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anas_unit5_exercise/main.dart';

void main() {
  testWidgets('shows the profile and its information', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kenneth Mac Rene V. Anas'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Technologies'), findsOneWidget);
    expect(find.text('Gaming'), findsOneWidget);
    expect(find.text('Reading'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('Gym'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('toggles between light and dark themes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(
      Theme.of(tester.element(find.byType(ProfileScreen))).brightness,
      Brightness.light,
    );

    await tester.tap(find.byTooltip('Switch to dark mode'));
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.byType(ProfileScreen))).brightness,
      Brightness.dark,
    );
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);
  });

  testWidgets('switches to the favorite animal screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('My favorite animal'), findsOneWidget);
    expect(find.text('Play dog sound'), findsOneWidget);
    expect(find.text('Dog sound played 0 times.'), findsOneWidget);
  });
}
