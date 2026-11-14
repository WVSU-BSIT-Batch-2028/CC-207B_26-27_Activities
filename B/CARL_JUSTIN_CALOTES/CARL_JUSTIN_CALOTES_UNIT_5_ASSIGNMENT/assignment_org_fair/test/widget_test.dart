// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';

void main() {
  testWidgets('CICT Org Fair app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository()),
    );

    await tester.pumpAndSettle();

    expect(find.text('CICT Org Fair'), findsOneWidget);
  });
}
