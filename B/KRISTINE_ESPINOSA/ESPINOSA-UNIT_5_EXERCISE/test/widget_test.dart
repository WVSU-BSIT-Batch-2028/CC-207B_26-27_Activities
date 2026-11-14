import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:espinosa_unit5_exercise/screens/profile_screen.dart';

void main() {
  testWidgets('Profile screen shows the biography and info rows', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('Hobbies'), findsOneWidget);
  });
}
