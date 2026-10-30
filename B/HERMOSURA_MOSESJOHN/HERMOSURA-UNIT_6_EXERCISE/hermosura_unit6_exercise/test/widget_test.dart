import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hermosura_unit6_exercise/main.dart';

void main() {
  testWidgets('navigation switches between Profile and My Pet', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Moses John Hermosura'), findsNWidgets(2));
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('BSIT'), findsOneWidget);
    expect(find.text('West Visayas State University'), findsOneWidget);
    expect(find.text('Tilap'), findsOneWidget);
    expect(find.byType(InfoTile), findsNWidgets(5));
    expect(find.text('Sagad mag standing sa modern jeep'), findsOneWidget);
    expect(find.text('My Biography'), findsOneWidget);
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.byType(Chip), findsNWidgets(5));
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.byType(Table), findsOneWidget);
    expect(
      find.textContaining('I am Moses, 20, and currently a 3rd Year BSIT'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Photo of Moses John Hermosura'),
      findsOneWidget,
    );
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );

    await tester.tap(find.text('My Pet').last);
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
    expect(find.text('Tilap is my pet cat'), findsOneWidget);
    expect(find.text('Reset count'), findsOneWidget);
    expect(find.bySemanticsLabel('Photo of Tilap, my cat'), findsOneWidget);

    final photoFinder = find.bySemanticsLabel('Photo of Tilap, my cat');

    Future<void> doubleTapPhoto() async {
      final position = tester.getCenter(photoFinder);
      final firstTap = await tester.startGesture(position);
      await firstTap.up();
      await tester.pump(const Duration(milliseconds: 50));
      final secondTap = await tester.startGesture(position);
      await secondTap.up();
      await tester.pump();
    }

    await doubleTapPhoto();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    await doubleTapPhoto();
    expect(find.byIcon(Icons.favorite), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Profile').last);
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
  });
}
