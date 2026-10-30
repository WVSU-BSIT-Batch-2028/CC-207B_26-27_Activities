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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(info.icon),
      title: Text(info.label),
      subtitle: Text(info.value),
    );
  }
}

class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });

  final String day;
  final String time;
  final String subject;
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Joseph Angelo Japitana';

  // Hobbies are no longer here: they moved to the chips card below.
  static const List<ProfileInfo> _infos = [
    ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT 3-B'),
    ProfileInfo(
      icon: Icons.account_balance,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Food',
      value: 'Loves trying all kinds of food',
    ),
    ProfileInfo(
      icon: Icons.calendar_today,
      label: 'Year',
      value: 'Third year',
    ),
    ProfileInfo(
      icon: Icons.place,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
  ];

  static const List<String> _hobbies = [
    'Playing guitar',
    'Drawing',
    'Trying new food',
    'Physical activities',
    'Sleeping',
    'Coding',
  ];


  static const List<ClassSlot> _schedule = [
    ClassSlot(day: 'Mon', time: '3:00-6:00 PM', subject: 'CC 207B'),
    ClassSlot(day: 'Tue', time: '1:00-2:30 PM', subject: 'CC 208'),
    ClassSlot(day: 'Wed', time: '1:00-4:00 PM', subject: 'CIT 212'),
    ClassSlot(day: 'Thu', time: '7:00-10:00 AM', subject: 'CIT 210'),
  ];

  Widget _cell(Widget child) =>
      Padding(padding: const EdgeInsets.all(8), child: child);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(_name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    semanticLabel: 'Photo of $_name',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        'IT student, guitar player, and lifelong foodie.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Information section
            for (final info in _infos) InfoTile(info: info),
            const SizedBox(height: 16),

            // Hobbies as chips
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Hobbies', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in _hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Class schedule as a Table
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Class Schedule', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: colors.outlineVariant),
                      columnWidths: const {
                        0: FixedColumnWidth(64),
                        1: FixedColumnWidth(120),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest,
                          ),
                          children: [
                            for (final title in ['Day', 'Time', 'Subject'])
                              _cell(
                                Text(
                                  title,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (final slot in _schedule)
                          TableRow(
                            children: [
                              _cell(Text(slot.day)),
                              _cell(Text(slot.time)),
                              _cell(Text(slot.subject)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Biography
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'I am a BSIT student at West Visayas State University who enjoys '
                      'building things with code. Outside of class, I love eating good food, '
                      'playing the guitar, and drawing whenever I need to unwind. I stay '
                      'active with all kinds of physical activities, and when the day is '
                      'done, nothing beats a good night of sleep.',
                      style: textTheme.bodyMedium,
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