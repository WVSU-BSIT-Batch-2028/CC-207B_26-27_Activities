# Unit 7 – Written Answers and Submission Checklist

## Written explanations

**E1 – Changing the CMS**

To move the application from one CMS to another, I would change the CMS-specific event source and its configuration, including the API endpoint, authentication, request parameters, and JSON-to-`FairEvent` mapping. The `EventSource` interface, `EventRepository`, event model, and application screens can stay the same because they use the common `fetchEvents()` interface.

**E2 – Token security**

A value passed with `String.fromEnvironment()` is compiled into the application and can potentially be extracted from a distributed app. A read-only Content Delivery API token can be used for publicly accessible event content, but it should not be treated as a secret. A Content Management API token or any token that permits creating, editing, or deleting CMS content must never be embedded in the client app. Access to private content or privileged CMS operations should go through a secured backend.

**E3 – Comparing CMS sources**

The URL, query parameters, authentication requirements, and JSON parsing differ between CMS providers. The shared HTTP helper (`getJson`) and common `FairEvent` model remain the same. Parsing differs most because each CMS returns a different JSON structure: Contentful nests values under `items`, `sys`, and `fields`; Strapi returns a flat list under `data`; and Sanity returns documents under `result` using `_id` for the document ID.

**E4 – HTTP errors**

A 401 or 403 response means the request was refused, so the token and read permissions should be checked by the developer or CMS administrator. A 404 means the endpoint URL or content type/API path should be checked by the developer. A 500-or-higher response indicates a server-side CMS problem, so the user can try again later. Other unexpected status codes are reported with the status number.

**E5 – Offline caching**

Showing the last successfully loaded events when the connection drops is a useful feature because students can still see previously retrieved information. This implementation keeps the saved copy in memory only. Closing or restarting the app clears it, so it will not be available after a restart without internet. Persistent local storage would be needed for that behavior.

**E6 – Keeping the Future out of `build()`**

The event-loading Future is created in `initState()` and stored in `_future`. Creating `repository.load()` directly inside `build()` could start another network request every time Flutter rebuilds the screen, including rebuilds caused by unrelated state changes. Keeping the Future in state prevents unnecessary repeated requests. Refresh explicitly creates a new Future.

**E7 – Waiting for refresh**

`RefreshIndicator` hides its progress indicator when the Future returned by `onRefresh` completes. If `_refresh()` returned before the CMS request finished, the spinner would disappear while the app was still waiting for updated events. Awaiting the load keeps the refresh indicator active until the request completes.

**E8 – UTC and local time**

The `Z` suffix means the timestamp is in UTC. The app calls `toLocal()` before formatting the event time so students see it in their device's time zone. For example, `2026-11-08T05:00:00Z` is 1:00 PM in the Philippines (UTC+8). Showing the UTC hour without converting it would display 5:00 AM instead.

## Final submission checklist

- [ ] Merge the updated `lib/` and `test/` folders into the original Flutter project.
- [ ] Keep the original `pubspec.yaml` and run `flutter pub get`.
- [ ] Run `flutter test` and confirm all tests pass.
- [ ] Create the `fairEvent` content type with the field IDs `title`, `orgId`, `startsAt`, `venue`, `description`, and `cancelled`.
- [ ] Publish at least 8 events belonging to at least 4 organizations.
- [ ] Make one of the published events cancelled.
- [ ] Create one additional draft and leave it unpublished.
- [ ] Run the app with the live CMS configuration.
- [ ] Capture screenshots for What's On, the offline saved-copy banner, an organization's filtered Events tab, and proof that the unpublished draft is not displayed.
- [ ] Check screenshots for exposed API tokens before submitting.
