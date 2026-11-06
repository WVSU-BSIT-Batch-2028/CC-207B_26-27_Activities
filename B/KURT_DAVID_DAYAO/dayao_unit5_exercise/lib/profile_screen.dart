import 'package:flutter/material.dart';
import 'profile_info.dart';

const String fullName = 'Kurt David G. Dayao';

const String tagline = 'A BSIT student who is barely surviving.';

const List<ProfileInfo> infos = [
  ProfileInfo(
    icon: Icons.cake,
    label: 'Birthday',
    value: 'March 28, 2004',
  ),
  ProfileInfo(
    icon: Icons.home,
    label: 'Address',
    value: 'Brgy. Oyungan, Miag-ao, Iloilo, Philippines',
  ),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'kurtdavid.dayao@wvsu.edu.ph',
  ),
  ProfileInfo(
    icon: Icons.school,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.computer,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
  ProfileInfo(
    icon: Icons.favorite,
    label: 'Hobbies',
    value: 'Smoking, Dringking, Reading, Sleeping, and Gaming',
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    return Scaffold(

      appBar: AppBar(title: const Text(fullName)),

  
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Row(
              children: [
                ClipOval(
                  child: Image.asset(

                    'assets/images/profile.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,

                    semanticLabel: 'Photo of $fullName',

                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 96,
                      height: 96,
                      color: colors.primaryContainer,
                      child: Icon(Icons.person, color: colors.onPrimaryContainer),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(tagline, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


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

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),

                    Text(
                      'An easy going type of person who loves to play, read, drink and do whatever that '
                      'stimulates me. I live in Miag-ao, Iloilo, I am 22 yrs old and currently a BSIT student. '
                      'Hopefully, I can survive this semester just like the previous ones and graduate.',
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

// One row of the information section: icon, label, and value.
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          // Expanded lets long values wrap to the next line.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: theme.textTheme.labelLarge),
                Text(info.value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}