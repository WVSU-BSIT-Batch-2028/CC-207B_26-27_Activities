import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catalan_unit7_exercise/main.dart';

void main() {
  testWidgets('profile shows Unit 6 hobby chips and class schedule',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfileScreen()),
    );

    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.text('Coding'), findsOneWidget);
    expect(find.text('Photography'), findsOneWidget);
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.text('Subject'), findsOneWidget);
  });

  testWidgets('gallery opens a photo detail and returns to the grid',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: GalleryScreen()),
    );

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(6));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('Make favorite'), findsOneWidget);
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
  });
}
