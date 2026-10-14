import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Profile & My Pet',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 9, 100, 35),
        useMaterial3: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? ProfileScreen.fullName : 'My Pet',
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [ProfileScreen(), PetScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'My Pet',
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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 3),
                Text(info.value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String fullName = 'Ellisa Shammah Bonete';
  static const String tagline = 'Curious mind. Future IT professional.';
  static const String biography =
      'I am an Information Technology student who enjoys learning, '
      'solving problems, and exploring how technology can improve '
      'everyday life. I love working on creative projects and building '
      'useful applications. My goal is to keep growing as a developer '
      'and create solutions that make a positive difference.';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Course',
      value: 'Bachelor of Science in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.apartment_outlined,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Location',
      value: 'Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.sports_esports_outlined,
      label: 'Hobbies',
      value: 'Sleeping, coding, exploring new ideas, and creative design',
    ),
    ProfileInfo(
      icon: Icons.code_outlined,
      label: 'Favorite Technology',
      value: 'React, Flutter, and Dart',
    ),
    ProfileInfo(
      icon: Icons.flag_outlined,
      label: 'Personal Goal',
      value: 'Build useful and accessible apps',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 340;
    final avatarSize = narrow ? 76.0 : 106.0;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                            semanticLabel:
                                'Profile image of Ellisa Shammah Bonete',
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: theme.textTheme.headlineSmall,
                                softWrap: true,
                              ),
                              const SizedBox(height: 6),
                              Text(tagline, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About Me', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),

                        for (final info in infos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text(biography, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PetDetails {
  final String name;
  final String animal;
  final String soundVerb;
  final String? note;

  const PetDetails({
    required this.name,
    required this.animal,
    required this.soundVerb,
    this.note,
  });
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const PetDetails pet = PetDetails(
    name: 'Mochi',
    animal: 'Rabbit',
    soundVerb: 'squeaked',
    note: 'This is my favorite animal: this rabbit illustration is not a '
        'photo of my own pet since I do not have a pet.',
  );

  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<void> _completionSubscription;

  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _completionSubscription.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() => _isPlaying = true);

    try {
      await _player.play(AssetSource('sounds/pet_sound.wav'));
      if (!mounted) return;
      setState(() => _playCount++);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not play the sound. Check the sound asset.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Meet ${pet.name}!',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  pet.animal,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(
                            'assets/images/pet.png',
                            fit: BoxFit.cover,
                            semanticLabel:
                                'Illustration of ${pet.name} the ${pet.animal}',
                          ),
                        ),
                      ),
                      if (_showHeart)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Icon(
                            Icons.favorite,
                            size: 50,
                            color: theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _showHeart
                      ? 'Favorited! Double-tap again to remove the heart.'
                      : 'Double-tap the picture to show a heart.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(
                    _isPlaying ? Icons.graphic_eq : Icons.volume_up_rounded,
                  ),
                  label: Text(_isPlaying ? 'Playing...' : 'Play rabbit sound'),
                ),
                const SizedBox(height: 12),
                Text(
                  '${pet.name} has ${pet.soundVerb} $_playCount '
                  '${_playCount == 1 ? 'time' : 'times'}.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (pet.note != null) ...[
                  const SizedBox(height: 18),
                  Text(
                    pet.note!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
