import 'package:flutter_test/flutter_test.dart';

import 'package:dasa_unit5_exercise/main.dart';

void main() {
  testWidgets('App opens on profile screen and shows navigation destinations',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Justine Dasa'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('My Pet'), findsWidgets);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('My Pet'), findsWidgets);
  });
}
