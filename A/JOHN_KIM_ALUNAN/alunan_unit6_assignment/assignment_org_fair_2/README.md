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

Answer:
E1 - lib/screens/home_shell.dart (lines 25 - 31)
The My Orgs tab needs the joined orgs to list them, the orgs tab needs them to show the Joined label and to add new ones, the Schedule tab needs the ids to highlight rows, and the navigation bar needs the count for the badge. Theses screens are siblings, so none of them can read another screen's State. If OrgListScreen kept the map, the other tabs could not see it, so the map is lifted up to HomeShell, their closest common parent. HomeShell passes it down and gets changes back through callbacks like onJoined and onLeave.

E2 - lib/screens/home_shell.dart (line 60)

IndexedStack builds all three pages at once and only shows the one at the current index, so the hidden pages stay in the widget tree. OrgListScreen is never removed, so its State, including the search controller text, the chips and the favorites, stays alive while I look at another tab. With the old pages[_index], the Orgs page would be thrown away and rebuilt when I came back, so the search box would be empty again.

E3 - lib/screens/org_list_screen.dart (lines 135 to 138)

The drawer is open on top of the list screen, so if I only push the About screen, About opens on top while the drawer stays open underneath. When I press back from About, I would land on the list with the drawer still open. Calling Navigator.pop(context) first closes the drawer, so pushNamed opens About from a clean screen and back returns to the list normally.

E4 - lib/screens/org_list_screen.dart (lines 258 to 272)

A Wrap places the chips side by side and moves a chip to a new line when it does not fit, so every chip stays visible and tappable. A Row never wraps, so on a narrow screen the last chips would go past the edge and Flutter would show the yellow and black overflow stripes with an overflow error.

E5 - lib/screens/org_list_screen.dart (lines 289 to 304)

Flutter divides the grid width by (maxCrossAxisExtent plus spacing) and rounds up to get the number of columns. On a 360 wide phone the grid is 344 wide after the 8 padding on each side, 344 / 208 is about 1.65, so there are 2 columns and each tile is (344 - 8) / 2 = 168 wide. On a 1000 wide window the grid is 984 wide, 984 / 208 is about 4.73, so there are 5 columns and each tile is (984 - 32) / 5 = 190.4 wide. Every tile stays under 200.

E6 - lib/screens/org_detail_screen.dart (lines 28 to 57)

The length of DefaultTabController, the number of Tab widgets in the TabBar and the number of children in the TabBarView must all be the same number, which is 3 here, and they must be in the same order so that tab 2 shows child 2. If they do not match, Flutter throws an error saying the controller length does not match the tabs, and the screen breaks instead of showing the tabs.

E7 - lib/screens/my_orgs_screen.dart (lines 23 to 52)

showDialog returns a bool? because the user can close the dialog without pressing either button, for example by tapping outside it or pressing the back button, and then the result is null. Testing confirmed == true is safe for null and only continues when the user really pressed Leave. Writing if (confirmed) would not even compile because a bool? cannot be used as a condition.

E8 - lib/screens/schedule_screen.dart (lines 47 to 70)

A Table makes every row share the same column widths, so Time, Booth and Org line up in clean vertical columns. If each Row sized itself, the width would depend on the text in that row and the columns would drift out of line from one row to the next. A Table also lets me give a whole row a decoration, which is how the joined orgs get highlighted.