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
    ProfileInfo(icon: Icons.code, label: 'Hobbies', value: 'Web development, Photo editing'),
  ];

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
          ],
        ),
      ),
    );
  }
}