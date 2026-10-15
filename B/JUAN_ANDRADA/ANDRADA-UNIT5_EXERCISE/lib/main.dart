import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// App + theme
// ---------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juan Andrada',
      debugShowCheckedModeBanner: false,
      // Change this one color and every screen follows.
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeShell: bottom navigation between Profile and My Pet
// ---------------------------------------------------------------------------

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ProfileScreen(),
    PetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the pet counter when you switch tabs.
      body: IndexedStack(index: _selectedIndex, children: _screens),
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

// ---------------------------------------------------------------------------
// Profile data model
// ---------------------------------------------------------------------------

class ProfileInfo {
  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

// ---------------------------------------------------------------------------
// Profile screen (stateless: it only shows information)
// ---------------------------------------------------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String fullName = 'Juan Miguel Rashley Andrada';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: 'Course and Section',
      value: 'BS Information Technology, 3-B',
    ),
    ProfileInfo(
      icon: Icons.home,
      label: 'Hometown',
      value: 'Leon, Iloilo',
    ),
    ProfileInfo(
      icon: Icons.fitness_center,
      label: 'Hobbies',
      value: 'Gym and Sports',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Spaghetti',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Juan Miguel Andrada')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile row: photo on the left, name and tagline on the right
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/me.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Juan Miguel Rashley Andrada',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        'BSIT student, gym regular, and spaghetti lover.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Information section built from the list (no copy-paste)
            Card(
              child: Column(
                children: [
                  for (final info in infos) InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Biography
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "I'm Juan Miguel Rashley Andrada, a BSIT 3-B student at "
                      'West Visayas State University, and I grew up in Leon, '
                      'Iloilo. Outside of class, I spend most of my free time '
                      'at the gym and playing sports, which keep me disciplined '
                      'and energized for school. I enjoy building apps and '
                      'learning how technology can solve everyday problems. '
                      'And if you ever want to make my day, a plate of '
                      'spaghetti always works.',
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

// One row in the information section
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

// ---------------------------------------------------------------------------
// Pet screen (stateful: it reacts to taps)
// ---------------------------------------------------------------------------

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const String petName = 'Louie';

  // Created once, released in dispose()
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;

  bool _isPlaying = false;
  bool _showHeart = false;
  int _meowCount = 0;

  @override
  void initState() {
    super.initState();
    // Turn the button back on when the sound finishes
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _meowCount++;
    });

    try {
      // AssetSource already adds "assets/" in front of this path
      await _player.play(AssetSource('sounds/meow.mp3'));
    } catch (e) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final timesWord = _meowCount == 1 ? 'time' : 'times';

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo with double-tap heart
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/images/pet.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of $petName, my cat',
                          ),
                        ),
                      ),
                      if (_showHeart)
                        Icon(
                          Icons.favorite,
                          size: 120,
                          color: theme.colorScheme.error,
                          semanticLabel: 'Heart',
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Double-tap the photo to show some love.',
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  petName,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Sound button
                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Playing...' : "Play $petName's meow"),
                ),
                const SizedBox(height: 16),

                // Counter
                Text(
                  '$petName has meowed $_meowCount $timesWord.',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}