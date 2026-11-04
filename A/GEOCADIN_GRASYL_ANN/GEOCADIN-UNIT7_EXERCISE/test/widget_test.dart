import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocadin_unit6_exercise/main.dart';

void main() {
  testWidgets('Profile app navigation works', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Information'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.pets));
    await tester.pumpAndSettle();

    expect(
      find.text('My pet has made a sound 0 times.'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.photo_library));
    await tester.pumpAndSettle();

   expect(find.byType(GridView), findsOneWidget);
  });
}