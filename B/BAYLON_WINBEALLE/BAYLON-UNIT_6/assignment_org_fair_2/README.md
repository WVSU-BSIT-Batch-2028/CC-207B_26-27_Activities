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

## Answers

**E1 (home_shell.dart, line 25, `_memberships`)**
The Orgs, My Orgs and Schedule screens all need the joined orgs (lines 39–49), but they are siblings and can't read each other's state. So I moved the map to their closest common parent, `HomeShell`. It passes the data down and gets changes back through callbacks like `onJoined` and `onLeave`. When it calls `setState`, all three tabs rebuild with the same data.

**E2 (home_shell.dart, line 66, `body: IndexedStack`)**
`IndexedStack` builds all three pages and only shows the one at `_index`. The hidden pages stay in the widget tree, so their `State` objects, including the search text controller in `OrgListScreen`, are not destroyed. With `pages[_index]` (Experiment C1), the old page is removed on every switch and the search box comes back empty.

**E3 (org_list_screen.dart, line 127, drawer `onTap`)**
The drawer is a layer on top of the current screen. If I only push the About screen, the drawer stays open underneath it and is still open when the user comes back (Experiment C4). `Navigator.pop(context)` closes the drawer first, so About opens from a clean Orgs screen.

**E4 (org_list_screen.dart, line 249, chips `Wrap`)**
`Wrap` moves chips that don't fit onto the next line, so all of them stay visible. A `Row` never wraps. When the chips are wider than the screen, it overflows and shows the yellow and black stripe (Experiment C2).

**E5 (org_list_screen.dart, line 288, `_buildGrid`)**
The column count is `ceil((width + spacing) / (maxCrossAxisExtent + spacing))`. A 360-wide phone with 8px padding has 344px, so (344+8)/208 rounds up to 2 columns, and each tile is (344−8)/2 = 168 wide. A 1000-wide window has 984px, so 5 columns of (984−4×8)/5 = 190.4 each. No tile is wider than 200, and the count grows with the screen (Experiment C5).

**E6 (org_detail_screen.dart, line 36, `DefaultTabController`)**
`length`, the number of `Tab`s in the `TabBar` and the number of children in the `TabBarView` must all be equal (3: About, Officers, Events). They share one controller, so tab *i* in the bar must match page *i* in the view. If they differ, Flutter throws an error that the controller length doesn't match (Experiment C3).

**E7 (my_orgs_screen.dart, line 29, `_confirmLeave`)**
`showDialog<bool>` returns a `bool?` because the result is `null` when the user closes the dialog without pressing a button, for example by tapping outside it or pressing back. Dart doesn't allow a `bool?` directly in an `if`, and `confirmed == true` is false for both `null` and `false`. So the org is only left when the user pressed Leave.

**E8 (schedule_screen.dart, line 49, `Table`)**
A `Table` sizes each column once for all rows (96, 72, then the rest), so the Time, Booth and Org cells line up in every row. If each `Row` in a `Column` sized itself, every row would have its own column widths based on its content, and the columns would be uneven.