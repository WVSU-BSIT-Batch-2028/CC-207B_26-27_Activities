import 'package:flutter/material.dart';

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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.school, label: 'School', value: 'West Visayas State University'),
    ProfileInfo(icon: Icons.menu_book, label: 'Course', value: 'BSIT'),
    ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'December 19, 2005'),
    ProfileInfo(icon: Icons.location_on, label: 'Hometown', value: 'Molo, Iloilo City'),
    ProfileInfo(icon: Icons.groups, label: 'Organization', value: 'LINK.exe'),
  ];

  static const List<String> hobbies = [
    'Frontend development',
    'Photo editing',
    'Gaming',
    'Arnis',
    'Designing',
  ];

  static const List<ClassSlot> schedule = [
    ClassSlot(day: 'Mon', time: '7:00-9:00', subject: 'Human Computer Interaction 2'),
    ClassSlot(day: 'Tue', time: '9:00-12:00', subject: 'Applications Development of Emerging Technologies'),
    ClassSlot(day: 'Wed', time: '1:00-4:00', subject: 'Web Systems and Technologies'),
    ClassSlot(day: 'Thu', time: '4:00-6:00', subject: 'Networking 2'),
  ];

    Widget _cell(String text, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Gracer Ann Escalada')),
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
                    'assets/images/me.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Gracer Ann Escalada',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gracer Ann S. Escalada',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Software developer and Editor',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Information section
            for (final info in infos) InfoTile(info: info),
            const SizedBox(height: 16),

            // Biography
            Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Im a hustler: I take on a lot, from coding and editing to writing proposals, and I like seeing things through. Im also a hipster: I like the off-beat, the well-made, and the details most people scroll past. Those two sides show up in everything I build.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

                        // Hobbies
            Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Hobbies', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final hobby in hobbies) Chip(label: Text(hobby)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Class schedule
            Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.colorScheme.outline),
            ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Class Schedule', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: theme.colorScheme.outline),
                      columnWidths: const {
                        0: FixedColumnWidth(56),
                        1: FixedColumnWidth(100),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final h in ['Day', 'Time', 'Subject'])
                              _cell(
                                h,
                                theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        for (final slot in schedule)
                          TableRow(
                            children: [
                              _cell(slot.day, theme.textTheme.bodyMedium),
                              _cell(slot.time, theme.textTheme.bodyMedium),
                              _cell(slot.subject, theme.textTheme.bodyMedium),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}