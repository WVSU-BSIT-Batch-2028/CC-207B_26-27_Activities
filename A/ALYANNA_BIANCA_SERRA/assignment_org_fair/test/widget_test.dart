import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/screens/org_list_screen.dart';

void main() {
  testWidgets('Org Fair screen loads', (WidgetTester tester) async {
    final repository = OrgRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: OrgListScreen(repository: repository),
      ),
    );

    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
    );

    expect(find.byType(OrgListScreen), findsOneWidget);
  });
}
