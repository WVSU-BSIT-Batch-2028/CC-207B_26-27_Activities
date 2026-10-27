import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';

void main() {
  testWidgets('Loads and displays organizations', (tester) async {
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(delay: const Duration(milliseconds: 100)),
      ),
    );

    expect(find.text('Loading organizations...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    expect(find.text('CICT Org Fair'), findsOneWidget);
    expect(find.text('Computer Science Circle'), findsOneWidget);
    expect(find.text('Loading organizations...'), findsNothing);
  });
}
