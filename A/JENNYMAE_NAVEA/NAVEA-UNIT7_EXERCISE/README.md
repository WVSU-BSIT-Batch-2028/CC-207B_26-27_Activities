# My Profile App - Unit 7 Exercise

The app adds a My Shelf page to the Unit 6 profile app. The shelf has three
tabs: My Picks (recommendations from Contentful), Books (Open Library search),
and Movies (OMDb search). The CMS stores each recommendation's title, kind,
external API ID, and note; the details screen fetches the current cover, year,
and summary from the appropriate public API.

## Configure and run

The exercise uses Contentful, Open Library, and OMDb. Open Library needs no key.
Create a Contentful delivery API token and an OMDb API key. Keep these values
in the ignored local `cms.json`, not in source files or commits:

```json
{
  "CMS": "contentful",
  "CMS_SPACE": "your-space-id",
  "CMS_TOKEN": "your-content-delivery-token",
  "OMDB_KEY": "your-omdb-key"
}
```

In Contentful, publish a content type with API ID `pick` and fields `title`,
`kind`, `externalId`, and `note`. Add at least two book picks and two movie
picks. Use `book` or `movie` for `kind`, the copied Open Library work ID or
IMDb ID for `externalId`, and your recommendation in `note`.

Run the app from this directory:

```powershell
flutter pub get
flutter run --dart-define-from-file=cms.json
```

On the Books or Movies tab, search with at least three characters. Results
load after typing pauses for half a second. Use the copy button on a result to
copy its external ID for a Contentful pick.

## Tests

```powershell
flutter test
flutter analyze
```
