import 'package:flutter/material.dart';

import '../models/profile_info.dart';

// TODO: replace the placeholder values below with your own details.
const String fullName = 'Mark Angelo A. Jamela';
const String tagline = 'BSIT 3-A student who loves building apps.';

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.cake, label: 'Birthdate', value: 'July 18, 2006'),
  ProfileInfo(icon: Icons.home, label: 'Address', value: 'Iloilo, Philippines'),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'markangelo.jamela@wvsu.edu.ph',
  ),
  ProfileInfo(icon: Icons.phone, label: 'Phone Number', value: '09388244039'),
  ProfileInfo(
    icon: Icons.school,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.menu_book,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
];

const String biography =
    'I am Mark Angelo A. Jamela, a third-year BSIT student at West Visayas '
    'State University in Iloilo City. I enjoy coding, building apps, and '
    'learning new technologies that make everyday tasks easier. When I am '
    'not studying, I like playing badminton and spending time with my dog, '
    'Luna. I am working toward a career in software development, one project '
    'at a time.';

const List<String> hobbies = [
  'Sleeping',
  'Gaming',
  'Eating',
];

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
}

const List<ClassSlot> classSchedule = [
  ClassSlot(
      day: 'Mon',
      time: '7:00am-9:00am',
      subject: 'Human Computer Interaction 2'),
  ClassSlot(
      day: 'Tue',
      time: '9:00am-12:00am',
      subject: 'Applications Development and Emerging Technologies'),
  ClassSlot(
      day: 'Wed',
      time: '10:00am-12:00nn',
      subject: 'Security Compliance and Governance'),
  ClassSlot(day: 'Thu', time: '4:00pm-6:00pm', subject: 'Networking 2'),
];

/// Display-only screen, so everything here is stateless.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(fullName),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile row: circular photo on the left, name + tagline right.
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $fullName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(tagline, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Information section built with a collection-for.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Hobbies', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final hobby in hobbies) Chip(label: Text(hobby)),
                        ],
                      )
                    ]),
              ),
            ),
            const SizedBox(height: 16),

            // Biography card.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(biography, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Class Schedule',
                        style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: theme.dividerColor),
                      columnWidths: const {
                        0: FixedColumnWidth(70),
                        1: FixedColumnWidth(85),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final heading in ['Day', 'Time', 'Subject'])
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  heading,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        for (final slot in classSchedule)
                          TableRow(
                            children: [
                              for (final value in [
                                slot.day,
                                slot.time,
                                slot.subject
                              ])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(value),
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
