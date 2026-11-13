# BRILLANTES-UNIT_5_EXERCISE

This Flutter web app is a two-screen profile and pet experience for Luisa Rose Brillantes.

## App Description

The app includes:
- a Profile screen with personal information, biography, and profile details
- a My Pet screen with a pet photo, sound playback, heart toggle, and play counter
- a bottom navigation bar for switching between screens
- responsive styling using Material 3 theme colors and text themes

## Project Type

This project is built for Flutter Web.

## Run the App

From the project folder, run:

```bash
flutter pub get
flutter run -d chrome
```

If you are using a browser-based environment, you can also run:

```bash
flutter run -d web-server
```

## Assets Included

- assets/images/my_photo.jpg
- assets/images/my_pet.jpg
- assets/sounds/pet_sound.mp3

## Notes

- The app uses a custom Material app theme with `ThemeData(colorSchemeSeed: Colors.indigo)`.
- Audio playback is implemented using the `audioplayers` package.
- The pet photo supports double-tap heart animation and a play counter that updates when the sound is triggered.
