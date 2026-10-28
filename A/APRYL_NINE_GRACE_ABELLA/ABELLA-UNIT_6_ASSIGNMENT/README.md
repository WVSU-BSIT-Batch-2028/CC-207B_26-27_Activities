## Part I — Code Explanations

### E1 — Why memberships are stored in HomeShell
Source: `lib/screens/home_shell.dart`, EXPLAIN comment at line 22.

Memberships are stored in HomeShell because several parts of the app need the same membership information. HomeShell passes this information to the Orgs, My Orgs, and Schedule pages and uses it for the navigation badge. Keeping one shared map in their parent prevents the pages from having different versions of the membership data.


### E2 — Why IndexedStack preserves search text
Source: `lib/screens/home_shell.dart`, EXPLAIN comment at line 57.

IndexedStack keeps all its pages in the widget tree while displaying only the selected page. This keeps the existing OrgListScreen State, including its search controller and search query, alive when I switch tabs. When I return to Orgs, the previous search text and results are still there.


### E3 — Why the drawer closes before opening About
Source: `lib/screens/org_list_screen.dart`, EXPLAIN comment at line 131.

Navigator.pop closes the drawer before Navigator.pushNamed opens the About screen. Without the first call, the drawer can remain open underneath the About screen. Closing it first means that going back from About returns to the normal Orgs page instead of an open drawer.


### E4 — Why the filter chips use Wrap
Source: `lib/screens/org_list_screen.dart`, EXPLAIN comment at line 257.

Wrap moves chips onto another line when they do not fit within the available width. A Row keeps the chips on one horizontal line, which can cause an overflow on a narrow screen. Using Wrap allows the filter controls to fit different screen sizes without requiring horizontal scrolling.


### E5 — How maxCrossAxisExtent determines the grid columns
Source: `lib/screens/org_list_screen.dart`, EXPLAIN comment at line 294.

The grid delegate calculates its column count from the available width instead of using a fixed number of columns. With 8 pixels of padding on each side, a 360-pixel-wide viewport leaves 344 pixels for the grid, producing two columns with tiles that are 168 pixels wide after the gap is included. A 1000-pixel-wide viewport leaves 984 pixels, producing five columns with tiles that are 190.4 pixels wide after the four gaps are included.


### E6 — What must match in the tab setup
Source: `lib/screens/org_detail_screen.dart`, EXPLAIN comment at line 29.

DefaultTabController.length must match the number of tabs in TabBar and the number of children in TabBarView. This app needs three of each, ordered as About, Officers, and Events. A count mismatch causes an error, while an incorrect order can display content under the wrong tab.


### E7 — Why the dialog result is nullable
Source: `lib/screens/my_orgs_screen.dart`, EXPLAIN comment at line 24.

showDialog<bool> returns a Future<bool?> because the dialog can close without returning a value, such as when the user taps outside it. In this implementation, Cancel returns false, Leave returns true, and dismissal without a result returns null. Checking confirmed == true allows the membership to be removed only when the user explicitly chooses Leave.


### E8 — Why the schedule uses Table
Source: `lib/screens/schedule_screen.dart`, EXPLAIN comment at line 51.

Table keeps the Time, Booth, and Org columns aligned across all schedule rows by applying shared column widths. This implementation gives Time a width of 96 pixels, Booth 72 pixels, and the remaining width to Org. Separate Row widgets would not automatically coordinate their column widths, so I would need to repeat the sizing rules manually to maintain alignment.