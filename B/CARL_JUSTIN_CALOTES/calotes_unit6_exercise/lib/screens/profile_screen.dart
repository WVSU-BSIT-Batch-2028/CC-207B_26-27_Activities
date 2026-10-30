
import 'package:flutter/material.dart';
import '../profile_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final profileInfo = [
      const ProfileInfo(
        icon: Icons.school,
        label: 'Course',
        value: 'BSIT',
      ),
      const ProfileInfo(
        icon: Icons.cake,
        label: 'Birthday',
        value: 'March 24, 2006',
      ),
      const ProfileInfo(
        icon: Icons.email,
        label: 'Email',
        value: 'carljustin.calotes@wvsu.edu.ph',
      ),
      const ProfileInfo(
        icon: Icons.star,
        label: 'Favorite Artist',
        value: 'BLACKPINK',
      ),
      const ProfileInfo(
        icon: Icons.favorite,
        label: 'Favorite Character',
        value: 'Phainon (Honkai: Star Rail)',
      ),
    ];

    final hobbies = [
      'Gaming',
      'Sleeping',
      'Listening to Music',
      'Watching Anime',
      'Chatting with Friends',
    ];

    final schedule = [
      ['Mon', '9:00-12:00', 'CIT 251 Security Compliance and Governance'],
      ['Tue', '7:00-9:00', 'CIT 210 Web Systems and Technologies'],
      ['Wed', '4:00-6:00', 'CIT 207B Application Development and Emerging Technologies'],
      ['Thu', '11:30-1:00', 'BA 234 Technopreneurship'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carl Justin Calotes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/Carla.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel:
                        'Profile photo of Carl Justin C. Calotes',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carl Justin C. Calotes',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Student',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final info in profileInfo)
                  SizedBox(
                    width:
                        (MediaQuery.of(context).size.width - 34) / 2,
                    child: Card(
                      color: colorScheme.surfaceContainerLow,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              info.icon,
                              size: 22,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              info.label,
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              info.value,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Card(
              color: colorScheme.surfaceContainerLow,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies)
                          Chip(
                            label: Text(hobby),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: colorScheme.primaryContainer,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hi~ I am Carl Justin Calotes and this will be '
                      'a romantic story like none that has come before. '
                      'You think so too, right? Just kidding hehehehe. '
                      'I am currently addicted to gacha games but I am '
                      'trying to quit, wish me luck!',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: colorScheme.surfaceContainerLow,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: colorScheme.outlineVariant,
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(1.1),
                        2: FlexColumnWidth(2.8),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                          ),
                          children: [
                            _scheduleCell('Day', true),
                            _scheduleCell('Time', true),
                            _scheduleCell('Subject', true),
                          ],
                        ),
                        for (final row in schedule)
                          TableRow(
                            children: [
                              _scheduleCell(row[0]),
                              _scheduleCell(row[1]),
                              _scheduleCell(row[2]),
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

  Widget _scheduleCell(String value, [bool isHeader = false]) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        value,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
