# unit6_org_fair

A new Flutter project.

### E1. In Part 1 the joined orgs were saved inside OrgListScreen. Now they live here, in HomeShell. Which screens need this map, and why can't one of those screens keep it for the others?
File: `lib/screens/home_shell.dart`         Lines: **25 and 42-52**

Answer: The joined organizations are stored in HomeShell because Orgs, My Orgs, and Schedule screens all need to use the same information. The Orgs screen uses it when a user joins, My Orgs uses it to show the organizations the user joined, and Schedule uses it to highlight or show their booth schedules. One screen cannot manage the data for the other screens because they are all separate screens. By keeping the data in HomeShell, all three screens can share the same information and therefore update together.


### E2. Type something in the search box, open the Schedule tab, then come back. Your search is still there. Which widget keeps it, and how? (Experiment C1 shows what happens without it.)
File: `lib/screens/home_shell.dart`         Lines: **62-65**

Answer: IndexedStack is the widget that keeps the search text by keeping the screens alive even when the user switches to another tab. Instead of removing and rebuilding the Orgs screen, it keeps its current state in memory. Because of this, the search text is still there when the user comes back.


### E3. Why do we close the drawer before opening the About screen? Try Experiment C4, then explain what you saw.
File: `lib/screens/org_list_screen.dart`         Lines: **140-143**

Answer: We close the drawer before opening the About screens so it does not remain open behind the About page. Navigator.pop() closes the drawer, and Navigator.pushNamed() opens the About screen. This makes moving between screens easier and cleaner.


### E4. These chips sit in a Wrap, not a Row. What does Wrap do when the chips don't fit on one line? What would a Row do? (Experiment C2)
File: `lib/screens/org_list_screen.dart`         Lines: **268-278**

Answer: Wrap moves category chips to another line when they cannot fit on one line. A Row tries to keep all the chips on one line, which can cause an overflow on smaller screens. Using Wrap keeps the filters visible and easy to use.


### E5. With maxCrossAxisExtent: 200, how many columns does a 360-wide phone get, and how wide is each tile? A 1000-wide window? Show your math, then check it with Experiment C5.
File: `lib/screens/org_list_screen.dart`         Lines: **297-312**

Answer: A 360-wide phone gets 2 columns, with each tile being 168 pixels wide. A 1000-wide window gets 5 columns, with each tile being 190.4 pixels wide. This happens because Flutter automatically adjusts the number of columns based on the available screen width.

For a 360-wide phone:
- Available width: 360 − 16 (padding) = 344
- Columns: ⌈344 ÷ 208⌉ = 2
- Tile width: (344 − 8 spacing) ÷ 2 = 168 pixels

For a 1000-wide window:
- Available width: 1000 − 16 (padding) = 984
- Columns: ⌈984 ÷ 208⌉ = 5
- Tile width: (984 − 32 spacing) ÷ 5 = 190.4 pixels

The 208 used in the calculations comes from 200 (`maxCrossAxisExtent`) + 8 (`crossAxisSpacing`).


### E6. DefaultTabController has a length, the TabBar has tabs and the TabBarView has children. What must be true about these three numbers? What happens when they don't match? (Experiment C3)
File: `lib/screens/org_detail_screen.dart`         Lines: **32-56**

Answer: The three numbers must be equal for the tabs to work properly. In our app, DefaultTabController has a length of 3, TabBar has 3 tabs (About, Officers, and Events), and TabBarView has 3 children. If these numbers do not match, Flutter may show an error because the number of tabs and pages is incorrect.


### E7. showDialog<bool> gives back a bool?, not a bool. When is it null? Why do we test confirmed == true instead of just confirmed?
File: `lib/screens/my_orgs_screen.dart`         Lines: **29-54**

Answer: The result is null when the user closes the dialog without choosing Leave or Cancel, such as by tapping outside it. We use confirmed == true to make sure the user actually selected Leave before removing the organization. We cannot use just confirmed because it might be null, and Flutter requires a non-null boolean for an if condition.


### E8. Why a Table here and not a Column of Rows? What would go wrong with the columns if each Row sized itself?
File: `lib/screens/schedule_screen.dart`         Lines: **54-72**

Answer: A Table here keeps the Time, Booth, and Org columns lined up across all rows. It also lets the app set column widths so the schedule looks organized. A Column of separate Row widgets would not automatically keep the columns aligned.