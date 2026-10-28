// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/widgets/org_card.dart';

void main() {
  testWidgets('OrgFairApp loads OrgListScreen', (WidgetTester tester) async {
    await tester.pumpWidget(OrgFairApp(repository: OrgRepository()));

    // Wait for fetchOrgs() to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that the app title appears
    expect(find.text('CICT Org Fair'), findsOneWidget);

    // Verify that at least one acronym from sampleOrgs is shown
    expect(find.text('CSC'), findsWidgets); // Computer Science Circle
  });

  testWidgets('Join form shows validation errors', (WidgetTester tester) async {
    await tester.pumpWidget(OrgFairApp(repository: OrgRepository()));

    // Wait for orgs to load
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap the first OrgCard
    await tester.tap(find.byType(OrgCard).first);
    await tester.pumpAndSettle();

    // Tap the Join button
    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    // Try submitting without filling anything
    await tester.tap(find.text('Submit'));
    await tester.pump();

    // Expect validation error messages
    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your WVSU email'), findsOneWidget);
    expect(find.text('Choose your year level'), findsOneWidget);
  });

  testWidgets('Submit button disabled until agreed', (WidgetTester tester) async {
    await tester.pumpWidget(OrgFairApp(repository: OrgRepository()));

    // Wait for orgs to load
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to JoinFormScreen
    await tester.tap(find.byType(OrgCard).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    // Initially, Submit should be disabled
    final Finder submitButton = find.widgetWithText(FilledButton, 'Submit');
    expect(tester.widget<FilledButton>(submitButton).onPressed, isNull);

    // Tick the agreement checkbox
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();

    // Now Submit should be enabled
    expect(tester.widget<FilledButton>(submitButton).onPressed, isNotNull);
  });
}
