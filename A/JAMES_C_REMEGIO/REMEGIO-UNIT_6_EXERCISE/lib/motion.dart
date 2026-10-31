import 'package:flutter/widgets.dart';

/// Returns [duration], or zero when the user has asked the system to reduce motion.
Duration motionDuration(BuildContext context, Duration duration) {
  if (MediaQuery.disableAnimationsOf(context)) {
    return Duration.zero;
  }
  return duration;
}
