import 'dart:io';

import 'package:cc207b_unit5/gallery_screen.dart';
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
      expect(info.label, isNot('Hobbies'));
    }
  });

  test('hobbies and sample classes are easy to edit', () {
    expect(ProfileContent.hobbies.length, greaterThanOrEqualTo(5));
    for (final String hobby in ProfileContent.hobbies) {
      expect(hobby.trim(), isNotEmpty);
    }
    expect(ProfileContent.schedule, hasLength(15));
    expect(
      ProfileContent.schedule
          .map(
            (slot) =>
                '${slot.day}|${slot.time}|${slot.code}|${slot.name}|${slot.room}',
          )
          .toList(),
      <String>[
        'Mon|7:00 AM–9:00 AM|CIT 213|Human Computer Interaction 2|ICT 106',
        'Mon|9:00 AM–12:00 PM|CIT 251|Security Compliance and Governance|ICT 305',
        'Mon|1:00 PM–3:00 PM|CIT 210|Web Systems and Technologies|ICT 307',
        'Mon|3:00 PM–4:00 PM|CIT 212|Networking 2 (Advanced Networking)|ICT 207',
        'Mon|4:00 PM–5:30 PM|CC 208|Methods of Research in Computing|ICT 106',
        'Tue|9:00 AM–12:00 PM|CC 207B|Applications Development and Emerging Technologies|ICT 307',
        'Tue|1:00 PM–2:30 PM|BA 234|Technopreneurship|ICT 107',
        'Tue|4:00 PM–6:00 PM|CIT 212|Networking 2 (Advanced Networking)|ICT 305',
        'Wed|7:00 AM–10:00 AM|CIT 213|Human Computer Interaction 2|ICT 306',
        'Wed|10:00 AM–12:00 PM|CIT 251|Security Compliance and Governance|ICT 305',
        'Wed|1:00 PM–4:00 PM|CIT 210|Web Systems and Technologies|ICT 307',
        'Wed|4:00 PM–5:30 PM|CC 208|Methods of Research in Computing|ICT 106',
        'Thu|10:00 AM–12:00 PM|CC 207B|Applications Development and Emerging Technologies|ICT 307',
        'Thu|1:00 PM–2:30 PM|BA 234|Technopreneurship|ICT 107',
        'Thu|4:00 PM–6:00 PM|CIT 212|Networking 2 (Advanced Networking)|ICT 305',
      ],
    );
    expect(
      ProfileContent.schedule[5].subject,
      'CC 207B — Applications Development and Emerging Technologies · ICT 307',
    );
  });

  test('gallery photos exist, are captioned, and stay under 500 KB', () async {
    expect(
      galleryPhotos.map((photo) => photo.caption).toList(),
      <String>[
        'CICT Logo',
        'WVSU Logo',
        'My Favorite Number',
        'Quezon Hall',
        'My Favorite Food: Adobo',
        'Vacation',
      ],
    );
    final Set<String> assets = <String>{};
    for (final photo in galleryPhotos) {
      expect(assets.add(photo.asset), isTrue, reason: photo.asset);
      final File file = File(photo.asset);
      expect(file.existsSync(), isTrue, reason: photo.asset);
      expect(file.lengthSync(), lessThan(500 * 1024), reason: photo.asset);
      final ByteData data = await rootBundle.load(photo.asset);
      expect(data.lengthInBytes, file.lengthSync(), reason: photo.asset);
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
      expect(find.text('My Hobbies'), findsOneWidget);
      expect(find.text('Coding'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(ProfileContent.hobbies.length));
      expect(find.text('My Class Schedule'), findsOneWidget);
      expect(find.textContaining('Technopreneurship'), findsWidgets);
      expect(find.byType(Table), findsOneWidget);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).destinations,
        hasLength(3),
      );
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
      expect(find.text('Reset count'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Reset count'),
            )
            .onPressed,
        isNull,
      );
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

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        2,
      );
      expect(find.text('My Gallery'), findsOneWidget);
      expect(
        find.text(
          'School logos, favorites, and a vacation. Tap a picture to open it.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('CICT Logo'),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);

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

  testWidgets('byte heart stays when switching tabs', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(PetScreen.portraitKey));
    await tester.pumpAndSettle();
    await _doubleTap(tester, find.byKey(PetScreen.portraitKey));
    expect(
      tester.widget<AnimatedOpacity>(find.byKey(PetScreen.heartKey)).opacity,
      1,
    );

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Pet'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AnimatedOpacity>(find.byKey(PetScreen.heartKey)).opacity,
      1,
    );
    expect(find.text('Byte has beeped 0 times'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back leaves the favorite unchanged and only one star shows', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quezon Hall'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(AppBar, 'Quezon Hall'),
      findsOneWidget,
    );
    expect(find.text('Make favorite'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star_rounded), findsNothing);

    await tester.tap(find.text('Quezon Hall'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);

    await tester.tap(find.text('My Favorite Food: Adobo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Make favorite'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset dialog returns false for cancel and true for reset', (
    WidgetTester tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return const ResetCountDialog(
                        message:
                            'Byte has beeped 2 times. Start again from zero?',
                      );
                    },
                  );
                },
                child: const Text('Open dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Reset the count?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
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
