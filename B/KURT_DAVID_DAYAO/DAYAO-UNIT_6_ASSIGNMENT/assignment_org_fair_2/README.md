# unit6_org_fair

E1. Why do the joined organizations live in HomeShell?
Reference: lib/screens/home_shell.dart, line 25.

The memberships are stored in HomeShell because the Orgs, My Orgs, and Schedule screens need the same information. The navigation badge also uses this data to display the membership count. Keeping the data in their shared parent allows all screens to update consistently when an organization is joined or left.


E2. Why does IndexedStack keep the search text?
Reference: lib/screens/home_shell.dart, line 62.

IndexedStack displays the selected page while keeping the other pages in the widget tree. This preserves the state of OrgListScreen, including its search controller and search query. When the user returns to the Orgs tab, the previous search is still there.


E3. Why is the drawer closed before opening About?
Reference: lib/screens/org_list_screen.dart, lines 141 and 142.

Navigator.pop(context) closes the drawer before Navigator.pushNamed opens the About screen. Without closing it first, the drawer remains open underneath the new screen. When the user goes back, the open drawer would appear again.


E4. Why use Wrap instead of Row for the filter chips?
Reference: lib/screens/org_list_screen.dart, line 267.

Wrap moves the remaining chips to another line when they cannot fit in the available width. A Row keeps its children on one horizontal line and can overflow when the screen is too narrow. Using Wrap allows the chips to fit on smaller screens.


E5. How many grid columns appear, and how wide are the tiles?
Reference: lib/screens/org_list_screen.dart, lines 298 and 306.

The grid uses maxCrossAxisExtent: 200, with 8 logical pixels of padding on each side and 8-pixel gaps between columns. Assuming the grid fills a 360-pixel-wide screen, the usable width is 360 − 16 = 344, giving two columns with a tile width of (344 − 8) ÷ 2 = 168 pixels. On a 1000-pixel-wide screen, the usable width is 1000 − 16 = 984, giving five columns with a tile width of (984 − 32) ÷ 5 = 190.4 pixels. The wider screen fits more columns while keeping the tiles within the specified maximum width.


E6. What must match in the tab widgets?
Reference: lib/screens/org_detail_screen.dart, lines 36, 41, and 49.

The DefaultTabController length, the number of TabBar tabs, and the number of TabBarView children must match. This app uses three of each for About, Officers, and Events, arranged in the same order. If their counts do not match, Flutter reports a tab-controller mismatch error.


E7. Why is the dialog result bool?, and why check == true?
Reference: lib/screens/my_orgs_screen.dart, lines 29 and 45.

The dialog returns a bool? because its result can be true, false, or null. Leave returns true, Cancel returns false, and dismissing the dialog without choosing either button can return null. Checking confirmed == true removes the membership only when the user explicitly confirms.


E8. Why use Table instead of a Column of Rows?
Reference: lib/screens/schedule_screen.dart, line 53.

Table shares column widths across its rows, keeping the Time, Booth, and Org entries aligned. A Column of independently sized Row widgets does not automatically coordinate those widths, so different text lengths can cause misalignment. The table uses fixed widths for Time and Booth, while the Org column takes the remaining space.