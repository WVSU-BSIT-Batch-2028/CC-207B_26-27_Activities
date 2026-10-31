# CICT Org Fair App – Part 2 (Unit 6 Assignment)

Name: Justin Ace Ardena
Section: BSIT 3A-CBS

## EXPLAIN answers (E1 to E8)

**E1 – `home_shell.dart`, `_memberships` (line 25)**
Three screens need to know which orgs I joined: the Orgs list, My Orgs, and Schedule. Screens that sit side by side cannot see each other's data. So I keep the joined orgs in `HomeShell`, their parent, and pass the data down to them. This is called "lifting state up".

**E2 – `home_shell.dart`, `IndexedStack` (line 60)**
`IndexedStack` keeps all three pages alive and only shows the one I picked. Because the Orgs page is never thrown away, the text I typed in the search box is still there when I come back. With `pages[_index]`, the old page is destroyed when I switch tabs, so the search text is gone (Experiment C1).

**E3 – `org_list_screen.dart`, drawer `onTap` (lines 136-137)**
`Navigator.pop(context)` closes the drawer first, and then `pushNamed` opens the About screen. If I skip the pop, the drawer stays open underneath. When I press Back from About, I see the drawer still open (Experiment C4).

**E4 – `org_list_screen.dart`, `Wrap` (line 260)**
When the chips don't fit on one line, `Wrap` moves the extra chips to the next line, so all of them stay visible. A `Row` cannot do that. It keeps everything on one line, and the extra chips go off the screen with a yellow-black "overflowed" warning (Experiment C2).

**E5 – `org_list_screen.dart`, `_buildGrid` (lines 292-303)**
`maxCrossAxisExtent: 200` means a tile can be at most 200 wide, so Flutter fits as many columns as it can. The formula is `columns = ceil((width + 8) / (200 + 8))`.
- Phone, 360 wide: usable width is 344 (after 8 padding on each side), so `ceil(352 / 208) = 2` columns, each `(344 - 8) / 2 = 168` wide.
- Window, 1000 wide: usable width is 984, so `ceil(992 / 208) = 5` columns, each `(984 - 4 x 8) / 5 = 190.4` wide (Experiment C5).
- (I had helped with AI for the calculations.)

**E6 – `org_detail_screen.dart`, `DefaultTabController` (lines 32-52)**
Three things must match: the `length` in `DefaultTabController`, the number of `Tab`s in the `TabBar`, and the number of children in the `TabBarView`. Here all three are 3 (About, Officers, Events), in the same order. If they don't match, the app crashes with an error and shows a red screen (Experiment C3).

**E7 – `my_orgs_screen.dart`, `_confirmLeave` (lines 24-46)**
The dialog gives back `bool?`, which means it can be `true`, `false`, or `null`. It is `null` when I close the dialog without pressing a button, such as tapping outside it. Writing `confirmed == true` makes sure only a real tap on "Leave" removes the org. Cancel (`false`) and closing the dialog (`null`) both do nothing.

**E8 – `schedule_screen.dart`, `Table` (line 53)**
A `Table` gives every row the same column widths, so Time, Booth, and Org line up in neat straight columns. If I used a `Column` of `Row`s, each row would size itself to its own text (like "8:00 AM" vs "10:00 AM"), and the columns would not line up. `Table` also gives me borders and lets me color a whole row (TODO 13).

## What I did for each TODO

| # | File | What I did |
|---|------|------------|
| 1 | home_shell | Used `IndexedStack` so every page stays alive |
| 2 | home_shell | Tapping a tab calls `setState` to switch pages |
| 3 | home_shell | Added a `Badge` on My Orgs showing the count, hidden at 0 |
| 4 | home_shell | `_join` saves the membership using `setState` |
| 5 | org_list_screen | Sends the new membership up with `widget.onJoined` |
| 6 | org_list_screen | Drawer closes, then opens About by its route name |
| 7 | org_list_screen | Chip tap adds or removes the category with `setState` |
| 8 | org_list_screen | Shows only the chosen categories (all when none chosen) |
| 9 | org_list_screen | Grid columns now depend on screen width (`maxCrossAxisExtent`) |
| 10 | org_detail_screen | Added the Officers tab (length 3) |
| 11 | org_detail_screen | Officers shown in a `ListView.separated` with dividers |
| 12 | my_orgs_screen | Asks "Leave?" with a dialog before removing an org |
| 13 | schedule_screen | Joined orgs' rows are highlighted with a `BoxDecoration` |