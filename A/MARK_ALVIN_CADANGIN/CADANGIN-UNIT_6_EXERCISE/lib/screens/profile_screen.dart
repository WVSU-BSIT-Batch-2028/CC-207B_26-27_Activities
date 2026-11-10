import 'package:flutter/material.dart';

import '../models/class_slot.dart';
import '../models/profile_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> _profileInfos = const [
    ProfileInfo(
      icon: Icons.school,
      label: 'Course & Year',
      value: 'BSIT 3A - Software Development Track',
    ),
    ProfileInfo(
      icon: Icons.account_balance,
      label: 'University',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'markalvin.cadangin@wvsu.edu.ph',
    ),
    ProfileInfo(icon: Icons.pets, label: 'Pet', value: 'Whitey (Puppy)'),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Leon, Iloilo, Philippines',
    ),
  ];

  final List<String> _hobbies = const [
    'Basketball',
    'Coding',
    'Music',
    'Movies',
    'Road Trips',
  ];

  final List<ClassSlot> _schedule = const [
    ClassSlot(
      day: 'Tue / Thu',
      time: '09:00 - 12:00 PM',
      subject: 'CC 207B - App Dev & Emerging Tech',
    ),
    ClassSlot(
      day: 'Mon / Wed',
      time: '4:00 - 5:30 PM',
      subject: 'CC 208 - Methods of Research in Computing',
    ),
    ClassSlot(
      day: 'Tue / Thu',
      time: '01:00 - 03:00 PM',
      subject: 'CIT 210 - Web Systems Technologies',
    ),
    ClassSlot(
      day: 'Mon / Wed',
      time: '09:00 - 12:00 PM',
      subject: 'CIT 246 - IT Project Management',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Alvin Cadangin'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpeg',
                    width: 84.0,
                    height: 84.0,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Mark Alvin Cadangin',
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mark Alvin Cadangin',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'BSIT Student & Aspiring Software Engineer',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'I am a 3rd-year BS Information Technology student at West Visayas State University specializing in Software Development. Outside of my studies, I spend my time playing basketball, coding, listening to music, watching movies, going on road trips, and taking care of my puppy Whitey.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (final hobby in _hobbies)
                          Chip(
                            label: Text(hobby),
                            backgroundColor: colorScheme.secondaryContainer,
                            labelStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Table(
                      border: TableBorder.all(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(92.0),
                        1: FixedColumnWidth(118.0),
                        2: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Day',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Time',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Subject',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final slot in _schedule)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot.day,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot.time,
                                  style: textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot.subject,
                                  style: textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    for (final info in _profileInfos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
