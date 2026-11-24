# CICT Org Fair 3 - Unit 7 Assignment

**Student Name:** Vincent John A. Tamaño  
**Course & Section:** BSIT 3A CBS  
**Assigned Folder:** `A/VINCENTJOHN_TAMAÑO/TAMAÑO-UNIT_7_ASSIGNMENT`

---

## Part A: CMS Selection Questions (Page 2)

### Chosen CMS: **Contentful** (Headless, hosted SaaS) / **Strapi** (Headless, self-hosted)

1. **Who will edit your content?**  
   Organization officers and fair coordinators. Content editors access the web-based CMS admin dashboard (e.g. Contentful App or Strapi Admin Panel) to draft, publish, reschedule, or cancel events without needing developer access or code deployments.

2. **Do you have a server?**  
   If using **Contentful**: No dedicated server is needed; Contentful is a fully hosted cloud SaaS providing high-availability global CDN endpoints out of the box.  
   If using **Strapi**: Yes, Strapi runs on a Node.js server (locally on `http://localhost:1337` during development or hosted on cloud platforms like Strapi Cloud/Render/Railway for production).

3. **Is there already a website?**  
   No existing website is required. The headless CMS operates purely via decoupled REST/GraphQL APIs, allowing our Flutter mobile and web client to fetch and render raw JSON content directly.

4. **Do users create data?**  
   No, regular students and attendees only consume read-only event data. Only authenticated org officers and administrators with CMS login credentials create, update, and publish data.

---

## Part B: Content Model

- **Content Type Name:** `fairEvent` (API Identifier) / `Fair Event`
- **Fields:**
  - `title`: Short text (`string`) — e.g., "Hour of Code"
  - `orgId`: Short text (`string`) — e.g., "csc"
  - `startsAt`: Date and time (`datetime`) — e.g., `2026-11-08T05:00:00.000Z` (1:00 PM PHT)
  - `venue`: Short text (`string`) — e.g., "CICT Lab 2"
  - `description`: Long text (`text`) — e.g., "Your first program in one hour. No experience needed."
  - `cancelled`: Boolean (`boolean`) — e.g., `false`

---

## Part E: Code Explanations (E1 to E8)

### E1: Interface Abstraction (`lib/data/event_source.dart`, lines 8–11)
> **Question:** The screens only know this interface. They never import `strapi_source.dart` or `contentful_source.dart`. What would you have to change to move the app from one CMS to another, and what would stay the same?

**Answer:**  
To switch between CMS providers, you only need to change the factory instantiation in `lib/config.dart` (or pass different `--dart-define` flags such as `CMS=contentful` instead of `CMS=strapi`). All UI presentation screens (`EventsScreen`, `OrgDetailScreen`, `HomeShell`), widget components, repository caching logic, and data models remain 100% unchanged because they depend strictly on the abstract `EventSource` interface, following the Dependency Inversion Principle.

---

### E2: Build-time Variables & Security (`lib/config.dart`, lines 24–26)
> **Question:** These values are put into the app when it is built. Is `CMS_TOKEN` a secret once the app is on someone's phone or on the web? What kind of token is safe to put here, and what kind never is?

**Answer:**  
No, `CMS_TOKEN` is never a secret once compiled into a client binary or shipped in web JavaScript; anyone can reverse engineer the APK, inspect network traffic, or view browser source to extract it. Therefore, only **read-only, public client tokens** (such as Contentful's Content Delivery API token or Strapi public read permissions) are safe to bundle. **Administrative, write, or management tokens must never be embedded** in client applications because attackers could delete, tamper with, or compromise the entire database.

---

### E3: Parsing and Schema Variances Across CMSs (`lib/data/cms/strapi_source.dart`, lines 42–45)
> **Question:** Open one of the other two CMS files and compare. Which lines differ, and which are the same? Why is the parsing the part that changes most from one CMS to another?

**Answer:**  
The network dispatching via `getJson(client, uri, ...)` and returning a `List<FairEvent>` is identical across all CMS sources. The lines that differ are the URL path construction, query parameters, and JSON response parsing. Parsing differs because each headless CMS uses its own proprietary JSON envelope structure (Strapi wraps objects under `data` with `documentId`, Contentful wraps under `items` separating `sys.id` from `fields`, and Sanity GROQ returns a flat array under `result` with `_id`).

---

### E4: HTTP Status Codes & Error Responsibility (`lib/data/event_source.dart`, lines 54–56)
> **Question:** 401, 404 and 500 are all "errors", but who has to fix each one: the user, you (the developer), or the people running the CMS?

**Answer:**  
- **401 / 403 (Unauthorized / Forbidden):** Fixed by the developer or CMS administrator by supplying a valid API token or enabling public read permissions in CMS role settings.
- **404 (Not Found):** Fixed by the developer by correcting a typo in the API endpoint URL or verifying that the content type identifier matches the CMS schema.
- **500 (Internal Server Error):** Fixed by the CMS hosting provider or DevOps administrator, as it signifies a server-side crash, database outage, or backend service failure. The end-user only needs to try again later.

---

### E5: Offline Cache in Memory (`lib/data/event_repository.dart`, lines 22–25)
> **Question:** Offline, the app shows the events it loaded earlier, with a banner. Is that a bug or a feature? This copy lives in memory only: what happens if the user closes the app and opens it again with no internet?

**Answer:**  
Displaying previously loaded events when offline is a feature known as graceful degradation or stale-while-revalidate caching, ensuring users still have access to schedule information even during connectivity drops. However, because `_lastGood` is stored solely in volatile RAM, completely terminating and restarting the app while offline clears the memory cache; the app will have no saved events and will display the offline error message until an active connection is restored.

---

### E6: Request Lifecycle: `initState` vs. `build()` (`lib/screens/events_screen.dart`, lines 18–21)
> **Question:** The request starts in `initState`, and again only in `_refresh`. Why not write `future: widget.repository.load()` inside `build()`? How many requests would the app send, and when?

**Answer:**  
In Flutter, `build()` can execute dozens of times during a single user session whenever parent widgets update, animations tick, soft keyboards open, or theme/orientation changes occur. Calling `load()` inside `build()` would fire a redundant HTTP network request on every single frame rebuild, overwhelming the server and causing UI flickering. Initiating the future in `initState` guarantees it runs exactly once upon mounting, and only re-fetches when explicitly triggered by the user via `_refresh()`.

---

### E7: Asynchronous Refresh Indicators (`lib/screens/events_screen.dart`, lines 82–84)
> **Question:** `RefreshIndicator` calls `onRefresh` and hides its spinner when the Future it gets back completes. What would the user see if `_refresh` returned right away, before the CMS answered?

**Answer:**  
If `_refresh` did not `await` the network request, its returned Future would resolve immediately. The pull-to-refresh loading spinner would dismiss instantly before the server responded, giving the user the false impression that the refresh had finished or that no new data was available, even while background network latency was still ongoing.

---

### E8: Time Zones and UTC Conversion (`lib/widgets/event_tile.dart`, lines 14–17)
> **Question:** The CMS sends "2026-11-08T05:00:00.000Z". What does the Z mean, and why do we call `toLocal()` before showing the time? What would a student in Iloilo see without it?

**Answer:**  
The `Z` suffix denotes Zulu time (Coordinated Universal Time / UTC, zero offset). Calling `toLocal()` converts the UTC timestamp into the device's local timezone (UTC+8 in the Philippines). Without calling `toLocal()`, a student in Iloilo viewing an event scheduled for 1:00 PM local time (05:00 UTC) would erroneously see 5:00 AM on the tile.

---

## Verification & Testing Summary

- **`dart analyze`**: **`No issues found!`** (Zero warnings, zero linter errors).
- **`flutter test`**: **34/34 Tests Passed**:
  - `events_test.dart` (TODO 1, 4, 5, 6, 7, 8, 9, 10, 11): 100% Passed
  - `strapi_source_test.dart` (TODO 2, 3 Strapi): 100% Passed
  - `contentful_source_test.dart` (TODO 2, 3 Contentful): 100% Passed
  - `sanity_source_test.dart` (TODO 2, 3 Sanity): 100% Passed
  - `org_fair_test.dart` (Part 2 regression tests): 100% Passed

