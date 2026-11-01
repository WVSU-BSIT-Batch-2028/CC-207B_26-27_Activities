import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dasa_unit5_exercise/main.dart';

void main() {
  testWidgets('App shows all three destinations and opens each screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Justine Dasa'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('My Pet'), findsWidgets);
    expect(find.text('Gallery'), findsWidgets);
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.text('Human Computer Interaction 2'), findsOneWidget);
    expect(find.text('Security Compliance and Governance'), findsOneWidget);
    expect(find.text('Web Systems and Technologies'), findsOneWidget);
    expect(find.text('Research'), findsOneWidget);
    expect(find.text('App Dev & Emerging Tech'), findsOneWidget);
    expect(find.text('Technopreneurship'), findsOneWidget);
    expect(find.text('Networking'), findsOneWidget);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('My Pet'), findsWidgets);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Reset count'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(find.text('girlfriend'), findsOneWidget);
    await tester.tap(find.text('girlfriend'));
    await tester.pumpAndSettle();
    expect(find.text('Make favorite'), findsOneWidget);

    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    final firstFavorite = find.byKey(const ValueKey('favorite-girlfriend'));
    expect(firstFavorite, findsOneWidget);

    await tester.tap(find.text('A day with friends'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(firstFavorite, findsOneWidget);
    expect(
      find.byKey(const ValueKey('favorite-A day with friends')),
      findsNothing,
    );

    await tester.tap(find.text('A day with friends'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(firstFavorite, findsNothing);
    expect(
      find.byKey(const ValueKey('favorite-A day with friends')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('favorite-A day with friends')),
      findsOneWidget,
    );
  });
}
