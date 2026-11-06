# unit6_org_fair

A new Flutter project.

E1. home_shell: _memberships (`lib/screens/home_shell.dart`, lines 25–26)

The `_memberships` map is defined on lines 25–26 to serve as the single source of truth for all organization memberships across the app. By lifting this state up into `HomeShell`, both `OrgListScreen`, `MyOrgsScreen`, and `ScheduleScreen` can share and update the same dynamic membership data. This line ensures that joining or leaving an organization on one tab immediately updates the state across all other tabs.

E2. home_shell: body (`lib/screens/home_shell.dart`, line 63)

Line 63 uses an `IndexedStack` as the body of the `Scaffold` so that all main screens remain mounted in memory simultaneously. Its purpose is to preserve the active state—such as user-entered search queries or scroll positions—when switching between navigation tabs. Without this line, switching tabs would destroy the screen's state and clear any active text field inputs.

E3. org_list_screen: drawer (`lib/screens/org_list_screen.dart`, line 139)

Line 139 executes `Navigator.pop(context)` right before pushing the About screen onto the navigation stack. Its purpose is to dismiss the open navigation drawer so it doesn't remain behind on the screen route. This ensures that when the user presses the back button on the About screen, they return directly to the organization list rather than an open drawer.

E4. org_list_screen: chips (`lib/screens/org_list_screen.dart`, line 263)

Line 263 uses a `Wrap` widget to display category filter chips in a flow layout. Its purpose is to automatically push excess chips onto a new row whenever the screen width isn't wide enough to display them on a single line. Replacing this with a `Row` would cause the layout to break and throw overflow errors on narrower screens.

E5. org_list_screen: _buildGrid (`lib/screens/org_list_screen.dart`, line 303)

Line 303 sets `maxCrossAxisExtent: 200` to make the grid automatically responsive based on available screen width. Its purpose is to dynamically calculate the number of columns (e.g., 2 columns on a 360px phone screen versus 5 columns on a 1000px desktop screen) so each card remains around 200px wide. This ensures the grid scales naturally across different devices without hardcoding fixed column counts.

E6. org_detail_screen (`lib/screens/org_detail_screen.dart`, line 36)

Line 36 sets `length: 3` on the `DefaultTabController` to declare the exact number of tabs managed in this detail view. Its purpose is to synchronize the 3 `Tab` headers in the `TabBar` with the 3 corresponding view pages in the `TabBarView`. If this value does not match the total number of tabs and views defined, the tab navigation will fail with a runtime exception.

E7. my_orgs_screen: _confirmLeave (`lib/screens/my_orgs_screen.dart`, line 30)

Line 30 calls `await showDialog<bool>` and assigns the result to a nullable `bool? confirmed` variable. Its purpose is to safely handle the user's interaction with the confirmation dialog, which can return `true` (clicked leave), `false` (clicked cancel), or `null` (dismissed by tapping outside). Testing this variable explicitly against `== true` on line 48 ensures the leave action only runs if the user explicitly clicked the leave button.

E8. schedule_screen (`lib/screens/schedule_screen.dart`, line 54)

Line 54 uses a `Table` widget instead of a `Column` of `Row`s to structure the schedule grid. Its purpose is to enforce uniform, aligned column widths (time, booth, org) across every single entry row. Unlike independent `Row` widgets that size themselves based on their own contents, `Table` aligns cell boundaries across all rows to maintain a consistent column layout.