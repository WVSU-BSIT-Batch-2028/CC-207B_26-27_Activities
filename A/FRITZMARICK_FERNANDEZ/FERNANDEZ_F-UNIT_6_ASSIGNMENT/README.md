**West Visayas State University**  
**College of Information and Communications Technology**  
**CC 207B – Application Development**  
**Unit 6 Assignment: CICT Org Fair App (Part 2)**

**Student Name:** Fritz Marick A. Fernandez  
**Year & Section:** BSIT 3A CBS  
**Date:** October 29, 2026  
**Repository:** https://github.com/WVSU-BSIT-Batch-2028/CC-207B_26-27_Activities

**Assigned Folder:**  
`A/FRITZMARICK_FERNANDEZ/FERNANDEZ_F-UNIT_6_ASSIGNMENT`

**ANSWERS**

The application includes the following screens:

**Part I: Code Explanations**

**E1. HomeShell and Navigation**  
**File:** `lib/screens/home_shell.dart`  
**Lines:** 22–25, 62–69

HomeShell serves as the main layout of the application. It allows users to navigate between the different screens. It also manages shared data and displays pages while preserving their state when switching tabs.

**E2. Organization List**  
**File:** `lib/screens/org_list_screen.dart`  
**Lines:** 99–107, 218–229, 289–304

OrgListScreen displays the available student organizations. It allows users to filter organizations by category and switch between list and grid layouts. Users can also open an organization's details to learn more about it.

**E3. Organization Details**  
**File:** `lib/screens/org_detail_screen.dart`  
**Lines:** 36–54

OrgDetailScreen displays information about a selected organization. It uses tabs to organize details such as the organization's information, officers, and events. This helps users find the information they need before joining.

**E4. My Organizations**  
**File:** `lib/screens/my_orgs_screen.dart`  
**Lines:** 23–46

MyOrgsScreen displays the organizations that the user has joined. It helps users keep track of their memberships. It also asks for confirmation before allowing a user to leave an organization.

**E5. Organization Schedule**  
**File:** `lib/screens/schedule_screen.dart`  
**Lines:** 47–68

ScheduleScreen displays the schedule of organization activities using a table. It highlights the rows for organizations that the user has joined. This helps students identify the activities connected to their memberships.

**E6. State Management**  
**File:** `lib/screens/home_shell.dart`  
**Lines:** 22–25

State management allows the application to respond when users perform actions. HomeShell stores the joined organizations in a shared membership map. This allows other screens to access the membership information and update their displays when changes occur.

**E7. Reusable Widgets**  
**File:** `lib/screens/org_detail_screen.dart`  
**Lines:** 98–119

Reusable widgets help keep the code organized and reduce repeated code. Flutter widgets can be combined to build interface elements such as tabs and their content. This makes the application easier to maintain and update.

**E8. Layout and User Interface**  
**File:** `lib/screens/org_list_screen.dart` and `lib/screens/schedule_screen.dart`  
**Lines:** `org_list_screen.dart` lines 255–270 and 289–304; `schedule_screen.dart` lines 47–68

Flutter layout widgets arrange the elements displayed on each screen. The application uses widgets such as Wrap and grid layouts to organize organization listings, while the Table widget aligns schedule information into columns. These layouts help keep the interface organized and easier to use.

**Testing Results**

The automated tests reported the following results:

**Flutter Test Passed: 9/9**

I ran the automated tests using `flutter test`. All nine tests passed. This confirms that the required features are working based on the provided test cases.

```terminal-text
00:00 +0: loading test/org_fair_test.dart
00:00 +0: Part 1 still works: loading, then the list
00:02 +1: TODO 1 and 2: tabs switch, and the search survives
00:03 +2: TODO 3, 4 and 5: a joined org shows in My Orgs with a badge
00:05 +3: TODO 12 (needs 4 and 5): leaving an org asks first
00:07 +4: TODO 6: the drawer closes, then About opens
00:07 +5: TODO 7 and 8: category chips filter the list
00:08 +6: TODO 9: the grid gets its columns from the width
00:09 +7: TODO 10 and 11: the Officers tab
00:10 +8: TODO 13 (needs 4 and 5): the schedule highlights joined orgs
00:10 +9: All tests passed!
```