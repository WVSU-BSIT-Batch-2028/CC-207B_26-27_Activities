# ESPINOSA-UNIT_6_ASSIGNMENT

CICT Org Fair App Part 2 - Kristine Joy Espinosa, BSIT 3B

## Explanations

**E1 - `lib/screens/home_shell.dart`, line 25**
The `_memberships` map is used by 3 screens: Orgs, My Orgs and Schedule. If only one screen keeps it, the other screens can't see or change it. That's why it's put in `HomeShell`, the parent of all 3, so it can pass the map down to them and update it using `_join` and `_leave`.

**E2 - `lib/screens/home_shell.dart`, line 60**
`IndexedStack` builds all 3 pages but only shows the one at `_index`. The other pages are just hidden, not removed, so the Orgs page still keeps the search text. If we only use `pages[_index]`, the page gets removed when we switch tabs so the search is gone.

**E3 - `lib/screens/org_list_screen.dart`, lines 136-137**
The drawer is also part of the Navigator stack. Line 136 (`Navigator.pop`) closes the drawer first, then line 137 opens the About screen. If we don't close it, the drawer is still open behind About, so when we press back we go back to the drawer and not the list.

**E4 - `lib/screens/org_list_screen.dart`, line 260**
If we use a `Row`, all the chips stay in one line, so on a small phone they don't fit and we get the yellow and black overflow error. `Wrap` moves the chips that don't fit to the next line, so all chips can still be seen.

**E5 - `lib/screens/org_list_screen.dart`, line 300**
`maxCrossAxisExtent: 200` means one tile can only be up to 200 wide. For a 360 wide phone: 360 / 200 = 1.8, rounded up is 2 columns, so each tile is around 180 wide. For a 1000 wide window: 1000 / 200 = 5 columns, around 200 wide each. The 8 px spacing makes them a bit smaller.

**E6 - `lib/screens/org_detail_screen.dart`, line 36**
The `length` in `DefaultTabController`, the number of Tabs in `TabBar`, and the number of children in `TabBarView` should all be the same (3) and in the same order, because tab 1 shows page 1 and so on. If they are not the same, Flutter shows an error.

**E7 - `lib/screens/my_orgs_screen.dart`, lines 29 and 45**
The dialog gives back `null` if the user closes it without pressing a button, like tapping outside or pressing back. That's why it's `bool?` and not `bool`. We check `confirmed == true` so the user only leaves the org if they really pressed Leave. If it's null, it acts like Cancel.

**E8 - `lib/screens/schedule_screen.dart`, line 50**
A `Table` makes each column the same width in every row, so Time, Booth and Org are lined up. If we use a Column of Rows, each Row sizes its own cells, so the columns won't line up.
