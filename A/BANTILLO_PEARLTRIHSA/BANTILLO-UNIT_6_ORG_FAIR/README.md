# Unit 6: CICT Org Fair
# Answer

# E1. Lifting State Up
In `lib/screens/home_shell.dart`, lines 23–47, the joined organizations are stored in `HomeShell` because both the Orgs page and My Orgs page need access to them. Keeping the state in one parent widget makes it easier to share and update the membership data.

# E2. IndexedStack
In `lib/screens/home_shell.dart`, lines 53–56, `IndexedStack` keeps the pages alive even when I switch between tabs. This helps preserve the search text and other page states instead of resetting them every time I return.

# E3. Closing the Drawer
In `lib/screens/org_list_screen.dart`, lines 129–140, the drawer is closed before opening the About page so it does not remain open over the new screen. This also makes navigation smoother.

# E4. Wrap vs. Row
In `lib/screens/org_list_screen.dart`, lines 261–272, `Wrap` is used for category chips because it moves them to the next line when there is not enough space. Unlike `Row`, it does not force everything to fit on a single line.

# E5. Grid Column Sizing
In `lib/screens/org_list_screen.dart`, lines 300–305, `SliverGridDelegateWithMaxCrossAxisExtent` sets the maximum width allowed for each grid item. Flutter uses the available screen width to determine how many columns can fit.

# E6. Matching Tabs and Tab Views
In `lib/screens/org_detail_screen.dart`, lines 32–54, the number of tabs in `TabBar` must match the number of pages in `TabBarView`. The `DefaultTabController` length must also match both so each tab displays the correct content.

# E7. Dialog Answer and `== true`
In `lib/screens/my_orgs_screen.dart`, lines 23–45, `showDialog<bool>` can return `true`, `false`, or `null` if the dialog is dismissed without a choice. Checking `== true` ensures the organization is removed only when the user confirms leaving.

# E8. Table vs. Column of Rows
In `lib/screens/schedule_screen.dart`, lines 53–71, a `Table` keeps information aligned in columns, making the booth schedule easier to read. A `Column` of separate `Row` widgets does not automatically keep each column aligned across all rows.