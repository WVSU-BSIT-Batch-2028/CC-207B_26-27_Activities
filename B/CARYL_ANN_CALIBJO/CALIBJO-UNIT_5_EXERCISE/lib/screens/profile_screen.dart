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
    ProfileInfo(
      icon: Icons.favorite,
      label: 'Hobbies',
      value: 'Reading, Dancing, Singing, Writing',
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
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(_biography, style: textTheme.bodyMedium),
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
