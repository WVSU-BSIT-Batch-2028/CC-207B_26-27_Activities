
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:org_fair/config.dart';
import 'package:org_fair/data/event_repository.dart';
import 'package:org_fair/data/orgs.dart';
import 'package:org_fair/main.dart';

void main() {
  testWidgets('Org Fair app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(),
        events: EventRepository(createEventSource(http.Client())),
      ),
    );

    // Wait for the repository requests and their delayed responses.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    // Verify that the app starts and displays its main navigation.
    expect(find.byType(OrgFairApp), findsOneWidget);
  });
}
