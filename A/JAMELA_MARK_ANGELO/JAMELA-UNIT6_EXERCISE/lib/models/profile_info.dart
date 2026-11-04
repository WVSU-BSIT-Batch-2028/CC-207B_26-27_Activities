import 'package:flutter/widgets.dart';

/// One row of the information section: an icon, a label and its value.
class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });
}
