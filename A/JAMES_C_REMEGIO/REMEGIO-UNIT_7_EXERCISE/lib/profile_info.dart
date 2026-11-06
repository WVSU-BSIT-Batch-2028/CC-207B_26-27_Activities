import 'package:flutter/material.dart';

/// One row of profile information, such as a course or an email address.
class ProfileInfo {
  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}
