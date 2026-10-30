import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navea_unit6_exercise/home_shell.dart';
import 'package:navea_unit6_exercise/main.dart';
import 'package:navea_unit6_exercise/screens/gallery_screen.dart';

void main() {
  testWidgets('Profile shows hobbies and class schedule', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.text('My Class Schedule'), findsOneWidget);
    expect(find.byType(Table), findsOneWidget);
    expect(tester.widget<Table>(find.byType(Table)).children, hasLength(16));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Gallery photo can be made the favorite', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(GalleryScreen.photos, hasLength(6));

    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image && widget.semanticLabel == 'Photo booth memories',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Make favorite'), findsOneWidget);

    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byType(HomeShell), findsOneWidget);
  });
}
