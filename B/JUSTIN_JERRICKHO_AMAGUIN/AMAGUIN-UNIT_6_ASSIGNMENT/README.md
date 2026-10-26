## E1 Membership state in HomeShell
Reference: lib/screens/home_shell.dart, line 25

The Orgs, My Orgs, and Schedule screens all need the membership information. HomeShell keeps it in one map and shares it with these screens. This keeps them consistent when an organization is joined or left.

## E2 Keeping the search when switching tabs
Reference: lib/screens/home_shell.dart, line 62

IndexedStack keeps all three pages in the widget tree but only shows the selected page. This keeps OrgListScreen and its search controller alive when switching tabs. When the user returns, the search text and filter are still there.

## E3 Closing the drawer before opening About
Reference: lib/screens/org_list_screen.dart, lines 136 and 137

Navigator.pop(context) closes the drawer before the About screen opens. Without it, the drawer can still be open when the user returns from About.

## E4 Using Wrap for the category chips
Reference: lib/screens/org_list_screen.dart, line 262

Wrap moves the chips onto another line when there is not enough horizontal space. A Row keeps them on one line, which can cause an overflow on a narrow screen.

## E5 How the grid decides its columns
Reference: lib/screens/org_list_screen.dart, line 301

The grid uses the available width, the 200-pixel setting, and the 8-pixel gaps to choose its columns. On a 360-pixel screen, subtracting the side padding leaves 344 pixels, giving ceil(344 / 208) = 2 columns with tiles measuring (344 - 8) / 2 = 168 pixels wide. On a 1000-pixel screen, the available width is 984 pixels, giving ceil(984 / 208) = 5 columns with tiles measuring (984 - 32) / 5 = 190.4 pixels wide.

## E6 Matching the tabs and pages
Reference: lib/screens/org_detail_screen.dart, lines 36, 40, and 48

The DefaultTabController length, the number of tabs, and the number of TabBarView children must match. This app has three of each for About, Officers, and Events. If the counts differ, Flutter reports an error in debug mode because the controller does not match the tabs or pages.

## E7 Handling the dialog result
Reference: lib/screens/my_orgs_screen.dart, lines 29 and 45

The dialog returns bool? because the answer can be true, false, or null. Leave returns true, Cancel returns false, and dismissing the dialog without choosing a button can return null. Checking confirmed == true makes sure the membership is removed only when the user chooses Leave.

## E8 Using a Table for the schedule
Reference: lib/screens/schedule_screen.dart, lines 53–58

Table keeps the Time, Booth, and Org columns aligned across all rows. The first two columns have fixed widths, while the Org column uses the remaining space. Separate Rows could size their contents differently unless matching widths were set for every row.
