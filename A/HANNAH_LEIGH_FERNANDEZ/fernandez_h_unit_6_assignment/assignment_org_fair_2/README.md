# unit6_org_fair_assignment

# ANSWERS

E1: `(lib/screens/home_shell.dart; line 25)` OrgListScreen needs this map to display joined orgs, MyOrgsScreen to show the memberships, and ScheduleScreen to note the orgs joined with their booth schedule. They can’t keep it for the others because they're children under HomeShell, which holds the membership data and can easily pass it to the others.

E2:`(lib/screens/home_shell.dart; line 62)` IndexedStack keeps the page alive if you switch because the state doesn't get disposed of when you switch tabs, which keeps the state of texts and other screens from being lost. Experiment C1 shows that using only pages[_index] would clear the search because the previous screen gets removed, so its state is lost.

E3: `(lib/screens/org_list_screen.dart lines 131–134)` Navigator.pop  closes the drawer before opening the About page. In Experiment C4, the drawer wont close, which interferes with the experience and navigation of the app.

E4: `(lib/screens/org_list_screen.dart line 258)` A Wrap moces the chips to the next line when there is no more space. Using Row would force everything in one line and would cause overflow.

E5: `(lib/screens/org_list_screen.dart lines 297–302)`The formula is columns = floor((width + 8) / (200 + 8)). The 8 is added because of the spacing between columns, and we round down to count the complete tiles that fit.

For 360: (360 + 8) / 208 = 1.76 = 1 column, each tile is 200 pixels maximum wide.

For 1000: (1000 + 8) / 208 = 4.84 = 4 columns, each tile is 200 pixels maximum wide.

E6: `(lib/screens/org_detail_screen.dart lines 32–52)` The number of tabs, pages, and controller length must match. Flutter will show an error because it cannot find the matching page for each tab.

E7: `(lib/screens/my_orgs_screen.dart lines 29 and 46)` howDialog returns true, false, or null. Cancelling returns false, Leaving returns true, and dismissing the dialog returns null. We test confirmed == true so the org is removed only when the user presses Leave.

E8: `(lib/screens/schedule_screen.dart lines 53–59)` Table is used instead of rows because they all share the same column widths. If each Row sized itself, the widths would be different because they would depend on the text length, causing misaligned columns.