// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deguia_unit5_exercise/main.dart';

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  testWidgets('profile and pet screens are reachable', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfilePetApp());
    await tester.pumpAndSettle();

    final theme = Theme.of(tester.element(find.byType(HomeShell)));
    final appBarTheme = theme.appBarTheme;
    expect(
      _contrastRatio(
        appBarTheme.foregroundColor!,
        appBarTheme.backgroundColor!,
      ),
      greaterThanOrEqualTo(4.5),
    );
    final buttonStyle = theme.filledButtonTheme.style!;
    expect(
      _contrastRatio(
        buttonStyle.foregroundColor!.resolve(const {})!,
        buttonStyle.backgroundColor!.resolve(const {})!,
      ),
      greaterThanOrEqualTo(4.5),
    );

    expect(find.text('Ryzel John De Guia'), findsNWidgets(2));
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('Favorite animal'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('My Favorite Animal: Owl'), findsOneWidget);
    expect(find.text('Play owl hoot'), findsOneWidget);

    final photo = find.byKey(const Key('pet-photo'));
    await tester.tap(photo);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(photo);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
