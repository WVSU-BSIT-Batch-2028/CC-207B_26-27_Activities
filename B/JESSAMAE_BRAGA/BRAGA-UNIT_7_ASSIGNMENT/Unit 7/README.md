# org_fair

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


EXPLAIN:

EXPLAIN E1: The screens only know this interface. They never import strapi_source.dart or contentful_source.dart. What would you have to change to move the app from one CMS to another, and what would stay the same? 

Answer:
	I would change the CMS source implementation, including its API URL, authentication, and JSON parsing. What would stay the same are the parts of the application that are independent of the CMS provider, such as the UI screens, EventSource interface, and FairEvent model.


EXPLAIN E2: These values are put into the app when it is built. Is CMS_TOKEN a secret once the app is on someone's phone or on the web? What kind of token is safe to put here, and what kind never is? 

Answer:
	The CMS_TOKEN is not completely secret once the application is built because someone could potentially extract it from the mobile app or web application. The safe token to use is a read-only Content Delivery API (CDA) token because it only allows access to published content. The token that should never be included is the Content Management API (CMA) token because it has permissions to create, edit, and manage content. 


EXPLAIN E3: Why do different CMS providers need different request configurations and JSON parsing? 

Answer:
	Different CMS providers need different request configurations and JSON parsing because they have different setups, API URLs, authentication methods, and JSON structures. They may also organize their content using different fields and content types. For example, Strapi and Sanity have their own content structures and configurations, while Contentful uses its own content types and fields. Therefore, each CMS needs its own implementation to retrieve and process data correctly. 


EXPLAIN E4: 401, 404 and 500 are all "errors", but who has to fix each one: the user, you (the developer), or the people running the CMS? 

Answer:
The person responsible for fixing errors depends on the type of error. A 401 Unauthorized error means the token is invalid or missing and should be fixed by the developer. A 404 Not Found error means the requested resource cannot be found because of an incorrect URL or content type. It can be fixed by the user if they entered the wrong URL, or by the developer if the API URL or content type is incorrectly configured. A 500 Internal Server Error means the server encountered an unexpected problem and should be fixed by the people running the CMS.

EXPLAIN E5: Offline, the app shows the events it loaded earlier, with a banner. Is that a bug or a feature? This copy lives in memory only: what happens if the user closes the app and opens it again with no internet? 

Answer: 
	It is a feature because the developer programmed the application to keep the last successfully loaded events in memory. This allows users to continue viewing previously loaded events even when they lose their internet connection. However, if the user closes the application and opens it again without the internet, the cached events will be lost because they are only stored in memory. The app may then display an error or an empty event list. 


EXPLAIN E6: The request starts in initState, and again only in _refresh. Why not write future: widget.repository.load() inside build()? How many requests would the app send, and when? 

Answer:
 	We should not put widget.repository.load() directly inside build() because Flutter can rebuild the screen multiple times. This means it could also send requests to the CMS multiple times, causing unnecessary data usage and network requests. Calling it inside initState() allows the application to load the events once when the screen is first opened. Another request is sent only when the user manually refreshes. 


EXPLAIN E7: RefreshIndicator calls onRefresh and hides its spinner when the Future it gets back completes. What would the user see if _refresh returned right away, before the CMS answered? 

Answer:
The user would still see the current screen and might assume that refreshing has already finished, even though the CMS has not yet responded. The refresh spinner would disappear too early, which could confuse the user and cause them to refresh again, resulting in unnecessary network requests. Using await ensures that the refresh spinner stays visible until the CMS request finishes. 


EXPLAIN E8: The CMS sends "2026-11-08T05:00:00.000Z". What does the Z mean, and why do we call toLocal() before showing the time? What would a student in Iloilo see without it?

Answer:
	Z means Zulu time and represents Coordinated Universal Time (UTC). We call .toLocal() before displaying the time to convert it to the user's local time zone. Without it, a student in Iloilo would see the time in UTC, which may not match the local time zone. For example, 5:00 AM UTC would appear as 1:00 PM in the Philippines. 
