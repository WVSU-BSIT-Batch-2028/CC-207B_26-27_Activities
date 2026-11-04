import 'package:flutter_test/flutter_test.dart';
import 'package:pieza_unit5_exercise/main.dart';

void main() {
  testWidgets('Profile screen displays required content',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('John Emmanuel Pieza'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Favorite Animal'), findsOneWidget);
  });

  testWidgets('My Pet screen displays the animal and sound button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Favorite Animal'));
    await tester.pumpAndSettle();

    expect(find.text('My Favorite Prehistoric Animal'), findsOneWidget);
    expect(find.text('T Rex'), findsOneWidget);
    expect(find.text('Play dinosaur sound'), findsOneWidget);
  });
}