# Unit 6 Exercise — My Profile App Part 2

Name: Daniella Dayrit  
Year and Section: ____________________  
Date: ____________________

## Completed Activity

This project extends the Unit 5 profile app with the required Unit 6 widgets and interactions:

- `IndexedStack` keeps the Profile, Cookie, and Gallery pages alive.
- The third `NavigationDestination` opens the Gallery tab.
- The Gallery uses `GridView.extent` with a maximum cross-axis extent of 160 pixels.
- Gallery tiles use `Image.asset`, rounded corners, semantic labels, and a `Stack` star overlay.
- Tapping a photo opens `PhotoScreen`; `Make favorite` returns `true` and saves one favorite photo.
- Hobbies are displayed as five chips inside a `Wrap`.
- The class schedule is displayed in a bordered `Table` with a themed header row.
- The Profile page remains scrollable on small screens.
- The Reset count button is disabled at zero and uses a confirmation dialog before resetting.

## Answers and Implementation Notes

### Part A — Keeping tabs alive

`IndexedStack` displays the selected page while keeping all page widgets mounted. This means the Cookie bark count is not lost when switching to Profile or Gallery.

### Part B — Gallery

`Photo` stores an asset path and caption. `GalleryScreen` builds six tiles with a collection-for. `Navigator.push<bool>` opens `PhotoScreen`; pressing Make favorite pops `true`, while the back arrow returns `null`. The Gallery stores only one favorite asset at a time and shows its star with `Stack` and `Positioned`.

### Part C — Profile additions

Five hobbies are shown as chips inside a wrapping layout. Four `ClassSlot` values are rendered with a bordered `Table`; the Day and Time columns use fixed widths while Subject uses the remaining width. The whole Profile page is inside `SingleChildScrollView` to avoid overflow on small screens.

### Part D — Reset dialog

The Reset count button is disabled while the count is zero. When pressed, it opens an `AlertDialog`; the count is reset only when the returned answer is exactly `true`.

## Evidence to Submit

Take screenshots showing:

1. Barking Cookie several times, switching tabs, and the count remaining.
2. The Gallery grid with at least six photos.
3. The photo detail screen and Make favorite button.
4. The favorite star on the selected gallery tile.
5. The five hobby chips.
6. The class schedule table.
7. The Reset count dialog and the disabled button when the count is zero.

## Project Contents

Submit `lib/main.dart`, `assets/images/gallery/`, `pubspec.yaml`, `pubspec.lock`, `test/`, this README, and the other Flutter project files. Replace the sample gallery image copies with six of your own photos or properly licensed photos before submitting.

Run the project with:

```bash
flutter pub get
flutter run
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
