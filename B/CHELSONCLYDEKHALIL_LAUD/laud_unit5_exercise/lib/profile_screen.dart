import 'package:flutter/material.dart';
import 'profile_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  //Unod sng profile
  static const List<ProfileInfo> _profileDetails = [
    ProfileInfo(icon: Icons.email, label: 'Email', value: 'chelsonclydekhalil.laud@wvsu.edu.ph'),
    ProfileInfo(icon: Icons.location_on, label: 'Address', value: 'Leganes, Iloilo'),
    ProfileInfo(icon: Icons.cake, label: 'Birthdate', value: 'August 23, 2006'),
    ProfileInfo(icon: Icons.phone, label: 'Phone Number', value: '09106401759'),
    ProfileInfo(icon: Icons.school, label: 'Education', value: 'West Visayas State University'),
    ProfileInfo(icon: Icons.code, label: 'Course', value: 'BS in Information Technology'),
    ProfileInfo(icon: Icons.games, label: 'Hobbies', value: 'Sleeping, Gaming, Coding'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chelson Clyde Khalil Laud'),
        elevation: 2
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Semantics(
                  label: 'Photo of Chelson Laud',
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chelson Clyde Khalil Laud',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Live, Laugh, Haha',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            for (final info in _profileDetails) InfoTile(info: info),

            const SizedBox(height: 16),

            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am a 3rd Year student studying Information Technology because they told me the salary is high and I was like wow okay! I enjoy learning new things and building cool stuff in this course because it gives me the wows and the woahs. I spend half my time staring at broken code wondering why it is not working, and the other half wondering why it suddenly works. But no worries, it is what is it.',
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