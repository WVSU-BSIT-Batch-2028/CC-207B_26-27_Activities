# Unit 7 – CICT Org Fair App (Part 3)

This archive contains the updated `lib/` and `test/` folders for the supplied Flutter starter project. The assignment's 11 TODOs have been implemented, including the Contentful, Strapi, and Sanity event-source adapters.

## Merge into your Flutter project

1. Make a backup of your project.
2. Extract this archive into the Flutter project root and allow the `lib/` and `test/` folders to merge with the existing folders.
3. Keep your original `pubspec.yaml`, Android/iOS/web folders, and other project configuration files.
4. From the project root, run:

   ```sh
   flutter pub get
   flutter test
   ```

The uploaded ZIPs did not include `pubspec.yaml`, so this archive deliberately does not replace or invent your project's package configuration.

## Use Contentful

Set up the `fairEvent` content type and its exact field IDs in Contentful, then run the app with your Space ID and read-only Content Delivery API token:

```sh
flutter run \
  --dart-define=CMS=contentful \
  --dart-define=CMS_SPACE=YOUR_SPACE_ID \
  --dart-define=CMS_TOKEN=YOUR_DELIVERY_TOKEN
```

Do not commit a file containing your token or include the token in screenshots. A client-side token can be extracted from a compiled app; use only a read-only token for public event content. Never put a Content Management API token in the app.

## What is included

- TODOs 1–5: HTTP status messages, all three CMS requests/parsers, and last-good-load fallback.
- TODOs 6–8: refresh handling, chronological sorting, and the offline `MaterialBanner` with Retry.
- TODO 9: cancelled event styling.
- TODO 10: organization-specific event loading.
- TODO 11: What's On navigation destination and page.

The tests are included in `test/`. They have not been executed in this environment because Flutter/Dart and the original `pubspec.yaml` were not included with the uploads. Run `flutter test` on your computer before submission and address any environment-specific failures.

## Still required outside the code

- Configure the live CMS and publish at least 8 events across at least 4 organizations.
- Mark one published event as cancelled.
- Create one additional draft event and leave it unpublished.
- Run the app against the live CMS and capture the assignment's requested evidence screenshots.

See `SUBMISSION_NOTES.md` for the written explanations and a final checklist.
