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

EXPLAIN E1 to EXPLAIN E8 ANSWERS:

E1:
    Explain:

    The joined orgs live in HomeShell because OrgListScreen, MyOrgsScreen, and ScheduleScreen need this map. One of these screens cannot keep the map for others because the other screens will not be able to access it directly without passing the data between them individually. Keeping it in HomeShell allows these screens to share consistent, updated information through properties and callbacks.

    File: lib/screens/home_shell.dart

    Line Number: Lines 25 (_memberships map declaration) and 27-33 (_join() method).

E2:
    Explain:

    The widget that keeps the search text when I switch tabs is the IndexedStack. It stacks the pages and shows only the selected page while keeping the other pages alive, even when they are hidden. Selecting a page is like placing one page of paper in front of the others so that it is the only one visible, without changing the state of the hidden pages. That is why when I return to the Orgs tab, my search text is still there. 

    File: lib/screens/home_shell.dart

    Line Number: Lines 62-65.

E3:
    Explain:

    We close the drawer so it will not disrupt the user's view when opening another screen. If we do not close the drawer before opening the AboutScreen, it may remain visible over the new screen and hide some of its contents. Closing it first makes navigation clearer and provides a better user experience. 

    File: lib/screens/org_list_screen.dart

    Line Number: Lines 139-142.

E4:
    Explain:

    The Wrap widget pushes the chips to the next line when they do not fit on one line. It automatically adjusts their positions to prevent the layout from overflowing. On the other hand, a Row tries to fit all the chips on a single line, which can cause a layout overflow and display black-and-yellow warning stripes. 

    File: lib/screens/org_list_screen.dart

    Line Number: Lines 265-275

E5:
    Explain:  
    To get the number of columns, we use the formula Columns = grid width ÷ maxCrossAxisExtent. For a 360-pixel-wide phone, 360200=1.8, which rounds up to 2 columns, and each tile is (360-8)2=176 pixels wide. For a 1000-pixel-wide window, 1000200=5, so there are 5 columns. Since there are four 8-pixel gaps between the five columns, each tile is (1000-4(8))5=193.6 pixels wide. 

    File: lib/screens/org_list_screen.dart

    Line Number: Lines 304-309.

E6:
    Explain:

    These three numbers should be equal. If the length in DefaultTabController is 3, the number of tabs in TabBar should also be 3, and the number of children in TabBarView should be 3 as well. If these numbers do not match, it may cause an error or the tabs may not function properly. 

    File: lib/screens/org_detail_screen.dart

    Line Number: Lines 32–56, specifically line 36 (DefaultTabController length), lines 41–45 (TabBar tabs), and lines 49–53 (TabBarView children). 

E7:
    Explain:

    The result of showDialog<bool> is bool? because it can return true, false, or null if the dialog is dismissed without an explicit result. We test confirmed == true to ensure that the organization is removed only when the user presses the Leave button. If the user presses Cancel or dismisses the dialog, the organization will not be removed. 

    File: lib/screens/my_orgs_screen.dart

    Line Number: Lines 29 and 47

E8:
    Explain:

    We use a Table instead of a Column of Row widgets to keep the columns consistently sized and aligned, making the schedule look organized. If each row sized its contents independently, the columns could become misaligned. This would make the schedule look unorganized and the data harder to read and follow. 

    File: lib/screens/schedule_screen.dart

    Line Number: Lines 52-70.
