import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF000A05);
    const accentColor = Color(0xFFFB3640);

    return MaterialApp(
      title: 'Justin Jerrickho Amaguin',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: accentColor,
              brightness: Brightness.dark,
            ).copyWith(
              primary: accentColor,
              onPrimary: Colors.white,
              secondary: accentColor,
              onSecondary: Colors.white,
              surface: backgroundColor,
            ),
        scaffoldBackgroundColor: backgroundColor,
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
      body: _selectedIndex == 0 ? const ProfileScreen() : const MyPetScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _fullName = 'Justin Jerrickho Amaguin';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Gmail',
      value: 'justinamaguin818@gmail.com',
    ),
    ProfileInfo(icon: Icons.school_outlined, label: 'Course', value: 'CC 207B'),
    ProfileInfo(
      icon: Icons.sports_soccer,
      label: 'Hobbies',
      value: 'Video editing, football',
    ),
    ProfileInfo(
      icon: Icons.edit_outlined,
      label: 'Skills',
      value: 'Editing, coding, leadership',
    ),
    ProfileInfo(
      icon: Icons.coffee_outlined,
      label: 'Fun fact',
      value: 'Addicted to coffee',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(_fullName)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      image: true,
                      label: 'Photo of $_fullName',
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: const AssetImage(
                          'assets/images/headshot.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_fullName, style: theme.textTheme.headlineSmall),
                          Text('Halloooo', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('About Me', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [for (final info in infos) InfoTile(info: info)],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'I enjoy video editing because it lets me turn raw '
                          'clips into stories. I like experimenting with '
                          'cuts, transitions, music, and pacing to make each '
                          'video engaging. I hope to keep improving my skills '
                          'and create polished videos that people enjoy '
                          'watching. :>',
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
      ),
    );
  }
}

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

class MyPetScreen extends StatefulWidget {
  const MyPetScreen({super.key});

  @override
  State<MyPetScreen> createState() => _MyPetScreenState();
}

class _MyPetScreenState extends State<MyPetScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription<void> _completionSubscription;
  int _meowCount = 0;
  bool _isPlaying = false;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
      });
    });
  }

  Future<void> _playMeow() async {
    setState(() {
      _isPlaying = true;
      _meowCount++;
    });

    try {
      await _audioPlayer.play(AssetSource('sounds/Meow.mp3'));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not play the meow sound: $error')),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_completionSubscription.cancel());
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            _showHeart = !_showHeart;
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                _isPlaying
                                    ? 'assets/images/PopcatOpen.jpg'
                                    : 'assets/images/PopcatClosed.webp',
                                fit: BoxFit.cover,
                                semanticLabel: _isPlaying
                                    ? 'Popcat with mouth open'
                                    : 'Popcat with mouth closed',
                              ),
                              if (_showHeart)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Icon(
                                      Icons.favorite,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('PopCat', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'PopCat is my favorite animal.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PopCat has meowed $_meowCount '
                      '${_meowCount == 1 ? 'time' : 'times'}.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _isPlaying ? null : _playMeow,
                      icon: const Icon(Icons.volume_up),
                      label: Text(_isPlaying ? 'Playing...' : 'Play meow'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
