import 'package:flutter/material.dart';
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
      icon: Icons.sports_esports_outlined,
      label: 'Hobbies & Interests',
      value: 'Fishing, Games, Gym',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
  ];

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

            const SizedBox(height: 24.0),

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
