// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:acebuche_unit6_exercise/main.dart';

void main() {
  testWidgets('shows three navigation destinations', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });

  testWidgets('makes a gallery photo favorite', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(
        const ValueKey('gallery-assets/images/gallery/charcoal_contest.jpg'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
