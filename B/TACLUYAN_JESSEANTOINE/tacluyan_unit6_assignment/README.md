# CICT Org Fair App — Unit 6

## Explanations E1–E8

### E1 — `lib/screens/home_shell.dart`, `_memberships` (around line 25)

HomeShell keeps the membership map because the Orgs, My Orgs, and Schedule pages all use the same information. This keeps the pages in sync when I join or leave an organization.

### E2 — `lib/screens/home_shell.dart`, `body` / `IndexedStack` (around line 55)

IndexedStack shows the page I selected while keeping the other pages in memory. My search text stays there when I switch to another tab and go back to Orgs.

### E3 — `lib/screens/org_list_screen.dart`, About drawer item (lines 129–131)

The drawer closes before the About page opens so it does not stay open in the background. When I press Back, I return to the Orgs page without the drawer appearing again.

### E4 — `lib/screens/org_list_screen.dart`, category chips / `Wrap` (lines 253–260)

Wrap moves the chips to another line when there is not enough space for them. Row keeps the chips on one line, which can cause them to overflow on a narrow screen.

### E5 — `lib/screens/org_list_screen.dart`, `_buildGrid` (lines 282–293)

On a 360-pixel screen, the grid has about 344 pixels of usable width, so two columns are about 168 pixels each: (344 − 8) ÷ 2. On a 1000-pixel screen, there are 984 usable pixels, allowing five columns that are about 190.4 pixels each: (984 − 32) ÷ 5.

### E6 — `lib/screens/org_detail_screen.dart`, `DefaultTabController`, `TabBar`, and `TabBarView` (around lines 32–56)

The controller length, the number of tabs, and the number of pages inside TabBarView must all be three. They must also follow the order About, Officers, and Events, or Flutter can show an error when the numbers do not match.

### E7 — `lib/screens/my_orgs_screen.dart`, `_confirmLeave` (lines 26–49)

showDialog<bool> can return true, false, or null if the dialog closes without a button being chosen. Checking confirmed == true makes sure the app removes the membership only when I press Leave, not when I press Cancel or dismiss the dialog.

### E8 — `lib/screens/schedule_screen.dart`, `_row` and `Table` (lines 15–34 and 48–66)

Table keeps the time, booth, and organization columns lined up across the rows. Separate Row widgets inside a Column can have different column widths, making the information harder to read.