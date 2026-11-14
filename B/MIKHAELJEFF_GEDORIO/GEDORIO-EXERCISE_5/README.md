# CC 207B Unit 5 Exercise — Mikhael Jeff Gedorio

Flutter app with Profile and My Pet screens, bottom navigation, profile info list, biography card, pet sound playback, bark counter, and double-tap heart overlay.

## Before running

1. Create/open a Flutter project, then replace its `lib/main.dart` and `pubspec.yaml` with these files (or copy the `lib/` and `assets/` folders into your existing project).
2. Add these three files:
   - `assets/images/profile.jpg` — your profile photo
   - `assets/images/haru.jpg` — Haru's photo
   - `assets/sounds/dog_bark.mp3` — a short dog bark audio file
3. In the VS Code terminal, run:
   ```bash
   flutter pub get
   flutter run -d windows
   ```
   If Windows desktop support is not enabled, run `flutter doctor` and enable the Windows desktop target first.

## Required assignment concepts included

- `MaterialApp` with `ThemeData` and a seeded color scheme
- `HomeShell` `StatefulWidget`, `NavigationBar`, and `setState`
- `ProfileInfo` class with `final` fields, `const` constructor, and required named parameters
- `List<ProfileInfo>` and collection-for building `InfoTile` stateless widgets
- Scrollable profile and pet screens
- Accessible semantic labels for photos
- `AudioPlayer`, completion listener, async playback, disabled/Playing button state, counter, and `dispose`
- `GestureDetector.onDoubleTap` with a `Stack` heart overlay

## Project name note

The assignment example uses `<lastname>_unit5_exercise`. This starter uses `gedorio_unit5_exercise` as the Flutter package name. If your instructor expects all caps or a specific folder convention, keep the repository folder name compliant with the class instructions while keeping the Flutter package name lowercase.
