import 'package:flutter/material.dart';
import 'pet_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme =
        ThemeData(colorSchemeSeed: const Color.fromARGB(255, 38, 90, 40));
    return MaterialApp(
      title: 'Pieza Profile',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'Favorite Animal',
          ),
        ],
      ),
    );
  }
}

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

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'August 19, 2005'),
  ProfileInfo(
      icon: Icons.location_on, label: 'Address', value: 'Pavia, Iloilo'),
  ProfileInfo(
      icon: Icons.email, label: 'Email', value: 'johnemmanuel.pieza@wvsu.edu.ph'),
  ProfileInfo(
      icon: Icons.mic, label: 'Favorite Artist', value: 'Travis Scott'),
  ProfileInfo(
      icon: Icons.music_note,
      label: 'Favorite Song',
      value: 'Apple Pie by Travis Scott'),
  ProfileInfo(
      icon: Icons.school, label: 'Education', value: 'West Visayas State University'),
  ProfileInfo(
      icon: Icons.favorite, label: 'Hobbies', value: 'Music, Gaming'),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('John Emmanuel Pieza'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of John Emmanuel Pieza',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.account_circle, size: 96),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Emmanuel Pieza',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BSIT 3A',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Card.outlined(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    for (final info in infos) ...[
                      InfoTile(info: info),
                      if (!identical(info, infos.last))
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card.outlined(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'I am an IT student who enjoys computers and learning new '
                      'technologies. I am currently learning Flutter and '
                      'building mobile apps. I am also interested in AI Prompts '
                      'and creating projects that solve real-world problems. '
                      'In my free time, I like gaming and listening to music.',
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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          SizedBox(
            width: 130,
            child: Text(
              info.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
