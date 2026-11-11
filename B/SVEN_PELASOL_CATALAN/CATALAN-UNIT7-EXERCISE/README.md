# CC 207B Unit 7 Exercise — My Profile App Part 3

Student: Sven Catalan  
Section: B

This project extends the Unit 6 My Profile App with a fourth navigation destination, **Shelf**. The Shelf contains **My Picks**, **Books**, and **Movies** tabs.

## Features added

- Open Library book search (`search.json`) with a 500 ms debounce and a three-character minimum.
- Copy Open Library work IDs for use in the CMS.
- OMDb movie search, poster handling, missing-result handling, and IMDb ID copying.
- Contentful `Pick` source that loads published recommendations from the Content Delivery API.
- Pull-to-refresh for My Picks; the CMS request starts in `initState`.
- Pick detail pages that load summaries and artwork from Open Library or OMDb using the stored external ID.
- Original Unit 6 Profile, My Pet, and Gallery tabs remain in the app.

## 1. Configure Contentful

Use the same Contentful space from the previous exercise. Create and publish a content type:

- Display name: `Pick`
- API ID: `pick`

Fields:

| Name | Field ID | Contentful type |
|---|---|---|
| Title | `title` | Short text |
| Kind | `kind` | Short text |
| External ID | `externalId` | Short text |
| Note | `note` | Long text |

Publish at least four entries: two books and two movies. Set `kind` to exactly `book` or `movie`, copy the external ID from the relevant search result, and write a short recommendation note. Publish all four entries.

## 2. Get an OMDb key

Request a free key at <https://www.omdbapi.com/apikey.aspx>. Keep the key private. Open Library does not require a key.

## 3. Run the app

From this project directory, run:

```powershell
flutter pub get
flutter run -d chrome `
  --dart-define=OMDB_KEY=YOUR_OMDB_KEY `
  --dart-define=CMS_SPACE=YOUR_CONTENTFUL_SPACE_ID `
  --dart-define=CMS_TOKEN=YOUR_CONTENT_DELIVERY_API_TOKEN
```

Optional: add `--dart-define=CMS_ENVIRONMENT=master` if your Contentful environment is not the default `master`.

Do not commit API keys or tokens. `.gitignore` excludes `cms.json` if you choose to use a local JSON configuration file, but runtime defines are shown above to avoid storing secrets in the project.

## 4. Tests

```powershell
flutter test
flutter analyze
```

## Evidence checklist

Capture screenshots of:

1. The Shelf tab showing its three inner tabs (My Picks, Books, Movies).
2. Book search results, including a copied Open Library work ID SnackBar.
3. Movie search results, including a copied IMDb ID SnackBar.
4. My Picks showing two books and two movies from Contentful.
5. A book pick detail page with its Open Library cover, note, and description.
6. A movie pick detail page with its OMDb poster, note, and plot.
7. My Picks after changing a CMS note and using pull-to-refresh.

Do not include screenshots that reveal API keys or Contentful tokens.
