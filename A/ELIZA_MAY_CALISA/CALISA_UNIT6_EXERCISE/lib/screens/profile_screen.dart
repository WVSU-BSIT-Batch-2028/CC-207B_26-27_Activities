import 'package:flutter/material.dart';

import '../models/profile_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'West Visayas State University - BSIT 3A',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Cabatuan, Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Chocolate Cake, Fries, Coffee',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'elizamay.calisa@wvsu.edu.ph',
    ),
  ];

  static const List<String> hobbies = [
    'Reading',
    'Watching Movies',
    'Listening to Music',
    'Playing Games',
    'Coffee',
    'Journaling',
  ];

  static const List<ClassSlot> schedule = [
    ClassSlot('Mon', '7:00-5:30', 'CIT213, CIT246, CIT210, CIT208'),
    ClassSlot('Tue', '9:00-6:00', 'CC207, BA234, CIT212'),
    ClassSlot('Wed', '7:00-5:30', 'CIT213, CIT246, CIT210, CIT208'),
    ClassSlot('Thu', '10:00-6:00', 'CC207, BA234, CIT212'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Eliza May Calisa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile row
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/portfolio.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Eliza May Calisa',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eliza May Calisa',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Building functional digital experiences from the ground up.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Information section
            for (final info in infos) InfoTile(info: info),
            const SizedBox(height: 16),

            // Biography
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'I am a 3rd-year Bachelor of Science in Information Technology student passionate about software development and modern web technologies. Currently honing my skills in front-end and back-end programming, I enjoy transforming ideas into functional, user-friendly applications. As I prepare for my capstone project and industry internship, I am actively building personal projects, mastering new frameworks, and seeking opportunities to collaborate on real-world tech solutions.',
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 16),

                    // Hobbies
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Hobbies',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final hobby in hobbies)
                                  Chip(label: Text(hobby)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Class schedule
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Class Schedule',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Table(
                              border: TableBorder.all(),
                              columnWidths: const {
                                0: FixedColumnWidth(60),
                                1: FixedColumnWidth(110),
                                2: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                  ),
                                  children: const [
                                    _Cell('Day', bold: true),
                                    _Cell('Time', bold: true),
                                    _Cell('Subject', bold: true),
                                  ],
                                ),
                                for (final c in schedule)
                                  TableRow(
                                    children: [
                                      _Cell(c.day),
                                      _Cell(c.time),
                                      _Cell(c.subject),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

class ClassSlot {
  final String day, time, subject;
  const ClassSlot(this.day, this.time, this.subject);
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  const _Cell(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
