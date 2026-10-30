// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('shows empty state when there are no organizations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(mode: ServerMode.empty, delay: Duration.zero),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CICT Org Fair'), findsOneWidget);
    expect(
      find.text('No organizations have signed up for the fair yet.'),
      findsOneWidget,
    );
  });

  testWidgets('navigates between the fair tabs and opens the about page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    expect(find.text('CICT Org Fair'), findsOneWidget);
    expect(find.text('Orgs'), findsOneWidget);
    expect(find.text('My Orgs'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);

    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Booth schedule'), findsOneWidget);
    expect(find.text('8:00 AM'), findsNWidgets(2));

    await tester.tap(find.text('My Orgs'));
    await tester.pumpAndSettle();
    expect(
      find.text('You have not joined any organizations yet.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Orgs'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About the fair'));
    await tester.pumpAndSettle();
    expect(find.text('CICT Org Fair 2026'), findsOneWidget);
    expect(find.text('November 5, 2026'), findsOneWidget);
  });

  testWidgets('category filters and grid toggle match the selected view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sports'));
    await tester.pumpAndSettle();
    expect(find.text('CICT Ballers'), findsOneWidget);
    expect(find.text('Shuttle Smashers'), findsOneWidget);
    expect(find.text('Computer Science Circle'), findsNothing);

    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('organization details include officer and event tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('CICT Robotics Club'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Officers'));
    await tester.pumpAndSettle();
    expect(find.text('Kian Mendoza'), findsOneWidget);

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();
    expect(find.text('Robotics Open Lab'), findsOneWidget);
  });

  testWidgets('joining and leaving an organization updates membership', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('CICT Robotics Club'));
    await tester.pumpAndSettle();
    expect(find.text('CRC'), findsOneWidget);
    await tester.drag(find.byType(ListView).last, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Join CRC'), findsOneWidget);
    await tester.tap(find.text('Join CRC'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Taylor Student');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'taylor@wvsu.edu.ph',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '12345678');
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Year 2').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Submit'));
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    await tester.tap(find.text('Orgs'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();
    expect(find.text('Joined'), findsOneWidget);

    await tester.tap(find.text('My Orgs'));
    await tester.pumpAndSettle();
    expect(find.text('CICT Robotics Club'), findsOneWidget);

    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    await tester.tap(find.text('My Orgs'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Leave CRC'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave').last);
    await tester.pumpAndSettle();
    expect(
      find.text('You have not joined any organizations yet.'),
      findsOneWidget,
    );
  });
}
