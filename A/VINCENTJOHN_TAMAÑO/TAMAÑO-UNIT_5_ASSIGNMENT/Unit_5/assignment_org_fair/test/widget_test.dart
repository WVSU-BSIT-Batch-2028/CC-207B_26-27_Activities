import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('Org Fair app loads the organization list', (tester) async {
    final repository = OrgRepository(
      delay: const Duration(seconds: 2),
    );

    await tester.pumpWidget(OrgFairApp(repository: repository));
    expect(find.text('Loading organizations...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('CICT Org Fair'), findsOneWidget);
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });
}
