# UNIT 6 Assignment - CICT Org Fair Part 2

## Explanations

### E1 — Shared membership state

`HomeShell` owns the membership map because the Orgs list, My Orgs page, and schedule all need to read the same joined organizations. As shown in `lib/screens/home_shell.dart` (lines 22–51), keeping the map in one shared parent allows the child screens to report actions back to the shell, so their views stay in sync.

### E2 — Keeping tab state

`IndexedStack` keeps each tab's widget mounted and displays the selected child. In `lib/screens/home_shell.dart` (lines 55–60), this allows each tab to retain its state. For example, the org list's search text controller in `lib/screens/org_list_screen.dart` (lines 31–34) keeps its value when the user switches tabs.

### E3 — Closing the drawer before About

The drawer is a route layered over the org list. In `lib/screens/org_list_screen.dart` (lines 131–139), popping the drawer first removes that layer before the named About route is pushed. When About is closed, the user returns to the org list without the old drawer still open.

### E4 — Wrap for category chips

`Wrap` lays chips from left to right and starts another line when there is not enough horizontal room. In `lib/screens/org_list_screen.dart` (lines 255–270), using `Wrap` instead of a `Row` helps prevent the category chips from overflowing on narrow screens.

### E5 — Grid sizing from available width

`SliverGridDelegateWithMaxCrossAxisExtent` fits as many columns as it can while keeping each tile at or below 200 logical pixels wide. On a 360-pixel phone, the grid has 344 pixels after its 16 pixels of padding; with two columns and one 8-pixel gap, each tile is 168 pixels wide: `(344 - 8) / 2 = 168`. On a 1000-pixel window, 984 pixels remain after padding; five columns with four 8-pixel gaps give tiles about 190 pixels wide: `(984 - 32) / 5 = 190.4`. The responsive delegate is in `lib/screens/org_list_screen.dart` (lines 292–304).

### E6 — Matching tab counts

The controller length, the number of `Tab` widgets, and the number of `TabBarView` children must all be three. As shown in `lib/screens/org_detail_screen.dart` (lines 29–57), each tab index needs a matching page at the same position. If the counts differ, the tab controller can produce an assertion error or a selected tab may not have a corresponding page.

### E7 — Nullable dialog result

The dialog returns `false` for Cancel and `true` for Leave. In `lib/screens/my_orgs_screen.dart` (lines 24–50), the result is nullable because the dialog could be dismissed without either button being pressed. Checking `confirmed == true` means leaving happens only after the user confirms.

### E8 — Table column alignment

`Table` gives every row the same column widths, so the time, booth, and organization values line up. In `lib/screens/schedule_screen.dart` (lines 49–72), using a `Table` keeps the columns aligned, unlike separate `Row` widgets whose children could be sized differently depending on their text.
