# unit7_org_fair_assignment

# ANSWERS

E1: To move the app from one CMS to another, the only changes would be the CMS source file, API URL, authentication token, and the code that converts the CMS data into the app's FairEvent model. The screens and interface would mostly stay the same.

E2: CMS\_TOKEN is not a secret because users can inspect the app and find the token once the app is accessed. Public read-only tokens are safe to put there, while private tokens, admin tokens, or tokens that can edit or delete content should never be included.

E3: Your answer is correct and already easy to understand. Just add a period at the end. When comparing the Strapi and Sanity files, the main difference is how they return their data. They have the same process of building the URL and headers, calling `getJson`, and converting the CMS data into a `List<FairEvent>`. Parsing changes the most because each CMS has a different way of storing and returning data.

E4: Error 401 would be for the user because it is an authentication problem, usually caused by a user not being able to log in. Error 404 would be for the developer because it is a missing URL, which means the developer must check if the content type name or API URL is correct. Error 500 would be for the CMS admin because it is an error with the server itself.

E5: It is a feature. If the app is still open when we lose connection, it can show previously loaded events. If the user closes and reopens the app without internet, the saved events are gone since they're only stored in memory. The app will not be able to fetch new events without Wi-Fi or an internet connection.

For 360: (360 + 8) / 208 = 1.76 = 1 column, each tile is 200 pixels maximum wide.

For 1000: (1000 + 8) / 208 = 4.84 = 4 columns, each tile is 200 pixels maximum wide.

E6: We don't use `widget.repository.load()` inside `build()` because it can run many times whenever the screen updates. It would cause the app to send multiple requests to the CMS even when the user isn't refreshing. Using the request in `_refresh` and `initState` makes sure the app only loads events when the screen opens or when the user refreshes.

E7: The user would see the refresh spinner disappear, which would lead them to think that the data has already updated even though the app is still waiting for a response.

E8: The Z means Zulu time, which is also known as Coordinated Universal Time (UTC). We call `toLocal()` to convert the time to the user's local time zone. Without calling it, a student in Iloilo would see the UTC time instead of the Philippine time.