# Unit 6 Assignment: CICT Org Fair Part 2

Alyanna Bianca S. Serra BSIT 3-A

## Answers

E1 (home_shell.dart, line 22-24: `_memberships`)
The HomeShell keeps the list of joined organizations because the tabs need to share or use the same data. This pass the data to each tab and updates it when I join or leave an organization.

E2 (home_shell.dart, line 55-57: `body`)
IndexedStack keeps the pages even when they are hidden. This means the search text will stay when I try to switch tabs. When I used pages[_index], the page was removed and the search box became empty when I returned.

E3 (org_list_screen.dart, line 131-132: drawer `onTap`)
I learned that I need to close the drawer before opening the About page. When I tried to not use the Navigator.pop, the drawer was still open when I pressed Back.

E4 (org_list_screen.dart, line 257-258: chips)
A Wrap moves the chips to the next line when there's no enough space. Row keeps them on one line, which will overflow when the screen is narrow.

E5 (org_list_screen.dart, line 294-296: `_buildGrid`)
`maxCrossAxisExtent: 200` is used to set the maximum width of each grid tile. Flutter adjusts the number of columns based on the screen size. A smaller screen shows fewer columns, and a wider screen can show more.

E6 (org_detail_screen.dart, line 29-31: `DefaultTabController`)
The controller length, the number of tabs, and the number of TabBarView pages must match. When I changed the length to 2 but kept three tabs, the screen showed an error.

E7 (my_orgs_screen.dart, line 24-25: `_confirmLeave`)
A dialog can return null if the user closes it without choosing an option. Using confirmed == true makes sure the organization is removed just when the user confirms by pressing Leave.

E8 (schedule_screen.dart, line 53-54: `Table`)
Because the Table keeps the columns aligned in every row. When I used a Column with separate Rows, the columns did not line up because the text had different lengths.


