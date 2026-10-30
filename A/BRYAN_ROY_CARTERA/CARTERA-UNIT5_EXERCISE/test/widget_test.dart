import 'package:flutter_test/flutter_test.dart';
import 'package:cartera_unit5_exercise/main.dart';

void main() {
  testWidgets('Profile and My Pet screens are displayed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}