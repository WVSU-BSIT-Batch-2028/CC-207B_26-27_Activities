import 'package:flutter/material.dart';

import '../models/profile_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Jenny Mae Navea';

  static const List<ProfileInfo> _infos = [
    ProfileInfo(
      icon: Icons.cake,
      label: 'Birthdate',
      value: 'February 3, 2006',
    ),
    ProfileInfo(
      icon: Icons.home,
      label: 'Address',
      value: 'Buyo, Santa Barbara, Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'jennymae.navea@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(icon: Icons.computer, label: 'Course', value: 'Bachelor of Science in Information Technology'),
    ProfileInfo(
      icon: Icons.favorite,
      label: 'Hobbies',
      value: 'Playing games, watching movies, listening to music, and solving Rubik\'s cube',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(_name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/my_photo.jpg',
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of $_name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Living simply, learning daily, and loving life.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'A little about me',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (final info in _infos) InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'My Biography',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hello! My name is Jenny Mae Navea, and I call Santa Barbara, Iloilo my home. I am currently 20 years old and navigating my 3rd year at West Visayas State University as a BSIT student. Outside of my classes, I describe myself as a grounded and easygoing person who loves spending quiet time at home. My pet is a huge part of my daily life, and nothing beats unwinding together after a long school day while listening to good music. I thrive in calm spaces, enjoy discovering new personal hobbies, and treasure honest conversations with the people I hold dear. No matter how busy life gets, I make it a point to appreciate the small things and keep a positive outlook.',
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
