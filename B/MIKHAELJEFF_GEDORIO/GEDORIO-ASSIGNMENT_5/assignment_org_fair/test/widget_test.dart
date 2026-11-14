
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:assignment_org_fair/data/orgs.dart';

void main() {
  testWidgets('Org Fair app starts', (WidgetTester tester) async {
    await tester.pumpWidget(
      OrgFairApp(repository: OrgRepository()),
    );

    await tester.pumpAndSettle();

    expect(find.text('CICT Org Fair'), findsOneWidget);
  });
}
