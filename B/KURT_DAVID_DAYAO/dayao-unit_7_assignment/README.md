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



Explain E1-E8 answers:

E1
The screens use the EventSource interface, so switching CMS mainly changes configuration and the source implementation.

E2
Build-time tokens can be extracted from the app. Use a read-only delivery token for public event content; management credentials must stay outside the app.

E3
CMSs use different URLs and JSON structures, but each source converts its response into the same FairEvent model.

E4
Token/permission and URL problems usually require configuration fixes; server failures require action from the CMS operator.

E5
Showing saved events helps during a failed request, but they may be outdated and disappear after an app restart.

E6
Starting a request inside build() could send another request every time the widget rebuilds.

E7
Returning before the request finishes would hide the refresh indicator too early.

E8
Z means UTC. Calling toLocal() converts 05:00 UTC to 1:00 PM on a device set to Philippine time.