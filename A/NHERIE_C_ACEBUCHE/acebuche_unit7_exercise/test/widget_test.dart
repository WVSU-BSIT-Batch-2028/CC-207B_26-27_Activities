import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:acebuche_unit7_exercise/main.dart';

void main() {
  testWidgets('shows four navigation destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Shelf'), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    await tester.tap(find.text('Shelf'));
    await tester.pumpAndSettle();
    expect(find.text('My Picks'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
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
