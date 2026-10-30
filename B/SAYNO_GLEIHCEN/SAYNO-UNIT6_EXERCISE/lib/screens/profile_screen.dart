import 'package:flutter/material.dart';

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

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.cake, label: 'Age', value: '20'),
  ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT'),
  ProfileInfo(
    icon: Icons.account_balance,
    label: 'School',
    value: 'Western Visayas State University',
  ),
  ProfileInfo(icon: Icons.location_on, label: 'Location', value: 'Iloilo City'),
  ProfileInfo(icon: Icons.pets, label: 'Pet', value: 'Sreit (dog)'),
];

const List<String> hobbies = [
  'Dancing',
  'Sleeping',
  'Reading',
  'Binge-watching movies/series',
  'Eating',
];

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

const List<ClassSlot> classes = [
  ClassSlot(
    day: 'Mon',
    time: '9am - 12pm',
    subject: 'CIT251 Security Compliance and Governance',
  ),
  ClassSlot(
    day: 'Tue',
    time: '7am - 9am',
    subject: 'CIT210 Web Systems and Technologies',
  ),
  ClassSlot(
    day: 'Wed',
    time: '4pm - 6pm',
    subject: 'CC207B App Development & Emerging Tech',
  ),
  ClassSlot(
    day: 'Thurs',
    time: '4pm - 6pm',
    subject: 'CIT213 Human Computer Interaction 2',
  ),
];

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(info.icon, color: Theme.of(context).colorScheme.primary),
      title: Text(info.label),
      subtitle: Text(info.value),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _cell(Widget child) =>
      Padding(padding: const EdgeInsets.all(8), child: child);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Gleih Cen Sayno')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/gley.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: '...',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gleih Cen Lopez Sayno',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "if it's for you, edi thank you!",
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final info in infos) InfoTile(info: info),
            const SizedBox(height: 16),
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
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
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
                    Text('My Class Schedule', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: colors.outlineVariant),
                      columnWidths: const {
                        0: FixedColumnWidth(52),
                        1: FixedColumnWidth(120),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: colors.primaryContainer),
                          children: [
                            _cell(Text('Day', style: textTheme.titleSmall)),
                            _cell(Text('Time', style: textTheme.titleSmall)),
                            _cell(Text('Subject', style: textTheme.titleSmall)),
                          ],
                        ),
                        for (final c in classes)
                          TableRow(
                            children: [
                              _cell(Text(c.day)),
                              _cell(Text(c.time)),
                              _cell(Text(c.subject)),
                            ],
                          ),
                      ],
                    ),
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
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "Hi! I'm Gleih Cen Lopez Sayno, a 20-year-old BSIT student at Western Visayas State University in Iloilo City. I'm learning to build apps and websites that are simple to use. When I'm not studying, I like dancing, reading, or binge-watching a movie or series. I also have a dog named Sreit.",
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