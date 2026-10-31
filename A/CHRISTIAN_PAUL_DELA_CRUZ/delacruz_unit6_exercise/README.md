# Christian Paul De la Cruz — Unit 6 Exercise

A Flutter profile app with persistent Profile, My Pet, and Gallery tabs. The
profile includes hobbies and a class schedule; the pet screen demonstrates
sample bark playback, a counter, and a confirmed reset; the gallery opens photos
on their own screen and lets one photo be marked as a favorite.

## Run

```sh
flutter pub get
flutter run
```

## Add gallery photos

The six photos are in `assets/images/gallery/` as `photo_01.jpg` through
`photo_06.jpg`. They are optimized to stay under 500 KB each. Update the
matching `Photo` captions in `lib/main.dart` to describe your photos.

The class schedule displays the times as provided; AM/PM is shown only for the
Tuesday 1:00–2:30 entry because that was the only time with AM/PM specified.
