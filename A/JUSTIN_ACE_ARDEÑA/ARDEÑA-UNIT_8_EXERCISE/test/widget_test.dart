import 'package:ardena_unit5_exercise/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Simulate native sound in widget tests; check real playback on a device.
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const codec = StandardMethodCodec();
  void sendAudioEvent(String playerId, String event, [Object? value]) {
    messenger.handlePlatformMessage(
      'xyz.luan/audioplayers/events/$playerId',
      codec.encodeSuccessEnvelope({'event': event, 'value': value}),
      (_) {},
    );
  }

  setUp(() {
    AudioCache.instance.loadedFiles[kPetSoundAsset] =
        Uri.file('/test/pet_sound.wav');
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (_) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global/events'),
      (_) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (call) async {
        final playerId = (call.arguments as Map)['playerId'] as String;
        if (call.method == 'create') {
          messenger.setMockMethodCallHandler(
            MethodChannel('xyz.luan/audioplayers/events/$playerId'),
            (_) async => null,
          );
        } else if (call.method == 'setSourceUrl') {
          sendAudioEvent(playerId, 'audio.onPrepared', true);
        } else if (call.method == 'resume') {
          sendAudioEvent(playerId, 'audio.onComplete');
        } else if (call.method == 'getDuration' ||
            call.method == 'getCurrentPosition') {
          return 0;
        }
        return null;
      },
    );
  });

  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(NavigationDestination, label));
    await tester.pumpAndSettle();
  }

  Finder photoImage(int index) => find.byWidgetPredicate(
        (widget) =>
            widget is Image && widget.semanticLabel == photos[index].caption,
      );

  testWidgets('Profile chips and schedule scroll without overflow at 360x640',
      (tester) async {
    await openApp(tester);
    expect(find.text('Hobbies'), findsNothing);
    expect(find.byType(Chip), findsAtLeastNWidgets(5));
    await tester.ensureVisible(find.text('My Hobbies'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byType(Table));
    await tester.pumpAndSettle();
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Subject'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Gallery returns a favorite, replaces it, and preserves it across tabs',
      (tester) async {
    await openApp(tester);
    await tapTab(tester, 'Gallery');
    expect(find.byType(GridView), findsOneWidget);
    for (var index = 0; index < photos.length; index++) {
      expect(photoImage(index), findsOneWidget);
    }
    await tester.tap(photoImage(0));
    await tester.pumpAndSettle();
    expect(find.byType(PhotoScreen), findsOneWidget);
    expect(find.text(photos[0].caption), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNothing);

    for (final index in [0, 1]) {
      await tester.tap(photoImage(index));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Make favorite'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.star), findsOneWidget);
      final tile =
          find.ancestor(of: photoImage(index), matching: find.byType(Stack));
      expect(find.descendant(of: tile, matching: find.byIcon(Icons.star)),
          findsOneWidget);
    }
    await tester.tap(photoImage(2));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapTab(tester, 'Profile');
    await tapTab(tester, 'Gallery');
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Bark count survives tabs; reset handles cancel, dismissal, and confirm',
      (tester) async {
    await openApp(tester);
    await tapTab(tester, 'My Pet');
    final resetButton = find.widgetWithText(OutlinedButton, 'Reset count');
    expect(tester.widget<OutlinedButton>(resetButton).onPressed, isNull);
    await tester.ensureVisible(find.text('Make $kPetName bark'));
    await tester.tap(find.text('Make $kPetName bark'));
    await tester.pumpAndSettle();
    await tapTab(tester, 'Profile');
    await tapTab(tester, 'Gallery');
    await tapTab(tester, 'My Pet');
    expect(find.text('$kPetName has $kPetVerb 1 time.'), findsOneWidget);

    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('$kPetName has $kPetVerb 1 time.'), findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    expect(find.text('$kPetName has $kPetVerb 1 time.'), findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('$kPetName has $kPetVerb 0 times.'), findsOneWidget);
    expect(tester.widget<OutlinedButton>(resetButton).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}
