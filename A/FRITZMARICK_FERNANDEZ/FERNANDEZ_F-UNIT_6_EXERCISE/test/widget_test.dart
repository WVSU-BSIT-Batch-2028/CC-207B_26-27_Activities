import 'package:flutter_test/flutter_test.dart';

import 'package:fernandez_f_unit_5_exercise/main.dart';

void main() {
  testWidgets('profile and pet navigation are available', (tester) async {
    await tester.pumpWidget(const FernandezProfileApp());

    expect(find.text('Fritz Marick A. Fernandez'), findsNWidgets(2));
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('Leonardo DiCapybara'), findsOneWidget);
    expect(find.text('Play pet sound'), findsOneWidget);
  });
}
