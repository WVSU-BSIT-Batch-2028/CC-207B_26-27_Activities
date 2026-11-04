# ANDRADA - Unit 7 Assignment (CICT Org Fair Part 3)

CMS used: Contentful

## EXPLAIN answers

**E1** (lib/data/event_source.dart, line 11)

The screens only depend on the EventSource interface, not on a specific CMS. To move to another CMS, I would write or finish that CMS's source class and change the values that config.dart uses to pick it. The screens, the repository and the FairEvent model stay the same.

**E2** (lib/config.dart, line 35)

CMS_TOKEN is not a real secret once the app is shipped, because the value is built into the app and someone could extract it. A read-only token like Contentful's Content Delivery token is safe here because it can only read published content. A token that can edit or delete data, like the Content Management token, should never be put in the app.

**E3** (lib/data/cms/contentful_source.dart, line 59)

The getJson call and the idea of returning a List<FairEvent> are the same in all three files. The URL, the query parameters and the parsing differ. Parsing changes the most because each CMS shapes its JSON differently: Contentful uses items, sys.id and fields, Strapi uses data and documentId, and Sanity uses result and _id.

**E4** (lib/data/event_source.dart, line 66)

A 401 usually means a wrong or missing token, and a 404 means a wrong URL or content type name, so I as the developer fix those. A 500 is a problem on the CMS side, so the people running it fix that, and the user can only try again later. The user can usually only fix problems like having no internet.

**E5** (lib/data/event_repository.dart, line 25)

It is a feature, because the student still sees useful information, and the banner says it may be old. The copy is only kept in memory, so it is lost when the app closes. If the user reopens the app with no internet, there is no saved copy, so they see the error message instead.

**E6** (lib/screens/events_screen.dart, line 21)

build() can run many times, such as whenever setState is called or the parent rebuilds. If the request were inside build(), every rebuild would send a new request and the list would keep going back to loading. Starting it in initState sends one request when the screen opens, and _refresh sends another only when the user asks.

**E7** (lib/screens/events_screen.dart, line 96)

If _refresh returned right away, the spinner would disappear immediately even though the CMS had not answered. The user would think the refresh was done, then the list would change later without warning. Awaiting the load keeps the spinner visible until the answer arrives.

**E8** (lib/widgets/event_tile.dart, line 17)

The Z means the time is in UTC. We call toLocal() to convert it to the phone's own time zone before showing it. Without it, a student in Iloilo (UTC+8) would see 5:00 AM for an event that really starts at 1:00 PM, which is 8 hours off.
