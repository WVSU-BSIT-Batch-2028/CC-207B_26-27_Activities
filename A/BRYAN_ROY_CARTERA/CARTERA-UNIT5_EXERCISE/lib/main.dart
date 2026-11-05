
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bryan Roy Cartera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProfileScreen(),
      const PetScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
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

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          info.icon,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        info.label,
        style: theme.textTheme.labelLarge,
      ),
      subtitle: Text(
        info.value,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'BS Information Technology',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.favorite,
      label: 'Hobbies',
      value: 'Gaming, coding, and music',
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: 'Interests',
      value: 'Technology and app development',
    ),
    ProfileInfo(
      icon: Icons.flag,
      label: 'Goal',
      value: 'Become a skilled IT professional',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bryan Roy Cartera'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Semantics(
                      image: true,
                      label: 'Photo of Bryan Roy Cartera',
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: const AssetImage(
                          'assets/images/Profile.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bryan Roy Cartera',
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Learning today, building tomorrow!',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Get to Know Me',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  for (final info in infos)
                    InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.tertiaryContainer,
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
                      'I am Bryan Roy Cartera, a BS Information '
                      'Technology student who enjoys learning about '
                      'technology, exploring new ideas, and developing '
                      'my programming skills. I believe every challenge '
                      'is an opportunity to learn and grow.',
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

// Temporary placeholder; we will implement the interactive pet screen next.

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _showHeart = false;
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();

    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _playSound() async {
  try {
    await _player.stop();
    await _player.setVolume(1.0);

    await _player.play(
      AssetSource('sounds/petsound.wav'),
    );

    debugPrint('Dog sound playback requested');

    if (!mounted) return;

    setState(() {
      _barkCount++;
      _isPlaying = true;
    });
  } catch (error, stackTrace) {
    debugPrint('Audio playback error: $error');
    debugPrint('$stackTrace');

    if (!mounted) return;

    setState(() {
      _isPlaying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Audio error: $error'),
      ),
    );
  }
}

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Best Friend'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Meet My Dog!',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Double-tap the photo to show some love!',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _showHeart = !_showHeart;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Semantics(
                              image: true,
                              label: 'Photo of my dog',
                              child: Image.asset(
                                'assets/images/Pet.jpg',
                                width: double.infinity,
                                height: 280,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (_showHeart)
                            Icon(
                              Icons.favorite,
                              size: 100,
                              color: theme.colorScheme.error,
                              shadows: const [
                                Shadow(
                                  blurRadius: 15,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isPlaying ? null : _playSound,
                        icon: Icon(
                          _isPlaying
                              ? Icons.hourglass_top
                              : Icons.volume_up,
                        ),
                        label: Text(
                          _isPlaying ? 'Playing...' : 'Play Dog Sound',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'My dog has barked $_barkCount times.',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
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

