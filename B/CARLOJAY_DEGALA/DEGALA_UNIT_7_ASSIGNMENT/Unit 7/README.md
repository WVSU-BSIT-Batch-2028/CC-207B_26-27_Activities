# DEGALA - Unit 7 Assignment (CICT Org Fair Part 3)

CMS Used: Contentful

## E1 - E8 Answers

# E1

Only the configuration file (cms.json) to point to a different CMS provider or implement a new EventSource class if integrating an entirely new backend. The screens and repository never interact directly with individual CMS files, so they remain untouched. What would stay the same would be all the UI screens (events_screen.dart, org_detail_screen.dart), the models (fair_event.dart), repository caching logic (event_repository.dart), and UI widgets (event_tile.dart) stay 100% identical because they only depend on the generic EventSource interface.

# E2

Embedded tokens like CMS_TOKEN are no longer secret because they can be extracted via reverse engineering or network inspection. Only read-only public tokens, such as those used for fetching public content delivery data  are safe to include in client-side builds, while write, administrative, or management tokens must never be used since exposing them would risk backend data integrity and security.

# E3

Two CMS lines differ by their API endpoint URLs, query parameters, and authentication headers, while what stays the same were the high-level interface, error handling, and data models. Parsing is the part that changes most significantly across providers because each headless CMS structures its raw JSON response payloads uniquely.

# E4

401 would be the developer who has to fix it.  404 would also be the developer to fix it. For the one who will fix the error 500 would be the people who runs the CMS

# E5

It is a feature, instead of crashing or showing a completely blank error screen when the internet drops, the app preserves a smooth user experience by falling back to the last successfully loaded data. If the user reopens the app while still offline, _lastGood will be null, meaning the app cannot fall back to a saved copy and will instead display a network error or failure screen.

# E6

The build() method in Flutter can be triggered frequently. If a network call future is instantiated directly inside build(), every single UI rebuild would trigger a brand-new HTTP request. It will trigger an endless loop of requests every time the widget tree rebuilds, easily spamming the API and causing performance bottlenecks or infinite rebuild loops. 

# E7

The pull-to-refresh spinner at the top of the RefreshIndicator would instantly disappear the moment the user lets go of the screen, long before the network request actually finishes fetching data from the CMS. This would make the UI feel broken or unresponsive because the loading indicator would stop spinning while data is still loading in the background.

# E8
Z means Zulu time or another name for that is Coordinated Universal Time (UTC). We call toLocal before showing the time because the raw timestamp from the CMS is in UTC, calling toLocal() converts that absolute time into the local time zone configured on the user's phone or device, ensuring that event schedules display correctly based on where the user is physically located. Without toLocal(), an event scheduled locally for 1:00 PM (13:00) stored as 05:00:00Z in the CMS would incorrectly display as 5:00 AM instead of 1:00 PM
