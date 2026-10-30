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


E1-E8 Answers

E1 (home_shell.dart, line 25, the _memberships map)
 The joined orgs live in HomeShell because more than one screen needs them. OrgListScreen uses them to show the Joined label, MyOrgsScreen lists them, and HomeShell uses the count for the badge. Sibling screens can’t read each other’s state, so the map has to sit in their closest shared parent. HomeShell passes it down, and the screens call onJoined and onLeave to change it.

E2 (home_shell.dart, line 60, the body)
 The widget that does this is IndexedStack. It builds all three pages at once and only shows the one at the current index, so the other pages stay in the widget tree. Their State objects never get thrown away, which is why the search text is still there when you come back. With pages[_index] alone, the old page is removed on every switch and its state is lost.

E3 (org_list_screen.dart, line 137, the drawer item)
 The drawer sits on top of the screen as its own layer on the navigator. If you call pushNamed without closing it, the About screen opens over a drawer that is still open. When you press back, you land on the list with the drawer still showing. Calling Navigator.pop(context) first closes the drawer, so back goes straight to the list.

E4 (org_list_screen.dart, line 260, the chips): When the chips don’t fit on one line, Wrap moves the extra ones down to the next line. A Row doesn’t wrap, it keeps everything on one line. If the chips are too wide, you get the yellow and black overflow stripe on the right edge.

E5 (org_list_screen.dart, line 289, _buildGrid)
 maxCrossAxisExtent is the maximum tile width, not a fixed size. Flutter divides the available width by (200 + 8 spacing) and rounds up to get the number of columns. On a 360 wide phone, the usable width is 344 after the 8 padding on each side. 344 / 208 is about 1.65, so 2 columns, and each tile is (344 - 8) / 2 = 168 wide. On a 1000 wide window the usable width is 984. 984 / 208 is about 4.73, so 5 columns, and each tile is (984 - 4 x 8) / 5 = 190.4 wide.

E6 (org_detail_screen.dart, line 33, the length)
 The length in DefaultTabController, the number of Tabs in the TabBar, and the number of children in the TabBarView must all be the same number. The order also has to match, so the second Tab opens the second child. If they don’t match, Flutter throws an error in debug mode saying the controller length doesn’t match the tabs or the children. 

E7 (my_orgs_screen.dart, line29, the if (confirmed == true ...))
 A dialog can close in more than one way. Cancel gives false and Leave gives true, but tapping outside the dialog or pressing back closes it with no value, so it returns null. That’s why the type is bool? and not bool. Testing confirmed == true handles null and false in one check, since only a real true passes. Writing if (confirmed) would not compile because a nullable bool can’t be used as a condition.
 
E8 (schedule_screen.dart, line 53, the columnWidths)
 In a Column of Rows, each Row sizes itself to its own content. “8:00 AM” and “10:00 AM” have different widths, so the Booth and Org parts would start at different spots on each row. A Table gives every column one width that all rows share, so everything lines up. It also lets the highlight color cover the whole row.
