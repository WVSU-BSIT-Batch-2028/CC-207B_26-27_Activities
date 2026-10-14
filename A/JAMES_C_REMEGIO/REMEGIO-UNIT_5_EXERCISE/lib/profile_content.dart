import 'package:flutter/material.dart';

import 'profile_info.dart';

/// Personal details for the Profile screen.
///
/// The biography and every detail below are read by the profile page.
class ProfileContent {
  const ProfileContent._();

  static const String displayName = 'James Remegio';

  static const String course = 'CC 207B';

  static const String tagline =
      'Aspiring IT professional, creative problem-solver, and lifelong learner.';

  /// Circular profile photo. Add your picture at this path if it is missing.
  static const String photoAsset = 'assets/images/profile.jpg';

  static const String biography =
      'I\'m James C. Remegio, a Bachelor of Science in Information Technology student at West Visayas State University. I\'m interested in software development and enjoy turning ideas into practical projects. Through my studies, I\'m building my programming skills, exploring new technologies, and learning to solve problems creatively. My goal is to keep growing as a developer and create useful, thoughtful technology.';

  static const List<ProfileInfo> details = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.badge_outlined,
      label: 'Name',
      value: displayName,
    ),
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Course',
      value: course,
    ),
    ProfileInfo(
      icon: Icons.menu_book_outlined,
      label: 'Program',
      value: 'Bachelor of Science in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.mail_outlined,
      label: 'Email',
      value: 'james.remegio@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.place_outlined,
      label: 'Campus',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.smart_toy_outlined,
      label: 'Companion',
      value: 'Byte',
    ),
  ];
}
