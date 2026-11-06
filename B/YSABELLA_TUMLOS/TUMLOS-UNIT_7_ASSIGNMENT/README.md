## Explanations (E1 to E8)

**E1**
Only the CMS source class and its settings change: I pick a different class (Strapi, Contentful or Sanity) and put that CMS's keys in `cms.json`. The screens, `FairEvent`, the repository and the event tile stay the same, because they only talk to the `EventSource` interface and never import a specific CMS file.

**E2**
No. The values are compiled into the app, so anyone can pull them out of a phone app or see them in the browser's network tab once it is on the web. Only a read-only token that can read published content, like Contentful's Content Delivery token, is safe to put here. A management/write token, a preview token (it shows drafts) or any secret key must never go in the app.

**E3**
The same lines: calling `getJson(client, uri, cms: name, headers: headers)`, building a `Uri`, and returning a `List<FairEvent>`. The different lines are the URL and query, the auth header, and the parsing. Contentful reads `items[].fields` with the id in `sys.id`, Strapi reads `data[]` with `documentId`, and Sanity reads `result[]` with `_id`. Parsing changes the most because the HTTP call is the same everywhere, but each CMS chooses its own JSON shape.

**E4**
A 401 (or 403) is the developer: a wrong token or missing read permission. A 404 is also mine: a wrong URL, space ID or content type name. A 500 is the CMS provider's problem, since their server failed. The user can only retry, and the user only fixes things when they have no connection.

**E5**
It is a feature. If the connection drops, the student still sees the last events with a banner instead of an empty screen. But the copy lives in memory only, so if the user closes the app and opens it again with no internet, nothing is saved and the app shows the "No connection" error screen.

**E6**
`build()` runs again every time the widget rebuilds (setState, rotating the screen, theme changes, and so on). Calling `load()` would send a new request on every rebuild and reset the list to loading each time. Starting it in `initState` sends one request when the screen opens, and one more only when the user refreshes or taps Retry.

**E7**
`RefreshIndicator` hides its spinner when the Future completes. If `_refresh` returned right away, the spinner would vanish instantly while the request was still running, so the user would think nothing happened and the list would change later without warning.

**E8**
The Z means UTC (a zero offset from universal time). `toLocal()` converts that time to the device's own time zone. Iloilo is UTC+8, so `05:00Z` shows as 1:00 PM. Without `toLocal()`, a student in Iloilo would see 5:00 AM, which is 8 hours wrong.