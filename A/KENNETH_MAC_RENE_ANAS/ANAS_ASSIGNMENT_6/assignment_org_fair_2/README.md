Part I. Explain E1 to E8

E1 home_shell: _memberships:

    lib/screens/home_shell.dart: 20-23, 34-43

    Memberships is kept in HomeShell because the Orgs, My Orgs, and Schedule pages all need the same data. When a user joins or leaves an organization, HomeShell updates the map and passes the new data down to the pages that show it. That way all three pages stay in sync without each keeping its own copy.

E2 home_shell: body:

    lib/screens/home_shell.dart:34-43

    IndexedStack is used so all three pages stay in the widget tree and only the selected one is visible. Because the pages aren’t rebuilt when I switch tabs, the Orgs page keeps its search text and other state when I come back to it.

E3 org_list_screen: drawer: 

    lib/screens/org_list_screen.dart:142-148

    When the drawer item is tapped, I call Navigator.pop first to close the drawer. If I skipped that, the drawer would stay open on top of the new page, and the transition would look messy. After it closes, Navigator.pushNamed opens the About page.

E4 org_list_screen: chips:

    lib/screens/org_list_screen.dart:246-255

    I used Wrap for the chips because it moves them to the next line when they don’t fit the available width. A Row tries to keep everything on one line, so on a narrow screen the chips would overflow.

E5 org_list_screen: _buildGrid: 

    lib/screens/org_list_screen.dart:268-274

    The maxCrossAxisExtent of 240 caps each grid tile at 240 logical pixels wide. As the screen gets wider, more columns fit, and the grid works out the number of columns by itself while still accounting for the spacing between tiles. This makes the layout responsive without hardcoding a column count.

E6 org_list_screen: _buildGrid:'

    lib/screens/org_detail_screen.dart:30-45

    The DefaultTabController length, the number of tabs in the TabBar, and the number of pages in the TabBarView all have to match. In this app each one has three entries: About, Officers, and Events. If they don’t match, the tabs and pages won’t line up correctly.

E7 my_orgs_screen: _confirmLeave: 
    
    lib/screens/my_orgs_screen.dart:17-34
    
    The dialog returns true if the user confirms leaving and false if they cancel. If they dismiss it some other way, like tapping outside, it returns null. Checking shouldLeave == true means the membership is only removed after an explicit confirmation, so a dismissed dialog never removes anything by accident.

E8 schedule_screen:
    
    lib/screens/schedule_screen.dart:65-116
    
    Table rows organize, so the times, booth numbers, and organization names all line up. If I had used separate Row widgets inside a Column, each row would lay itself out independently, and keeping the columns aligned would be much harder.