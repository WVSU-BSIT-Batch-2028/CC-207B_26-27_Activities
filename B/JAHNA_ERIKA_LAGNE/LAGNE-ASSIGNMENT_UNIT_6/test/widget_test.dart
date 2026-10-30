
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit6_org_fair/main.dart';
import 'package:unit6_org_fair/data/orgs.dart';

void main() {
  testWidgets('Org Fair app loads successfully', (
    WidgetTester tester,
  ) async {
    // Set the test screen size.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.reset);

    // Launch the Org Fair app.
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(
          delay: const Duration(milliseconds: 100),
        ),
      ),
    );

    // Check that the loading message appears.
    expect(find.text('Loading organizations...'), findsOneWidget);

    // Wait for the organizations to load.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();

    // Check that an organization appears.
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });
}
