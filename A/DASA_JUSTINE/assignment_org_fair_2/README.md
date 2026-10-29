# unit6_org_fair

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Code Explanations (E1–E8)

### E1 — Lifting State Up
**Location:** `lib/screens/home_shell.dart`, line 25

The `_memberships` map is stored in `HomeShell` because multiple screens need access to the student's joined organizations. If the map were kept inside `OrgListScreen`, the other screens would not be able to use the same data directly. Keeping it in the parent allows the screens to share updated membership information.

### E2 — IndexedStack
**Location:** `lib/screens/home_shell.dart`, line 60

The `IndexedStack` displays only the selected page while keeping the other pages in the widget tree. This allows the Orgs screen to retain its state, including the search text, when I switch to another tab. Without it, switching tabs could recreate the screen and reset its state.

### E3 — Closing the Drawer
**Location:** `lib/screens/org_list_screen.dart`, lines 136-137

The drawer is closed using `Navigator.pop(context)` before opening the About screen. This removes the drawer from view so it does not remain open over the next screen. After that, `Navigator.pushNamed()` opens the About screen using its registered route name.

### E4 — Wrap vs. Row
**Location:** `lib/screens/org_list_screen.dart`, line 260

A `Wrap` moves chips to the next line when there is not enough horizontal space. A `Row` tries to arrange its children on a single horizontal line, which can cause a layout overflow if the chips do not fit. Using `Wrap` makes the category filters work better on different screen sizes.

### E5 — Grid Column Calculation
**Location:** `lib/screens/org_list_screen.dart`, lines 293-321

The `SliverGridDelegateWithMaxCrossAxisExtent` determines the number of columns based on the available width and the maximum width of each tile. With the grid's 8-pixel horizontal padding and 8-pixel spacing, a 360-pixel-wide screen has 344 pixels available, allowing 2 columns of 168 pixels each. A 1000-pixel-wide screen has 984 pixels available, allowing 5 columns of about 190.4 pixels each. This lets the grid adapt to different screen widths.

### E6 — Matching Tab Counts
**Location:** `lib/screens/org_detail_screen.dart`, lines 32-53

The `DefaultTabController` length, the number of tabs in the `TabBar`, and the number of children in the `TabBarView` must all match. Each tab needs a corresponding page to display its content. If the counts do not match, the tabs and their pages will not work correctly and may cause an error.

### E7 — Dialog Return Value
**Location:** `lib/screens/my_orgs_screen.dart`, lines 23-45

The result of `showDialog<bool>()` is a nullable Boolean (`bool?`) because the dialog can return `true`, `false`, or `null` if it is dismissed without choosing either button. Checking `confirmed == true` ensures that the organization is removed only when the user explicitly selects Leave. Canceling or dismissing the dialog does not remove the membership.

### E8 — Table vs. Column of Rows
**Location:** `lib/screens/schedule_screen.dart`, line 53

A `Table` aligns cells into consistent columns, making the schedule easier to read. If I used a `Column` containing separate `Row` widgets, each row could size its columns independently based on its content. This could make the times, booth numbers, and organization names appear misaligned.
