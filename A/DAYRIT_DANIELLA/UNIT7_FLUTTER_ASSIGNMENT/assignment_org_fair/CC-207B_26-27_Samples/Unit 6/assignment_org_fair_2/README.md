# CICT Org Fair App — Unit 6

## Part I: explanations

**E1 — `lib/screens/home_shell.dart`**: `HomeShell` owns memberships because the Orgs, My Orgs, and Schedule tabs all need the same current data. Keeping the map in one parent lets it pass the data and callbacks down consistently; a child screen would not be the shared owner for its sibling screens.

**E2 — `lib/screens/home_shell.dart`**: `IndexedStack` displays only the selected child but keeps all children mounted. Therefore `OrgListScreen` and its `TextEditingController` remain alive when another tab is selected, so the search text is preserved.

**E3 — `lib/screens/org_list_screen.dart`**: Closing the drawer removes it from the current route before the About route is pushed. Without that pop, the drawer route can remain in the navigation stack and appear again when returning from About.

**E4 — `lib/screens/org_list_screen.dart`**: `Wrap` places chips on the next line when the available width is insufficient. A `Row` keeps one horizontal line and can overflow instead.

**E5 — `lib/screens/org_list_screen.dart`**: With 800 pixels and 16 pixels of total grid padding, 784 pixels remain. Four columns fit because `(784 - 3*8) / 4 = 190`, which is at most 200; a max-extent delegate chooses that column count automatically.

**E6 — `lib/screens/org_detail_screen.dart`**: `DefaultTabController.length`, the number of `TabBar` tabs, and the number of `TabBarView` children must all be equal. A mismatch causes a tab/controller assertion or leaves the view without a matching child.

**E7 — `lib/screens/my_orgs_screen.dart`**: `showDialog<bool>` returns `Future<bool?>` because a dialog may be dismissed without choosing either button, producing `null`. Testing `confirmed == true` performs the leave action only after the explicit Leave choice.

**E8 — `lib/screens/schedule_screen.dart`**: `Table` measures columns together, so every row shares aligned column widths. Independent `Row`s size their columns separately, causing times, booths, and organization names to stop lining up.

## Part II: code analysis

1. `OrgFairApp` is stateless because its configuration does not change, while `OrgListScreen` is stateful because search, filters, loading, favorites, and hidden items change during use.
2. Controllers own resources and listeners; disposing `_searchController` releases them when the screen is removed.
3. Pressing Try again assigns a new future, then the builder shows loading, followed by either success, empty, or error when that future completes.
4. `onChanged` calls `setState`, causing `_buildOrgs` to run again and apply the current query to the list.
5. `Expanded` receives the available height constraint from the `Column` and gives its child the remaining space; without it, the scrollable child has an unbounded or conflicting height.
6. The favorite value is owned by `_OrgListScreenState`; the card widgets receive it as `isFavorite` and report long presses through a callback.
7. `push` returns a future that completes with the value passed to `Navigator.pop`; `_openDetail` awaits that `Registration` and sends it to the parent.
8. A nullable banner URL is checked before creating the image provider, while loading and error builders provide safe UI for unavailable images.
9. The awaited form can outlive the detail screen. `context.mounted` confirms its context is still valid before using it to pop a route.
10. `GlobalKey<FormState>` identifies the form and lets the state call methods such as `validate`, `save`, and `reset`.
11. `AutovalidateMode.onUserInteraction` shows errors after the user interacts, avoiding a wall of errors on the untouched form while still giving immediate feedback afterward.

## Widget classification

| Feature | Widgets | Type and reason |
|---|---|---|
| Org list or grid | `ListView.builder`, `GridView.builder`, `OrgCard`, `OrgTile` | The list screen is stateful because filters and search change; the item widgets are stateless because their data comes from it. |
| Favorite star | `Icon` inside `OrgCard`/`OrgTile` | Stateless by itself; the changing favorite state lives in the parent screen. |
| Banner image | `OrgBanner`, `Image`, `DecoratedBox` | Stateless; it renders the provided URL or fallback/loading/error UI. |
| Submit button | `FilledButton` in `JoinFormScreen` | The button is stateless, but the form screen is stateful because it validates and stores input before submission. |
