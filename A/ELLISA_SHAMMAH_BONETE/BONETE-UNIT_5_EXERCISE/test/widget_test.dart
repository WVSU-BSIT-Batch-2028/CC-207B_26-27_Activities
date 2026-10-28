import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bonete_unit5_exercise/main.dart';

void main() {
  testWidgets('Profile info and pet tab are displayed', (tester) async {
    await tester.pumpWidget(const ProfilePetApp());

    expect(find.text('Your Full Name'), findsWidgets);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('About Me'), findsOneWidget);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('Meet Mochi!'), findsOneWidget);
    expect(find.text('Play rabbit sound'), findsOneWidget);
    expect(find.text('Mochi has meowed 0 times.'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
