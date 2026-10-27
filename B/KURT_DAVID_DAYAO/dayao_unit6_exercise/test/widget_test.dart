// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:dayao_unit_5_exercise/main.dart';

void main() {
  testWidgets('App navigation switches between profile, pet, and gallery',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kurt David G. Dayao'), findsWidgets);

    await tester.tap(find.text('My Pet'));
    await tester.pump();
    expect(find.text('My Pet'), findsWidgets);
    expect(find.text('Make Summer bark'), findsOneWidget);

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(find.text('My Gallery'), findsOneWidget);
  });
}
