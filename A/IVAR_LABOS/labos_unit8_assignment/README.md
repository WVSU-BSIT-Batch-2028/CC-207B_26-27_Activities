# CICT Org Fair App

**Live site:** https://YOUR-GITHUB-USERNAME.github.io/YOUR-REPOSITORY/

Releases: every push to `main` is tested, built and published to GitHub Pages
(`.github/workflows/deploy.yml`); every pull request is checked by
`.github/workflows/ci.yml`. Version 1.1.0 (build 2).

To run it, copy `cms.example.json` to `cms.json`, fill it in, then:
`flutter run --dart-define-from-file=cms.json`

---

# CICT Org Fair App (Part 3): Contentful CMS

## CMS used

**Contentful** (hosted headless CMS, free plan).

Content type: **Fair Event**, API identifier `fairEvent`

| Field ID | Type |
|---|---|
| `title` | Short text |
| `orgId` | Short text |
| `startsAt` | Date and time |
| `venue` | Short text |
| `description` | Long text |
| `cancelled` | Boolean |

## The 11 TODOs and how they work

### 1. `event_source.dart`: turn status codes into messages

After the server answers, a `switch` checks the status code.

- `200`: decode the JSON.
- `401` or `403`: the token or read permission is wrong.
- `404`: the URL or content type name is wrong.
- `500` and up: the CMS server has a problem.
- Anything else: a generic message.

Each error becomes a `CmsException` with a message people can read, so the app never shows raw codes.

### 2. `contentful_source.dart`: build the request

This builds the address `cdn.contentful.com/spaces/<space>/environments/master/entries` with three query parameters:

- `content_type=fairEvent` (only events)
- `order=fields.startsAt` (earliest first)
- `limit=100`

The token goes in the header `Authorization: Bearer <token>`, which proves the app may read.

### 3. `contentful_source.dart`: turn JSON into events

Contentful's answer has a list called `items`. For each item, the id comes from `sys.id` and everything else from `fields`. Each item becomes a `FairEvent`. Contentful leaves empty fields out of the JSON, so a missing `description` becomes `''` and a missing `cancelled` becomes `false`.

### 4. `event_repository.dart`: save every good load

When `fetchEvents()` succeeds, the list is stored in `_lastGood`. This keeps the latest working copy of the events in memory.

### 5. `event_repository.dart`: fall back to the saved copy

If a load fails, the code checks `_lastGood`. If a saved list exists, it returns it with `savedCopy: true`, so the screen knows the data is old. If nothing is saved, the error is passed on so the screen can show it.

### 6. `events_screen.dart`: `_refresh`

`_refresh` starts a new load and stores it in `_future` inside `setState`, so the screen rebuilds and shows the loading state. It then `await`s the result, which keeps the pull-to-refresh spinner visible until the data arrives. The `try/catch` does nothing on an error, because the `FutureBuilder` already shows it.

### 7. `events_screen.dart`: sort by date

The CMS can send events in any order. The code copies the list (`[...load.events]`) and sorts the copy by `startsAt`, earliest first. A copy is used so the original list is not changed.

### 8. `events_screen.dart`: offline banner

When `load.savedCopy` is true, a `MaterialBanner` appears at the top: "No connection. Showing the events saved earlier." Its Retry button calls `_refresh`. The `if` is inside the list, so the banner only exists when needed.

### 9. `event_tile.dart`: cancelled events

If `event.cancelled` is true, the tile changes in three ways:

- the title has a line through it
- a "Cancelled" chip appears on the right
- the icon becomes the red `event_busy` icon

Normal events keep the regular icon and no chip.

### 10. `org_detail_screen.dart`: this org's events only

In `initState`, the tab calls `loadForOrg(widget.orgId)`, which loads the events and keeps only those whose `orgId` matches the org. Doing it in `initState` means the request is sent once, not every time the tab rebuilds.

### 11. `home_shell.dart`: add the What's On tab

The `pages` list includes `EventsScreen`, and the `NavigationBar` has a matching "What's On" destination with the `event` icon. The two lists must be in the same order, because the selected index picks the page. `IndexedStack` keeps every page alive, so switching tabs does not reload them.