import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:delacruz_unit6_exercise/main.dart';

void main() {
  testWidgets('profile shows approved details, hobbies, and schedule', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfilePetApp());

    expect(find.text('Christian Paul De la Cruz'), findsNWidgets(2));
    expect(
      find.text('LIVING LIFE TO THE FULLEST, MEMENTO MORI'),
      findsOneWidget,
    );
    expect(find.text('West Visayas State University'), findsOneWidget);
    expect(find.text('BSIT 3A'), findsOneWidget);
    expect(find.text('Iloilo City, Philippines'), findsNothing);
    expect(find.text('My Hobbies'), findsOneWidget);
    for (final hobby in [
      'Cooking',
      'Reading books',
      'Travelling',
      'Gardening',
      'Running',
    ]) {
      expect(find.text(hobby), findsOneWidget);
    }
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.text('Human Computer Interaction'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation opens the pet screen and reset starts disabled', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfilePetApp());

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('Meet the sample dog.'), findsOneWidget);
    expect(find.text('Play sample bark'), findsOneWidget);
    expect(find.text('The sample dog has barked 0 times.'), findsOneWidget);
    final resetButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Reset count'),
    );
    expect(resetButton.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bark count survives switching tabs', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfilePetApp());
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Play sample bark'));
    await tester.tap(find.text('Play sample bark'));
    await tester.pump();
    tester.takeException();
    expect(find.text('The sample dog has barked 1 time.'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    expect(find.text('The sample dog has barked 1 time.'), findsOneWidget);
  });

  testWidgets('gallery opens photos and keeps only one favorite', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfilePetApp());
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Photo 1'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Photo 1'));
    await tester.pumpAndSettle();

    expect(find.text('Photo 1'), findsOneWidget);
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Photo 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset dialog only clears the bark count when confirmed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfilePetApp());
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Play sample bark'));
    await tester.tap(find.text('Play sample bark'));
    await tester.pump();
    tester.takeException();
    expect(find.text('The sample dog has barked 1 time.'), findsOneWidget);

    await tester.ensureVisible(find.text('Reset count'));
    await tester.tap(find.text('Reset count'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('The sample dog has barked 1 time.'), findsOneWidget);

    await tester.ensureVisible(find.text('Reset count'));
    await tester.tap(find.text('Reset count'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset').last);
    await tester.pumpAndSettle();
    expect(find.text('The sample dog has barked 0 times.'), findsOneWidget);
    tester.takeException();
  });
}
