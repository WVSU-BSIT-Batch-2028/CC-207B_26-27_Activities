
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';

void main() {
  testWidgets('Org Fair app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository()),
    );

    // Allow time for the repository fetch and screen rebuild.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('CICT Org Fair'), findsOneWidget);
  });
}
