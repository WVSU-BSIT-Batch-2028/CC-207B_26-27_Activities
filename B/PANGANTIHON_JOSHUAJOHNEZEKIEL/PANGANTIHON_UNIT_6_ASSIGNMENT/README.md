# EXPLAIN E1 to E8

## E1 - Lifting state up in HomeShell
The joined orgs live in `HomeShell` because several screens need the same information at the same time. `OrgListScreen` needs to know whether an org is already joined, `MyOrgsScreen` needs to list and remove memberships, and `ScheduleScreen` needs the joined IDs to highlight rows. The map is stored in `lib/screens/home_shell.dart:22-25` so there is one shared source of truth instead of several screens each trying to keep their own copy.

## E2 - Why IndexedStack keeps the search text
`IndexedStack` keeps the old page widgets alive instead of destroying them when the user switches tabs. Because the `OrgListScreen` instance stays in memory, its `TextEditingController` and `_query` value remain available, so the search text is still there when the user returns. This behavior is in `lib/screens/home_shell.dart:56-62`.

## E3 - Why the drawer closes before opening About
The drawer should be closed before navigating to the About screen so the old route is removed from the stack and does not remain behind the new screen. If it stays open, the user can end up returning to a stale drawer instead of the previous screen. The close-and-open pattern is in `lib/screens/org_list_screen.dart:128-138`.

## E4 - Wrap versus Row for chips
`Wrap` lets the chips move onto a new line when there is not enough horizontal space, which makes the layout responsive. A `Row` would force everything onto one line and overflow the available width, causing layout issues. The chip layout is in `lib/screens/org_list_screen.dart:255-270`.

## E5 - Column math for maxCrossAxisExtent
The grid calculates how many columns fit inside the available width and limits each tile so it does not exceed `maxCrossAxisExtent`. With a 360-wide phone, two 200-wide tiles would be too wide once spacing is included, so it usually fits only one column; on a wider screen, more columns can fit. The relevant code is in `lib/screens/org_list_screen.dart:289-304`.

## E6 - Matching lengths in DefaultTabController, TabBar, and TabBarView
The number of tabs, the length passed to `DefaultTabController`, and the number of children in `TabBarView` must all match so each tab index has a page to show. If they do not match, Flutter cannot map tab positions to content properly and the tab UI becomes inconsistent or crashes. The matching structure is in `lib/screens/org_detail_screen.dart:28-54`.

## E7 - Why the dialog result is bool? and checked with == true
`showDialog<bool>` returns a nullable bool because the dialog can be dismissed without a real choice, such as by tapping outside or pressing the back button. That makes the result `null` instead of `false`, so the code must check `confirmed == true` to be sure the user actually confirmed leaving. The dialog logic is in `lib/screens/my_orgs_screen.dart:23-50`.

## E8 - Why a Table is used instead of a Column of Rows
A `Table` keeps every column aligned across the whole schedule, which is important for a list of times, booths, and organization names. If each row was sized independently, the columns could end up with different widths and the schedule would look uneven and disorganized. The table layout is in `lib/screens/schedule_screen.dart:41-69`.
