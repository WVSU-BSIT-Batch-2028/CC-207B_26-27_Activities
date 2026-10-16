import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// Replace these three values with your own details.
const String studentName = 'Jesse Antoine G. Tacluyan';
const String petName = 'Coby';
const String animalDescription = 'This is my pet.';

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfileScreen(),
          PetScreen(),
        ],
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
            icon: Icon(Icons.pets),
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

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> infos = const [
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Course',
      value: 'BSIT',
    ),
    ProfileInfo(
      icon: Icons.groups_outlined,
      label: 'Year and Section',
      value: 'BSIT 3-B',
    ),
    ProfileInfo(
      icon: Icons.favorite_border,
      label: 'Hobbies',
      value: 'Gaming, music, drawing and skateboarding',
    ),
    ProfileInfo(
      icon: Icons.sports_esports,
      label: 'Favorite Game',
      value: 'Your favorite game',
    ),
    ProfileInfo(
      icon: Icons.restaurant_outlined,
      label: 'Favorite Food',
      value: 'Ramen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(studentName)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/my_photo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $studentName',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BSIT student who enjoys learning new things.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final info in infos) InfoTile(info: info),
              const SizedBox(height: 8),
              Card(
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
                        'I am a BSIT student who enjoys learning about '
                        'technology, playing games, and exploring new skills. '
                        'I hope to improve my programming abilities and create '
                        'useful applications.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Meet $petName',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                animalDescription,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Semantics(
                image: true,
                label: 'Photo of $petName. Double-tap to toggle a heart.',
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/my_pet.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of $petName',
                          ),
                          if (_showHeart)
                            Center(
                              child: Icon(
                                Icons.favorite,
                                size: 72,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play $petName sound'),
              ),
              const SizedBox(height: 12),
              Text(
                '$petName sound played $_playCount '
                '${_playCount == 1 ? 'time' : 'times'}.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Double-tap the photo to show or hide the heart.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
