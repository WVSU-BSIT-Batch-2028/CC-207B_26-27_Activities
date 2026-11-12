# unit6_org_fair

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# CICT Org Fair, Part 2

Caryl Ann Calibjo, BSIT 3B

## EXPLAIN answers

**E1. home_shell.dart, lines 22 to 25**
The joined orgs live in `_memberships` (home_shell.dart, line 25) because three screens and the badge need them: OrgListScreen, MyOrgsScreen and ScheduleScreen (lines 42, 47, 52), plus the My Orgs badge. These screens are siblings, and a sibling cannot read another sibling's state, so none of them can keep the map for the others. HomeShell is their common parent. It passes the data down through constructors and receives changes through the callbacks `onJoined` and `onLeave`.

**E2. home_shell.dart, lines 57 to 62**
`IndexedStack` (home_shell.dart, line 62) builds all three pages and shows only the page at `_index`. The hidden pages stay in the widget tree, so their State objects survive, including the search text in the Orgs screen. With `pages[_index]` instead, Flutter replaces one widget with another and destroys the old State, so the search box comes back empty.

**E3. org_list_screen.dart, lines 131 to 138**
The drawer sits on top of the Orgs page. If I push the About screen without closing it, the drawer stays open underneath. When I press back from About, I return to the open drawer, not the page. `Navigator.pop(context)` on line 136 closes the drawer first, so back leads to a clean Orgs page.

**E4. org_list_screen.dart, lines 257 to 273**
A `Wrap` moves a chip to the next line when the row runs out of room. A `Row` never wraps. On a narrow screen it would draw the extra chips past the edge and show the yellow and black overflow stripes in debug mode. `Wrap` on line 262 keeps every chip visible and tappable. At a width of 360, the Service chip dropped to a second line.

**E5. org_list_screen.dart, lines 297 to 306**
Flutter computes the column count as the available width divided by (`maxCrossAxisExtent` + spacing), rounded up. On a 360-wide phone, the grid has 344 pixels after the 8-pixel padding on each side. 344 / 208 = 1.65, which rounds up to 2 columns. Each tile gets (344 - 8) / 2 = 168 pixels. On a 1000-wide window the grid has 984 pixels. 984 / 208 = 4.73 rounds up to 5 columns, and each tile gets (984 - 4 x 8) / 5 = 190.4 pixels.

**E6. org_detail_screen.dart, lines 29 to 31**
The `length` on line 36, the number of `Tab` widgets in the `TabBar` (lines 42 to 44), and the number of children in the `TabBarView` (line 49) must all be the same number. The controller needs one page for each tab. When they do not match, Flutter stops with a red error screen in debug mode, and the message says the controller's length does not match the number of tabs.

**E7. my_orgs_screen.dart, lines 24 and 25, with the check on line 46**
`showDialog<bool>` returns `bool?` because the user can close the dialog without pressing a button. Tapping the gray area outside it, or pressing the back button, closes it and returns `null`. The test `confirmed == true` handles all three outcomes in one check, and only a real tap on Leave passes it. A plain `if (confirmed)` would not even compile, because Dart does not accept a nullable `bool?` as a condition.

**E8. schedule_screen.dart, lines 51 to 53**
A `Table` (line 53) measures each column once, using the `columnWidths` on lines 55 to 59, and applies that width to every row. This keeps Time, Booth and Org in straight vertical lines. A `Column` of `Row`s would size each `Row` on its own, so a short time like "9:00 AM" and a long one like "10:00 AM" would push the next cell to different positions. The columns would zigzag. A `Table` also gives you the borders and the per-row `decoration` that TODO 13 uses.
