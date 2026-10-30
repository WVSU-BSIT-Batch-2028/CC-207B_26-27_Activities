# unit6_org_fair
# E1–E8 explanations

# E1 

In home_shell.dart line 25, HomeShell owns the joined-org map because the Orgs list, My Orgs, and Schedule all need to read the same membership data. The child screens receive that data from HomeShell and report changes through callbacks, keeping one shared source of truth.

# E2 

Around home_shell.dart line 62, using an IndexedStack means all the tabs stay loaded in the background instead of being destroyed. That's why when you type a search, switch tabs, and come back, your text is still there—the widget never actually closed.

# E3 

In org_list_screen.dart line 137, we close the drawer first before opening the About screen so that when you hit the back button later, you go straight to the main list. If we didn't close it first, hitting back would awkwardly dump you back into an open drawer.

# E4 

In org_list_screen.dart line 262, we use Wrap because if there are too many category chips to fit horizontally, it automatically pushes the extra ones to the next line. If we used a Row, it would just try to cram them all on one line and cause a yellow-and-black overflow error.

# E5 

On org_list_screen.dart line 301, maxCrossAxisExtent sets the maximum tile width, and the grid chooses the number of columns that fit. On a 360-pixel screen, 8 pixels of padding on each side leaves 344 pixels; with 8-pixel gaps, two columns are each (344 - 8) / 2 = 168 pixels wide. On a 1000-pixel screen, the 16 pixels of padding leave 984 pixels; five columns with four 8-pixel gaps are each (984 - 32) / 5 = 190.4 pixels wide.

# E6 

In org_detail_screen.dart line 32, the length property in the DefaultTabController has to match both the number of tabs in the TabBar and the number of screens in the TabBarView. If they don't match, the selected tabs cannot map correctly to their views, and Flutter reports an error.

# E7 

The dialog result in my_orgs_screen.dart line 24 is a bool? (nullable) because the user could just tap outside the box to close it, which returns null. By checking == true, we make absolutely sure they actually clicked the "Leave" button before deleting their data.

# E8 

In schedule_screen.dart line 51, a Table is better because it forces all the columns to align perfectly across every row. If we just stacked a bunch of Row widgets in a Column, the cells would size themselves independently, making the schedule look messy and unaligned.
