import 'dart:io';

/// The beep declared in `pubspec.yaml`.
const String robotBeepAsset = 'assets/sounds/robot_beep.mp3';

/// File inside the macOS app bundle, when this process is that app.
///
/// The desktop player cannot read a temporary copy while the app sandbox is
/// on, so the beep is played from this bundled file.
String? bundledRobotBeepPath() {
  if (!Platform.isMacOS) {
    return null;
  }

  final String executable = Platform.resolvedExecutable;
  final int slash = executable.lastIndexOf('/');
  if (slash < 0) {
    return null;
  }
  final String macOsDirectory = executable.substring(0, slash);
  final File beep = File(
    '$macOsDirectory/../Frameworks/App.framework/Resources/flutter_assets/$robotBeepAsset',
  );
  if (!beep.existsSync()) {
    return null;
  }
  return beep.absolute.path;
}
