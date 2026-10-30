import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moje_unit6_exercise/main.dart';

void main() {
  testWidgets(
    'Photo result selects exactly one favorite and back preserves it',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GalleryScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey(photos[0].asset)));
      await tester.pumpAndSettle();
      expect(find.text('My portrait'), findsOneWidget);
      await tester.tap(find.text('Make favorite'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.star), findsOneWidget);
      await tester.tap(find.byKey(ValueKey(photos[1].asset)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Make favorite'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.star), findsOneWidget);
      final tile = find.byKey(ValueKey(photos[1].asset));
      expect(
        find.descendant(of: tile, matching: find.byIcon(Icons.star)),
        findsOneWidget,
      );
      await tester.tap(find.byKey(ValueKey(photos[2].asset)));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: tile, matching: find.byIcon(Icons.star)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Profile fits a narrow phone with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: const ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Chip), findsNWidgets(5));
    await tester.ensureVisible(find.text('My Class Schedule'));
    await tester.pumpAndSettle();
    expect(find.byType(Table), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
