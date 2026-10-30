
import 'package:flutter_test/flutter_test.dart';

import 'package:calotes_unit6_exercise/main.dart';

void main() {
  testWidgets('Pet app displays navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });
}
