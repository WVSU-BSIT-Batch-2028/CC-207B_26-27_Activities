import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// Own information
// ---------------------------------------------------------------------------
const String kFullName = 'Justin Ace Ardeña';
const String kTagline = 'BSIT student 24/7 on Duty.';
const String kPhotoAsset = 'assets/images/profile.jpg';
const String kPetPhotoAsset = 'assets/images/pet.jpg';
const String kPetSoundAsset = 'sounds/pet_sound.wav'; // relative to assets/
const String kPetName = 'Sherbert';
const String kPetVerb = 'squeaked';
const String kBiography =
    'I am a Bachelor of Science in Information Technology student at West '
    'Visayas State University. I enjoy learning how networks work with '
    'Cybersecurity, solving problems through code, and spending time with my pet. '
    '(I dont actually like pets LMAO)';

const List<ProfileInfo> kInfos = [
  ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT'),
  ProfileInfo(icon: Icons.location_on, label: 'Location', value: 'Iloilo City'),
  ProfileInfo(
      icon: Icons.sports_tennis, label: 'Hobbies', value: 'Basketball, Gaming, Mukbang'),
  ProfileInfo(icon: Icons.email, label: 'Email', value: 'justinace.ardena@wvsu.edu.ph'),
  ProfileInfo(
      icon: Icons.restaurant, label: 'Favorite Food', value: 'Unli Chicken Wings!'),
  ProfileInfo(icon: Icons.pets, label: 'Imaginary Pet', value: 'Sherbert (Monkey)'),
];

// ---------------------------------------------------------------------------
// App root
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  final scheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
  return MaterialApp(
    title: 'Unit 5 Exercise',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
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

  static const List<Widget> _screens = [ProfileScreen(), PetScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the Pet screen's state (counter, heart) alive
      // while the user switches tabs.
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
          NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'My Pet'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile screen (all stateless)
// ---------------------------------------------------------------------------
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
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyLarge),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(kFullName)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile row: circular photo + Expanded text column
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      kPhotoAsset,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $kFullName',
                      errorBuilder: (_, __, ___) => const SizedBox(
                        width: 96,
                        height: 96,
                        child: Icon(Icons.person, size: 64),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kFullName, style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(kTagline, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Information section built with collection-for
              Card(
                child: Column(
                  children: [
                    for (final info in kInfos) InfoTile(info: info),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Biography
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(kBiography, style: theme.textTheme.bodyMedium),
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

// ---------------------------------------------------------------------------
// Pet screen (stateful)
// ---------------------------------------------------------------------------
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer(); // created once
  bool _isPlaying = false;
  bool _liked = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose(); // release what you created
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _count++;
    });
    try {
      // AssetSource looks inside the assets/ folder
      await _player.play(AssetSource(kPetSoundAsset));
    } catch (_) {
      // If the sound can't be played, don't leave the button disabled.
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet Sherbert')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onDoubleTap: () => setState(() => _liked = !_liked),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          kPetPhotoAsset,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of my pet, $kPetName',
                          errorBuilder: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.pets, size: 96),
                          ),
                        ),
                      ),
                    ),
                    if (_liked)
                      Icon(Icons.favorite,
                          size: 96, color: theme.colorScheme.error),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlaying ? 'Playing...' : 'Make $kPetName bark'),
              ),
              const SizedBox(height: 16),
              Text(
                '$kPetName has $kPetVerb $_count '
                '${_count == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Double-tap the photo to give $kPetName a heart.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
