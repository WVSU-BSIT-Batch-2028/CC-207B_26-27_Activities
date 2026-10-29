# Explanation of E1 to E8

## E1 - Lifting State Up in HomeShell

The joined organizations are stored in `HomeShell` because multiple screens need to access the same data. `OrgListScreen` checks which organizations the user has joined, `MyOrgsScreen` displays and removes memberships, and `ScheduleScreen` uses the joined organization IDs to highlight schedule entries. Keeping the data in `lib/screens/home_shell.dart:22-25` provides one shared source of information and keeps the screens synchronized.

## E2 - How IndexedStack Preserves Search Text

`IndexedStack` keeps pages in memory when switching between tabs instead of destroying them. Since `OrgListScreen` remains active, its `TextEditingController` and `_query` variable retain their values. This allows the search text to remain when the user returns to the screen. The implementation is in `lib/screens/home_shell.dart:56-62`.

## E3 - Why the Drawer Closes Before Opening About

The drawer is closed before navigating to the About screen to ensure proper navigation. This prevents the drawer from remaining open and allows the user to return to the previous screen correctly. The navigation code is in `lib/screens/org_list_screen.dart:128-138`.

## E4 - Why Wrap Is Used Instead of Row for Chips

`Wrap` allows chips to move to the next line when there is not enough horizontal space. This makes the layout responsive to different screen sizes. On the other hand, `Row` keeps its children on one horizontal line, which may cause overflow on smaller screens. The code is in `lib/screens/org_list_screen.dart:255-270`.

## E5 - Understanding Column Calculation with maxCrossAxisExtent

The grid determines how many columns can fit based on the available screen width and the maximum width of each tile. For example, a 360-pixel-wide phone may only fit one 200-pixel tile per row when spacing is included. Wider screens can accommodate more columns. This helps the grid adjust to different screen sizes. The implementation is in `lib/screens/org_list_screen.dart:289-304`.

## E6 - Matching DefaultTabController, TabBar, and TabBarView Lengths

The number of tabs in `TabBar`, the length specified in `DefaultTabController`, and the number of pages in `TabBarView` must be equal. This ensures that every tab corresponds to the correct page. If their lengths do not match, the application may encounter errors or display inconsistent content. The relevant code is in `lib/screens/org_detail_screen.dart:28-54`.

## E7 - Why the Dialog Returns bool? and Uses == true

The `showDialog<bool>` function can return `true`, `false`, or `null`. A `null` result occurs when the dialog is dismissed without selecting an option, such as when the user taps outside the dialog or presses the back button. Using `confirmed == true` ensures that the action continues only when the user explicitly confirms it. The dialog logic is in `lib/screens/my_orgs_screen.dart:23-50`.

## E8 - Why Table Is Used Instead of a Column of Rows

A `Table` keeps columns aligned across all rows, making schedule information easier to read and organize. This is useful for displaying times, booths, and organization names consistently. Using separate rows could result in different column widths, making the schedule look uneven. The implementation is in `lib/screens/schedule_screen.dart:41-69`.
