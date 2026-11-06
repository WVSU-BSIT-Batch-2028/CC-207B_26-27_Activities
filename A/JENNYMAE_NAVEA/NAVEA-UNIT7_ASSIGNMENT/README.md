# CICT Org Fair App - Unit 7, Part 3

This Flutter app displays fair events from a CMS, with built-in sample events
when no CMS is configured. The event screens use the shared `FairEvent` model
and `EventSource` interface, so the UI does not depend on a particular CMS.

## Explanation answers

### E1 - Switching CMS sources

To switch CMS providers, select or construct the other `EventSource`
implementation in `config.dart` and supply that provider's configuration. The
screens and repository can stay the same because each source implements
`fetchEvents()` and returns a `List<FairEvent>`. Provider-specific URLs,
authentication, and JSON parsing belong in the source implementation.

### E2 - Are `--dart-define` values secret?

No. Values supplied with `--dart-define` are compiled into the app and can be
extracted from a distributed mobile or web app. Only use a public, read-only
token that is safe for every user to see, and restrict it to the minimum
permissions needed to read published events. Never include an administrator,
write-enabled, or otherwise privileged secret. For private data or privileged
access, make requests through a secure backend that keeps the secret off the
client.

### E3 - What changes between CMS sources?

Each source has the same overall job—make a GET request, pass its response to
the shared `getJson()` helper, and turn the returned JSON into
`FairEvent` objects. The URL, query format, and authorization headers differ
by provider. The JSON parsing differs most because each CMS wraps and names
data differently: for example, Contentful puts entries under `items` and
fields under `fields`, Strapi returns `data`, and Sanity returns `result`.
Their event IDs also use different keys. The sources normalize these different
responses into the same app model so the UI does not need CMS-specific logic.

### E4 - Who should fix HTTP errors?

- **401 or 403:** The request was not authorized. Check the configured token
  and whether it has permission to read the content; whoever manages the CMS
  credentials and permissions needs to correct them.
- **404:** The requested URL, endpoint, or content type was not found. Check
  the app's CMS URL and content type/API ID; this is usually a configuration
  or developer fix.
- **500 or higher:** The server reported a problem. The CMS service may need
  attention; retry later or contact the CMS administrator/provider.

### E5 - Is the saved offline copy a bug or a feature?

Showing the last successful event list when a later request fails is an
offline feature: it keeps useful information available and identifies it as
saved data. The copy is only held in memory, though, so it is lost when the
app process closes. On a fresh launch without internet, there is no saved
copy until events have loaded successfully again. Persistent offline storage
would be needed to keep it across launches.

### E6 - Why keep the future out of `build()`?

`build()` can run many times in response to state changes, parent rebuilds, or
layout updates. Creating `repository.load()` there can start another request
on each rebuild. Instead, the screen stores the future in `initState()` and
replaces it only when the user refreshes. The `FutureBuilder` then observes
that stable future rather than repeatedly starting loads.

### E7 - Why does refresh await the request?

`RefreshIndicator` hides its spinner when the future returned by `onRefresh`
completes. If `_refresh()` returned before the CMS request finished, the
spinner would disappear while the old events were still shown and the update
was still in progress. Awaiting the load keeps the refresh indicator active
until the request succeeds or fails.

### E8 - What does `Z` mean in an event time?

The `Z` suffix means the timestamp is in UTC. `2026-11-08T05:00:00.000Z` is
05:00 UTC, which is 1:00 PM in Iloilo (Philippine time, UTC+8). Calling
`toLocal()` converts the instant to the device's local time before formatting
it, so a student in Iloilo sees the event at 1:00 PM instead of 5:00 AM.
