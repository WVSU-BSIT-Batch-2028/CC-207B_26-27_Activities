# Running the Dart and Flutter Examples

You can run the `.dart` examples in either of these ways. Choose the instructions that match the example: plain Dart examples are in `Dart/`, while Flutter app examples are in `Flutter_1/`.

## 1. Run locally with Flutter

1. Install the Flutter SDK by following the [official installation guide](https://docs.flutter.dev/get-started/install). Flutter includes the Dart SDK.
2. Open a terminal and check your setup:

   ```bash
   flutter doctor
   ```

3. For a Flutter app, create a project and open its folder:

   ```bash
   flutter create my_app
   cd my_app
   ```

4. Copy the contents of the Flutter example into `lib/main.dart` in the new project.
5. Start an emulator or connect a device, then run:

   ```bash
   flutter run
   ```

For a plain Dart example, you do not need to create a Flutter project. From the repository's root folder, run the file with the Dart SDK; for example:

```bash
dart run "Unit 5/Dart/main.dart"
```

## 2. Run online with DartPad

1. Open [https://dartpad.dev/](https://dartpad.dev/).
2. Select **Dart** mode for a plain Dart example, or **Flutter** mode for a Flutter app example.
3. Copy the example's code into the editor and select **Run**.

DartPad is convenient for trying examples, but some platform features and third-party packages may not be available. Run the example locally if it depends on something DartPad does not support.