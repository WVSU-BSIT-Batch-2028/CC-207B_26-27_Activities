# Christian Paul De la Cruz — My Profile App

The profile app includes Profile, My Pet, Gallery, and My Shelf navigation
destinations. My Shelf has My Picks, Books, and Movies tabs. Books use Open
Library; movies use OMDb; recommended picks and notes come from Contentful.

## Run

```sh
flutter pub get
flutter run --dart-define=OMDB_KEY=your-omdb-key --dart-define=CONTENTFUL_SPACE_ID=your-space-id --dart-define=CONTENTFUL_ENVIRONMENT=master --dart-define=CONTENTFUL_DELIVERY_TOKEN=your-delivery-token
```

If you are not ready to configure a CMS or OMDb, the profile and book search
still work. The Movies and My Picks tabs explain which settings are missing.

## Contentful setup

Create and publish a content type with the Contentful content type ID `pick`
and these fields:

| Field ID | Type | Example |
| --- | --- | --- |
| `title` | Short text | The Hobbit |
| `kind` | Short text | `book` or `movie` |
| `externalId` | Short text | `OL27482W` or `tt0816692` |
| `note` | Long text | A short note explaining why you recommend it |

Publish each entry. Create a Content Delivery API token and pass its value at
run time; do not commit API keys or tokens to source control. Add at least two
books and two movies for the assignment.

Open Library searches are sent after typing pauses for 500 ms and the query is
at least three characters. Use each result's copy button to copy its external
ID for a Contentful entry. Pull down on My Picks to reload notes after editing
the CMS.

## Personalize

- Update the name, tagline, biography, and `profileInfos` values in
  `lib/main.dart`.
- Replace `assets/images/profile_illustration.jpg` with your own portrait.
- Replace `assets/images/favorite_dog.jpg` and
  `assets/sounds/dog_bark.wav` with your own animal media.
- Update the gallery image list in `lib/screens/gallery_screen.dart` to use
  your chosen photos.
