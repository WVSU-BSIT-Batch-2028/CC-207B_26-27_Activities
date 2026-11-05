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


## E1–E4 Explanations

### E1 — CMS independence
The screens use the EventSource interface instead of directly using a specific CMS file. To change from Contentful to another CMS, I would change the selected CMS source and its configuration. The screens, EventRepository, FairEvent model, and UI can stay the same.

### E2 — Dart define token safety
Values from --dart-define are included when the app is built. A token in a web or mobile app can be seen by users, so it is not a secret after publishing. Only a restricted, read-only Content Delivery token is safe to use. A Content Management token, write token, or administrator token must never be included in the app.

### E3 — CMS adapter differences
The URL, query parameters, headers, and JSON parsing differ between Contentful, Strapi, and Sanity. The shared EventSource interface and getJson error handling remain similar. Parsing changes most because every CMS returns event data in a different JSON structure.

### E4 — HTTP error responsibility
A 401 or 403 error usually means the developer must check the token or permissions. A 404 error usually means the developer must check the API URL or content type name. A 500-level error is a problem with the CMS service, so the user should try again later while the CMS provider resolves it.