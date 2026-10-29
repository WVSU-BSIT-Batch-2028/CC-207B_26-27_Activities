# CICT Org Fair — Unit 6

## Part 2 — Explanations

### E1. Why membership state belongs in HomeShell

HomeShell keeps the joined organizations because the organization list, My Orgs, and Schedule all need the same information. If each screen kept its own copy, one screen could show a membership that the others do not know about. Keeping the map in their common parent lets the screens share it, and `setState` updates the badge and pages whenever an organization is joined or left.

Code reference: `lib/screens/home_shell.dart`, lines 25, 30, and 39–50.

### E2. How IndexedStack preserves search text

`IndexedStack` shows one page at a time but keeps the other pages mounted. This means the search controller and query are still there when the user leaves the Orgs tab and comes back. If the body used only `pages[_index]`, switching to another screen would remove `OrgListScreen`, so its search text would be lost when it is created again.

Code reference: `lib/screens/home_shell.dart`, line 60; `lib/screens/org_list_screen.dart`, lines 34–35.

### E3. Why the drawer closes before opening About

The drawer is closed with `Navigator.pop(context)` before the About screen opens through `Navigator.pushNamed`. Otherwise, the drawer can stay open underneath the new screen. Closing it first means that pressing Back from About returns to the organization list with the drawer already shut.

Code reference: `lib/screens/org_list_screen.dart`, lines 136–137.

### E4. Why Wrap is used for the category chips

`Wrap` moves a chip to the next line when it no longer fits beside the others. This is useful on a small screen, as shown by the Service chip appearing on a second line in the phone screenshot. A plain `Row` keeps all the chips on one line, so they could overflow when the screen is too narrow.

Code reference: `lib/screens/org_list_screen.dart`, lines 260–270.

### E5. How the grid determines its columns

The grid works out the number of columns from the available width, using `maxCrossAxisExtent: 200`, 8-pixel gaps, and 8-pixel padding on both sides. On a 360-pixel screen, 344 pixels remain after padding, so `ceil(344 / 208)` gives 2 columns and each tile is `(344 - 8) / 2 = 168` pixels wide. On a 1000-pixel screen, 984 pixels remain, so `ceil(984 / 208)` gives 5 columns and each tile is `(984 - 32) / 5 = 190.4` pixels wide. The 800-pixel screenshot shows four columns, with tiles about 190 pixels wide.

Code reference: `lib/screens/org_list_screen.dart`, lines 291 and 299–303.

### E6. What must match in the tab widgets

The controller length, number of tabs, and number of pages must all be the same. This app uses three: About, Officers, and Events, with the pages arranged in that same order. If the counts do not match, Flutter reports an assertion error; if the order is wrong, a tab can show the wrong content.

Code reference: `lib/screens/org_detail_screen.dart`, lines 36, 42–44, and 50–52.

### E7. Why the dialog result is nullable

The result is `bool?` because the user can close the dialog without pressing either button, which returns null. Cancel returns false, and Leave returns true. Checking `confirmed == true` makes sure the organization is removed only after the user chooses Leave, while cancelling or dismissing the dialog keeps the membership.

Code reference: `lib/screens/my_orgs_screen.dart`, lines 29, 35, 39, and 45.

### E8. Why the schedule uses a Table

A `Table` keeps the Time, Booth, and Org columns lined up across the whole schedule. The Time column is 96 pixels wide, Booth is 72 pixels, and Org uses the remaining space. With separate `Row`s, each row could give its cells different widths, so extra sizing would be needed to keep the columns aligned.

Code reference: `lib/screens/schedule_screen.dart`, lines 53–59.

## Part II — CICT Org Fair Code Analysis

| No. | Where | Question | Answer |
| --- | --- | --- | --- |
| E1 | `main.dart` | Why is OrgFairApp stateless but OrgListScreen stateful? | OrgFairApp only sets up the app, theme, and routes, so it does not need its own changing state. OrgListScreen needs state because the user can search, select categories, mark favorites, hide organizations, switch views, and reload the data. |
| E2 | `org_list_screen.dart`: `dispose()` | Why must controllers be disposed? | The search controller is no longer needed when its screen's State is permanently removed. Calling `dispose()` releases its resources and clears its listeners. This helps avoid keeping unused resources in memory. |
| E3 | `org_list_screen.dart`: `FutureBuilder` | What is the order of states when Try again is pressed? | Try again starts a new request through `_reload`. The screen changes from the error message to loading, then shows the list, an empty message, or another error. The future moves through waiting and done; a temporary none state may also appear when the old future is replaced. |
| E4 | `org_list_screen.dart`: `_buildOrgs` | How does the list update while the user types? | Each time the user types, `onChanged` saves the new text in `_query` and calls `setState`. The screen then filters the organization names and acronyms and shows the matches. The search ignores letter case and still follows the selected categories and hidden organizations. |
| E5 | `org_list_screen.dart`: `Expanded` | How do constraints go down and sizes go up? | The parent tells its children how much space they can use, and the children report their sizes back. After the search box and chips take their space, `Expanded` gives the list or grid the height that is left. The results can then scroll inside that area instead of growing beyond the screen. |
| E6 | `org_card.dart` | Where does the favorite star's state live? | The favorite state is stored in `_favoriteIds` in OrgListScreen. A long press adds or removes the organization's ID and calls `setState`. OrgCard and OrgTile receive `isFavorite` from the parent, and their icons simply show whether the organization is a favorite. |
| E7 | `org_list_screen.dart`: `_openDetail` | How does data come back from another screen? | The first screen awaits `Navigator.push`, and the opened screen sends a result back through `Navigator.pop`. Here, the join form returns a Registration, which the detail screen passes back to the list. The list wraps it in a Membership and sends it to HomeShell using `widget.onJoined`. |
| E8 | `org_banner.dart` | How do null safety, `loadingBuilder`, and `errorBuilder` work? | Some organizations have no banner URL, so the app checks for null and shows a groups placeholder instead. If a URL is available, `Image.network` loads it and `loadingBuilder` shows a progress indicator while it loads. If the request fails, `errorBuilder` shows the broken-image placeholder. |
| E9 | `org_detail_screen.dart`: `_join` | Why check `context.mounted` after `await`? | The user might leave the screen while the app is waiting for a result. Checking `context.mounted` makes sure the screen's context is still valid before using it to navigate. If it is no longer mounted, the app skips that action. |
| E10 | `join_form_screen.dart`: `_formKey` | What does `GlobalKey<FormState>` provide? | The key lets the screen access the FormState through `currentState`. It uses `validate()` to check the answers and `save()` to run each field's `onSaved` callback. It also uses `reset()` to return the fields to their initial values. |
| E11 | `join_form_screen.dart`: `autovalidateMode` | When should validation errors appear? | Errors are hidden when the form first opens. With `onUserInteraction` set on the Form, changing a field can trigger validation for the form, including fields that have not been touched yet. Pressing Submit also checks all fields with `validate()` before saving. |

## Widget identification

| Feature | Widget(s) used | Stateless or stateful? Why? |
| --- | --- | --- |
| Organization list or grid | `ListView.builder`; `GridView.builder`; `OrgListScreen` | `ListView` and `GridView` are stateless, while their internal scrollable widgets keep scrolling state. `OrgListScreen` is stateful because it stores the search, filters, favorites, and selected view. |
| Favorite star | `Icon` inside `OrgCard` or `OrgTile` | The `Icon`, `OrgCard`, and `OrgTile` are stateless. The parent stores the favorite selection and passes it down through `isFavorite`, so the star only displays the current value. |
| Banner image | `OrgBanner`; `Image.network` | `OrgBanner` is stateless, but `Image` is stateful because it handles image loading and updates. `OrgBanner` chooses whether to display the image or a placeholder. |
| Submit button | `FilledButton` | `FilledButton` is stateful through `ButtonStyleButton`, so it can handle interactions such as focus and pressing. The parent uses `_agreed` to enable or disable it, while `FormState` handles validation and saving. |
