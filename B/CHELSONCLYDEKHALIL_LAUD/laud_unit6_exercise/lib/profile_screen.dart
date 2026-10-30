import 'package:flutter/material.dart';
import 'profile_info.dart';
import 'models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  //Unod sng profile
  static const List<ProfileInfo> _profileDetails = [
    ProfileInfo(icon: Icons.email, label: 'Email', value: 'chelsonclydekhalil.laud@wvsu.edu.ph'),
    ProfileInfo(icon: Icons.location_on, label: 'Address', value: 'Leganes, Iloilo'),
    ProfileInfo(icon: Icons.cake, label: 'Birthdate', value: 'August 23, 2006'),
    ProfileInfo(icon: Icons.phone, label: 'Phone Number', value: '09106401759'),
    ProfileInfo(icon: Icons.school, label: 'Education', value: 'West Visayas State University'),
    ProfileInfo(icon: Icons.code, label: 'Course', value: 'BS in Information Technology'),
  ];

  static const List<String> _hobbies = [
    'Coding',
    'Gaming',
    'Sleeping',
    'Impulsive Buying',
    'Haggling',
    'Collecting',
    'Doomscrolling',
    'Painting',
  ];

  static const List<ClassSlot> _schedule = [
    ClassSlot(day: 'Monday', time: '9:00AM-12:00PM\n\n1:00PM-3:00PM\n\n3:00PM-6:00PM', subject: 'IT Project Management\n\nNetworking 2\n\nApplication Development'),
    ClassSlot(day: 'Tuesday', time: '7:00AM-9:00AM\n\n11:30AM-1:00PM\n\n1:00PM-2:30PM\n\n3:00PM-6:00PM', subject: 'Web Systems\n\nTechnopreneurship\n\nResearch in Computing\n\nHCI 2'),
    ClassSlot(day: 'Wednesday', time: '10:00AM-12:00PM\n\n1:00PM-4:00PM\n\n4:00PM-6:00PM', subject: 'IT Project Management\n\nNetworking 2\n\nApplication Development'),
    ClassSlot(day: 'Thursday', time: '7:00AM-10:00AM\n\n11:30AM-1:00PM\n\n1:00PM-2:30PM\n\n4:00PM-6:00PM', subject: 'Web Systems\n\nTechnopreneurship\n\nResearch in Computing\n\nHCI 2'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chelson Clyde Khalil Laud'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Semantics(
                  label: 'Photo of Chelson Laud',
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chelson Clyde Khalil Laud',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Live, Laugh, Haha',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            for (final info in _profileDetails) InfoTile(info: info),

            const SizedBox(height: 16),

            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (final hobby in _hobbies)
                          Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am a 3rd Year student studying Information Technology because they told me the salary is high and I was like wow okay! I enjoy learning new things and building cool stuff in this course because it gives me the wows and the woahs. I spend half my time staring at broken code wondering why it is not working, and the other half wondering why it suddenly works. But no worries, it is what is it.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(95.0),
                        1: FixedColumnWidth(140.0),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Day',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Subject',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
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
                                child: Text(slot.day),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(slot.time),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(slot.subject),
                              ),
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
    );
  }
}