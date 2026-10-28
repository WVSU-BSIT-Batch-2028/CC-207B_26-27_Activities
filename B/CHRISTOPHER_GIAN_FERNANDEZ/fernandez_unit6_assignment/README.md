# Unit 6: Code Explanations (E1–E8)

# EXPLAIN E1: In Part 1 the joined orgs were saved inside OrgListScreen.
# Now they live here, in HomeShell. Which screens need this map, and why
# can't one of those screens keep it for the others?
 
The memberships are stored in HomeShell because both the Orgs page and My Orgs page need access to the same data. Keeping the data in their common parent allows the child screens to receive the latest memberships and update them through callbacks instead of maintaining separate copies. (lines 27–33)

# EXPLAIN E2: Type something in the search box, open the Schedule tab,
# then come back. Your search is still there. Which widget keeps it,
# and how? (Experiment C1 shows what happens without it.)

An IndexedStack only displays the currently selected page while keeping the other pages alive. This basically means the search text and other screen state can remain when I switch tabs and return, instead of being reset because the page was removed from the widget tree. (line 62)

# EXPLAIN E3: Why do we close the drawer before opening the
# About screen? Try Experiment C4, then explain what you saw.

Because it closes the drawer route before navigating to the new page, which gives the user the expected navigation behavior instead of leaving the drawer open over the About screen. (lines 135-138)

# EXPLAIN E4: These chips sit in a Wrap, not a Row. What does Wrap
# do when the chips don't fit on one line? What would a Row do?
# (Experiment C2)

A Wrap automatically moves chips onto another line when they no longer fit in the available width. A Row on the other hand, keeps its children on a single horizontal line, which can cause the chips to overflow on smaller screens. (Lines 262-272)

# EXPLAIN E5: With maxCrossAxisExtent: 200, how many columns does a
# 360-wide phone get, and how wide is each tile? A 1000-wide window?
# Show your math, then check it with Experiment C5.

On a 360-wide phone, the grid has 2 columns with each tile being 168 pixels wide. On a 1000-wide window, it has 5 columns with tiles approximately 190.4 pixels wide. This allows the layout to adjust to different screen sizes. (Lines 301-306)

360-wide: 
Available width: 360 - 8 - 8 = 344 px
Two columns fit because 344 / 2 = 172 px per column, including spacing.
Subtract the 8 px spacing: (344 - 8) / 2 = 168 px per tile.

1000-wide:
Available width: 1000 - 8 - 8 = 984px
Five columns fit because 984 / 5 = 196.8 px per column, including spacing.
Subtract the four gaps of 8 px each: (984 - 4 * 8) / 5 = 190.4 px per tile.

# EXPLAIN E6: DefaultTabController has a length, the TabBar has tabs and
# the TabBarView has children. What must be true about these three
# numbers? What happens when they don't match? (Experiment C3)

The DefaultTabController length, the number of tabs in the TabBar, and the number of pages in the TabBarView must all match. In this app, all three use three entries for About, Officers, and Events. If the counts do not match, Flutter can throw an error or the tabs may not work correctly. (Lines 32-44)

# EXPLAIN E7: showDialog<bool> gives back a bool?, not a bool. When is
# it null? Why do we test confirmed == true instead of just confirmed?

The result of showDialog<bool> is nullable because the dialog may be dismissed without the user choosing either button. Checking confirmed == true ensures the organization is removed only when the user explicitly selects Leave, not when they select Cancel or dismiss the dialog. (Lines 29-45)

# EXPLAIN E8: Why a Table here and not a Column of Rows? What would
# go wrong with the columns if each Row sized itself?

A Table coordinates the widths of each column so that the time, booth, and organization information line up across different rows. If a separate Row were used for every schedule entry instead, each row could size its contents independently, making the columns less consistent and harder to read. (Lines 53-71)

