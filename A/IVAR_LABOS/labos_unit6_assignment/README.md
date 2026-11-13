# CICT Org Fair, Part 2 (Unit 6 Assignment)

Name: Ivar R Labos
Year and Section: BSIT 3-A

## Part I: Expalain answers

**E1: Lifting state up (`lib/screens/home_shell.dart`, line 25)**
Three screens need the `_memberships` map: the Orgs list shows the "Joined" chip, My Orgs lists the joined orgs, and Schedule highlights their booths. None of these screens can keep the map for the others, because sibling widgets cannot read each other's State. HomeShell is their common parent, so it owns the map, passes it down as parameters, and receives changes back through callbacks like `_join` and `_leave`.

**E2: IndexedStack keeps the search text (`lib/screens/home_shell.dart`, line 60)**
`IndexedStack` builds all three pages at once and only shows the one at `index`, so the other pages stay in the widget tree. Because OrgListScreen is never removed, its State (and the `TextEditingController` with my search text) stays alive while I look at another tab. With `pages[_index]`, the old page is thrown away on every switch, so its State is destroyed and the search box comes back empty.

**E3: Closing the drawer first (`lib/screens/org_list_screen.dart`, lines 136-137)**
The drawer is itself a route that sits on top of the Navigator stack. If I call `pushNamed` without `Navigator.pop(context)` first, About opens on top of the drawer, so when I press back I land on the still-open drawer instead of the list. Popping first removes the drawer, so back goes straight to the list.

**E4: Wrap or Row for the chips (`lib/screens/org_list_screen.dart`, line 260)**
When the chips do not fit on one line, `Wrap` moves the extra chips down to a new line, and nothing is cut off. A `Row` never wraps; it keeps everything on one line, so the chips that do not fit overflow and Flutter shows the yellow-black overflow stripes with an error in the console.

**E5: Column math of maxCrossAxisExtent (`lib/screens/org_list_screen.dart`, line 299)**
The grid picks the smallest number of columns that keeps every tile at most 200 wide: `columns = ceil(usableWidth / (200 + 8))`. A 360-wide phone has 360 - 16 = 344 usable, 344 / 208 = 1.65, so 2 columns, and each tile is (344 - 8) / 2 = 168 wide. A 1000-wide window has 984 usable, 984 / 208 = 4.73, so 5 columns, and each tile is (984 - 4 x 8) / 5 = 190.4 wide.

**E6: Matching the tab numbers (`lib/screens/org_detail_screen.dart`, lines 36, 40-44, 48)**
The `length` of DefaultTabController, the number of `Tab`s in the TabBar and the number of children in the TabBarView must all be the same number (3 now: About, Officers, Events), and in the same order, so tab *i* shows child *i*. If they do not match, Flutter throws an assertion error ("Controller's length property does not match the number of tabs") and the tabs fail to show properly.

**E7: Why `bool?` and `== true` (`lib/screens/my_orgs_screen.dart`, lines 29 and 46)**
`showDialog<bool>` returns `null` when the user closes the dialog without pressing either button, for example by tapping outside it or pressing the back button. Since `confirmed` can be null, `if (confirmed)` does not compile under null safety. Writing `confirmed == true` is only true for the Leave button, so null and false both mean "do not leave".

**E8: Table instead of Column of Rows (`lib/screens/schedule_screen.dart`, line 53)**
A `Table` gives one shared set of column widths (`columnWidths`) to every row, so the Time, Booth and Org cells line up in straight columns. If each `Row` in a `Column` sized itself, every row would be laid out on its own and the cells would start at different x-positions whenever the text length is different. A Table also gives per-row decoration (TODO 13) and borders.
