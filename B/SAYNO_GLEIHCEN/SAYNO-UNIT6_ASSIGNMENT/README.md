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

# Unit 6 Assignment: CICT Org Fair Part 2

## E1: Lifting state up (home_shell.dart, line 22)
Three tabs need the joined orgs: the list (to show who is a member), My Orgs (to show the list), and Schedule (to highlight rows). The badge in HomeShell needs it too. Screens next to each other cannot see each other's state, so the map must live in their common parent, HomeShell. It sends the data down through constructors and gets changes back through callbacks like `onJoined`.

## E2: IndexedStack (home_shell.dart, line 55)
`IndexedStack` builds all the pages and only shows the one at the current index. The others stay alive in the background, so the search screen keeps its State and its text. With `pages[_index]`, the old page is removed and its State is thrown away, so the search resets.

## E3: Closing the drawer first (org_list_screen.dart, line 131)
The drawer sits on top of the screen like a route. If we open About without closing it, the drawer stays underneath, and when I press back from About the drawer is still open. `Navigator.pop(context)` closes the drawer first, so About opens cleanly. 

## E4: Wrap vs Row (org_list_screen.dart, line 256)
When chips do not fit on one line, `Wrap` moves them to the next line. A `Row` cannot wrap, so the extra chips run off the screen and Flutter shows an overflow warning (the yellow and black stripes).

## E5: maxCrossAxisExtent math (org_list_screen.dart, line 293)
The columns are the width divided by (200 + spacing 8), rounded up. The grid has 8 padding on each side. A 360-wide phone has 344 usable width: 344 / 208 = 1.65, so 2 columns, and each tile is (344 - 8) / 2 = 168 wide. A 1000-wide window has 984 usable width: 984 / 208 = 4.7, so 5 columns, and each tile is (984 - 4 x 8) / 5 = about 190 wide.

## E6: Tab numbers must match (org_detail_screen.dart, line 29)
The `length` of `DefaultTabController`, the number of `Tab`s in the `TabBar`, and the number of children in the `TabBarView` must all be the same number (3 here). If they do not match, Flutter shows an error because the tabs and pages cannot line up.

## E7: bool? in the dialog (my_orgs_screen.dart, line 24)
`showDialog<bool>` returns `bool?` because the user can close the dialog without pressing a button, by tapping outside or pressing back, and then the answer is `null`. We write `confirmed == true` because `null == true` is just false, so it is safe. A plain `if (confirmed)` would not even compile, since a `bool?` cannot be used as a condition.

## E8: Table vs Column of Rows (schedule_screen.dart, line 49)
A `Table` makes every row share the same column widths, so the Time, Booth, and Org columns line up. If each `Row` sized itself, a short word like "9:00" and a long name would make the columns different widths in every row, and everything would look crooked.