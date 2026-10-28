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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Joseph Angelo Japitana';

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
      icon: Icons.music_note,
      label: 'Music',
      value: 'Playing the guitar',
    ),
    ProfileInfo(
      icon: Icons.brush,
      label: 'Art',
      value: 'Drawing',
    ),
    ProfileInfo(
      icon: Icons.fitness_center,
      label: 'Activities',
      value: 'All kinds of physical activities',
    ),
    ProfileInfo(
      icon: Icons.bedtime,
      label: 'Favorite Pastime',
      value: 'Sleeping',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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