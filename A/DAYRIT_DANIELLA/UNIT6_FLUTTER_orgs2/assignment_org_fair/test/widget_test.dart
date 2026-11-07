import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows error state with a retry action', (tester) async {
    final repository = OrgRepository(mode: ServerMode.error, delay: Duration.zero);

    await tester.pumpWidget(OrgFairApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('No connection. Check your internet and try again.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('allows a successful reload after a retry', (tester) async {
    final repository = OrgRepository(mode: ServerMode.error, delay: Duration.zero);

    await tester.pumpWidget(OrgFairApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Try again'), findsOneWidget);

    repository.mode = ServerMode.success;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Computer Science Circle'), findsOneWidget);
  });
}
