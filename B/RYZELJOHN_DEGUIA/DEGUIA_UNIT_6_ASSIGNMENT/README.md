## E1 - Lifting state up in HomeShell
State lives right inside `HomeShell` because `OrgListScreen`, `MyOrgsScreen`, and `ScheduleScreen` all need access to the exact same dataset simultaneously. Instead of forcing individual screens to manage fragmented copies, everything funnels through a single source of truth at `lib/screens/home_shell.dart:22-25`.

## E2 - Why IndexedStack keeps the search text
Switching tabs normally destroys widget state. `IndexedStack` bypasses this by hiding unselected pages rather than unmounting them, keeping the active instance—and any typed query inside `OrgListScreen`—safe in memory at `lib/screens/home_shell.dart:56-62`.

## E3 - Why the drawer closes before opening About
Dismissing the drawer before loading the About screen prevents old routing history from lingering underneath. Leaving it open leaves a stale phantom layer behind the UI. You can find this exact ordering at `lib/screens/org_list_screen.dart:128-138`.

## E4 - Wrap versus Row for chips
`Wrap` automatically shifts items onto the next line when horizontal space runs thin. A standard `Row` refuses to wrap, pushing content off-screen and triggering overflow warnings. Check the implementation at `lib/screens/org_list_screen.dart:255-270`.

## E5 - Column math for maxCrossAxisExtent
Grid layouts divide available screen width against `maxCrossAxisExtent` to compute column counts automatically. A narrow phone display restricts things to a single column, whereas wider viewports expand based on those exact pixel thresholds (`lib/screens/org_list_screen.dart:289-304`).

## E6 - Matching lengths in DefaultTabController, TabBar, and TabBarView
Flutter expects a strict one-to-one ratio between the `DefaultTabController` length, the `TabBar` items, and the `TabBarView` children. Mismatches shatter widget routing and trigger runtime faults. Look at `lib/screens/org_detail_screen.dart:28-54`.

## E7 - Why the dialog result is bool? and checked with == true
Dialogs can be dismissed by tapping outside or hitting back, returning a raw `null` instead of a flat `false`. Checking `confirmed == true` guards against those ambiguous null states before triggering data mutations (`lib/screens/my_orgs_screen.dart:23-50`).

## E8 - Why a Table is used instead of a Column of Rows
Plain rows size themselves independently, which turns schedules into misaligned chaos. A proper `Table` forces shared column constraints across every single row, keeping times, booths, and names rigidly aligned (`lib/screens/schedule_screen.dart:41-69`).