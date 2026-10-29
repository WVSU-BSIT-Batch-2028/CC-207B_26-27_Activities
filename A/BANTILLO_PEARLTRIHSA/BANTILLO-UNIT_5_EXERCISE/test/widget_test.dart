
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bantillo_unit5_exercise/main.dart';

void main() {
  testWidgets('Profile and pet app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
  });
}
