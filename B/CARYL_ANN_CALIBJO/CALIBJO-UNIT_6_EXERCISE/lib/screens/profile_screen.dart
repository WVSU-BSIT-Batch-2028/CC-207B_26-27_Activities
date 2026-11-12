import 'package:flutter/material.dart';

/// One row of information: an icon, a label and a value.
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

/// Draws one ProfileInfo as a row.
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: colors.primary),
          const SizedBox(width: 16),
          // Expanded lets a long value wrap instead of overflowing.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: textTheme.labelLarge),
                Text(info.value, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One class meeting: the day, the time and the subject.
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

/// One padded cell of the schedule table.
class ScheduleCell extends StatelessWidget {
  const ScheduleCell(this.text, {super.key, this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Text(
        text,
        style: bold ? style?.copyWith(fontWeight: FontWeight.bold) : style,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _infos = <ProfileInfo>[
    ProfileInfo(icon: Icons.cake, label: 'Birthdate', value: 'October 9, 2005'),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Address',
      value: 'Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'carylann.calibjo@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value:
          'Bachelor of Science in Information Technology, '
          'specializing in Cybersecurity',
    ),
  ];

  static const _hobbies = <String>[
    'Singing',
    'Dancing',
    'Reading',
    'Walking',
    'Watching movies/series',
    'Fiction writing',
  ];

  static const _schedule = <ClassSlot>[
    ClassSlot(
      day: 'Mon',
      time: '09:00-12:00',
      subject: 'Security Compliance and Governance',
    ),
    ClassSlot(day: 'Mon', time: '13:00-15:00', subject: 'Networking 2'),
    ClassSlot(
      day: 'Tue',
      time: '07:00-09:00',
      subject: 'Web Systems and Technologies',
    ),
    ClassSlot(day: 'Tue', time: '11:30-13:00', subject: 'Technopreneurship'),
    ClassSlot(
      day: 'Tue',
      time: '13:00-14:30',
      subject: 'Methods of Research in Computing',
    ),
    ClassSlot(
      day: 'Wed',
      time: '10:00-12:00',
      subject: 'Security Compliance and Governance',
    ),
    ClassSlot(day: 'Wed', time: '13:00-16:00', subject: 'Networking 2'),
    ClassSlot(
      day: 'Thu',
      time: '07:00-10:00',
      subject: 'Web Systems and Technologies',
    ),
    ClassSlot(day: 'Thu', time: '11:30-13:00', subject: 'Technopreneurship'),
    ClassSlot(
      day: 'Thu',
      time: '13:00-14:30',
      subject: 'Methods of Research in Computing',
    ),
  ];

  static const _biography =
      // 'I am a Bachelor of Science in Information Technology student at '
      // 'West Visayas State University, specializing in Cybersecurity. '
      // 'I am curious by nature. When something behaves oddly, I follow it '
      // 'until I understand why, and I notice the small details others skip. '
      // 'Attacks change every month, so I treat learning as a habit, not a '
      // 'phase. I served in the student council from my freshman to '
      // 'sophomore year, where I grew as a leader and learned to connect '
      // 'with people. I read people and situations with care, and I stay '
      // 'focused under pressure. Outside class, I write stories, keep a '
      // 'journal, and read self-help and romance. I hope to join a company '
      // 'where I can grow in cybersecurity and act with integrity.';
      'I am a Bachelor of Science in Information Technology student at '
      'West Visayas State University, specializing in Cybersecurity. '
      'I have always been curious. When something acts strangely, I follow '
      'it until it makes sense, and I enjoy the small details most people '
      'walk past. Technology keeps changing, so I treat learning as a '
      'habit.\n\n'
      'I served in the student council from my freshman to sophomore year. '
      'It taught me how to lead, and it taught me how to listen. I pay '
      'attention to people and to the moment, which helps me stay calm '
      'when things get tense.\n\n'
      'Outside class, I write stories, keep a journal, and read '
      'self-help and romance. These quiet habits keep me grounded. '
      'I hope to join a company where I can grow in cybersecurity, '
      'work with good people, and act with integrity.';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/me.jpg',
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Caryl Ann Calibjo',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Caryl Ann Calibjo', style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        'Curious by nature. Calm under pressure. '
                        'Keeping watch, so others don\'t have to.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Collection-for: one InfoTile per item in _infos.
                    for (final info in _infos) InfoTile(info: info),
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
                    Text('My Hobbies', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    // Wrap moves chips to the next line when a row is full.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Collection-for: one Chip per hobby.
                        for (final hobby in _hobbies) Chip(label: Text(hobby)),
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
                    Text(_biography, style: textTheme.bodyMedium),
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
                      // Day and Time keep fixed widths. Subject takes the rest.
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                        1: FixedColumnWidth(84),
                        2: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        // Header row: theme background colour and bold text.
                        TableRow(
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                          ),
                          children: const [
                            ScheduleCell('Day', bold: true),
                            ScheduleCell('Time', bold: true),
                            ScheduleCell('Subject', bold: true),
                          ],
                        ),
                        // Collection-for: one TableRow per class.
                        for (final slot in _schedule)
                          TableRow(
                            children: [
                              ScheduleCell(slot.day),
                              ScheduleCell(slot.time),
                              ScheduleCell(slot.subject),
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
