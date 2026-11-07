// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('profile and Cookie remembrance are available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Daniella\nDayrit'), findsOneWidget);
    expect(find.text('About me'), findsOneWidget);

    await tester.tap(find.text('Cookie'));
    await tester.pumpAndSettle();

    expect(find.text('A place in my heart'), findsOneWidget);
    expect(find.text('My sweet Cookie'), findsOneWidget);
  });
}
