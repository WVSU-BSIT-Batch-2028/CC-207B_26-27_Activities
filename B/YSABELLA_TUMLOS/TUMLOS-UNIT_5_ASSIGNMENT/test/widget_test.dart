import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('Org Fair shows loading, then the org list', (tester) async {
    await tester.pumpWidget(OrgFairApp(repository: OrgRepository()));

    // Loading state while the fake server waits.
    expect(find.text('Loading organizations...'), findsOneWidget);

    // Let the fake 2-second request finish.
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Loading organizations...'), findsNothing);
    expect(find.text('Search organizations'), findsOneWidget);
  });
}