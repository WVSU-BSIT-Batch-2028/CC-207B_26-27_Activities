# CICT Org Fair App (Part 2) — Unit 6 Assignment

**Student Name:** Nherie C. Acebuche  
**Section:** Section A  
**Course:** CC 207B / CC 206  
**Activity:** Unit 6 Assignment (CICT Org Fair App Development Part 2 & Code Analysis)  

---

## E1–E8 Code Explanations

### E1: Lifting State to HomeShell
* **File & Line Reference:** `lib/screens/home_shell.dart:22-25`
* **Answer:**
`_memberships` lives in `HomeShell` because multiple sibling screens (`OrgListScreen`, `MyOrgsScreen`, and `ScheduleScreen`) as well as the navigation bar badge in `HomeShell` all depend on this data. If `OrgListScreen` kept it, `MyOrgsScreen` and `ScheduleScreen` could not access or update it when switching tabs, as sibling widgets in Flutter cannot directly inspect each other's private state. Lifting the state up to their closest common ancestor (`HomeShell`) allows it to pass data down via parameters and handle updates through callback functions.

### E2: Preserving Search State Across Tabs
* **File & Line Reference:** `lib/screens/home_shell.dart:54-57`
* **Answer:**
The search text is preserved because `HomeShell` uses an `IndexedStack` as its body (`lib/screens/home_shell.dart:59-62`). Unlike simple switching (which discards and recreates unselected widgets), `IndexedStack` keeps all child pages alive in the widget tree and only changes which one is visually painted. Because `OrgListScreen` is never disposed, its `State` object and `_searchController` retain their text and cursor state across tab navigation.

### E3: Closing the Drawer Before Pushing a Route
* **File & Line Reference:** `lib/screens/org_list_screen.dart:123-125`
* **Answer:**
We call `Navigator.pop(context)` before `Navigator.pushNamed(context, AboutScreen.routeName)` so that the drawer is dismissed before opening the About screen. If the drawer were left open beneath the new route, navigating back from the About screen would return the user to an open drawer rather than the main screen, creating an awkward and unnatural navigation experience.

### E4: Wrap vs. Row for Filter Chips
* **File & Line Reference:** `lib/screens/org_list_screen.dart:247-250`
* **Answer:**
A `Wrap` widget automatically breaks its children into multiple horizontal or vertical runs when there is not enough room on a single line. In contrast, a `Row` constrains its children to a single horizontal axis without wrapping; when the chips exceed the available screen width, `Row` causes an unbounded horizontal overflow error (`A RenderFlex overflowed...` yellow-and-black striped banner).

### E5: Max Cross Axis Extent Math
* **File & Line Reference:** `lib/screens/org_list_screen.dart:284-287`
* **Answer:**
With `maxCrossAxisExtent: 200`, `spacing: 8`, and total horizontal padding of 16 (8 on each side):
- **360-wide phone:** Available width is $360 - 16 = 344$. For 2 columns with 1 gap of 8, tile width is $(344 - 8) / 2 = 168$ px (since 1 column of 344 would exceed 200). Thus, it yields 2 columns of 168 px width.
- **1000-wide window:** Available width is $1000 - 16 = 984$. To keep width $\le 200$, it creates 5 columns: $(984 - (4 \times 8)) / 5 = (984 - 32) / 5 = 190.4$ px per tile.

### E6: DefaultTabController and Tab Synchronization
* **File & Line Reference:** `lib/screens/org_detail_screen.dart:29-32`
* **Answer:**
The `length` in `DefaultTabController`, the number of items in `TabBar.tabs`, and the number of widgets in `TabBarView.children` must all be strictly equal. If these numbers do not match, Flutter throws an assertion error (`Controller's length property (X) does not match the number of tabs (Y)`) during layout and fails to build the widget.

### E7: Nullable Boolean from showDialog
* **File & Line Reference:** `lib/screens/my_orgs_screen.dart:24-26`
* **Answer:**
`showDialog<bool>` returns a nullable `bool?` because the dialog can be dismissed without selecting either button (for example, by tapping the barrier outside the dialog or pressing the system back button), which produces `null`. We test `confirmed == true` instead of `if (confirmed)` because in Dart a condition must evaluate to a non-nullable `bool`, and `null` should be treated as an unconfirmed dismissal.

### E8: Table vs. Column of Rows
* **File & Line Reference:** `lib/screens/schedule_screen.dart:47-49`
* **Answer:**
A `Table` enforces synchronized column boundaries across every row by measuring all rows against shared column width constraints (`columnWidths`). If we used a `Column` of independent `Row`s, each row would lay out its children based solely on its own contents, resulting in misaligned column borders and jagged vertical divisions across different rows.

---

## Experiments (C1–C5)

### Experiment C1: Without IndexedStack
* **Intentionally Changed:** Replaced `IndexedStack(index: _index, children: pages)` with `body: pages[_index]` in `home_shell.dart`.
* **Observation:** After typing in the search box in the Orgs tab, switching to Schedule and returning cleared the search box.
* **Explanation:** Without `IndexedStack`, switching tabs disposes the unselected page and recreates it from scratch upon returning, destroying its local state and controllers.

### Experiment C2: Row instead of Wrap
* **Intentionally Changed:** Replaced `Wrap` with `Row` for category filter chips in `org_list_screen.dart`.
* **Observation:** On narrower screens, a yellow-and-black striped overflow bar appeared with a message saying `A RenderFlex overflowed by X pixels on the right`.
* **Explanation:** `Row` requires all children to stay on a single line and cannot wrap overflowing elements to the next line.

### Experiment C3: Mismatched TabController Length
* **Intentionally Changed:** Changed `length: 3` to `length: 2` in `DefaultTabController` in `org_detail_screen.dart` while having 3 tabs.
* **Observation:** Flutter threw an assertion error: `'length == tabs.length': Controller's length property (2) does not match the number of tabs (3)`.
* **Explanation:** `DefaultTabController` enforces an invariant assertion that its configured count equals the number of tab definitions and views.

### Experiment C4: Not Closing Drawer Before Navigation
* **Intentionally Changed:** Removed `Navigator.pop(context)` before `Navigator.pushNamed(context, AboutScreen.routeName)` in `org_list_screen.dart`.
* **Observation:** Tapping back on the About screen showed the drawer still open over the org list.
* **Explanation:** Pushing a new route without popping the drawer leaves the drawer route open on the navigator stack beneath the newly pushed screen.

### Experiment C5: Grid Layout Behavior
* **Intentionally Changed:** Adjusted `maxCrossAxisExtent: 150` on a 800-wide viewport.
* **Observation:** The grid displayed 5 narrower columns instead of 4 columns.
* **Explanation:** `SliverGridDelegateWithMaxCrossAxisExtent` dynamically computes column count as $\lceil \text{width} / \text{maxExtent} \rceil$ ensuring each item does not exceed the limit.

