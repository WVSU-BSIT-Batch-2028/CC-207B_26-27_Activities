# ANDRADA - Unit 6 Assignment (CICT Org Fair Part 2)

## EXPLAIN answers

**E1** (lib/screens/home_shell.dart, line 25)

The joined orgs are needed by three screens: the Orgs list (to show which orgs I'm a member of), My Orgs (to list them), and Schedule (to highlight their booths). These screens are siblings, so one of them can't see the data inside another. That's why `_memberships` lives in their shared parent, HomeShell, which passes it down to all three and rebuilds them with setState. This is called lifting state up.

**E2** (lib/screens/home_shell.dart, line 60)

The IndexedStack keeps the search text. It builds all three pages and keeps them alive, but only shows the page at `_index`, so the Orgs page and its search box are never destroyed when I switch tabs. Without it (Experiment C1, using `pages[_index]`), the Orgs page is thrown away and rebuilt, so the search box comes back empty.

**E3** (lib/screens/org_list_screen.dart, line 136)

The drawer is a route on top of the Orgs screen, so it has to be closed with Navigator.pop before About is pushed. If we skip the pop (Experiment C4), About opens on top of the open drawer, and when I press Back the drawer is still showing instead of the org list.

**E4** (lib/screens/org_list_screen.dart, line 260)

A Wrap moves the chips that don't fit onto the next line, so all of them stay visible on a narrow screen. A Row keeps all its children on one line no matter what, so on a small screen the chips run past the edge and Flutter shows the yellow-and-black overflow stripes (Experiment C2).

**E5** (lib/screens/org_list_screen.dart, line 299)

maxCrossAxisExtent: 200 means each tile can be at most 200 wide, so Flutter uses the fewest columns that keep tiles under that size. Phone: usable width is 360 - 16 padding = 344, and 344 / (200 + 8 spacing) = 1.65, rounded up to 2 columns, each (344 - 8) / 2 = 168 wide. A 1000-wide window: 1000 - 16 = 984, and 984 / 208 = 4.73, rounded up to 5 columns, each (984 - 4 x 8) / 5 = about 190 wide (Experiment C5).

**E6** (lib/screens/org_detail_screen.dart, line 32)

The `length` of DefaultTabController, the number of tabs in the TabBar, and the number of children in the TabBarView must all be the same, which is 3 here (About, Officers, Events), and in the same order. If they don't match (Experiment C3), Flutter throws an error and shows the red error screen, because the controller doesn't know which page belongs to which tab.

**E7** (lib/screens/my_orgs_screen.dart, line 29)

showDialog returns `bool?` because the dialog can close without pressing any button, for example by tapping outside it or pressing Back, and then the result is null. Dart won't let us write `if (confirmed)` with a nullable bool, and null should not count as yes anyway. Checking `confirmed == true` means the org is only removed when the user actually pressed Leave.

**E8** (lib/screens/schedule_screen.dart, line 51)

A Table makes every row share the same column widths, so the Time, Booth and Org columns line up from top to bottom. If it were a Column of Rows, each Row would size its own cells, so a row with a long org name would have different widths and the columns would not line up.