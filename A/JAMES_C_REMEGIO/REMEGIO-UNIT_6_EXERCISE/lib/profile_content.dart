import 'package:flutter/material.dart';

import 'class_slot.dart';
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

  /// Easy to edit. These chips restate interests already in [biography].
  static const List<String> hobbies = <String>[
    'Coding',
    'Software projects',
    'Exploring technology',
    'Problem solving',
    'Learning new skills',
    'Creative work',
  ];

  /// BSIT 3-A, First Semester, SY 2026–2027. No classes Friday–Sunday.
  static const List<ClassSlot> schedule = <ClassSlot>[
    ClassSlot(
      day: 'Mon',
      time: '7:00 AM–9:00 AM',
      code: 'CIT 213',
      name: 'Human Computer Interaction 2',
      room: 'ICT 106',
    ),
    ClassSlot(
      day: 'Mon',
      time: '9:00 AM–12:00 PM',
      code: 'CIT 251',
      name: 'Security Compliance and Governance',
      room: 'ICT 305',
    ),
    ClassSlot(
      day: 'Mon',
      time: '1:00 PM–3:00 PM',
      code: 'CIT 210',
      name: 'Web Systems and Technologies',
      room: 'ICT 307',
    ),
    ClassSlot(
      day: 'Mon',
      time: '3:00 PM–4:00 PM',
      code: 'CIT 212',
      name: 'Networking 2 (Advanced Networking)',
      room: 'ICT 207',
    ),
    ClassSlot(
      day: 'Mon',
      time: '4:00 PM–5:30 PM',
      code: 'CC 208',
      name: 'Methods of Research in Computing',
      room: 'ICT 106',
    ),
    ClassSlot(
      day: 'Tue',
      time: '9:00 AM–12:00 PM',
      code: 'CC 207B',
      name: 'Applications Development and Emerging Technologies',
      room: 'ICT 307',
    ),
    ClassSlot(
      day: 'Tue',
      time: '1:00 PM–2:30 PM',
      code: 'BA 234',
      name: 'Technopreneurship',
      room: 'ICT 107',
    ),
    ClassSlot(
      day: 'Tue',
      time: '4:00 PM–6:00 PM',
      code: 'CIT 212',
      name: 'Networking 2 (Advanced Networking)',
      room: 'ICT 305',
    ),
    ClassSlot(
      day: 'Wed',
      time: '7:00 AM–10:00 AM',
      code: 'CIT 213',
      name: 'Human Computer Interaction 2',
      room: 'ICT 306',
    ),
    ClassSlot(
      day: 'Wed',
      time: '10:00 AM–12:00 PM',
      code: 'CIT 251',
      name: 'Security Compliance and Governance',
      room: 'ICT 305',
    ),
    ClassSlot(
      day: 'Wed',
      time: '1:00 PM–4:00 PM',
      code: 'CIT 210',
      name: 'Web Systems and Technologies',
      room: 'ICT 307',
    ),
    ClassSlot(
      day: 'Wed',
      time: '4:00 PM–5:30 PM',
      code: 'CC 208',
      name: 'Methods of Research in Computing',
      room: 'ICT 106',
    ),
    ClassSlot(
      day: 'Thu',
      time: '10:00 AM–12:00 PM',
      code: 'CC 207B',
      name: 'Applications Development and Emerging Technologies',
      room: 'ICT 307',
    ),
    ClassSlot(
      day: 'Thu',
      time: '1:00 PM–2:30 PM',
      code: 'BA 234',
      name: 'Technopreneurship',
      room: 'ICT 107',
    ),
    ClassSlot(
      day: 'Thu',
      time: '4:00 PM–6:00 PM',
      code: 'CIT 212',
      name: 'Networking 2 (Advanced Networking)',
      room: 'ICT 305',
    ),
  ];

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
