import 'package:flutter/material.dart';

import '../models/profile_info.dart';
import '../widgets/info_tile.dart';

// TODO: replace the placeholder values below with your own details.
const String fullName = 'Mark Angelo A. Jamela';
const String tagline = 'BSIT 3-A student who loves building apps.';

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.cake, label: 'Birthdate', value: 'July 18, 2006'),
  ProfileInfo(icon: Icons.home, label: 'Address', value: 'Iloilo, Philippines'),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'markangelo.jamela@wvsu.edu.ph',
  ),
  ProfileInfo(icon: Icons.phone, label: 'Phone Number', value: '09388244039'),
  ProfileInfo(
    icon: Icons.school,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.menu_book,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
  ProfileInfo(
    icon: Icons.sports_esports,
    label: 'Hobbies',
    value: 'Coding, Gaming',
  ),
];

const String biography =
    'I am Mark Angelo A. Jamela, a third-year BSIT student at West Visayas '
    'State University in Iloilo City. I enjoy coding, building apps, and '
    'learning new technologies that make everyday tasks easier. When I am '
    'not studying, I like playing badminton and spending time with my dog, '
    'Luna. I am working toward a career in software development, one project '
    'at a time.';

/// Display-only screen, so everything here is stateless.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(fullName),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile row: circular photo on the left, name + tagline right.
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $fullName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(tagline, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Information section built with a collection-for.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (final info in infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Biography card.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(biography, style: theme.textTheme.bodyMedium),
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
