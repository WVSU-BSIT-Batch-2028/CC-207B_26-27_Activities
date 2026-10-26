# CICT Org Fair Part 2

## Explanations

### E1 — Shared membership state

`HomeShell` stores memberships because the Orgs list, My Orgs page, and Schedule all need to reflect the same joins ([home_shell.dart](./lib/screens/home_shell.dart:25)). Keeping this map in one parent lets the child screens receive the current data and report changes through callbacks, rather than maintaining separate copies that could disagree.

### E2 — Keeping tabs alive

`IndexedStack` displays the selected page while keeping the other pages mounted ([home_shell.dart](./lib/screens/home_shell.dart:60)). Since the Orgs page is not destroyed when switching tabs, its state—including the search text—remains available when the user returns.

### E3 — Closing the drawer before About

The drawer is closed with `Navigator.pop` before the named About route is pushed ([org_list_screen.dart](./lib/screens/org_list_screen.dart:136)). This removes the drawer overlay first, so the About page opens as the next screen and returning from it does not reveal an unexpectedly open drawer.

### E4 — Wrap versus Row

The category chips are children of a `Wrap` ([org_list_screen.dart](./lib/screens/org_list_screen.dart:262)). When they do not fit on one line, `Wrap` places later chips on another line; a `Row` would keep them in one horizontal line and could overflow the available width.

### E5 — Grid column sizing

`SliverGridDelegateWithMaxCrossAxisExtent` uses a maximum tile width of 200 pixels and 8-pixel spacing ([org_list_screen.dart](./lib/screens/org_list_screen.dart:301)). At 360 pixels wide, the grid has 344 pixels after its 8-pixel side padding; that fits 2 columns of 168 pixels each. At 1000 pixels wide, the 984-pixel grid area fits 5 columns of about 190 pixels each.

### E6 — Matching tab counts

`DefaultTabController` has a length of 3, matching the three tabs and three `TabBarView` children ([org_detail_screen.dart](./lib/screens/org_detail_screen.dart:32)). Their counts and ordering must match so each tab selects the corresponding page; a mismatch causes a runtime assertion.

### E7 — Confirming a leave action

`showDialog<bool>` returns a nullable boolean: the dialog buttons return `true` or `false`, while dismissing the dialog without choosing a button returns `null` ([my_orgs_screen.dart](./lib/screens/my_orgs_screen.dart:29)). Testing `confirmed == true` ensures only the explicit Leave choice removes a membership.

### E8 — Using a Table for the schedule

The schedule uses a `Table` to give each row shared column widths ([schedule_screen.dart](./lib/screens/schedule_screen.dart:53)). If each row were a separate `Row`, its children could size their columns independently, making the time, booth, and organization values misalign from one row to the next.
