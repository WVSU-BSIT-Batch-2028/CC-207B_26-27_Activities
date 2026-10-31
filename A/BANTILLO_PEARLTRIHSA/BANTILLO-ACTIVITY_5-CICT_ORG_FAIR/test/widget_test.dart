
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';

void main() {
  testWidgets('CICT Org Fair app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository()),
    );

    // Allow the repository's 2-second timer to finish.
    await tester.pump(const Duration(seconds: 2));

    // Rebuild the screen after the timer completes.
    await tester.pump();

    expect(find.text('CICT Org Fair'), findsOneWidget);
  });
}
