import 'package:flutter_test/flutter_test.dart';
import 'package:brillantes_unit5_exercise/main.dart';

void main() {
  testWidgets('app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('My Pet'), findsWidgets);
  });
}
