Web URL: https://si-chelson.github.io/CC-207B_26-27_Activities/

# E1: The screens only know this interface. They never import strapi_source.dart or contentful_source.dart. What would you have to change to move the app from one CMS to another, and what would stay the same?
We only need to change cms.json and make a single new source file for that new database. Which means we do not need to modify or rewrite our app screens and widgets because they interact with the EventSource interface instead rather than the CMS implemented directly.

# E2: These values are put into the app when it is built. Is CMS_TOKEN a secret once the app is on someone's phone or on the web? What kind of token is safe to put here, and what kind never is?
It will not be a secret anymore because anyone can easily inspect the code inside the app or network requests to steal it. What is safe to put are the read-only access tokens because it only let users view the data and we must not use admin or write tokens because then anyone could edit or delete the data.

# E3: Open one of the other two CMS files and compare. Which lines differ, and which are the same? Why is the parsing the part that changes most from one CMS to another?
The website link and how we pull out the text fields change but fetching JSON stays the same. Parsing also changes the most because every database service organizes its data differently so we have to write custom lines to unpack it.

# E4: 401, 404 and 500 are all "errors", but who has to fix each one: the user, you (the developer), or the people running the CMS?
The developer has to fix 401 and 404 errors by fixing the wrong tokens or typos int he link and the people running the CMS has to fix 500 errors because it means their own servers crashed. Also the user should not be responsible for any errors made on the app and should not be the one to fix them.

# E5: Offline, the app shows the events it loaded earlier, with a banner. Is that a bug or a feature? This copy lives in memory only: what happens if the user closes the app and opens it again with no internet?
Showing saved events offline is a feature so the screen is not completely empty when the internet drops down. But since the list is saved in a phone memory that is temporary, closing the app deletes it and opening the app again offline will show an error screen instead because the saved list is gone.

# E6: The request starts in initState, and again only in _refresh. Why not write future: widget.repository.load() inside build()? How many requests would the app send, and when?
Putting the load inside build() makes the app ask the database every time the screen moves or updates which spams the server with a lot of requests while putting it in initState makes it load just once when the screen opens.

# E7: RefreshIndicator calls onRefresh and hides its spinner when the Future it gets back completes. What would the user see if _refresh returned right away, before the CMS answered?
The spinning loading circle would close instantly before new data comes back from the internet and the user would think it finished refreshing even though the list on screen did not change at all.

# E8: The CMS sends "2026-11-08T05:00:00.000Z". What does the Z mean, and why do we call toLocal() before showing the time? What would a student in Iloilo see without it?
The Z means global world time and we use toLocal() so it changes to Philippine local time because without it a student in Iloilo will see the event starting 8 hours earlier than the actual schedule.