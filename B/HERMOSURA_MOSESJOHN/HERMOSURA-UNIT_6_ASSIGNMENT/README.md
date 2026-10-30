# Unit 6 Assignment: CICT Org Fair part 2
Moses John Hermosura
BSIT 3B
October 28, 2026 
Hi sir

## EXPLAIN answers

### E1 (home_shell.dart, line 25)

The joined orgs were initially inside OrgListScreen. Now, because the three tabs (Orgs, My Orgs, and Schedule) and the badge need the same data, the \_memberships is in HomeShell, which is their common parent. It passes data down through parameters and receives updates through the onJoined callback.

### E2 (home_shell.dart, line 60)

IndexedStack keeps all pages alive but only shows the selected one, preserving their states (including the search text). When I tried pages[_index] instead (experiment C1), the search text disappeared after switching tabs because the page was rebuilt from scratch.

### E3 (org_list_screen.dart, line 136)

Navigator.pop(context) closes the drawer before pushNamed opens About because without it, the drawer stays open underneath. In experiment C4, returning to the list showed the drawer still open, so the terminal showed there were errors.

### E4 (org_list_screen.dart, line 260)

Wrap transfers the chips to the next line when they don't fit, while Row keeps them on one line. In C2, using Row on a narrow screen caused an overflow of 111 pixels.

### E5 (org_list_screen.dart, line 300)

Because of maxCrossAxisExtent: 200, the grid limits each tile's width to 200 pixels. After accounting for padding and spacing, a 360-pixel screen fits 2 columns (168 pixels each), while a 1000-pixel screen fits 5 (190.4 pixels each). This matches C5.

### E6 (org_detail_screen.dart, line 36)

All 3 (DefaultTabController, TabBar, TabBarView) must match in count and order. In C3, setting the length to 2 caused a mismatch error and prevented the Events tab from being clicked.

### E7 (my_orgs_screen.dart, line 46)

showDialog<bool> returns bool? because it can return null if closed without a pressing a button. Cancel returns false, and Leave returns true. Thus, confirmed == true only removes the org when Leave is pressed, not when tapping outside or pressing back.

### E8 (schedule_screen.dart, line 51)

A table keeps columns aligned by giving every row the same column widths. A column of rows would size cells themselves, causing it to not line up evenly.
