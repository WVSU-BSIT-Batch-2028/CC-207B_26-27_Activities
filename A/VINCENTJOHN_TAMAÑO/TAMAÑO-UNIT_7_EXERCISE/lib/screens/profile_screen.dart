import 'package:flutter/material.dart';
import '../models/class_slot.dart';
import '../models/profile_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> profileInfos = [
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Degree & Track',
      value: 'BS Information Technology - Cybersecurity Track',
    ),
    ProfileInfo(
      icon: Icons.account_balance_outlined,
      label: 'University',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'vincentjohntamano123@gmail.com',
    ),
    ProfileInfo(
      icon: Icons.phone_outlined,
      label: 'Phone',
      value: '+63 945 682 9136',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
  ];

  static const List<String> hobbies = [
    'Fishing',
    'Gaming',
    'Gym & Fitness',
    'Linux Homelab',
    'Cybersecurity CTFs',
    'Mobile App Dev',
  ];

  static const List<ClassSlot> classSchedule = [
    ClassSlot(day: 'Mon', time: '7:30–9:30 AM', subject: 'CIT 213 · ICT 106'),
    ClassSlot(day: 'Mon', time: '9:30–12:30 PM', subject: 'CIT 251 · ICT 305'),
    ClassSlot(day: 'Mon', time: '1:30–3:30 PM', subject: 'CIT 210 · ICT 307'),
    ClassSlot(day: 'Tue', time: '9:30–12:30 PM', subject: 'CC 207B · ICT 307'),
    ClassSlot(day: 'Tue', time: '1:30–2:30 PM', subject: 'BA 234 · ICT 107'),
    ClassSlot(day: 'Wed', time: '7:30–10:30 AM', subject: 'CIT 213 · ICT 306'),
    ClassSlot(day: 'Wed', time: '10:30–12:30 PM', subject: 'CIT 251 · ICT 305'),
    ClassSlot(day: 'Thu', time: '10:30–12:30 PM', subject: 'CC 207B · ICT 307'),
    ClassSlot(day: 'Thu', time: '4:30–6:30 PM', subject: 'CIT 212 · ICT 305'),
  ];

  Widget _tableCell(BuildContext context, String text, {bool isHeader = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Text(
        text,
        style: isHeader
            ? theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              )
            : theme.textTheme.bodySmall,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincent John Tamaño'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/ProfileLight.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Vincent John Tamaño',
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vincent John Tamaño',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'BSIT Cybersecurity Student · Aspiring Sysadmin',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            Text(
              'Profile Information',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8.0),

            for (final info in profileInfos) InfoTile(info: info),

            const SizedBox(height: 16.0),

            // Part C.a: Hobbies as Chips in Wrap
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Part C.b: Class Schedule Table with actual schedule
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Table(
                      border: TableBorder.all(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(52),
                        1: FixedColumnWidth(110),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            _tableCell(context, 'Day', isHeader: true),
                            _tableCell(context, 'Time', isHeader: true),
                            _tableCell(context, 'Subject', isHeader: true),
                          ],
                        ),
                        for (final slot in classSchedule)
                          TableRow(
                            children: [
                              _tableCell(context, slot.day),
                              _tableCell(context, slot.time),
                              _tableCell(context, slot.subject),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'I am Vincent John Tamaño, a BS Information Technology student specializing in Cybersecurity at West Visayas State University. I am passionate about securing enterprise networks, managing self-hosted Linux homelab systems, and developing software applications. I continuously explore new technologies in systems administration, network engineering, and cross-platform mobile development.',
                      style: theme.textTheme.bodyMedium,
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
