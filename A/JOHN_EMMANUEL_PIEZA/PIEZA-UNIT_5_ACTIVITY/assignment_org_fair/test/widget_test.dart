
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';

void main() {
  testWidgets('Org Fair app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository()),
    );

    // Allow the delayed organization fetch to finish.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
