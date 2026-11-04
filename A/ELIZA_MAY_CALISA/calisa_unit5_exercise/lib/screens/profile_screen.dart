import 'package:flutter/material.dart';

import '../models/profile_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'West Visayas State University - BSIT 3A',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Cabatuan, Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.sports_esports,
      label: 'Hobbies',
      value: 'Reading, Watching Movies, Listening to Music, Playing Games',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Chocolate Cake, Fries, Coffee',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'elizamay.calisa@wvsu.edu.ph',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Eliza May Calisa')),
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
                    'assets/images/portfolio.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Eliza May Calisa',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eliza May Calisa',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Building functional digital experiences from the ground up.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
                      'I am a 3rd-year Bachelor of Science in Information Technology student passionate about software development and modern web technologies. Currently honing my skills in front-end and back-end programming, I enjoy transforming ideas into functional, user-friendly applications. As I prepare for my capstone project and industry internship, I am actively building personal projects, mastering new frameworks, and seeking opportunities to collaborate on real-world tech solutions.',
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
