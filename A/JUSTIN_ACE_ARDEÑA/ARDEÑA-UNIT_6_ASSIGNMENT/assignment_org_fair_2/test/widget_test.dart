import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit6_org_fair/data/orgs.dart';
import 'package:unit6_org_fair/main.dart';

void main() {
  testWidgets('Org Fair starts and loads organizations', (tester) async {
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(delay: const Duration(milliseconds: 100)),
      ),
    );

    expect(find.text('CICT Org Fair'), findsOneWidget);
    expect(find.text('Loading organizations...'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // Advance the fake server delay, then render the loaded organizations.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.text('Loading organizations...'), findsNothing);
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });
}
