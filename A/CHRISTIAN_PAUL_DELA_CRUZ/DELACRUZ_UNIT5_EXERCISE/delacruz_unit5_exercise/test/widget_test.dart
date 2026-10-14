import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:delacruz_unit5_exercise/main.dart';

void main() {
  testWidgets('profile shows student information and biography', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProfilePetApp());

    expect(find.text('Christian Paul De la Cruz'), findsNWidgets(2));
    expect(find.text('My Biography'), findsOneWidget);
    expect(
      find.text('Music, writing stories, cooking, and playing games'),
      findsOneWidget,
    );
    expect(find.text('BSIT 3A'), findsOneWidget);
    expect(find.text('Dog'), findsOneWidget);
    expect(find.text('Iloilo City, Philippines'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation opens the favorite-animal screen', (tester) async {
    await tester.pumpWidget(const ProfilePetApp());

    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.text('My Pet'), findsNWidgets(2));
    expect(find.text('Dogs are my favorite animal.'), findsOneWidget);
    expect(
      find.text('Here is a dog while I get my own photo ready.'),
      findsNothing,
    );
    expect(find.text('Play sample bark'), findsOneWidget);
    expect(find.text('The sample dog has barked 0 times.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('double-tapping the animal picture toggles its heart', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfilePetApp());
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Photo of a dog'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.bySemanticsLabel('Photo of a dog'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
