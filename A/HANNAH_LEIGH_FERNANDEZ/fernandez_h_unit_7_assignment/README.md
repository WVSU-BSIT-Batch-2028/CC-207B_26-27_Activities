# unit7_org_fair_assignment

# ANSWERS

E1: To move the app from one CMS to another, the only changes would be the CMS source file, API URL, authentication token, and the code that converts the CMS data into the app's FairEvent model. The screens and interface would mostly stay the same.

E2: CMS\_TOKEN is not a secret because users can inspect the app and find the token once the app is accessed. Public read-only tokens are safe to put there, while private tokens, admin tokens, or tokens that can edit or delete content should never be included.

E3: Your answer is correct and already easy to understand. Just add a period at the end. When comparing the Strapi and Sanity files, the main difference is how they return their data. They have the same process of building the URL and headers, calling `getJson`, and converting the CMS data into a `List<FairEvent>`. Parsing changes the most because each CMS has a different way of storing and returning data.

E4: Error 401 would be for the user because it is an authentication problem, usually caused by a user not being able to log in. Error 404 would be for the developer because it is a missing URL, which means the developer must check if the content type name or API URL is correct. Error 500 would be for the CMS admin because it is an error with the server itself.

E5: `(lib/screens/org_list_screen.dart lines 297–302)`The formula is columns = floor((width + 8) / (200 + 8)). The 8 is added because of the spacing between columns, and we round down to count the complete tiles that fit.

For 360: (360 + 8) / 208 = 1.76 = 1 column, each tile is 200 pixels maximum wide.

For 1000: (1000 + 8) / 208 = 4.84 = 4 columns, each tile is 200 pixels maximum wide.

E6: `(lib/screens/org_detail_screen.dart lines 32–52)` The number of tabs, pages, and controller length must match. Flutter will show an error because it cannot find the matching page for each tab.

E7: `(lib/screens/my_orgs_screen.dart lines 29 and 46)` howDialog returns true, false, or null. Cancelling returns false, Leaving returns true, and dismissing the dialog returns null. We test confirmed == true so the org is removed only when the user presses Leave.

E8: `(lib/screens/schedule_screen.dart lines 53–59)` Table is used instead of rows because they all share the same column widths. If each Row sized itself, the widths would be different because they would depend on the text length, causing misaligned columns.