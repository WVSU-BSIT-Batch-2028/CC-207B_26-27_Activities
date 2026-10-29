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

1. lib/screens/home_shell.dart - line 25
   The joined organizations (_memberships) live in HomeShell because HomeShell acts as the parent container managing multiple tabs (OrgListScreen, MyOrgsScreen, and ScheduleScreen). By lifting the state to this common ancestor, data can be shared seamlessly across sibling screens—for instance, when a user joins an org in the detail view, HomeShell receives the update and instantly reflects the badge count on the "My Orgs" tab and updates the highlighted rows in the "Schedule" tab.

2. lib/screens/home_shell.dart - line 62
    IndexedStack keeps all its child screens rendered and alive simultaneously in the widget tree, only hiding the ones that are not currently active. Because the screens are never destroyed or disposed of when switching navigation tabs, local UI states—such as typed search queries, scroll offsets, and active text field controllers—are perfectly preserved.

3. lib/screens/org_list_screen.dart - lines 137-138
    The drawer is explicitly popped (Navigator.pop(context)) before pushing the About route to ensure a clean navigation transition and proper UI dismissal. If left open, the navigation stack would attempt to push the new route while the drawer overlay is still in the process of sliding or settling, causing visual glitches and leaving an orphaned drawer state when returning.

4. lib/screens/org_list_screen.dart - line 261
    A Wrap automatically flows overflowing items onto the next line when horizontal space runs out, which is ideal for category filter chips of varying lengths. In contrast, a Row forces all children into a single horizontal line and will trigger a layout overflow error (yellow-and-black stripes) if the total width exceeds the screen bounds.

5. lib/screens/org_list_screen.dart - line 300
    SliverGridDelegateWithMaxCrossAxisExtent dynamically calculates the column count so each tile stays at or below the maximum cross-axis extent of 200px. With 8px spacing, a 360px-wide grid fits 2 columns of about 176px each; a 1000px-wide grid fits about 5 columns of about 194px each. The layout adapts the number and width of tiles to the available space.

6. lib/screens/org_detail_screen.dart - lines 36, 40, and 48
    The length property in DefaultTabController must precisely match both the total number of Tab items inside the TabBar and the number of child view widgets inside the TabBarView. If these numbers mismatch, Flutter throws a runtime assertion error because the controller cannot map tab index selections to views properly.

7. lib/screens/my_orgs_screen.dart - line 46
    showDialog<bool> returns a nullable bool? because the dialog can be dismissed in multiple ways, such as tapping outside its bounds or pressing the back button—which yields null instead of an explicit true or false. Testing explicitly with == true safely handles this nullability and ensures code execution proceeds only when the user deliberately clicks the confirmation button.

8. lib/screens/schedule_screen.dart - line 50
    A Table enforces uniform column width constraints globally across all its rows, ensuring that time blocks, booth names, and organization labels align vertically down the entire schedule grid. If a Column of independent Rows were used instead, each row would size itself based solely on its own individual content widths, resulting in misaligned and jagged columns.
    