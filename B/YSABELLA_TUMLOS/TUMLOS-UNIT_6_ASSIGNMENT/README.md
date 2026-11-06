## E1 — lib/screens/home_shell.dart, lines 22-50

As the Orgs, My Orgs and Schedule tabs are siblings they are unable to read one another’s state. The memberships map therefore has to be in HomeShell, their common parent. The Orgs screen puts out “Joined” indicators, My Orgs is where the memberships are listed and Schedule will highlight any booths that have been joined. Should one of the screens hold onto the map the rest would be without it and could not update on a change. With setState the `_join` and `_leave` methods alter the single map so all tabs can rebuild with the latest data.

## E2 — lib/screens/home_shell.dart, lines 54-60; lib/screens/org_list_screen.dart, lines 32-35

The IndexedStack (line 60) has all three pages in the widget tree but displays only the one at `_index`. Since the State of OrgListScreen and its `_searchController` remain in place, the text is left in the search box for when the student returns.

**C1** (replace IndexedStack with pages[_index]) : tab switching disposes of the OrgListScreen State and takes it off the tree, meaning a new one is built on return. The chips and list/grid selection as well as hidden orgs are reset and the search box is empty. The FutureBuilder goes and fetches the orgs once more which brings up the loading spinner. The memberships are safe in HomeShell.

## E3 — lib/screens/org_list_screen.dart, lines 129-140

At line 137 Navigator.pop(context) is called to shut the drawer before the About screen is opened by Navigator.pushNamed at 138. Being a route on the navigation stack, the drawer has to be closed first or it would be left under the new screen.

**C4** (remove Navigator.pop(context)) : the open drawer is covered by the About screen. A press of Back from the About screen puts the student back on the Orgs screen with the drawer still open, requiring them to close it by hand.


## E4 — lib/screens/org_list_screen.dart, lines 256-272

Wrap will put any chips that do not fit on a single line onto the next one, with `spacing: 8` to leave some room in between. A Row is not as accommodating; it puts everything on one line and will overflow if the screen is narrow. Wrap is better suited to varying text sizes and phone widths.

**C2** (replace Wrap with Row, then narrow the window) : here the chips go beyond the screen edge. Flutter will put up a yellow-black overflow stripe and throw a “RenderFlex overflowed by N pixels” error while cutting off the last of the chips. Using Wrap means they simply shift to a second line.

## E5 — lib/screens/org_list_screen.dart, lines 293-305

With maxCrossAxisExtent set to 200 the tile has a maximum width and Flutter will use only as many columns as are needed to keep them at or under that figure: columns = ceil(available width ÷ (200 + 8 spacing)). There is an 8 pixel padding on either side of the grid and 8 pixels separating the tiles. On a 360-pixel phone there is 344 to work with for 2 columns of (344 − 8) ÷ 2 = 168 pixels. A 1000-pixel window has 984 available, which comes out to 5 columns of (984 − 32) ÷ 5 = 190.4.

**C5** (try different device widths or resize the window): on a 360-wide phone the grid is 2 columns, 5 on a 1000-wide window, with the tiles remaining just under 200 pixels.

## E6 — lib/screens/org_detail_screen.dart, lines 32-54

The length of the DefaultTabController, the Tabs in the TabBar and the children of the TabBarView have to be equal, in this case 3. That ensures each tab has its own content and the proper page is displayed when the student makes a switch.

**C3** (set length: 2 with 3 tabs) : An assertion error is raised by Flutter on opening the detail screen. The accompanying message indicates a discrepancy between the controller’s length and the TabBar (or TabBarView) children count; in debug mode the red error page is what is displayed.

## E7 — lib/screens/my_orgs_screen.dart, lines 23-52

A call to showDialog<bool> returns a Future<bool?> which may be true, false or null. The latter occurs if the dialog is closed with no value, for instance by tapping outside of it or hitting Back. `if (confirmed)` will not compile since Dart has no use for a nullable bool in that position. To have the org removed one must check `confirmed == true` when the user elects to Leave. An await is followed by a `context.mounted` to verify the screen is still present.

## E8 — lib/screens/schedule_screen.dart, lines 47-69

The Table ensures each cell is properly aligned with its column in both the header and the rows. The Time and Booth columns are given set widths of 96 and 72 respectively while the Org column fills in the rest. Were this a Column of Rows, each Row would determine the size of its cells from the text within them. That would mean the columns do not line up across rows and the schedule would be difficult to make out.