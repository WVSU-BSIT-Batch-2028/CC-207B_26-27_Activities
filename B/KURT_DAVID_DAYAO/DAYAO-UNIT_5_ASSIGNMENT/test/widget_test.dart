import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('OrgFairApp loads its home screen', (tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository(delay: const Duration(milliseconds: 1))),
    );

    expect(find.text('CICT Org Fair'), findsOneWidget);
    expect(find.text('Loading organizations...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });
}
