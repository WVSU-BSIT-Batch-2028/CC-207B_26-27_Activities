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
        icon: Icons.sports_esports,
        label: 'Hobbies',
        value: 'Gaming & Sleeping',
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
              spacing: 10,
              runSpacing: 10,
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
          ],
        ),
      ),
    );
  }
}
