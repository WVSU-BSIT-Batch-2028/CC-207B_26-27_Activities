# Unit 6 Assignment: CICT Org Fair Part 2

Name: Gracer Ann Escalada
Gr.Sec.: BSIT 3A SDT

E1: Lifting state up (home_shell.dart,line 25 `_memberships`)
There are 4 parts that needs to know which orgs I joined: the Orgs list, My Orgs, the
Schedule and the badge on the navbar. Those screens are all side by side, so
they can't see each other's content. That's why the map sits in `HomeShell`, their
parent. It shares the data downward, and the screens report changes back
through `onJoined` and `onLeave`.

E2: IndexedStack (home_shell.dart,line 60 `body`)
`IndexedStack` keeps all three pages on or alive and just shows the one I
selected. So the Orgs screen is never dissapear when I switch tabs, and the
text I typed in the search box is still there when I come back. With
`pages[_index]` the old page gets pushed away, and the text goes with it.

E3: Closing the drawer first (org_list_screen.dart, line 136)
The drawer sits on top of the screen as its own. If I open 'About the org fair'
without closing it, the drawer underneath will still be open, so pressing back
shows the drawer again. Calling `Navigator.pop(context)` first closes it, so
back goes straight to the Orgs screen.

E4: Wrap or Row (org_list_screen.dart, line 260)
When the chips don't fit on one line, `Wrap` moves the extra ones to the next
line, like how wrapping usually works. A `Row` can't do that, so the chips run 
off the edge of the screen and Flutter shows the yellow and black overflow stripes. 
I used `Wrap` so it works on any screen width making it responsive too.

E5: maxCrossAxisExtent math (org_list_screen.dart, line 300, `_buildGrid`)
`maxCrossAxisExtent: 200` means a tile can be at most 200 wide, so Flutter
adds columns until that's true. On a 360 phone the grid area is 344 wide, so
it needs 2 columns, and each tile is about 168 wide. On a 1000 wide window the
area is 984, so it uses 5 columns of about 190 each. The columns grow with
the screen, but the tiles never go over 200.

E6: Tab counts (org_detail_screen.dart, line 32)
3 numbers have to match: the `length` in `DefaultTabController`, the
number of `Tab`s in the `TabBar` and the number of children in the
`TabBarView`. All three are 3 in my code, in the same order (About, Officers,
Events). If one is different, Flutter gives an error that the controller
length doesn't match the tabs.

E7: bool? and == true (my_orgs_screen.dart, line 29, `_confirmLeave`)
The dialog returns `bool?` because the user can close it without pressing
either button, like tapping outside it or pressing back, and that gives `null`.
`if (confirmed)` won't work on a nullable value, so I check
`confirmed == true`. That's only true when they pressed Leave, and false or
null both mean they stay in the org.

E8: Table vs Column of Rows (schedule_screen.dart, line 51)
A `Table` sets each column's width once for all the rows, so Time, Booth and
Org line up correctlt. If I used a `Column` of `Row`s, every row would size
itself, and the columns would end up bad when the text lengths
differ. The `Table` also gave me decorations on the row, which I used to highlight
the orgs I joined.