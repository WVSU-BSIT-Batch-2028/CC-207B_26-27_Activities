Unit 6 Assignment — CICT Org Fair App
E1. Lifting State Up
Location: lib/screens/home_shell.dart, lines 25–34 and 43–53.
The membership map is stored in HomeShell because the Orgs, My Orgs, and Schedule screens all need the same membership data. HomeShell passes this data to the screens, so when a student joins or leaves an organization, the shared state updates and the screens can display the changes.
E2. IndexedStack
Location: lib/screens/home_shell.dart, lines 58–66.
The IndexedStack displays only the selected page while keeping all three pages mounted. This preserves each page's state, such as the search text, when the user switches tabs and returns to the Orgs page.
E3. Closing the Drawer
Location: lib/screens/org_list_screen.dart, lines 131–138.
Navigator.pop(context) closes the drawer before Navigator.pushNamed() opens the About screen. This prevents the drawer from remaining open when the user returns from the About page.
E4. Wrap vs. Row
Location: lib/screens/org_list_screen.dart, lines 253–269.
Wrap automatically moves category filter chips to the next line when there is not enough horizontal space. A Row keeps its children on one line, which can cause a layout overflow on smaller screens.
E5. Responsive Grid
Location: lib/screens/org_list_screen.dart, lines 287–302 — _buildGrid() and SliverGridDelegateWithMaxCrossAxisExtent.
SliverGridDelegateWithMaxCrossAxisExtent adjusts the number of columns based on the available screen width, with each tile having a maximum width of 200 pixels. For a 360-pixel screen, the 8-pixel padding on both sides leaves 344 pixels, so two columns fit: (344 − 8) ÷ 2 = 168 pixels per tile. For a 1000-pixel screen, 984 pixels remain, allowing five columns: (984 − 32) ÷ 5 = 190.4 pixels per tile.
E6. Tab Lengths
Location: lib/screens/org_detail_screen.dart, lines 29–56.
The DefaultTabController length, the number of TabBar tabs, and the number of TabBarView children must all match. This app has three tabs—About, Officers, and Events—with one corresponding page for each. If the counts do not match, Flutter can produce an assertion error.
E7. Dialog Return Value
Location: lib/screens/my_orgs_screen.dart, lines 23–50 — _confirmLeave().
showDialog<bool>() returns true when the user selects Leave, false when the user selects Cancel, and potentially null if the dialog is dismissed without choosing either button. Checking confirmed == true ensures that the organization is removed only when the user confirms the action.
E8. Table vs. Column of Rows
Location: lib/screens/schedule_screen.dart, lines 49–69 — Table in build().
A Table keeps the Time, Booth, and Org columns aligned across all rows. Separate Row widgets inside a Column may calculate their column widths independently, making the schedule harder to read because the columns might not line up.
