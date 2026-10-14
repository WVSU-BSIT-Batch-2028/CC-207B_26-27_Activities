import 'package:cc207b_unit5/info_tile.dart';
import 'package:cc207b_unit5/main.dart';
import 'package:cc207b_unit5/pet_screen.dart';
import 'package:cc207b_unit5/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(installAudioplayersMock);

  test('beep count uses singular and plural wording', () {
    expect(beepCountLabel(0), 'Byte has beeped 0 times');
    expect(beepCountLabel(1), 'Byte has beeped 1 time');
    expect(beepCountLabel(3), 'Byte has beeped 3 times');
  });

  test('profile keeps at least five editable details', () {
    expect(ProfileContent.details.length, greaterThanOrEqualTo(5));
    for (final info in ProfileContent.details) {
      expect(info.label, isNotEmpty);
      expect(info.value, isNotEmpty);
    }
  });

  testWidgets('profile and pet screens fit small and narrow windows', (
    WidgetTester tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final Size size in const <Size>[
      Size(320, 568),
      Size(390, 844),
      Size(280, 640),
      Size(480, 420),
    ]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      await tester.pumpWidget(MyApp(key: ValueKey<Size>(size)));
      await tester.pumpAndSettle();

      expect(find.text('James Remegio.'), findsOneWidget);
      expect(find.text(ProfileContent.tagline), findsOneWidget);
      expect(find.text('My Biography'), findsOneWidget);
      expect(find.text(ProfileContent.biography), findsOneWidget);
      expect(
        find.bySemanticsLabel('Photo of James Remegio'),
        findsOneWidget,
      );
      expect(
        find.byType(InfoTile),
        findsNWidgets(ProfileContent.details.length),
      );
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('My Pet'));
      await tester.pumpAndSettle();

      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1,
      );
      expect(find.text('Meet Byte'), findsOneWidget);
      expect(find.text('Play beep'), findsOneWidget);
      expect(find.text('Byte has beeped 0 times'), findsOneWidget);
      expect(find.text('Double-tap Byte to leave a heart'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Byte, a blue pixel-art robot'),
        findsWidgets,
      );
      expect(
        tester.widget<AnimatedOpacity>(find.byKey(PetScreen.heartKey)).opacity,
        0,
      );
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.byKey(PetScreen.portraitKey));
      await tester.pumpAndSettle();
      await _doubleTap(tester, find.byKey(PetScreen.portraitKey));

      expect(find.text('Double-tap Byte to hide the heart'), findsOneWidget);
      expect(
        tester.widget<AnimatedOpacity>(find.byKey(PetScreen.heartKey)).opacity,
        1,
      );
      expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.byKey(PetScreen.portraitKey));
      await tester.pumpAndSettle();
      await _doubleTap(tester, find.byKey(PetScreen.portraitKey));
      expect(find.text('Double-tap Byte to leave a heart'), findsOneWidget);
      expect(
        tester.widget<AnimatedOpacity>(find.byKey(PetScreen.heartKey)).opacity,
        0,
      );

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
      );
      expect(find.text('James Remegio.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

Future<void> _doubleTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 80));
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void installAudioplayersMock() {
  final TestDefaultBinaryMessenger messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(
    const MethodChannel('xyz.luan/audioplayers.global'),
    (MethodCall call) async => null,
  );
  messenger.setMockMethodCallHandler(
    const MethodChannel('xyz.luan/audioplayers'),
    (MethodCall call) async => null,
  );
}
