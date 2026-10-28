# Unit 6 Assignment: Code Explanations (E1–E8)

# E1: home_shell: _memberships
The memberships map is stored in `HomeShell` because both `OrgListScreen` and `MyOrgsScreen` need access to the same shared data. Keeping the data in their common parent allows the child screens to receive the latest memberships and update them through callbacks instead of maintaining separate copies. A child screen cannot hold this state for its peers because Flutter passes data downward through the widget tree.

# E2: home_shell: body
An `IndexedStack` widget only displays the currently selected tab while keeping all other tab screens active in memory. This ensures the search text and screen state remain intact when switching back and forth between tabs instead of being destroyed. Standard tab switching destroys off-screen pages, which causes user inputs like search queries to reset.

# E3: org_list_screen: drawer
We call `Navigator.pop(context)` to close the drawer route before pushing the new `AboutScreen` route onto the stack. This provides expected navigation behavior so that pressing the back button on the About screen returns to the organization list. Leaving the drawer open would result in the drawer overlapping the main screen when navigating back.

# E4: org_list_screen: chips
A `Wrap` widget automatically moves category chips onto a new line when they exceed the available screen width. A `Row` widget keeps all child items on a single horizontal line regardless of screen size. Using a `Row` when items do not fit on one line causes a visual layout overflow error.

# E5: org_list_screen: _buildGrid
On a 360-wide screen, 2 columns fit, resulting in a tile width of approximately 168 pixels after subtracting padding and gap spacing ($(360 - 16 - 8) / 2$). On a 1000-wide screen, 5 columns fit, resulting in a tile width of approximately 190.4 pixels ($(1000 - 16 - 32) / 5$). Setting `maxCrossAxisExtent` to 200 allows the layout to dynamically adjust column count based on available screen space.

# E6: org_detail_screen
The `length` parameter of `DefaultTabController`, the number of tabs in `TabBar`, and the number of views in `TabBarView` must all be equal. In this screen, all three components are configured with a value of 3 for the About, Officers, and Events tabs. If these values do not match, Flutter throws an index assertion runtime error.

# E7: my_orgs_screen: _confirmLeave
The return type of `showDialog<bool>` is nullable (`bool?`) because a user can dismiss the dialog box without clicking either button. Checking `confirmed == true` ensures that the leave operation only runs when the user explicitly clicks the "Leave" button. Testing `confirmed` directly causes a compilation error because a nullable boolean cannot be evaluated as a strict boolean condition.

# E8: schedule_screen
A `Table` coordinates column widths globally across every row so that time, booth, and organization text line up neatly. If a `Column` of `Row` widgets were used, each row would independently size its columns based on its content length. Independent sizing results in misaligned, unorganized columns across the schedule display.