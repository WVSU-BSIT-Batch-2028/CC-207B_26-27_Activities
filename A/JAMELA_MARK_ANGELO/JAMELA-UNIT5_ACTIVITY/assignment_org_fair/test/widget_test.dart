import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/main.dart';

class _CountingOrgRepository extends OrgRepository {
  _CountingOrgRepository({super.mode}) : super(delay: Duration.zero);

  int fetchCount = 0;

  @override
  Future<List<Org>> fetchOrgs() {
    fetchCount++;
    return super.fetchOrgs();
  }
}

Future<void> _showOrgList(WidgetTester tester, OrgRepository repository) async {
  await tester.pumpWidget(OrgFairApp(repository: repository));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('TODO 1: fetch organizations once when the list screen starts', (
    WidgetTester tester,
  ) async {
    final repository = _CountingOrgRepository();

    await _showOrgList(tester, repository);

    expect(repository.fetchCount, 1);
    expect(find.text('Computer Science Circle'), findsOneWidget);
  });

  testWidgets('TODO 2: refresh fetches organizations again', (
    WidgetTester tester,
  ) async {
    final repository = _CountingOrgRepository(mode: ServerMode.empty);

    await _showOrgList(tester, repository);
    expect(repository.fetchCount, 1);

    await tester.tap(find.text('Refresh'));
    await tester.pumpAndSettle();

    expect(repository.fetchCount, 2);
    expect(
      find.text('No organizations have signed up for the fair yet.'),
      findsOneWidget,
    );
  });

  testWidgets('TODO 3: long-pressing an organization toggles its favorite', (
    WidgetTester tester,
  ) async {
    await _showOrgList(tester, OrgRepository(delay: Duration.zero));

    await tester.longPress(find.text('Computer Science Circle'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('TODO 4: errors show a Try again action', (
    WidgetTester tester,
  ) async {
    await _showOrgList(
      tester,
      OrgRepository(mode: ServerMode.error, delay: Duration.zero),
    );

    expect(
      find.text('No connection. Check your internet and try again.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('TODO 5: an empty result shows the empty-state message', (
    WidgetTester tester,
  ) async {
    await _showOrgList(
      tester,
      OrgRepository(mode: ServerMode.empty, delay: Duration.zero),
    );

    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(
      find.text('No organizations have signed up for the fair yet.'),
      findsOneWidget,
    );
    expect(find.text('Refresh'), findsOneWidget);
  });

  testWidgets('TODO 6: typing in search filters the organization list', (
    WidgetTester tester,
  ) async {
    await _showOrgList(tester, OrgRepository(delay: Duration.zero));

    await tester.enterText(find.byType(TextField), 'pixel');
    await tester.pumpAndSettle();

    expect(find.text('Pixel Arts Guild'), findsOneWidget);
    expect(find.text('Computer Science Circle'), findsNothing);
  });

  testWidgets('TODO 7: dismissing an organization hides it and offers undo', (
    WidgetTester tester,
  ) async {
    await _showOrgList(tester, OrgRepository(delay: Duration.zero));

    await tester.drag(
      find.text('Computer Science Circle'),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Computer Science Circle'), findsNothing);
    expect(find.text('CSC hidden'), findsOneWidget);
    expect(find.text('UNDO'), findsOneWidget);
  });
}
