// Widget tests: prove every example builds and behaves as the comments say.
// Run with: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_examples_advanced/examples/01_material_app_scaffold.dart';
import 'package:flutter_examples_advanced/examples/02_safe_area.dart';
import 'package:flutter_examples_advanced/examples/03_alignment_playground.dart';
import 'package:flutter_examples_advanced/examples/04_flex_and_spacer.dart';
import 'package:flutter_examples_advanced/examples/05_overflow_fixes.dart';
import 'package:flutter_examples_advanced/examples/06_list_views.dart';
import 'package:flutter_examples_advanced/examples/07_grid_view.dart';
import 'package:flutter_examples_advanced/examples/08_tables.dart';
import 'package:flutter_examples_advanced/examples/09_stack_navigation.dart';
import 'package:flutter_examples_advanced/examples/10_drawer_navigation.dart';
import 'package:flutter_examples_advanced/examples/11_tab_navigation.dart';
import 'package:flutter_examples_advanced/examples/12_bottom_navigation.dart';
import 'package:flutter_examples_advanced/examples/13_bottom_tab_bar.dart';
import 'package:flutter_examples_advanced/examples/14_stack_widget.dart';
import 'package:flutter_examples_advanced/main.dart' as gallery;
import 'package:flutter_test/flutter_test.dart';

Widget app(Widget home) => MaterialApp(home: home);

// A phone-sized screen in logical pixels.
void setScreen(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('menu opens every example without errors', (tester) async {
    await tester.pumpWidget(const gallery.AdvancedExamplesApp());
    for (final example in gallery.examples) {
      await tester.scrollUntilVisible(find.text(example.title), 50);
      await tester.tap(find.text(example.title));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: example.title);
      // Same as the Android back button. (The drawer demo shows a hamburger
      // instead of a back arrow, as slide 49 warns, so pageBack() can't be used.)
      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('01: custom leading hides the drawer button', (tester) async {
    await tester.pumpWidget(const ScaffoldApp());
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    await tester.tap(find.text('Custom leading icon'));
    await tester.pump();
    expect(find.byTooltip('Open navigation menu'), findsNothing);
    expect(find.byIcon(Icons.traffic), findsOneWidget);

    await tester.tap(find.byTooltip('Add'));
    await tester.pump();
    expect(find.text('FAB pressed 1 times'), findsOneWidget);

    await tester.tap(find.text('Floating action button'));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('02: SafeArea moves content below the notch', (tester) async {
    setScreen(tester, const Size(390, 844));
    tester.view.padding = const FakeViewPadding(top: 47, bottom: 34);
    await tester.pumpWidget(app(const SafeAreaDemo()));
    expect(
      tester.getTopLeft(find.byKey(const Key('top-text'))).dy,
      greaterThanOrEqualTo(47),
    );
    expect(find.textContaining('top 47.0'), findsOneWidget);

    await tester.tap(find.text('Wrap in SafeArea'));
    await tester.pump();
    expect(
      tester.getTopLeft(find.byKey(const Key('top-text'))).dy,
      lessThan(47),
    );
  });

  testWidgets('03: alignment changes box positions; Expanded cancels it', (
    tester,
  ) async {
    setScreen(tester, const Size(400, 900));
    await tester.pumpWidget(app(const AlignmentPlayground()));
    double leftOfA() => tester.getTopLeft(find.byKey(const Key('box-A'))).dx;

    expect(leftOfA(), 16); // start: hugs the left edge of the stage
    await tester.tap(find.widgetWithText(ChoiceChip, 'end').first);
    await tester.pump();
    expect(leftOfA(), greaterThan(16));

    await tester.tap(find.text('Expanded on the middle box'));
    await tester.pump();
    expect(leftOfA(), 16); // no free space left to move it
    expect(find.textContaining('nothing left to share out'), findsOneWidget);
  });

  testWidgets('04: Expanded fills, Flexible stays small', (tester) async {
    setScreen(tester, const Size(400, 900));
    await tester.pumpWidget(app(const FlexDemo()));
    Size boxOf(String label) => tester.getSize(
      find
          .ancestor(
            of: find.text(label).first,
            matching: find.byType(Container),
          )
          .first,
    );
    final Size expanded = boxOf('Expanded');
    final Size flexible = boxOf('Flexible');
    expect(expanded.width, greaterThan(80));
    expect(flexible.width, 80);
    expect(find.textContaining('A gets 1/4'), findsOneWidget);
  });

  testWidgets('05: fixes have no overflow, the problem does', (tester) async {
    setScreen(tester, const Size(390, 844));
    await tester.pumpWidget(app(const OverflowDemo()));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Show the problem').first);
    await tester.pump();
    expect(tester.takeException(), isA<FlutterError>());
  });

  testWidgets('06: ListView.builder is lazy', (tester) async {
    setScreen(tester, const Size(390, 844));
    await tester.pumpWidget(app(const ListViewDemo()));
    expect(find.text(people[0].name), findsWidgets);
    expect(find.text('student999@example.com'), findsNothing);

    await tester.tap(find.text('How many were built?'));
    await tester.pump();
    final String message = tester
        .widget<Text>(find.textContaining('itemBuilder has built'))
        .data!;
    final int built = int.parse(
      RegExp(r'built (\d+)').firstMatch(message)!.group(1)!,
    );
    expect(built, lessThan(30));

    await tester.tap(find.text('separated'));
    await tester.pumpAndSettle();
    expect(find.text('Sponsored: CICT Org Fair'), findsWidgets);
  });

  testWidgets('07: GridView.extent picks the column count from the width', (
    tester,
  ) async {
    setScreen(tester, const Size(400, 844));
    await tester.pumpWidget(app(const GridViewDemo()));
    expect(
      find.text('Width 400 -> 3 columns'),
      findsOneWidget,
    ); // 400 / 150 = 2.67 -> 3
    // Check the real grid agrees: three tiles share the first row.
    final double y0 = tester.getTopLeft(find.text('Student 1')).dy;
    expect(tester.getTopLeft(find.text('Student 3')).dy, y0);
    expect(tester.getTopLeft(find.text('Student 4')).dy, greaterThan(y0));

    await tester.tap(find.text('count'));
    await tester.pump();
    expect(find.text('Width 400 -> 2 columns'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Student 3')).dy,
      greaterThan(tester.getTopLeft(find.text('Student 1')).dy),
    );
  });

  testWidgets('08: Table lines up, DataTable sorts', (tester) async {
    setScreen(tester, const Size(800, 900));
    await tester.pumpWidget(app(const TableDemo()));
    // In a Table, every cell in a column starts at the same x.
    expect(
      tester.getTopLeft(find.text('January')).dx,
      tester.getTopLeft(find.text('3742').first).dx,
    );

    // Sort by Total, descending on the second tap: Ana sold the most (13638).
    await tester.tap(find.text('Total'));
    await tester.pump();
    await tester.tap(find.text('Total'));
    await tester.pump();
    final firstRowName =
        tester
                .widget<DataTable>(find.byType(DataTable))
                .rows
                .first
                .cells
                .first
                .child
            as Text;
    expect(firstRowName.data, 'Ana');
    await tester.tap(find.text('Total'));
    await tester.pump();
    final lowest =
        tester
                .widget<DataTable>(find.byType(DataTable))
                .rows
                .first
                .cells
                .first
                .child
            as Text;
    expect(lowest.data, 'Benjamin');
  });

  testWidgets('09: push with data, pop with result, named route, dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: const ShopHome(), routes: shopRoutes),
    );
    await tester.tap(find.text('Notebook'));
    await tester.pumpAndSettle();
    expect(find.text('₱45.00'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget); // cart badge

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Place order?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Place order').last);
    await tester.pumpAndSettle();
    expect(find.text('Order placed. Thank you!'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
  });

  testWidgets('10: drawer swaps the body and closes', (tester) async {
    await tester.pumpWidget(app(const DrawerDemo()));
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Starred'));
    await tester.pumpAndSettle();
    expect(find.text('This is the Starred page'), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing); // closed before we left
  });

  testWidgets('11: kept-alive tab keeps its count, the other resets', (
    tester,
  ) async {
    await tester.pumpWidget(app(const TabDemo()));
    await tester.tap(find.byTooltip('Add one on A'));
    await tester.pump();
    await tester.tap(find.text('Show B'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add one on B'));
    await tester.pump();
    expect(find.text('Count: 1'), findsOneWidget);

    await tester.tap(find.text('Show C'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show A'));
    await tester.pumpAndSettle();
    expect(find.text('Count: 1'), findsOneWidget); // A kept it
    await tester.tap(find.text('Show B'));
    await tester.pumpAndSettle();
    expect(find.text('Count: 0'), findsOneWidget); // B lost it
  });

  testWidgets('12: IndexedStack keeps state across destinations', (
    tester,
  ) async {
    await tester.pumpWidget(app(const BottomNavDemo()));
    await tester.tap(find.byTooltip('Add one on Home'));
    await tester.pump();
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.text('Home count: 1'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep pages alive (IndexedStack)'));
    await tester.pump();
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.text('Home count: 0'), findsOneWidget);
  });

  testWidgets('13: slide 57 colours hide the selected tab; the fix shows it', (
    tester,
  ) async {
    await tester.pumpWidget(app(const BottomTabBarDemo()));
    Color labelColour() =>
        DefaultTextStyle.of(tester.element(find.text('Show A'))).style.color!;
    final ColorScheme colors = Theme.of(tester.element(find.text('Show A')))
        .colorScheme;

    expect(labelColour(), colors.onPrimary);
    await tester.tap(find.text('Use slide 57 colours').first);
    await tester.pump();
    expect(labelColour(), colors.primary); // same as the background
  });

  testWidgets('14: Positioned moves the badge', (tester) async {
    await tester.pumpWidget(app(const StackWidgetDemo()));
    final before = tester.getTopLeft(find.text('NEW'));
    await tester.drag(find.byType(Slider).first, const Offset(100, 0));
    await tester.pump();
    expect(tester.getTopLeft(find.text('NEW')).dy, greaterThan(before.dy));
  });
}
