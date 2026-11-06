# Pangantihon Unit 7 Exercise

The app adds a **My Shelf** destination to the profile app. Its tabs search
Open Library books, search OMDb movies, and load personal recommendations from
Strapi. A pick stores only its title, kind, external API ID, and your note;
opening a pick loads its cover, year, and summary from the relevant catalog.

## Set up Strapi

In the Strapi Content-Type Builder, create a **Pick** collection type with:

| Field | Type |
|---|---|
| `title` | Short text |
| `kind` | Enumeration: `book`, `movie` |
| `externalId` | Short text |
| `note` | Long text |

Save the content type. In **Settings → Users & Permissions Plugin → Roles →
Public**, enable the `find` and `findOne` permissions for Pick, then save.
Publish your records; draft entries are not returned to the app. The app reads
`GET /api/picks` and supports Strapi 5 as well as Strapi 4 response shapes.

The following IDs are ready-to-use examples for all the recommendations you
listed. Add these records in Strapi and publish them. “Hanibal” is entered as
**Hannibal**.

| Title | Kind | `externalId` | Note |
|---|---|---|---|
| Sherlock Holmes | book | `OL262421W` | Classic detective stories with clever clues and a memorable investigator. |
| Sophie's World | book | `OL19671516W` | A playful introduction to the big questions and history of philosophy. |
| Hannibal | book | `OL23478W` | A dark psychological thriller built around an unsettling cat-and-mouse pursuit. |
| Jujutsu Kaisen Manga | book | `OL20644916W` | High-energy supernatural battles balanced by an engaging cast and emotional stakes. |
| Monster Manga | book | `OL8694262W` | A carefully paced moral thriller that asks what makes someone human. |
| Pluto Manga | book | `OL17438123W` | A thoughtful sci-fi mystery that reimagines Astro Boy with a moving humanist core. |
| Inception | movie | `tt1375666` | A clever, layered sci-fi thriller that rewards a second watch. |
| Interstellar | movie | `tt0816692` | A sweeping space adventure grounded by its emotional family story. |
| Memento | movie | `tt0209144` | A gripping mystery whose unusual structure makes the audience piece it together. |
| The Prestige | movie | `tt0482571` | A tense rivalry full of misdirection, ambition, and satisfying reveals. |
| Shutter Island | movie | `tt1130884` | An atmospheric psychological mystery that keeps questioning what is real. |
| The Dark Knight | movie | `tt0468569` | A gripping superhero crime drama with a memorable central conflict. |

You need at least four published picks for the exercise; adding all twelve makes
the recommendations complete. The book IDs identify the Open Library works
(the manga IDs point to volume one).

## Configure and run

Get a free OMDb key from [omdbapi.com/apikey.aspx](https://www.omdbapi.com/apikey.aspx).
Provide it and your Strapi server URL at build/run time; do not put a privileged
Strapi token or your OMDb key in source control.

For an Android emulator with Strapi running on your computer, use
`10.0.2.2` to reach the computer from the emulator:

```powershell
flutter run --dart-define=OMDB_KEY=your-omdb-key --dart-define=CMS_URL=http://10.0.2.2:1337
```

For Flutter web or desktop on the same computer, use
`--dart-define=CMS_URL=http://localhost:1337`. For a hosted Strapi instance,
use its HTTPS URL instead. If your Strapi Public role can read picks, no token
is needed. If you use a read-only API token, pass it with
`--dart-define=CMS_TOKEN=your-read-only-token`; build-time values are visible in
the client app, so never use an admin or write-enabled token.

Open the **Shelf** destination:

- **My Picks** loads the published Strapi records on entry. Pull down to refresh
  after publishing or changing a note.
- **Books** and **Movies** search after you stop typing for 500 ms (minimum
  three characters). Use the copy button to copy an Open Library work ID or
  IMDb ID for a Strapi record.
- Open a pick to see its API-provided artwork, year, and summary alongside your
  Strapi note.

## Suggested screenshots

1. The profile screen with the bottom navigation visible.
2. The Shelf **My Picks** list showing both book and movie recommendations.
3. **Books** search results, including the query, covers, and copy-ID buttons.
4. **Movies** search results with the OMDb posters and copy-ID buttons.
5. An opened book pick showing its cover, year, recommendation note, and
   description.
6. An opened movie pick showing its poster, year, note, and plot summary.
7. The picks list after changing a note in Strapi and pulling to refresh, so the
   updated note is visible.
8. (If your instructor accepts CMS evidence) Strapi's published Pick records
   and the Public `find` permission.
