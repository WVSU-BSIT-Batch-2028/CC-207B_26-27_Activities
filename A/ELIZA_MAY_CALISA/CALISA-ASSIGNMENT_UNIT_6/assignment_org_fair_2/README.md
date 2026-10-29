Unit 6 Assignment: CICT Org Fair App Development Part 2

EXPLAIN Answers for part I.

E1: Why the joined orgs live in HomeShell

By holding shared data in the main parent screen (HomeShell), the top level manages the information while child pages focus purely on displaying content and handling user taps. This setup keeps the entire app synchronized automatically. As a result, actions like joining or leaving a group instantly update your organization list, badge counts, and schedule highlights all at once.

Reference: lib/screens/home_shell.dart, line 25 (final Map<String, Membership> _memberships)

E2: Why IndexedStack keeps the search text when you switch tabs

The search state is kept by OrgListScreen's State object, including its TextEditingController and _query. In home_shell.dart:61, replacing body: pages[_index] with an IndexedStack keeps all tab widgets mounted, so switching tabs does not dispose OrgListScreen or reset its search state.

Reference: lib/screens/home_shell.dart, line 61 (body: IndexedStack(...))

E3: Why the drawer is closed before the About screen opens

We close the drawer first so it does not remain open on top of the About screen. If we open the screen without closing it, the drawer may stay visible or create confusing back-navigation behavior.

Reference: lib/screens/org_list_screen.dart, line 128 (the "About the fair" ListTile, onTap)

E4: Wrap or Row when the chips do not fit

A Wrap moves chips to the next line when they no longer fit horizontally. This allows all chips to remain visible without overflowing the screen. A Row keeps every chip on one line, so chips that do not fit may overflow or cause a layout error.

Reference: lib/screens/org_list_screen.dart, line 260 (the Wrap of FilterChips)

E5: The column math of maxCrossAxisExtent

On a 360-wide phone, the usable width is 360 − 16 = 344. Two columns are needed because one would be 344 wide (over 200). Each tile is (344 − 8) ÷ 2 = 168. On a 1000-wide window, the usable width is 984. Four columns would make tiles (984 − 24) ÷ 4 = 240, which is over 200, so Flutter uses 5 columns, each (984 − 32) ÷ 5 = 190.4 wide.

Reference: lib/screens/org_list_screen.dart, line 301 (maxCrossAxisExtent: 200 in _buildGrid)

E6: What must match in DefaultTabController, TabBar and TabBarView

The DefaultTabController length, the number of TabBar tabs, and the number of TabBarView children must all be the same. This ensures every tab has exactly one matching page. If the numbers do not match, Flutter throws an error at runtime and the tabs may not work correctly.

Reference: lib/screens/org_detail_screen.dart, line 37 (length: 3, the TabBar and the TabBarView)

E7: Why a dialog answer is bool? and is tested with == true

showDialog<bool> can return null when the dialog is dismissed without pressing a button, such as by tapping outside it or pressing the back button. We test confirmed == true so the leave action happens only when the user explicitly chooses Leave, not when the result is false or null.

Reference: lib/screens/my_orgs_screen.dart, line 45 (if (confirmed == true && context.mounted))

E8: Why a Table and not a Column of Rows

A Table keeps every row aligned in the same columns and gives each column a consistent width. With a Column of separate Row widgets, each row could size its columns independently, causing the text and cells to shift out of alignment.

Reference: lib/screens/schedule_screen.dart, line 53 (the Table in build)