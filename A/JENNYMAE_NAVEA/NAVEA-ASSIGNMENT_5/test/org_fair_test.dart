import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assignment_org_fair/data/orgs.dart';
import 'package:assignment_org_fair/models/registration.dart';
import 'package:assignment_org_fair/screens/join_form_screen.dart';
import 'package:assignment_org_fair/screens/org_detail_screen.dart';
import 'package:assignment_org_fair/screens/org_list_screen.dart';
import 'package:assignment_org_fair/widgets/org_card.dart';

const testOrg = Org(
  id: 'test-org',
  name: 'Test Organization',
  acronym: 'TEST',
  description: 'An organization for widget tests.',
  category: OrgCategory.academic,
  members: 25,
);

void main() {
  group('CICT Org Fair Assignment Tests', () {
    testWidgets('TODO 1: OrgListScreen fetches and displays organizations', (
      WidgetTester tester,
    ) async {
      final repository = OrgRepository(delay: Duration.zero);
      await tester.pumpWidget(
        MaterialApp(home: OrgListScreen(repository: repository)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OrgListScreen), findsOneWidget);
      expect(find.text('Computer Science Circle'), findsOneWidget);
    });

    testWidgets('TODOs 2, 4, and 5: Retry and refresh reload server states', (
      WidgetTester tester,
    ) async {
      final repository = OrgRepository(
        mode: ServerMode.error,
        delay: Duration.zero,
      );
      await tester.pumpWidget(
        MaterialApp(home: OrgListScreen(repository: repository)),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('No connection. Check your internet and try again.'),
        findsOneWidget,
      );
      repository.mode = ServerMode.success;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Computer Science Circle'), findsOneWidget);

      final emptyRepository = OrgRepository(
        mode: ServerMode.empty,
        delay: Duration.zero,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: OrgListScreen(
            key: const ValueKey('empty-state-test'),
            repository: emptyRepository,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('No organizations have signed up for the fair yet.'),
        findsOneWidget,
      );

      emptyRepository.mode = ServerMode.success;
      await tester.tap(find.text('Refresh'));
      await tester.pumpAndSettle();
      expect(find.text('Computer Science Circle'), findsOneWidget);
    });

    testWidgets('TODOs 3 and 6: Search filters and long-press favorites', (
      WidgetTester tester,
    ) async {
      final repository = OrgRepository(delay: Duration.zero);
      await tester.pumpWidget(
        MaterialApp(home: OrgListScreen(repository: repository)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Computer Science');
      await tester.pumpAndSettle();
      expect(find.text('Computer Science Circle'), findsOneWidget);
      expect(find.text('IT Student Organization'), findsNothing);

      await tester.longPress(find.text('Computer Science Circle'));
      await tester.pump();
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(OrgCard), findsOneWidget);
    });

    testWidgets('TODOs 7 and 8: Dismiss cards and disable Join for members', (
      WidgetTester tester,
    ) async {
      final repository = OrgRepository(delay: Duration.zero);
      await tester.pumpWidget(
        MaterialApp(home: OrgListScreen(repository: repository)),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.text('Computer Science Circle'),
        const Offset(-700, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Computer Science Circle'), findsNothing);

      await tester.pumpWidget(
        const MaterialApp(home: OrgDetailScreen(org: testOrg, isMember: true)),
      );
      final joinButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(joinButton.onPressed, isNull);
      expect(find.text('Already a member'), findsOneWidget);
    });

    testWidgets('TODOs 9 and 10: Validate, save, and return a registration', (
      WidgetTester tester,
    ) async {
      _setTallTestView(tester);
      await tester.pumpWidget(const MaterialApp(home: _RegistrationTestHost()));

      await tester.tap(find.text('Open join form'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Jane Doe');
      await tester.enterText(fields.at(1), 'jane@wvsu.edu.ph');
      await tester.enterText(fields.at(2), '123456');
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Year 1').last);
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -1200));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe|jane@wvsu.edu.ph|123456|1'), findsOneWidget);
      expect(find.byType(JoinFormScreen), findsNothing);
    });

    testWidgets('TODOs 11 and 12: Validate school email and student ID', (
      WidgetTester tester,
    ) async {
      _setTallTestView(tester);
      await tester.pumpWidget(
        const MaterialApp(home: JoinFormScreen(org: testOrg)),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'not-a-school-email');
      await tester.pumpAndSettle();
      expect(
        find.text('Use your school email, like juan@wvsu.edu.ph'),
        findsOneWidget,
      );

      final studentIdField = _textFormField('Student ID number');
      await tester.enterText(studentIdField, 'abc12');
      await tester.pumpAndSettle();
      final studentIdInput = tester.widget<EditableText>(
        find.descendant(
          of: studentIdField,
          matching: find.byType(EditableText),
        ),
      );
      expect(studentIdInput.controller.text, '12');
      expect(find.text('Enter at least 6 digits'), findsOneWidget);
    });

    testWidgets('TODOs 13 and 14: Inputs update state and gate Submit', (
      WidgetTester tester,
    ) async {
      _setTallTestView(tester);
      await tester.pumpWidget(
        const MaterialApp(home: JoinFormScreen(org: testOrg)),
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit'))
            .onPressed,
        isNull,
      );

      final switchTile = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchTile.value, isTrue);
      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isFalse,
      );

      await tester.drag(find.byType(Slider), const Offset(80, 0));
      await tester.pump();
      expect(tester.widget<Slider>(find.byType(Slider)).value, greaterThan(3));

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Submit'))
            .onPressed,
        isNotNull,
      );
    });
  });
}

void _setTallTestView(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Finder _textFormField(String label) {
  return find.widgetWithText(TextFormField, label);
}

class _RegistrationTestHost extends StatefulWidget {
  const _RegistrationTestHost();

  @override
  State<_RegistrationTestHost> createState() => _RegistrationTestHostState();
}

class _RegistrationTestHostState extends State<_RegistrationTestHost> {
  Registration? _registration;

  Future<void> _openForm() async {
    final registration = await Navigator.of(context).push<Registration>(
      MaterialPageRoute(builder: (_) => const JoinFormScreen(org: testOrg)),
    );
    if (registration != null && mounted) {
      setState(() => _registration = registration);
    }
  }

  @override
  Widget build(BuildContext context) {
    final registration = _registration;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _openForm,
              child: const Text('Open join form'),
            ),
            if (registration != null)
              Text(
                '${registration.fullName}|${registration.email}|'
                '${registration.studentId}|${registration.yearLevel}',
              ),
          ],
        ),
      ),
    );
  }
}
