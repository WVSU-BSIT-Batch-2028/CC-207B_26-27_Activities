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
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.byType(Chip), findsNWidgets(6));
    expect(find.text('My Class Schedule'), findsOneWidget);
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

  testWidgets('switches to the pet and gallery screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('My favorite animal is dog'), findsOneWidget);
    expect(find.text('Bark'), findsOneWidget);
    expect(find.text('Dog barked 0 times.'), findsOneWidget);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(find.text('My Gallery'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Profile portrait'), findsOneWidget);

    await tester.tap(find.text('Profile portrait'));
    await tester.pumpAndSettle();
    expect(find.text('Make favorite'), findsOneWidget);

    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('confirms before resetting the bark count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Bark'));
    await tester.tap(find.text('Bark'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Dog barked 1 time.'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    expect(find.text('Dog barked 1 time.'), findsOneWidget);

    await tester.ensureVisible(find.text('Reset count'));
    await tester.tap(find.text('Reset count'));
    await tester.pumpAndSettle();
    expect(find.text('Reset the count?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Dog barked 1 time.'), findsOneWidget);

    await tester.ensureVisible(find.text('Reset count'));
    await tester.tap(find.text('Reset count'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Dog barked 0 times.'), findsOneWidget);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );
  });

  testWidgets('lays out profile and gallery on a narrow screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
