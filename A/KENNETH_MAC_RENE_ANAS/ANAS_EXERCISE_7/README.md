# Unit 7 Exercise — My Profile App, Part 3

This Flutter app adds a **My Shelf** destination with **My Picks**, **Books**
(Open Library search), and **Movies** (OMDb search). Picks are stored in
Contentful; each pick stores only the external book/movie ID and your note.
The app gets the title, cover/poster, and summary from the respective public
API when a pick is opened.

## 1. Configure Contentful

1. In Contentful, open the space where you want to keep your recommendations.
2. Create a content type named **Pick** and set its **API identifier** to
   `pick`. The app uses that exact ID when it requests entries.
3. Add these fields. Set each field's **Field ID** exactly as shown:

   | Field ID | Contentful field type | Example |
   | --- | --- | --- |
   | `title` | Short text | The Hobbit |
   | `kind` | Short text | `book` or `movie` (lowercase) |
   | `externalId` | Short text | Open Library work ID or IMDb ID |
   | `note` | Long text | A short reason you recommend it |

   Make all four fields required. If Contentful offers a value validation for
   `kind`, restrict it to `book` and `movie`.
4. Save the content type. Open **Settings → API keys** and create/copy a
   **Content delivery API** key. You need the **Space ID** and its **Content
   Delivery API access token**. Do not use a Content Management API token.
5. In Contentful, create an entry for each recommendation and **Publish** it.
   The delivery API returns published entries only. Create at least two books
   and two movies for the exercise.

Contentful serves entries from its CDN using
`https://cdn.contentful.com/spaces/{SPACE_ID}/environments/{ENVIRONMENT}/entries`.
The app sends `content_type=pick` and the Content Delivery API token as the
`access_token` query parameter. Use `master` for the default Contentful
environment, or supply your actual environment ID.

## 2. Get the external API IDs

1. Get a free OMDb key from [omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx)
   and confirm the email activation.
2. Run the app with your Contentful and OMDb values (see below).
3. In **Shelf → Books**, search for a title. In **Shelf → Movies**, search for
   a movie. Search starts after three characters and a 500 ms pause.
4. Tap the copy button beside the result to copy its ID. Book IDs look like
   `OL27482W`; movie IDs look like `tt0816692`.
5. Create/publish one Contentful Pick entry per result. Set `kind` to `book`
   or `movie`, paste the ID into `externalId`, and add your own title and note.
   The `title` is shown in My Picks; details are loaded from Open Library or
   OMDb using `externalId`.

If movie search reports `Invalid API key!`, OMDb is rejecting the configured
key. Activate a valid key from OMDb, update `OMDB_KEY` in your local
`config.json`, then fully stop and restart the app so Flutter reloads the
compile-time value.

## 3. Run the Flutter app

From this project directory, install dependencies and pass the values as Dart
defines:

```powershell
flutter pub get
flutter run --dart-define=CONTENTFUL_SPACE_ID=your-space-id --dart-define=CONTENTFUL_DELIVERY_TOKEN=your-delivery-token --dart-define=CONTENTFUL_ENVIRONMENT=master --dart-define=OMDB_KEY=your-omdb-key
```

`CONTENTFUL_ENVIRONMENT` is optional and defaults to `master`. On Windows,
replace each placeholder with your own value; do not include angle brackets.
You can also put the values in a local JSON file and run
`flutter run --dart-define-from-file=config.json`. Its contents should look like
this (replace the values and keep the file out of Git):

```json
{
  "CONTENTFUL_SPACE_ID": "your-space-id",
  "CONTENTFUL_DELIVERY_TOKEN": "your-delivery-token",
  "CONTENTFUL_ENVIRONMENT": "master",
  "OMDB_KEY": "your-omdb-key"
}
```

The Contentful and OMDb values are not stored in the source code. A token
embedded in a mobile or web app can still be extracted from the built app, so
use only a read-only Content Delivery API token and never an administrative
Content Management API token.

## 4. Check the exercise requirements

- **My Picks:** loading, error, empty, and list states; pull down to refresh.
- **Book/movie search:** debounced search, covers/posters or fallback icons, and
  copy-ID buttons.
- **Pick details:** opens the matching public API record and displays its image,
  title, your note, and summary.
- Change a note in Contentful, publish the entry, then pull down to refresh My
  Picks to see the update.

Run the analyzer and tests with:

```powershell
flutter analyze
flutter test
```

Take the required screenshots showing the working app before submitting the
Flutter project to your assigned repository folder.
