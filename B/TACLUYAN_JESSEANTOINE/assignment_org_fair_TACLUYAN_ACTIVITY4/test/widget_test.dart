import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('Org Fair app builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(delay: Duration.zero),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}