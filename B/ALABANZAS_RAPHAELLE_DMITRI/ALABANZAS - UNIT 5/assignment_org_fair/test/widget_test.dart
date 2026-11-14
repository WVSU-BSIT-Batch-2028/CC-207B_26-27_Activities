
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

void main() {
  testWidgets('Org Fair app loads organizations', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(
        repository: OrgRepository(),
      ),
    );

    // Advance the test clock to allow the repository's
    // 2-second delay to finish.
    await tester.pump(const Duration(seconds: 2));

    // Process the completed FutureBuilder update.
    await tester.pump();

    expect(find.text('CICT Org Fair'), findsOneWidget);
  });
}
