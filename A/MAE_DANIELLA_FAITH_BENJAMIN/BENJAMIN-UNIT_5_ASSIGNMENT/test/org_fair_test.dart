//============================================================================
// NOTE: AI-GENERATED TEST SUITE
//
// This test file was generated with the assistance of ChatGPT to verify the
// implementation of TODOs 1–14 in the CC 207B Unit 5 CICT Org Fair assignment.
//
// The assignment instructions reference a test/org_fair_test.dart file
// containing seven automated tests. However, this file was not included in
// the starter project or found in the official Activities and
// Samples repositories at the time of checking.
//
// The starter project instead contains test/widget_test.dart, which references
// the default Flutter MyApp class and fails to compile because that class
// does not exist in the CICT Org Fair application.
//
// Therefore, this additional test suite was created to independently check
// the required functionalities without modifying or deleting the original
// test file.

// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/models/registration.dart';
import 'package:assignment_org_fair/screens/join_form_screen.dart';
import 'package:assignment_org_fair/screens/org_detail_screen.dart';

void main() {
  // TODOs 1 and 6: Load organizations and filter the list.
  testWidgets('1: loads organizations and searches by name', (tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Computer Science Circle'), findsOneWidget);
    expect(find.text('CICT Robotics Club'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Robotics');
    await tester.pumpAndSettle();
    expect(find.text('CICT Robotics Club'), findsOneWidget);
    expect(find.text('Computer Science Circle'), findsNothing);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });

  // TODOs 2 and 4: Show errors and allow retrying.
  testWidgets('2: shows error and retries successfully', (tester) async {
    final repository = OrgRepository(
      mode: ServerMode.error,
      delay: Duration.zero,
    );
    await tester.pumpWidget(OrgFairApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    expect(
      find.text('No connection. Check your internet and try again.'),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);

    repository.mode = ServerMode.success;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });

  // TODO 5: Show empty state and refresh it.
  testWidgets('3: shows empty state and refreshes', (tester) async {
    final repository = OrgRepository(
      mode: ServerMode.empty,
      delay: Duration.zero,
    );
    await tester.pumpWidget(OrgFairApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(
      find.text('No organizations have signed up for the fair yet.'),
      findsOneWidget,
    );

    repository.mode = ServerMode.success;
    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });

  // TODOs 3 and 7: Favorite by long press and hide by swipe.
  testWidgets('4: toggles favorite and dismisses organization', (tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    final title = find.text('Computer Science Circle');
    expect(title, findsOneWidget);
    expect(find.byIcon(Icons.star), findsNothing);

    await tester.longPress(title);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsWidgets);

    await tester.longPress(title);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNothing);

    final card = find.byKey(const ValueKey('csc'));
    expect(card, findsOneWidget);
    await tester.drag(card, const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(find.text('CSC hidden'), findsOneWidget);
    expect(title, findsNothing);
  });

  // TODO 8: Disable Join for existing members.
  testWidgets('5: Join is enabled for nonmembers and disabled for members',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(
      home: OrgDetailScreen(org: sampleOrgs.first, isMember: false),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Join CSC'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull);

    await tester.pumpWidget(MaterialApp(
      home: OrgDetailScreen(org: sampleOrgs.first, isMember: true),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Already a member'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
  });

  // TODOs 11 and 12: Validate email and student ID.
  testWidgets('6: validates school email and numeric student ID',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(
      home: JoinFormScreen(org: sampleOrgs.first),
    ));
    await tester.pumpAndSettle();

    final email = find.widgetWithText(TextFormField, 'WVSU email');
    final studentId = find.widgetWithText(TextFormField, 'Student ID number');

    await tester.enterText(email, 'student@gmail.com');
    await tester.pumpAndSettle();
    expect(
      find.text('Use your school email, like juan@wvsu.edu.ph'),
      findsOneWidget,
    );

    await tester.enterText(email, 'student@wvsu.edu.ph');
    await tester.pumpAndSettle();
    expect(
      find.text('Use your school email, like juan@wvsu.edu.ph'),
      findsNothing,
    );

    await tester.enterText(studentId, 'abc');
    await tester.pumpAndSettle();
    expect(find.text('abc'), findsNothing);

    await tester.enterText(studentId, '12345');
    await tester.pumpAndSettle();
    expect(find.text('Enter at least 6 digits'), findsOneWidget);

    await tester.enterText(studentId, '202410123');
    await tester.pumpAndSettle();
    expect(find.text('Enter at least 6 digits'), findsNothing);
  });

  // TODOs 9, 10, 13 and 14: Interact with inputs, validate, save, return data.
  testWidgets('7: enables Submit after agreement and returns registration',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Registration? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              result = await Navigator.of(context).push<Registration>(
                MaterialPageRoute(
                  builder: (_) => JoinFormScreen(org: sampleOrgs.first),
                ),
              );
            },
            child: const Text('Open form'),
          );
        }),
      ),
    ));
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();

    final submit = find.widgetWithText(FilledButton, 'Submit');
    expect(tester.widget<FilledButton>(submit).onPressed, isNull);

    // Checkbox, switch and slider must update their displayed values.
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);

    final switchTile = find.byType(SwitchListTile);
    expect(tester.widget<SwitchListTile>(switchTile).value, isTrue);
    await tester.tap(switchTile);
    await tester.pumpAndSettle();
    expect(tester.widget<SwitchListTile>(switchTile).value, isFalse);

    final slider = find.byType(Slider);
    await tester.drag(slider, const Offset(80, 0));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, greaterThan(3));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Test Student',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'WVSU email'),
      'test.student@wvsu.edu.ph',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Student ID number'),
      '202410123',
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Year 3').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.fullName, 'Test Student');
    expect(result!.email, 'test.student@wvsu.edu.ph');
    expect(result!.studentId, '202410123');
    expect(result!.yearLevel, 3);
    expect(result!.wantsUpdates, isFalse);
    expect(result!.hoursPerWeek, greaterThan(3));
  });
}
