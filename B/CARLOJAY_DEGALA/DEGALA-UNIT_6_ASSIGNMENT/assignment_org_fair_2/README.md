# DEGALA - Unit 6 Assignment (CICT Org Fair Part 2)

## Explain answers (E1 - E8)

## E1:  Location: /lib/screens/home_shell.dart, line 25
	The OrgListScreen, MyOrgsScreen, and ScheduleScreen all need access to their membership data. The HomeShell must hold the memberships map so it can safely pass data.

## E2: Location: /lib/screens/home_shell.dart, line 62-64
	Replacing the body with an IndexedStack keeps all screens mounted in memory instead of destroying them when switching tabs. This is what preserves the text and prevents it from resetting.

## E3: Location: /lib/screens/org_list_screen.dart, line 135-137	
	We close the navigation drawer using Navigator.pop(context) before opening the About screen. Leaving the drawer open can cause visual glitches. So if we skip pop, the About is open on top of the drawer, and when pressed Back, the drawer is still open instead of the org list. 

## E4: Location: /lib/screens/org_list_screen.dart, line 260-270
	A Wrap would automatically move overflowing chips down to the next line. Whereas a Row would cause a yellow and black overflow error when space runs out.

## E5: Location: /lib/screens/org_list_screen.dart, line 299-304
	With maxCrossAxisExtent: 200, a 360-wide phone displays 2 columns (since 360/200 = 1.8, rounding up). A 1000 wide window displays 5 columns (1000/200 = 5). This delegate automatically adjusts column counts based on the available screen width.

## E6: Location: /lib/screens/org_detail_screen.dart, line 32-56
	The DefaultTabController length, total count of items in TabBar and children count of in TabBarView must all be identical. If the numbers do not match, the layout will cause an error.

## E7: Location: /lib/screens/my_orgs_screen.dart, line 23–47
	The showDialog returns a bool? Because the dialog can be dismissed by tapping outside or pressing the back button, which yields a null. We test confirmed == true instead of just confirmed to safely handle the null case and ensure the user actually pressed the Leave button.

## E8: Location: /lib/screens/schedule_screen.dart, line 53-71
	A Table is used because it syncs with the cell’s width globally across all rows, so that the vertical columns line up neatly. If we used a column of rows instead, each row would size its internal items independently based on its own text length. This would cause the columns to misalign down the screen.