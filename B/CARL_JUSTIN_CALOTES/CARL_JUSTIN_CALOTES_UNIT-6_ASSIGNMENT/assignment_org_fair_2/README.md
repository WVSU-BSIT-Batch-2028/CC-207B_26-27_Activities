E1
file: lib/screens/home_shell.dart
line: 42-52

the membership map is stored in HomeShell because it is needed in by multiple screens, keeping it in the parent allows the screens to share the same membership information. The other screens will have no direct access to the map if it's being kept in only one screen.

E2
file: lib/screeens/home_shell.dart
line: 62-65

the IndexStack displays the page selected by the index while keeping the other pages active. This helps in preserving the state of a screen when swtiching tabs.

E3
file: lib/screens/org_list_screen.dart
line: 135-138

The drawer should close before opening the About page so it does not remain in the navigation stack. Navigator.pop(context) closes the drawer and then Navigator.pushNamed opens the About page. When the user presses back, they can directly return to the org list instead of seeing the drawer again.

E4
file: lib/screens/org_list_screen.dart
line: 259-269

Wrap allows them to move in another line when there is not enough horizontal space. On the other hand, Row keeps its children on one horizontal line and may cause overflow.

E5
file: lib/screens/org_list_screen.dart
line: 298-304

The SliverGridDelegateWithMaxCrossAxisExtent adjusts the number of columns based on the available screen width. On a 360-pixel phone, the grid has 2 columns with tiles around 168 pixels wide. On a 1000-pixel window, it has 5 columns with tiles around 190.4 pixels wide. (Sir, I'm weak sa math)


E6
file: lib/screens/org_detail_screen.dart
line: 32-56

The DefaultTabController, TabBar, and TabBarView must have matching lengths because each tab needs a corresponding page. If their lengths do not match, Flutter can produce an error when the tabs are used.

E7
file: lib/screens/my_orgs_screen.dart
line: 29-45

The showDialog<bool> function returns a nullable Boolean (bool?) because the dialog may be dismissed without choosing either button, which can return null. The Cancel button returns false, while the Leave button returns true. Checking confirmed == true ensures that the organization is removed only when the student confirms leaving.

E8
file: lib/screens/my_orgs_screen.dart
line: 53-71

A Table is used because it keeps the columns aligned across all rows. If each row were created separately using a Row, the contents could have different widths and the columns might not line up properly.