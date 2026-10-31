# CC 206 Advanced Flutter Topics: Examples

Working, interactive examples for the **6. Advanced Flutter Topics** deck
(layouts, lists, grids, tables and navigation). Each screen has switches,
sliders or buttons so students can change something and see what happens,
instead of only reading code.

Verified on **Flutter 3.47.7 / Dart 3.13.5** (current stable, October 2026):
- `flutter analyze`: no issues
- `flutter test`: all 15 widget tests pass
- `flutter build web`: builds

## Two ways to use them

**1. Show one example quickly (no setup):** open https://dartpad.dev, paste one
file from `lib/examples/`, and press Run. Every file has its own `main()`.

**2. Run the whole set in DartPad:** open https://dartpad.dev, choose Flutter,
paste `dartpad_all_examples.dart`, and press Run. It contains the same menu as
the local app and all 14 examples in one file. It uses only Flutter SDK
libraries, so no package setup is needed. Tests are not included.

**3. Run the whole set locally:**

```
flutter create .        # adds android/ios/windows/... folders for your machine
flutter pub get
flutter run             # opens a menu that links to every example
flutter test            # optional: runs the widget tests
```

## What's inside

| File | Slides | What students can try |
|---|---|---|
| `01_material_app_scaffold.dart` | 4–10 | Toggle a custom `leading` icon and watch the hamburger button disappear; hide the FAB and bottom bar; open a bottom sheet. Uses Material 3 `colorSchemeSeed`. |
| `02_safe_area.dart` | 11–13 | Toggle `SafeArea` and read the real insets from `MediaQuery.paddingOf` (run on a phone or emulator with a notch). |
| `03_alignment_playground.dart` | 14–19 | Pick any `mainAxisAlignment` / `crossAxisAlignment` for a Row or Column. Turn on `Expanded` and see why alignment stops doing anything. |
| `04_flex_and_spacer.dart` | 19–20 | Sliders for `flex` on two `Expanded` boxes and a `Spacer`; `Expanded` vs `Flexible` side by side. |
| `05_overflow_fixes.dart` | 21–23 | Three overflow problems with a "Show the problem" switch: long text (`Expanded` + ellipsis), too many chips (`Wrap`), tall column (`SingleChildScrollView`). |
| `06_list_views.dart` | 23–28 | `ListView`, `.builder` and `.separated` on 1000 people, with a button that shows how few rows `.builder` actually built. |
| `07_grid_view.dart` | 29–34 | `GridView.extent`, `.count` and `.builder` with sliders, and the column-count arithmetic shown on screen. |
| `08_tables.dart` | 35–39 | `Table` vs nested Rows/Columns (switch to see the misalignment), plus a sortable `DataTable`. |
| `09_stack_navigation.dart` | 41–47 | A small shop: push with data, pop with a result, a named route with `arguments`, and a confirm dialog. |
| `10_drawer_navigation.dart` | 48–52 | A drawer that swaps the body and closes itself, plus an item that pushes a new screen. |
| `11_tab_navigation.dart` | 53–56 | `DefaultTabController` + `TabBar` + `TabBarView`. One tab keeps its counter, the other loses it: ask the class why. |
| `12_bottom_navigation.dart` | 57 | Material 3 `NavigationBar` with `IndexedStack` so each page keeps its state. |
| `13_bottom_tab_bar.dart` | 57 | The slide 57 TabBar at the bottom, with a switch that shows why its selected tab becomes invisible in Material 3, and the fix. |
| `14_stack_widget.dart` | new | The `Stack` *layout* widget with `Positioned`, so students don't confuse it with stack *navigation*. |

`lib/main.dart` is a menu that opens every example. `test/widget_test.dart`
checks that each screen behaves the way its comments say.
`docs/screenshots/` has a picture of each screen.
