# Unit 6 Assignment: CICT Org Fair Part 2

Name: Lyka R. Lamparero
Section: BSIT 3A

## E1: home_shell.dart, _memberships, line 21
The joined orgs live in HomeShell because three screens need them. OrgListScreen marks the orgs already joined, MyOrgsScreen shows them, and ScheduleScreen highlights their rows. These screens are siblings, so one of them cannot keep the map for the others. HomeShell is their closest common parent, so it keeps the map and passes it down.

## E2: home_shell.dart, body, line 55
IndexedStack keeps all the pages in the widget tree and only shows the page at the selected index. Because OrgListScreen stays in the tree, its State and its search TextField keep their text. With pages[_index], the old page is removed and a new State is created when you come back, so the search text is lost.

## E3: org_list_screen.dart, drawer, line 131
The drawer is a route placed on top of the screen. If it is not closed first, it stays open underneath the About screen. Navigator.pop closes it before pushNamed opens About. In Experiment C4, I removed Navigator.pop and opened About, and when I pressed back the drawer was still open on top of the list.

## E4: org_list_screen.dart, chips, line 257
Wrap moves the chips to the next line when they do not fit on one line. A Row does not wrap, so the chips that do not fit run past the edge of the screen. In Experiment C2, I changed Wrap to Row and the chips ran past the right edge, with a yellow and black overflow warning.

## E5: org_list_screen.dart, _buildGrid, line 294
maxCrossAxisExtent: 200 means each tile can be at most 200 wide, so Flutter adds more columns as the screen gets wider. A 360 wide phone gets 2 columns (each tile about 168 wide). A 1000 wide window gets 5 columns (each tile about 190 wide). In Experiment C5, I counted 2 columns at 360 wide and 5 columns at 1000 wide, which matches my math.

## E6: org_detail_screen.dart, DefaultTabController, line 29
The length of DefaultTabController, the number of Tabs in the TabBar, and the number of children in the TabBarView must all be the same. Here they are all 3. If they do not match, Flutter shows an error because the tabs and the pages cannot be matched. In Experiment C3, I changed length to 2 while there were still 3 tabs, and Flutter showed an error about the tab count.

## E7: my_orgs_screen.dart, _confirmLeave, line 24
showDialog<bool> returns bool? because the result is null when the user closes the dialog without pressing a button, for example by tapping outside it or pressing back. We test confirmed == true so that null counts as not confirmed. Only a real tap on Leave removes the org.

## E8: schedule_screen.dart, Table, line 51
A Table gives each column one width for all rows, so Time, Booth, and Org line up. In a Column of Rows, each Row sizes itself from its own content, so the columns would not line up from row to row.