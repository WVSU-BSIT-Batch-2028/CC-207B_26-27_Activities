# org_fair

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

E1 - I only need to change the EventSource implementation and its setup when I move the app to another CMS. The screens and repository can stay the same because they use the shared EventSource interface.

E2 - I understand that values added with dart define are included in the built app. This means CMS TOKEN is not a secret after the app is installed or published. I should only use a token that is safe to expose such as a read only public token. I must never place an admin token or a token with write access in the app.

E3 - The request URL and the JSON parsing differ between CMS platforms. The shared parts are calling getJson and returning a List of FairEvent objects. Parsing changes the most because each CMS uses a different JSON structure and different field names.

E4 - I see that a 401 or 403 usually means I need to check the token or its permissions. A 404 means the URL or content type name may be wrong. A 5xx response is a problem on the CMS side so I should try again later. This helps me know who can fix the problem.

E5 - I see the saved copy as a useful offline feature because it lets users keep viewing events when the internet is unavailable. The copy only lives in memory so it is lost when the app closes. The app would need local storage to show it after being opened again.

E6 - I should not call load inside build because build can run many times. That would send repeated requests and waste network resources. Starting the request in initState and refresh keeps each request under the control of the screen.

E7 - RefreshIndicator hides its spinner when the Future returned by onRefresh completes. If _refresh returned immediately the spinner would disappear before the CMS finished responding. Awaiting the load keeps the spinner visible until the refresh is complete.

E8 - The Z means the time is in UTC. I call toLocal so Flutter converts it to the phone's local time zone before displaying it. This lets a student in Iloilo see the correct local time instead of a UTC time.
