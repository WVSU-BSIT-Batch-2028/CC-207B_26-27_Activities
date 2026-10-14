# Unit 5 Assignment - Code Analysis

## CICT Org Fair Code Analysis

### E1 - Why is `OrgFairApp` stateless but `OrgListScreen` stateful?

`OrgFairApp` only builds the app shell, theme, and first screen from values passed to it. It has no values that change while it is open, so a `StatelessWidget` is enough. `OrgListScreen` owns changing values such as the fetch `Future`, search query, hidden organization IDs, favorites, and registrations. It must be a `StatefulWidget` so `setState()` can rebuild the interface when those values change.

### E2 - Why dispose the search controller?

`TextEditingController` owns resources and listeners used by the text field. Calling `dispose()` when the screen is removed releases them and prevents leaks or callbacks being sent to a screen that no longer exists. Without disposal, repeatedly opening and closing the screen could leave unused controllers in memory.

### E3 - What happens after Try again while the server is in error mode?

`_reload()` assigns a new fetch `Future` inside `setState()`. The `FutureBuilder` first builds its loading state while that future is pending. When the future completes with an exception, it rebuilds with the error state and shows the error text and Try again button. Pressing Try again repeats the same loading-then-error sequence until the server mode changes.

### E4 - How does the list update while the user types?

The search field's `onChanged` callback stores the new text in `_query` inside `setState()`. That schedules a rebuild. `_buildOrgs` then filters the organizations using the latest query and displays the matching list or grid.

### E5 - Why does removing `Expanded` cause a layout error?

The `Column` must divide its vertical space between the search box and the scrolling list. `Expanded` gives the list a finite height equal to the remaining space. Without it, the `Column` gives the non-flex child an unbounded vertical constraint, while a `ListView` or `GridView` needs a bounded viewport height. Flutter reports an unbounded-height viewport/layout error. Constraints go down from parents to children; sizes go back up from children to parents.

### E6 - Where does the favorite star's state live?

The favorite state lives in the parent screen's `_favoriteIds` set. Long-pressing a card calls the parent's `onLongPress` callback, which changes that set inside `setState()`. The parent rebuilds `OrgCard` and passes the updated `isFavorite` value, so the stateless card displays the filled or outlined star.

### E7 - How does data come back from another screen?

`Navigator.push<Registration>()` returns a `Future<Registration?>`. The form completes that future by calling `Navigator.of(context).pop(registration)`. The detail screen receives the value and pops it again with `Navigator.of(context).pop(registration)`, completing the list screen's future. The list then saves it in `_registrations` and rebuilds the card as joined.

### E8 - How do null safety and the image builders work?

`bannerUrl` is nullable (`String?`). `OrgBanner` checks whether it is `null` before passing it to `Image.network`; when absent, it shows the groups placeholder. The `loadingBuilder` shows a progress indicator while the download is in progress and returns the image child when loading finishes. The `errorBuilder` shows a broken-image placeholder if the download fails. After the null check, Dart promotes the local `url` value to non-null `String`.

### E9 - Why check `context.mounted` after `await`?

While the form route is open, the detail screen could be removed from the widget tree. After the asynchronous navigation returns, its `BuildContext` may no longer be valid. Checking `context.mounted` ensures the screen still exists before using the context to pop the route.

### E10 - What does `GlobalKey<FormState>` provide?

It gives the state object access to the specific `Form` and its descendant fields. The form key lets `_submit()` call `validate()` to run validators and report whether the fields are valid, `save()` to run each field's `onSaved` callback, and `reset()` to restore the form fields to their initial values.

### E11 - When should validation errors appear?

`AutovalidateMode.onUserInteraction` begins showing validation feedback after the user interacts with a field. This avoids presenting a screen full of errors before the student has had a chance to enter anything, while still giving immediate guidance during form completion. `always` validates from the start and can make untouched fields look invalid immediately.

## Widget and state table

| Feature | Widget(s) used | Stateless or stateful? Why? |
|---|---|---|
| Organization list or grid | `OrgListScreen`, `ListView.builder`, `GridView.builder` | `OrgListScreen` is stateful because it owns the loaded future, search, favorites, hidden IDs, and registrations. The list and grid widgets are rebuilt from that state. |
| Favorite star | `OrgCard` and `Icon` | `OrgCard` is stateless. The parent owns favorite state and passes `isFavorite` to it after each rebuild. |
| Banner image | `OrgBanner`, `Image.network` | `OrgBanner` is stateless because it only displays the `Org` passed in. `Image.network` manages its own loading and error behavior through its builders. |
| Submit button | `FilledButton` in `JoinFormScreen` | The button is configured declaratively from the stateful form. Its `onPressed` is `null` until `_agreed` is true, then it calls `_submit`. |
