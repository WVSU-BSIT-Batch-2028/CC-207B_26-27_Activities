# Unit 5 screenshot evidence

Completed on 14 October 2026 from the Desktop copy of assignment_org_fair.

## Deliverables

- `../output/pdf/James_Remegio_Unit_5_Screenshot_Evidence.pdf`: 11 labeled pages containing 20 actual application screenshots.
- `screenshots/`: 20 original, unedited PNG captures.
- `flutter_test.txt`: all 7 assignment tests passed.
- `flutter_analyze.txt`: no issues found.
- `manifest.json`: screenshot captions and requirement mapping.

## Capture details

Flutter 3.35.6, Dart 3.9.2, Chrome 154. Portrait viewport: 430 x 1050; desktop viewport: 1200 x 800. Device pixel ratio: 2. These are screenshots of the running Flutter web application, not native phone/emulator screenshots or mockups. Registration email and ID are illustrative test values.

The prior /workspace/scratch/70758f9d21ee/assignment_org_fair path does not exist on this host. The Desktop project contains the completed application and code analysis. Its SDK requirement was lowered from ^3.13.5 to ^3.9.2, which supports all APIs used; pubspec.lock was resolved accordingly. No application Dart files were edited.

The original web/index.html is an iCloud dataless file and was unavailable to the build. Screenshots therefore use /tmp/org-fair-evidence-run, containing identical lib/ files with a standard Flutter-generated web launcher. The build completed successfully. source_sha256.json records the application files used.

Server states were exercised using the built-in Fake server mode menu. The image-failure screenshot was produced by blocking the ITSO image request in the browser. All other captures use normal UI interactions. Screenshot 04 records retry loading; keeping the server in error mode returned to the same error display afterward. Refresh was also exercised in empty mode. Screenshots span multiple app runs; favorites and registrations are session state.

## Screenshot index

- [Loading organizations](screenshots/01_loading.png): The loading indicator appears while a repository request is pending. TODOs 1-2.
- [Organization list](screenshots/02_organization_list.png): A successful request displays all eight organizations in the phone-width layout. TODO 1.
- [Error feedback](screenshots/03_error_retry.png): Server: error displays a helpful connection message and the Try again action. TODO 4.
- [Retry starts another request](screenshots/04_retry_loading.png): Pressing Try again returns the screen to loading. With error mode unchanged, it returns to the error state. TODO 2; E3.
- [Empty repository result](screenshots/05_empty_refresh.png): Server: empty displays the empty-state message and Refresh action. TODO 5.
- [Search filters the list](screenshots/06_search_match.png): Typing robotics leaves CICT Robotics Club as the only matching organization. TODO 6; E4.
- [Search with no matches](screenshots/07_search_no_results.png): An unmatched query displays a distinct no-results message. TODO 6.
- [Long-press favorite](screenshots/08_favorite.png): Long-pressing CICT Robotics Club fills its star. The parent screen stores the favorite state. TODO 3; E6.
- [Swipe to hide](screenshots/09_swipe_hide_undo.png): Swiping Computer Science Circle removes its card and displays CSC hidden with UNDO. TODO 7.
- [Undo restores the card](screenshots/10_undo_restored.png): Pressing UNDO restores Computer Science Circle; the Robotics favorite remains selected. TODO 7.
- [Details and missing banner](screenshots/11_org_detail.png): Opening Robotics shows its description, member count, Join button, and placeholder for its null banner URL. E8.
- [Initial form state](screenshots/12_form_initial_disabled.png): The untouched form has no validation errors. Submit is disabled while the agreement is unchecked. TODO 14; E11.
- [Validation and digits only](screenshots/13_form_validation.png): Invalid submission shows name, school-email, ID-length and year-level errors. Typing 12ab3 leaves only 123. TODOs 9, 11-12.
- [Reset clears the form](screenshots/14_form_reset.png): Reset clears values and validation errors and restores Events, 3 hours, updates on, and an unchecked agreement.
- [Valid form and changed inputs](screenshots/15_form_valid_enabled.png): Demo data is entered; Year 2, Media, 7 hours and updates off are selected. Checking the agreement enables Submit. TODOs 11-14.
- [Registration returned to list](screenshots/16_registration_success.png): Submitting valid data returns to the list, displays Welcome to CRC, James Remegio! and marks Robotics as Joined. TODOs 9-10; E7, E9.
- [Duplicate joining disabled](screenshots/17_already_member_disabled.png): Reopening the joined organization displays a disabled Already a member button. TODO 8.
- [Responsive grid layout](screenshots/18_responsive_grid.png): At a 1200-pixel viewport width, the same screen displays three columns. The joined state is retained. E5.
- [Network banner loaded](screenshots/19_network_banner.png): Computer Science Circle displays its downloaded banner image and organization details. E8.
- [Failed-image fallback](screenshots/20_banner_error_fallback.png): The ITSO image request was deliberately blocked in the browser. The app displays its broken-image placeholder and remains usable. E8.
