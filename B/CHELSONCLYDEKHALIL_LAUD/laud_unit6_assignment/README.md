# E1: Lifting state up: why the joined orgs live in HomeShell
We put the joined orgs map inside HomeShell at home_shell.dart in line 25 because all the three tab screens need to see which orgs you joined. If we kept that list hidden inside just one screen then the other screens would not know when you joined or left an org. So putting it in the main parent screen makes it so that every tab can see and share the exact same list easily.

# E2: Why IndexedStack keeps your search text when you switch tabs
The IndexedStack found at home_shell.dart in line 62 keeps all of our tab pages active instead of deleting them when we switch tabs. This means whatever text we typed in the search box stays there when we come back and the page never resets because it was just hidden in the background the whole time.

# E3: Why the drawer is closed before the About screen opens
We close the drawer first at org_list_screen.dart in line 135 so that the side menu hides before the About page opens up. If you do not close it first then the side menu will still be open on the screen when you press back to exit the About page.

# E4: Wrap or Row when the chips do not fit
The filter chips are placed inside a wrap widget found in the padding section at org_list_screen.dart in line 260 so that the chips automatically bump down to a new row when they run out of space. And if we used a row instead then the chips would go past the edge of the screen and that it will break the design showing the yellow stripes.

# E5: The column math of maxCrossAxisExtent
The grid delegate located at org_list_screen.dart in line 300 divides the screen width by 200 to decide how many columns can fit. On a small phone that is 360 wide, if we do the math and divide 360 by 200 it gives 1.8 which rounds up to make 2 columns. And on a wide computer screen that is 1000 wide, we divide it by 200 and that makes 5 columns instead.

# E6: What must match in DefaultTabController, TabBar and TabBarView
The length number in the return DefaultTabController section at org_detail_screen.dart in line 36 must match the number of tabs in the tab bar and the number of pages in the tab view which means all three of these numbers must be set to 3 so that the tabs line up correctly. If they do not match right then the app gets confused and then crashes because it tries to show a tab page that is missing.

# E7: Why a dialog answer is bool? and is tested with == true
The popup box that shows at my_orgs_screen.dart in line 29 can be empty or null if the user taps outside the box without clicking a button. And then we test if confirmed is equal to true in line 47 so that the app knows for sure that the user clicked the actual leave button instead of just dismissing the popup so that it prevents the app from accidentally removing you from an org when you just closed it.

# E8: Why a Table and not a Column of Rows
We used a table at schedule_screen.dart in line 53 because it looks neat since it forces every box to line up in vertical columns across the whole page. And if we used a column of rows instead then each row would change size depending on how long the text would be and that would make the schedule look messy and not align correctly.

