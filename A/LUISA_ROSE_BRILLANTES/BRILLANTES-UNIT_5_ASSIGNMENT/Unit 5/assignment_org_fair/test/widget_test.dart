import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('app loads', (tester) async {
    // Use a zero-delay repository so the Future resolves immediately.
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(delay: Duration.zero),
      ),
    );

    // Let the zero-duration timer fire and the FutureBuilder rebuild.
    await tester.pumpAndSettle();

    expect(find.text('CICT Org Fair'), findsOneWidget);
  });
}
