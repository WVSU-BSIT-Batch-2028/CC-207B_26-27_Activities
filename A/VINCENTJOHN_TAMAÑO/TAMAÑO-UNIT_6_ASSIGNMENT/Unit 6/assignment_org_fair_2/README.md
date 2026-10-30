# CICT Org Fair 2 - Unit 6 Assignment

**Student Name:** Vincent John Tamaño  
**Course & Section:** BSIT - Batch 2028  

---

## Part I: Code Explanations (E1 to E8)

### E1: Lifting state up (`lib/screens/home_shell.dart`, lines 22–25)
> **Question:** In Part 1 the joined orgs were saved inside `OrgListScreen`. Now they live here, in `HomeShell`. Which screens need this map, and why can't one of those screens keep it for the others?

**Answer:**  
All three main screens—`OrgListScreen` (to display the "Joined" indicator), `MyOrgsScreen` (to list the memberships and handle leaving), and `ScheduleScreen` (to highlight joined orgs in the booth table)—need access to the `_memberships` map, as does `HomeShell` itself to update the badge counter. If one screen owned this state, sibling screens could not access or modify it directly without tight, fragile coupling. Lifting state up to their common ancestor (`HomeShell`) adheres to Flutter best practices by establishing a single source of truth that passes data down via properties and receives updates back through callbacks.

---

### E2: Preserving state with `IndexedStack` (`lib/screens/home_shell.dart`, lines 54–58)
> **Question:** Type something in the search box, open the Schedule tab, then come back. Your search is still there. Which widget keeps it, and how?

**Answer:**  
The `IndexedStack` widget keeps the search text alive. Unlike a typical conditionally swapped body (e.g. `pages[_index]`) which disposes and destroys the unselected widgets from the widget and element trees, `IndexedStack` keeps all its children mounted in the tree and retains their `State` and `TextEditingController` instances. It only changes the visual visibility by painting the child at the active `index` while hiding the others offstage.

---

### E3: Closing drawer before navigation (`lib/screens/org_list_screen.dart`, lines 123–128)
> **Question:** Why do we close the drawer before opening the About screen? Try Experiment C4, then explain what you saw.

**Answer:**  
In Flutter, opening a `Drawer` pushes a modal route onto the navigation history stack. If you navigate to `AboutScreen` without popping the drawer first (`Navigator.pop(context)`), the drawer's route remains underneath `AboutScreen`. When the user later presses the back button to leave `AboutScreen`, they return to find the drawer still open over the screen rather than returning directly to the main organization list.

---

### E4: `Wrap` vs. `Row` layout (`lib/screens/org_list_screen.dart`, lines 244–247)
> **Question:** These chips sit in a `Wrap`, not a `Row`. What does Wrap do when the chips don't fit on one line? What would a Row do?

**Answer:**  
A `Wrap` widget automatically flows its children onto multiple horizontal or vertical lines (runs) whenever they exceed the available cross-axis boundary, preventing clipping. In contrast, a `Row` forces all its children along a single horizontal line with unbounded horizontal constraints. If the chips exceed the screen width in a `Row`, Flutter triggers a layout overflow error and displays the yellow-and-black striped overflow banner.

---

### E5: Column math of `maxCrossAxisExtent` (`lib/screens/org_list_screen.dart`, lines 281–287)
> **Question:** With `maxCrossAxisExtent: 200`, how many columns does a 360-wide phone get, and how wide is each tile? A 1000-wide window?

**Answer:**  
Given 8px padding on each side (total padding = 16px) and 8px cross-axis spacing between columns:
- **360px-wide phone:** Available width is $360 - 16 = 344\text{ px}$. One column of 344px exceeds the max limit of 200px, so Flutter allocates **2 columns** with 1 gap of 8px. Tile width is $(344 - 8) / 2 = \mathbf{168\text{ px}}$ each.
- **1000px-wide window:** Available width is $1000 - 16 = 984\text{ px}$. Four columns would yield $(984 - 24) / 4 = 240\text{ px} > 200\text{ px}$ (exceeds 200). Therefore, Flutter allocates **5 columns** with 4 gaps of 8px ($32\text{ px}$). Tile width is $(984 - 32) / 5 = \mathbf{190.4\text{ px}}$ each.

---

### E6: Tab coordination (`lib/screens/org_detail_screen.dart`, lines 29–35)
> **Question:** `DefaultTabController` has a length, the `TabBar` has tabs and the `TabBarView` has children. What must be true about these three numbers? What happens when they don't match?

**Answer:**  
The `length` specified in `DefaultTabController`, the number of items in `TabBar.tabs`, and the number of widgets in `TabBarView.children` must all be strictly equal. If these numbers do not match, the `TabController` cannot align the tab index with the corresponding page view. At runtime, Flutter throws an assertion error (`Controller's length property (...) does not match the number of tabs (...)`), causing a red error screen or app crash.

---

### E7: Dialog return value and type checking (`lib/screens/my_orgs_screen.dart`, lines 24–29)
> **Question:** `showDialog<bool>` gives back a `bool?`, not a `bool`. When is it null? Why do we test `confirmed == true` instead of just `confirmed`?

**Answer:**  
`showDialog<bool>` returns `null` if the user dismisses the dialog without selecting an explicit action—such as by tapping the modal scrim outside the dialog box or pressing the Android system back button. Because Dart enforces sound null safety, a nullable `bool?` cannot be evaluated directly inside an `if` statement condition (`if (confirmed)` causes a compilation error). Checking `confirmed == true` safely handles all three possible states (`true`, `false`, and `null`), executing the leave action only when explicitly confirmed.

---

### E8: `Table` vs. `Column` of `Row`s (`lib/screens/schedule_screen.dart`, lines 47–49)
> **Question:** Why a `Table` here and not a `Column` of `Rows`? What would go wrong with the columns if each Row sized itself?

**Answer:**  
A `Table` enforces synchronized column dimensions across every row according to shared `columnWidths`, ensuring the "Time", "Booth", and "Org" columns align vertically into clean, straight columns. If a `Column` of independent `Row`s were used, each row would lay out its children autonomously based on intrinsic text lengths. This would cause column boundaries to shift inconsistently from row to row, creating a misaligned, jagged grid.

---

## Part II: CICT Org Fair Code Analysis (E1 to E11)

| # | Where | The question is about | Answer |
|---|---|---|---|
| **E1** | `main.dart` | Why `OrgFairApp` is stateless but `OrgListScreen` is stateful? | `OrgFairApp` is a top-level configuration widget whose properties and theme never change during runtime. `OrgListScreen` is stateful because its UI must react dynamically to internal state changes, such as search queries, category filters, grid/list view toggles, and async loading states. |
| **E2** | `org_list_screen`: `dispose()` | Why controllers must be disposed? | `TextEditingController` attaches listeners to system input channels. Failure to dispose it in `dispose()` causes memory leaks and keeps listeners alive after the widget is removed from the tree. |
| **E3** | `org_list_screen`: `FutureBuilder` | The order of states when the user presses Try again? | When `_reload()` creates a new future, `FutureBuilder` transitions from `ConnectionState.waiting` (displaying the loading indicator spinner) to `ConnectionState.done` (displaying either the data list or error state). |
| **E4** | `org_list_screen`: `_buildOrgs` | How the list updates while the user types? | The `TextField` triggers `onChanged`, which calls `setState(() => _query = value)`. This invokes `build()`, where `_buildOrgs` re-filters the orgs list against `_query` and re-renders visible items. |
| **E5** | `org_list_screen`: `Expanded` | Constraints go down, sizes go up? | In Flutter's layout protocol, parents pass constraints down (e.g., `Expanded` forces its child to occupy all remaining vertical space in the `Column`), and children report their concrete sizes back up to their parents. |
| **E6** | `org_card.dart` | Where the favorite star's state lives? | The state lives in the parent widget (`_OrgListScreenState` inside `_favoriteIds`), not inside `OrgCard`. `OrgCard` is a stateless presentation widget that receives `isFavorite` and reports toggles via `onLongPress`. |
| **E7** | `org_list_screen`: `_openDetail` | How data comes back from another screen? | Data comes back asynchronously through `Navigator.push<T>()` returning a `Future<T?>`, which resolves when the pushed screen calls `Navigator.pop(context, result)`. |
| **E8** | `org_banner.dart` | Null safety and the loading and error builders? | Dart's null safety guarantees `ImageChunkEvent? loadingProgress` is checked for `null` (indicating loading finished); `errorBuilder` catches failed image loads and provides a fallback widget gracefully without crashing. |
| **E9** | `org_detail_screen`: `_join` | Why check `context.mounted` after await? | An `await` suspends execution. By the time it finishes, the user may have popped or disposed the widget; checking `context.mounted` ensures the `BuildContext` is still valid before calling `Navigator`. |
| **E10** | `join_form_screen`: `_formKey` | What a `GlobalKey<FormState>` gives you? | It provides a globally unique reference to the `FormState`, allowing external code to trigger `validate()`, `save()`, and `reset()` on all descendant form fields at once. |
| **E11** | `join_form_screen`: `autovalidateMode` | When errors should appear? | `AutovalidateMode.onUserInteraction` ensures error messages appear only after the user has interacted with a field, preventing annoying validation errors from showing up on an empty, pristine form. |

---

## Widget Classification Table

| Feature | Widget(s) used | Stateless or Stateful? Why? |
|---|---|---|
| **Org list or grid** | `ListView.builder`, `GridView.builder` | **Stateless**: They are configuration widgets that construct scrollable lists or grids based on data passed down to them; scroll position is managed by the underlying scroll controller/viewport. |
| **Favorite star** | `IconButton` / `Icon` | **Stateless**: The star does not maintain its own filled/unfilled state; its visual presentation is driven entirely by the `isFavorite` boolean passed down from the parent `StatefulWidget`. |
| **Banner image** | `Image.network` | **Stateful**: `Image` is a `StatefulWidget` internally because it must manage async image stream listening, chunk loading progress, frame decoding, and error state caching. |
| **Submit button** | `FilledButton` | **Stateless**: `FilledButton` is a stateless button that delegates click events to its `onPressed` callback and renders styles based on the parent theme and enabled state. |
