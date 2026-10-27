# Unit 6 Assignment - CICT Org Fair Part 2

**Name:** Mark Alvin Cadangin  
**Section:** BSIT 3A-SDT  
**Course:** CC-207B  

---

### E1: Lifting state up (`lib/screens/home_shell.dart:25`)
In Part 2, three different screens need access to `_memberships`: `OrgListScreen` (to show if an org is joined), `MyOrgsScreen` (to list joined orgs and leave them), and `ScheduleScreen` (to highlight booth slots). In Flutter, sibling screens cannot access each other's private state directly. We lift the state up to their common parent `HomeShell`, which holds `_memberships` as the single source of truth and passes it down to each tab.

### E2: Preserving search text with IndexedStack (`lib/screens/home_shell.dart:62`)
`IndexedStack` keeps all of its child pages mounted in the widget tree at the same time, only changing which child is visible on screen. If we used `body: pages[_index]`, switching tabs would unmount `OrgListScreen` and dispose its `TextEditingController`. Because `IndexedStack` keeps `OrgListScreen` alive in memory, the search box text and filtered list stay intact when we switch tabs and return.

### E3: Closing the drawer before opening About (`lib/screens/org_list_screen.dart:136`)
Opening the drawer pushes it as a route onto the Navigator stack. If we push the About screen without closing the drawer first, the drawer stays open behind it; when the user taps back from the About screen, they will be looking at the open drawer instead of the org list. Calling `Navigator.pop(context)` first closes the drawer so pressing back returns straight to the list.

### E4: Wrap vs Row for chips (`lib/screens/org_list_screen.dart:260`)
A `Row` only lays out children on a single horizontal line, so if there are too many chips or the screen is narrow, it overflows and causes a yellow-and-black stripe error (`RenderFlex overflowed`). `Wrap` automatically wraps overflowing chips to the next line. This makes sure the category chips fit on any screen width without overflowing.

### E5: Column math of maxCrossAxisExtent (`lib/screens/org_list_screen.dart:298`)
The grid has 8 px padding on each side (16 px total) and 8 px spacing between columns.
- On a 360 px phone: Usable width is $360 - 16 = 344\text{ px}$. Flutter calculates $(344 + 8) / (200 + 8) = 352 / 208 \approx 1.69$, which rounds up to **2 columns**. With 1 gap of 8 px, each tile width is $(344 - 8) / 2 = \mathbf{168\text{ px}}$.
- On a 1000 px window: Usable width is $1000 - 16 = 984\text{ px}$. Flutter calculates $(984 + 8) / (200 + 8) = 992 / 208 \approx 4.77$, which rounds up to **5 columns**. With 4 gaps of 8 px (32 px total), each tile width is $(984 - 32) / 5 = \mathbf{190.4\text{ px}}$.

### E6: Matching tabs and views (`lib/screens/org_detail_screen.dart:36`)
The `length` in `DefaultTabController`, the number of `Tab` items in `TabBar.tabs`, and the number of views in `TabBarView.children` must all be the exact same number (3 in our case). If they don't match, Flutter throws a runtime assertion error because the tab controller index does not have a matching view to display.

### E7: Dialog return type bool? and == true (`lib/screens/my_orgs_screen.dart:29`)
`showDialog<bool>` returns a `bool?` because the user can dismiss the dialog without pressing either button, such as tapping the dark barrier outside or pressing the Android back button, which returns `null`. In Dart, you cannot do `if (confirmed)` on a nullable boolean. Writing `if (confirmed == true)` ensures we only leave the org when the user explicitly taps the "Leave" button.

### E8: Table vs Column of Rows (`lib/screens/schedule_screen.dart:51`)
A `Table` aligns columns across every row simultaneously using fixed and flex column widths, so all times, booths, and org names line up neatly in a grid. If we used a `Column` of `Row` widgets, each row would size its columns based only on its own text length, making the columns jagged and misaligned across rows. A `Table` also lets us paint a clean row-level background highlight for joined orgs.
