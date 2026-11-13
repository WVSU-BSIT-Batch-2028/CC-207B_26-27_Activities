# Unit 6 Exercise Description

## Description
Completes the Unit 6 assignment for the My Profile App Part 2. The app keeps the pet bark count alive across tab switches, adds a Gallery tab with photo grid and favorite functionality, updates the profile with hobbies chips and class schedule table, and asks for confirmation before resetting the bark count.

## Changes made

### HomeShell
- Replaced the tab content logic with IndexedStack so the selected page state is preserved
- Added a third tab for Gallery
- Kept the pet screen alive while switching between tabs

### Pet screen
- Kept the pet image and sound from Unit 5
- Added a bark counter that survives tab changes
- Added an OutlinedButton labeled “Reset count”
- Added a confirmation dialog before resetting the count
- Disabled the reset button when the count is 0

### Gallery screen
- Created a Photo model with asset and caption
- Added at least 6 gallery images in assets/images/gallery/
- Built a grid using GridView.extent with maxCrossAxisExtent: 160
- Added rounded image tiles and semantic labels
- Tapping a photo opens a PhotoScreen
- PhotoScreen shows the image in full and a “Make favorite” button
- Returning true from the detail page saves the favorite photo
- Favorite tile displays a star using Stack and Positioned
- Only one photo can be the favorite

### Profile screen
- Removed hobbies from the information rows
- Added a Card titled “My Hobbies” with chips in a Wrap
- Added a ClassSlot model and list of classes
- Added a Card titled “My Class Schedule” with a bordered table
- Added a themed header row with bold text
- Used columnWidths so Day and Time have fixed widths and Subject takes the rest
- Ensured the page remains scrollable on smaller screens
