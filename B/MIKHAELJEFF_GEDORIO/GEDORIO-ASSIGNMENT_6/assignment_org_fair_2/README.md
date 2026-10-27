# Unit 6 Assignment – Code Explanations

## E1. Why does the membership data live in HomeShell?

Location: `lib/screens/home_shell.dart`, line 25

The membership data is stored in `HomeShell` because different screens need to use the same information. For example, My Orgs shows the organizations I joined, while Schedule highlights their rows. Keeping the data in one place helps the screens stay updated.

E2. Why use IndexedStack?

Location: `lib/screens/home_shell.dart`, line 60

`IndexedStack` keeps the pages alive even when I switch to another tab. This helps preserve information, such as the search text I entered on the Orgs page. Without it, the page might be rebuilt and lose its current state.

## E3. Why close the drawer before opening About?

Location: `lib/screens/org_list_screen.dart`, lines 137-138

The drawer is closed first using `Navigator.pop(context)`. Then, `Navigator.pushNamed` opens the About screen. This prevents the drawer from staying open over the new screen.

## E4. Why use Wrap instead of Row for the filter chips?

Location: `lib/screens/org_list_screen.dart`, lines 263-273

`Wrap` allows the filter chips to move to the next line when there is not enough space. A `Row` tries to keep its children on one line, which can cause an overflow on a narrow screen. Using `Wrap` makes the layout fit better on different screen sizes.

## E5. How does maxCrossAxisExtent affect the grid?

Location: `lib/screens/org_list_screen.dart`, lines 302-307

`SliverGridDelegateWithMaxCrossAxisExtent` sets the maximum width of each grid item. The grid adjusts the number of columns depending on the available screen width. A wider screen can show more columns, while a smaller screen shows fewer.

## E6. What must match in DefaultTabController, TabBar, and TabBarView?

Location: `lib/screens/org_detail_screen.dart`, lines 37-56

The controller length, the number of tabs, and the number of pages must be the same. In my app, there are three tabs: About, Officers, and Events, with one page for each tab. If these numbers do not match, the tab layout can cause an error.

## E7. Why check confirmed == true?

Location: `lib/screens/my_orgs_screen.dart`, lines 24–43

The result of `showDialog<bool>` can be `true`, `false`, or `null` if the dialog is dismissed without choosing an answer. I use `confirmed == true` so the organization is removed only when the user presses Leave. Pressing Cancel keeps the organization in the list.

## E8. Why use a Table instead of a Column of Rows?

Location: `lib/screens/schedule_screen.dart`, lines 16-71

A `Table` keeps the schedule columns aligned, so the time, booth, and organization information stays in the correct columns. If I used separate `Row` widgets, each row's contents could take up different amounts of space. A `Table` makes the schedule easier to read.
