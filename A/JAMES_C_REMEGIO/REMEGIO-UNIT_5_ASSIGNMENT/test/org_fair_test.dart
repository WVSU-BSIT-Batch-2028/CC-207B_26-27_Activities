import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  Future<void> openApp(
    WidgetTester tester, {
    ServerMode mode = ServerMode.success,
  }) async {
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(
          mode: mode,
          delay: const Duration(milliseconds: 10),
        ),
      ),
    );
  }

  testWidgets('loads the organization list', (tester) async {
    await openApp(tester);
    expect(find.text('Loading organizations...'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsOneWidget);
    expect(find.text('CICT Robotics Club'), findsOneWidget);
  });

  testWidgets('shows an empty state and refresh action', (tester) async {
    await openApp(tester, mode: ServerMode.empty);
    await tester.pumpAndSettle();
    expect(
      find.text('No organizations have signed up for the fair yet.'),
      findsOneWidget,
    );
    expect(find.text('Refresh'), findsOneWidget);
  });

  testWidgets('shows an error and retries the request', (tester) async {
    final repository = OrgRepository(
      mode: ServerMode.error,
      delay: const Duration(milliseconds: 10),
    );
    await tester.pumpWidget(OrgFairApp(repository: repository));
    await tester.pumpAndSettle();
    expect(find.textContaining('No connection.'), findsOneWidget);
    repository.mode = ServerMode.success;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });

  testWidgets('search filters organizations as the user types', (tester) async {
    await openApp(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'robotics');
    await tester.pump();
    expect(find.text('CICT Robotics Club'), findsOneWidget);
    expect(find.text('Computer Science Circle'), findsNothing);
  });

  testWidgets('long press toggles a favorite', (tester) async {
    await openApp(tester);
    await tester.pumpAndSettle();
    final org = find.text('CICT Robotics Club');
    await tester.longPress(org);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('swiping dismisses an organization from the list', (tester) async {
    await openApp(tester);
    await tester.pumpAndSettle();
    await tester.drag(find.text('Computer Science Circle'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsNothing);
  });

  testWidgets('valid registration returns to the list as joined', (tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await openApp(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).at(2));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Join CRC'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Join CRC'), findsOneWidget);
    await tester.tap(find.text('Join CRC'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'James Remegio');
    await tester.enterText(fields.at(1), 'james@wvsu.edu.ph');
    await tester.enterText(fields.at(2), '2026001234');
    await tester.tap(find.text('Year level'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Year 1').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('I agree to follow the org constitution'));
    await tester.pump();
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('CICT Robotics Club'), findsOneWidget);
    expect(find.text('Joined'), findsOneWidget);
  });
}
