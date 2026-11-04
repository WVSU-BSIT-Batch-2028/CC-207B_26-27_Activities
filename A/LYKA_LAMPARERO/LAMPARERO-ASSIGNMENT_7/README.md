# Unit 7 Assignment: CICT Org Fair Part 3

Name: Lyka R. Lamparero
Section: BSIT 3A
CMS: Contentful

## E1: event_source.dart, line 11
To move to another CMS, I only change the line in config.dart that picks the source, and the --dart-define values. The screens, the repository and FairEvent stay the same. They only use the EventSource interface, so they do not know which CMS is behind it.

## E2: config.dart, line 35
No, CMS_TOKEN is not a secret once the app is on someone's phone or on the web, because the values are put inside the app and anyone can dig them out. A read-only Delivery token that can only see published entries is safe to put here. A management or write token must never be put here.

## E3: contentful_source.dart, line 61
The request lines are almost the same in every CMS file: the URL, the query and the headers. What changes most is the parsing, because each CMS sends a different JSON shape. In Contentful the list is in items and the values are inside fields, so the code that reads them has to be different.

## E4: event_source.dart, line 63
A 401 is usually mine to fix, because the token or the read permission is wrong. A 404 is also mine, because the URL or the content type name is wrong. A 500 is a problem on the CMS side, so the people running it have to fix it. The user can only try again later.

## E5: event_repository.dart, line 31
It is a feature, not a bug. The app shows the last good events with a banner, so the user still sees something when the internet drops. The copy is only in memory, so if the user closes the app and opens it again with no internet, there is nothing saved and the error shows.

## E6: events_screen.dart, line 26
If the request was inside build(), it would be sent again every time the screen rebuilds, for example on setState or when the window changes size. That would send many requests that are not needed. In initState it is sent once, and again only when the user refreshes.

## E7: events_screen.dart, line 38
If _refresh returned right away, the spinner of RefreshIndicator would disappear before the CMS answered. The user would see the old list with no sign that it is loading. Waiting for the Future keeps the spinner until the new answer comes.

## E8: event_tile.dart, line 17
The Z means the time is in UTC. toLocal() changes it to the time zone of the phone. Without it, a student in Iloilo would see 5:00 AM instead of 1:00 PM, which is 8 hours off.
