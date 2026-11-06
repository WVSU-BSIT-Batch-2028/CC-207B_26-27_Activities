# CC 207B Unit 7 Exercise: My Profile App part 3 — My Shelf

**Student Name:** Vincent John A. Tamaño  
**Year & Section:** BSIT 3A CBS  
**Subject:** CC 207B - Application Development  
**Institution:** West Visayas State University  

---

## Overview

In Unit 7 Exercise, the Profile app is extended with a fourth navigation tab: **My Shelf**, containing three specialized tabs:
1. **My Picks:** Displays curated book and movie recommendations stored in **Contentful CMS**. Each pick only stores the external ID, title, kind, and a personal recommendation note. Pull-to-refresh (`RefreshIndicator`) updates the list from the CMS live. Tapping a pick navigates to the detailed view.
2. **Books:** Searches public books via the **Open Library Search API** (`openlibrary.org`). Includes a 500ms debounce timer, cover image previews, author details, first publish year, and a one-tap copy button for work IDs with SnackBar feedback.
3. **Movies:** Searches movies via the **OMDb API** (`omdbapi.com`). If no API key is passed, displays clear instructions and a temporary key field. Features poster previews, year, and a one-tap copy button for IMDb IDs (`imdbID`).
4. **Pick Details Screen:** Fetches live external metadata on demand:
   - For books: Loads detailed work summary from Open Library (`/works/<id>.json`) using a Dart 3 pattern match switch expression on `description`.
   - For movies: Loads full plot synopsis and poster from OMDb (`?i=<id>&plot=short`).
   - Displays the recommendation quote card with personal note, cover/poster, and API summary.

---

## Contentful CMS Setup

The app is connected to the user's Contentful Space:
- **Space ID:** `a9iyylcfbwl9`
- **Delivery Token:** `bcwq41k3bJ4VrEnaBRAN-jQrZAP6rn4xvJBL_Jj6nNw`
- **Environment:** `master`
- **Content Type:** `pick`

### Content Model (`pick`):
| Field | Type | Description |
|---|---|---|
| `title` | Short text | Title of the book or movie |
| `kind` | Short text | Either `book` or `movie` |
| `externalId` | Short text | Work ID from Open Library (e.g. `OL27482W`) or IMDb ID (e.g. `tt0816692`) |
| `note` | Long text | Personal note on why you recommend it |

---

## How to Run

### Standard Run (uses Contentful credentials & configured OMDb key `4fbbb3e5`):
```bash
flutter run
```

### Run with custom OMDb API key override:
```bash
flutter run --dart-define=OMDB_KEY=4fbbb3e5
```

### Full configuration via `--dart-define`:
```bash
flutter run \
  --dart-define=OMDB_KEY=your_omdb_key \
  --dart-define=CMS_SPACE_ID=a9iyylcfbwl9 \
  --dart-define=CMS_TOKEN=bcwq41k3bJ4VrEnaBRAN-jQrZAP6rn4xvJBL_Jj6nNw \
  --dart-define=CMS_ENV=master
```

---

## Verification & Testing

To run the analyzer:
```bash
dart analyze
```
*(Result: 0 issues found)*

To run all unit and widget tests:
```bash
flutter test
```
*(Result: All tests passed)*
