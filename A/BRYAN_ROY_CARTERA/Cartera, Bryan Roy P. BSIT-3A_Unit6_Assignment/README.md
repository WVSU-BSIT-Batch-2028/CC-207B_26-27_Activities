# Unit 6: Organization Fair — Cartera

### E1 — `home_shell.dart`, `_memberships`

**Question: Why are the joined organizations stored in HomeShell?**

The membership data is stored in HomeShell because three screens need to use it: OrgListScreen, MyOrgsScreen, and ScheduleScreen. OrgListScreen shows which organizations the user has joined, MyOrgsScreen displays the joined organizations, and ScheduleScreen highlights their schedules. Since these screens are siblings, they cannot directly access each other's state. HomeShell acts as their common parent and shares the membership data with all three screens. This method is known as *lifting state up*.

# E2 — `home_shell.dart`, `body`

**Question: Why does IndexedStack keep the search text?**

IndexedStack keeps all its child screens in the widget tree but only displays the selected screen. Because OrgListScreen stays in the tree when switching tabs, its state and TextEditingController are preserved. This allows the search text to remain when the user returns to the screen. If we used `pages[_index]` instead, the previous screen would be removed, its state would be destroyed, and the search text would be lost.

# E3 — `org_list_screen.dart`, drawer `onTap`

**Question: Why should the drawer close before opening About?**

The drawer appears on top of the current screen. If we open the About page while the drawer is still open, it might remain open when the user returns. Closing the drawer first makes sure that the app returns to the normal screen before navigating to About. This keeps the navigation process organized and meets the test's expectation that the drawer should be closed after pressing the back button.

# E4 — `org_list_screen.dart`, category chips in `Wrap`

**Question: Why use Wrap instead of Row?**

Wrap automatically moves items to the next line when there is not enough horizontal space. This is useful for category chips because the number of categories and the screen size can change. Row tries to arrange all the chips on a single line, which may cause an overflow error if they do not fit. Using Wrap makes the layout more flexible and prevents the chips from going outside the screen.

# E5 — `org_list_screen.dart`, `_buildGrid`

**Question: How do you calculate the grid columns and tile width using `maxCrossAxisExtent: 200`?**

GridView first subtracts the padding from the total screen width to determine the available space. For a phone that is 360 pixels wide with 8 pixels of padding on both sides, the available width is 360 − 16 = 344 pixels. With a maximum tile width of 200 pixels and 8 pixels of spacing, the grid will have approximately 2 columns. Each tile will be (344 − 8) ÷ 2 = 168 pixels wide.

For a window that is 1000 pixels wide, the available width is 1000 − 16 = 984 pixels. Using the same spacing and maximum extent, the grid will have approximately 5 columns. The tile width will be (984 − 4 × 8) ÷ 5 = 190.4 pixels. This allows the grid to adjust to different screen sizes.

# E6 — `org_detail_screen.dart`, `DefaultTabController`

**Question: What must match in DefaultTabController, TabBar, and TabBarView?**

The length set in DefaultTabController must be equal to the number of tabs in TabBar and the number of pages in TabBarView. If these numbers are different, Flutter may produce an assertion error because the tabs and their corresponding pages do not match. In this project, all three must have a length of 3 for the About, Officers, and Events tabs.

# E7 — `my_orgs_screen.dart`, `_confirmLeave`

**Question: Why does the dialog return a Boolean, and why do we check `== true`?**

The `showDialog<bool>` function returns a `Future<bool?>`, which means the result can be true, false, or null. Choosing Leave returns true, while choosing Cancel returns false. If the user closes the dialog by tapping outside it or pressing the system back button, the result may be null. Checking `confirmed == true` ensures that the organization is removed only when the user explicitly confirms the action. Both false and null mean that the organization should remain in the list.

# E8 — `schedule_screen.dart`, `Table`

**Question: Why use a Table instead of a Column of Rows?**

A Table keeps the columns aligned and gives each row consistent column widths and borders. This helps the Time, Booth, and Org columns line up properly, even when the text has different lengths. If we used a Column containing separate Rows, the cells might have different widths, making the columns look uneven. A Table also makes it easier to highlight an entire row using `TableRow.decoration`.
