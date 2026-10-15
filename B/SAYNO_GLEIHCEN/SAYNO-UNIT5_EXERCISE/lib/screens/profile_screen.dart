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
  ProfileInfo(
    icon: Icons.interests,
    label: 'Hobbies',
    value: 'Dancing, sleeping, reading, binge-watching movies/series',
  ),
  ProfileInfo(icon: Icons.pets, label: 'Pet', value: 'Sreit (dog)'),
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                    semanticLabel: 'Photo of Gleih Cen Sayno',
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