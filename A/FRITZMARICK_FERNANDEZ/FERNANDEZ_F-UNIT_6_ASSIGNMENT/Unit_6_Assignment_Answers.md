# West Visayas State University
## College of Information and Communications Technology
Luna St., La Paz, Iloilo City 5000, Iloilo, Philippines  
* Trunkline: (063) (033) 320-0870 loc 1403 * Telefax No.: (033) 320-0879  
* Website: www.wvsu.edu.ph * Email Address: cict@wvsu.edu.ph  

---

# Unit 6 Assignment: CICT Org Fair App Part 2

**Name:** Fritz Marick Fernandez  
**Date:** October 29, 2026  
**Year and Section:** BSIT 3A  
**Submission Folder:** `CC-207B_26-27_Activities/A/FRITZMARICK_FERNANDEZ/FERNANDEZ_F-UNIT_6_ASSIGNMENT`

---

## I. CICT Org Fair App Development part 2 (35 points + 24 points = 59 points)

### Code Changes Performed (13 TODOs)

| # | File | What to do | Slide | Implementation Summary |
|---|---|---|---|---|
| **1** | `home_shell` | Show the selected page with an `IndexedStack` so every page stays alive | 71 NavigationBar | Used `IndexedStack(index: _index, children: pages)` in `Scaffold.body`. |
| **2** | `home_shell` | `onDestinationSelected`: switch tabs with `setState` | 71 NavigationBar | Added `onDestinationSelected: (i) => setState(() => _index = i)`. |
| **3** | `home_shell` | A `Badge` on the My Orgs icons with the number of joined orgs, hidden at 0 | 71 (Badge docs) | Wrapped icons in `Badge(isLabelVisible: count > 0, label: Text('$count'), child: ...)`. |
| **4** | `home_shell` | `_join`: save the membership in the map with `setState` | 57 Passing data | Set `_memberships[membership.org.id] = membership;` inside `setState`. |
| **5** | `org_list_screen` | Pass the new membership up with `widget.onJoined` | 57 Passing data | Passed `Membership(org: org, registration: registration)` to `widget.onJoined`. |
| **6** | `org_list_screen` | Drawer item: close the drawer, then `pushNamed` the About screen | 53 to 56, 64 Drawer | Called `Navigator.pop(context)` then `Navigator.pushNamed(context, AboutScreen.routeName)`. |
| **7** | `org_list_screen` | `_toggleCategory`: add or remove the category with `setState` | Unit 5 setState; 26 Wrap | Added/removed category in `_categories` inside `setState`. |
| **8** | `org_list_screen` | Keep only the orgs in the selected categories (all when none is selected) | Unit 5 search filter | Added `.where((o) => _categories.isEmpty \|\| _categories.contains(o.category))`. |
| **9** | `org_list_screen` | Grid columns from the width: `SliverGridDelegateWithMaxCrossAxisExtent` | 36, 40 GridView | Used `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.9)`. |
| **10** | `org_detail_screen` | Add the Officers tab: a `Tab`, a `TabBarView` child and the right length | 65 to 68 Tabs | Set `length: 3`, added `Tab(icon: Icon(Icons.people_outline), text: 'Officers')` and `_buildOfficers()`. |
| **11** | `org_detail_screen` | The officers in a `ListView.separated` with a `Divider` between them | 29 ListView | Rendered `ListView.separated` with `ListTile` items and `Divider()`. |
| **12** | `my_orgs_screen` | Ask with `showDialog<bool>` before leaving an org | 58 Dialogs | Showed `AlertDialog` titled `Leave ${org.acronym}?` with Cancel (`false`) and Leave (`true`). |
| **13** | `schedule_screen` | Highlight the rows of joined orgs with a `BoxDecoration` | 44 to 46 Table | Applied `decoration: joined ? BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer) : null`. |

---

### Part I: Code Explanations (EXPLAIN E1 to EXPLAIN E8) (24 points)

#### E1: `home_shell: _memberships` (lines 22–25)
**Question:** Lifting state up: why the joined orgs live in HomeShell
> **Answer:** In Part 2, three sibling screens require access to the joined organizations data: `OrgListScreen` needs it to display the "Joined" indicator and disable duplicate join actions, `MyOrgsScreen` needs it to list all joined organizations and trigger leaving, and `ScheduleScreen` needs it to highlight corresponding fair-day booth slots. Because Flutter enforces unidirectional data flow, sibling widgets cannot access or mutate each other's private internal state. State must therefore be lifted up to their common parent, `HomeShell`, which acts as the single source of truth, distributing the data down via constructor parameters and receiving modifications back through callbacks.

#### E2: `home_shell: body` (lines 54–57)
**Question:** Why IndexedStack keeps your search text when you switch tabs
> **Answer:** The `IndexedStack` widget preserves the search box text, filter selections, and scroll position across tab switches. If we conditionally rendered screens using `body: pages[_index]`, switching tabs would unmount and dispose the inactive screen's `State` object, thereby destroying the `TextEditingController` and wiping out user input. `IndexedStack` keeps all its child widgets permanently mounted in the element and render tree, merely controlling visibility by only painting and hit-testing the child at the current index.

#### E3: `org_list_screen: drawer` (lines 123–127)
**Question:** Why the drawer is closed before the About screen opens
> **Answer:** In Flutter, opening a `Drawer` pushes a modal route onto the navigator stack above the scaffold body. If `Navigator.pushNamed(context, AboutScreen.routeName)` were called without first dismissing the drawer, the About screen route would be pushed on top of the open drawer route. When the user subsequently taps the back button on the About screen, they would pop back into the open drawer covering the screen rather than returning to the organization list. Calling `Navigator.pop(context)` first dismisses the drawer route, ensuring intuitive, clean back-stack navigation.

#### E4: `org_list_screen: chips` (lines 255–257)
**Question:** Wrap or Row when the chips do not fit
> **Answer:** A `Row` lays out its children in a single horizontal line under unbounded horizontal constraints, meaning that if the combined width of the chips exceeds the screen width, Flutter throws an unhandled layout exception ("A RenderFlex overflowed by X pixels") and paints yellow-and-black hazard stripes. In contrast, `Wrap` is designed to flow excess children across multiple runs (lines) whenever horizontal space is exhausted. This allows category filter chips to break onto subsequent lines gracefully across various mobile viewport widths and dynamic text scale factors.

#### E5: `org_list_screen: _buildGrid` (lines 292–294)
**Question:** The column math of maxCrossAxisExtent
> **Answer:** `SliverGridDelegateWithMaxCrossAxisExtent` computes the column count by dividing the available cross-axis width by `maxCrossAxisExtent` (200) and rounding up: $\text{columns} = \lceil W_{\text{available}} / 200 \rceil$. The tile width is then calculated by subtracting the total cross-axis spacing and dividing equally: $\text{tileWidth} = (W_{\text{available}} - (\text{columns} - 1) \times \text{spacing}) / \text{columns}$.
> - **On a 360px-wide phone** (with 16px horizontal padding: 8px left + 8px right, and 8px spacing): Available width = $360 - 16 = 344\text{ px}$. Columns = $\lceil 344 / 200 \rceil = 2\text{ columns}$. Tile width = $(344 - 1 \times 8) / 2 = 336 / 2 = 168.0\text{ px}$.
> - **On a 1000px-wide window** (with 16px horizontal padding and 8px spacing): Available width = $1000 - 16 = 984\text{ px}$. Columns = $\lceil 984 / 200 \rceil = 5\text{ columns}$. Tile width = $(984 - 4 \times 8) / 5 = (984 - 32) / 5 = 952 / 5 = 190.4\text{ px}$.

#### E6: `org_detail_screen` (lines 29–32)
**Question:** What must match in DefaultTabController, TabBar and TabBarView
> **Answer:** The `length` defined in `DefaultTabController`, the number of items in `TabBar.tabs`, and the number of child views in `TabBarView.children` must all be strictly equal. If these counts differ, Flutter throws an assertion failure at build or runtime (such as `'tabs.length == controller.length'` or `'children.length == controller.length'`). Because the tab controller synchronizes scroll animations, swipe physics, and active tab indicators based on that fixed integer index range, any mismatch corrupts index mapping and crashes the interface.

#### E7: `my_orgs_screen: _confirmLeave` (lines 24–26)
**Question:** Why a dialog answer is bool? and is tested with == true
> **Answer:** `showDialog<bool>` returns `Future<bool?>` because a modal dialog can be dismissed without clicking either the "Leave" (`true`) or "Cancel" (`false`) action button. For instance, tapping the modal barrier outside the dialog, pressing the Android system back button, or hitting the Escape key pops the route with `null`. Under Dart's sound null safety, a `bool?` cannot be used directly in an `if` condition; testing `confirmed == true` cleanly handles all three possible outcomes, evaluating to `true` only upon explicit confirmation and safely resolving to `false` if the user cancelled or dismissed the dialog.

#### E8: `schedule_screen` (lines 47–49)
**Question:** Why a Table and not a Column of Rows
> **Answer:** A `Table` calculates coordinated column dimensions across all rows simultaneously according to unified rules (`FixedColumnWidth` and `FlexColumnWidth`), guaranteeing that every cell in a column aligns vertically. If we instead used a `Column` containing separate `Row` widgets, each row would layout its cells independently based on the intrinsic widths of its own text and icons. Because slot times, booth labels, and acronym lengths vary in character count, column boundaries would shift inconsistently from row to row, producing an unaligned, jagged layout.

---

## II. CICT Org Fair Code Analysis (22 points + 8 points = 30 points)

### Code Analysis Questions (EXPLAIN E1 to EXPLAIN E11)

| # | Where | The question is about | Answer |
|---|---|---|---|
| **E1** | `main.dart` | Why `OrgFairApp` is stateless but `OrgListScreen` is stateful? | `OrgFairApp` defines immutable application-level configuration (theme data, title, and static route definitions) that remains unchanged during runtime. In contrast, `OrgListScreen` manages interactive, mutable state that changes throughout user interaction—including search query strings, active category filter sets, loading/error states, favorited/hidden org IDs, and list/grid layout toggles. |
| **E2** | `org_list_screen: dispose()` | Why controllers must be disposed? | Controllers like `TextEditingController` register internal listeners and retain underlying platform channel and memory resources. If not explicitly disposed via `.dispose()`, these resources remain active even after the widget is removed from the widget tree, causing permanent memory leaks and potentially triggering runtime exceptions if listeners fire on unmounted elements. |
| **E3** | `org_list_screen: FutureBuilder` | The order of states when the user presses Try again? | When `_reload()` is invoked, a new `Future` is instantiated and assigned to `_orgsFuture` inside `setState`. The `FutureBuilder` transitions from `ConnectionState.done` (holding the error) immediately to `ConnectionState.waiting`, rendering the progress spinner and "Loading organizations...". Upon asynchronous completion, it transitions back to `ConnectionState.done` with resolved data (or a new error). |
| **E4** | `org_list_screen: _buildOrgs` | How the list updates while the user types? | The search `TextField` defines `onChanged: (value) => setState(() => _query = value)`. On every keystroke, `setState` triggers a widget rebuild, causing `_buildOrgs()` to re-evaluate the `.where()` filters against the updated `_query` and instantly render the filtered subset of organizations without requiring a manual submit action. |
| **E5** | `org_list_screen: Expanded` | Constraints go down, sizes go up? | In Flutter's layout protocol, parents pass constraints down, children report sizes up, and parents position children. Inside the vertical `Column`, `Expanded` takes whatever vertical height remains after the search bar and filter chips claim their intrinsic sizes, and passes tight bounded constraints down to the `ListView` or `GridView`, which sizes itself to fill that exact remaining space. |
| **E6** | `org_card.dart` | Where the favorite star's state lives? | The favorite state lives in the parent state object `_OrgListScreenState` within the `_favoriteIds` set. `OrgCard` is a `StatelessWidget` that receives `isFavorite` as an immutable boolean and notifies the parent via `onLongPress`. This state-lifting architecture ensures favorite selections persist consistently even as the list is filtered or reorganized. |
| **E7** | `org_list_screen: _openDetail` | How data comes back from another screen? | Data is returned asynchronously using the `Future` returned by `Navigator.push<Registration>()`. When the user completes the registration form on `JoinFormScreen`, the form pops back using `Navigator.pop(context, registration)`. This resolves the awaited push future in `_openDetail`, delivering the `Registration` object back to the caller. |
| **E8** | `org_banner.dart` | Null safety and the loading and error builders? | `Org.bannerUrl` is nullable (`String?`), requiring null-safe checks or fallback builders. `Image.network` provides `loadingBuilder` to display a progress indicator while network bytes are downloading, and `errorBuilder` to catch HTTP failures or missing image URLs and render a graceful placeholder container instead of throwing an unhandled red error screen. |
| **E9** | `org_detail_screen: _join` | Why check `context.mounted` after `await`? | An `await` pauses execution during an asynchronous operation (such as waiting for route transitions or network responses). During this delay, the user may have navigated away, unmounting the widget's `BuildContext`. Calling `Navigator.of(context)` on an unmounted context triggers runtime exceptions and memory leaks; checking `context.mounted` ensures the widget is still active in the element tree. |
| **E10** | `join_form_screen: _formKey` | What a `GlobalKey<FormState>` gives you? | A `GlobalKey<FormState>` provides direct, type-safe access to the internal `FormState` object across the widget hierarchy. It allows calling `_formKey.currentState!.validate()` to execute all child input validators, `save()` to commit input values to model variables, and `reset()` to revert the form fields to their initial states. |
| **E11** | `join_form_screen: autovalidateMode` | When errors should appear? | Setting `AutovalidateMode.onUserInteraction` ensures validation error messages only appear after the user has actively focused and edited a specific form field. This prevents overwhelming the user with premature red error messages on a freshly opened form while still providing immediate, interactive feedback as they type. |

---

### Widget Classification Table (Stateless vs Stateful)

| Feature | Widget(s) used | Stateless or Stateful? Why? |
|---|---|---|
| **Org list or grid** | `ListView.builder` / `GridView.builder` (and `OrgCard` / `OrgTile`) | **Stateful** at the host screen level (`OrgListScreen`). While `ListView.builder`, `GridView.builder`, `OrgCard`, and `OrgTile` are instantiated as immutable widgets, the enclosing `OrgListScreen` manages mutable state (`_showGrid`, `_query`, `_categories`, `_hiddenIds`) and rebuilds the layout whenever the user toggles between list and grid views or modifies filters. |
| **Favorite star** | `Icon(Icons.star)` / `Icon(Icons.star_border)` in `OrgCard` / `OrgTile` | **Stateless** at the card/tile level. The star icon widget does not store its own toggle state; it is purely driven by the `isFavorite` boolean passed down through constructor parameters. When tapped or long-pressed, it delegates execution to the parent `_OrgListScreenState`, which updates `_favoriteIds` and rebuilds the UI. |
| **Banner image** | `OrgBanner` (utilizing `Image.network`, `ClipRRect`, `DecoratedBox`, `AspectRatio`, `Center`, `CircularProgressIndicator`, `Icon`) | **Stateless**. `OrgBanner` is implemented as a `StatelessWidget`. It simply accepts an immutable `Org` object and renders the network banner image or fallback placeholder using `loadingBuilder` and `errorBuilder`, without maintaining any mutable internal state across rebuilds. |
| **Submit button** | `FilledButton` / `FilledButton.icon` (in `JoinFormScreen`) | **Stateless** as an individual component widget. `FilledButton` is a `StatelessWidget` that receives its display configuration and `onPressed` callback from the host `_JoinFormScreenState`. Its enabled/disabled state and triggering behavior are governed by the parent form's state. |

---

## Verification: Test Suite Output

```bash
$ flutter test
Resolving dependencies...
Got dependencies!
00:00 +0: loading test/org_fair_test.dart
00:00 +0: Part 1 still works: loading, then the list
00:02 +1: TODO 1 and 2: tabs switch, and the search survives
00:03 +2: TODO 3, 4 and 5: a joined org shows in My Orgs with a badge
00:05 +3: TODO 12 (needs 4 and 5): leaving an org asks first
00:07 +4: TODO 6: the drawer closes, then About opens
00:07 +5: TODO 7 and 8: category chips filter the list
00:08 +6: TODO 9: the grid gets its columns from the width
00:08 +7: TODO 10 and 11: the Officers tab
00:09 +8: TODO 13 (needs 4 and 5): the schedule highlights joined orgs
00:10 +9: All tests passed!
```
