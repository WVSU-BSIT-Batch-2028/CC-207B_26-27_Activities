
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';
import '../lib/data/orgs.dart';
import '../lib/screens/org_list_screen.dart';

void main() {
  testWidgets(
    'Organization Fair app launches successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        OrgFairApp(
          repository: OrgRepository(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(OrgListScreen), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
  );
}
