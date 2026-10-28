import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kenneth Mac Rene V. Anas | Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF69D2C8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF69D2C8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      themeMode: _themeMode,
      home: HomeShell(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeToggle: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          });
        },
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['Kenneth Mac Rene V. Anas', 'My Pet'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(titles[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: widget.onThemeToggle,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
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
  const ProfileInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: colors.primary),
          const SizedBox(width: 16),
          SizedBox(
            width: 112,
            child: Text(info.label, style: textTheme.titleSmall),
          ),
          Expanded(child: Text(info.value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'West Visayas State University, 2024 to present',
    ),
    ProfileInfo(
      icon: Icons.computer_outlined,
      label: 'Program',
      value: 'BS Information Technology, major in Software Development',
    ),
    ProfileInfo(
      icon: Icons.badge_outlined,
      label: 'Year level',
      value: 'Third year',
    ),
    ProfileInfo(
      icon: Icons.code,
      label: 'Focus',
      value: 'Software development and practical digital solutions',
    ),
    ProfileInfo(
      icon: Icons.groups_outlined,
      label: 'Strengths',
      value: 'Planning, teamwork, research, communication, and problem-solving',
    ),
    ProfileInfo(
      icon: Icons.terminal,
      label: 'Technologies',
      value: 'C++, Java, PHP, JavaScript, HTML, React, Next.js, and MySQL',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'Kennethmacrene.anas@wvsu.edu.ph',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of Kenneth Mac Rene V. Anas',
                        errorBuilder: (context, error, stackTrace) =>
                            ColoredBox(
                              color: colors.primaryContainer,
                              child: SizedBox(
                                width: 88,
                                height: 88,
                                child: Center(
                                  child: Text(
                                    'A',
                                    style: textTheme.headlineLarge?.copyWith(
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kenneth Mac Rene V. Anas',
                            style: textTheme.titleLarge?.copyWith(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Third-year IT student focused on Software Development.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('A little about me', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [for (final info in infos) InfoTile(info: info)],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: colors.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        'I am a third-year Information Technology student at '
                        'West Visayas State University, majoring in Software '
                        'Development. I enjoy building user-centered digital '
                        'solutions and combining software development with '
                        'project planning, research, problem-solving, clear '
                        'communication, and teamwork. I am growing my skills '
                        'through academic and practical projects.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Hobbies', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colors.tertiaryContainer,
                        foregroundColor: colors.onTertiaryContainer,
                        child: const Icon(Icons.sports_esports_outlined),
                      ),
                      title: const Text('Gaming'),
                      subtitle: const Text(
                        'I enjoy playing video games casually offlineand competitively online.',
                      ),
                    ),
                    const Divider(height: 1, indent: 72),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colors.primaryContainer,
                        foregroundColor: colors.onPrimaryContainer,
                        child: const Icon(Icons.menu_book_outlined),
                      ),
                      title: const Text('Reading'),
                      subtitle: const Text(
                        'I enjoy reading books and mangas for fun.',
                      ),
                    ),
                    const Divider(height: 1, indent: 72),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colors.secondaryContainer,
                        foregroundColor: colors.onSecondaryContainer,
                        child: const Icon(Icons.movie_outlined),
                      ),
                      title: const Text('Watching'),
                      subtitle: const Text(
                        'I like watching movies, shows, and animes.',
                      ),
                    ),
                    const Divider(height: 1, indent: 72),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colors.errorContainer,
                        foregroundColor: colors.onErrorContainer,
                        child: const Icon(Icons.fitness_center_outlined),
                      ),
                      title: const Text('Gym'),
                      subtitle: const Text(
                        'I enjoy going to the gym and beefing up.',
                      ),
                    ),
                  ],
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
  late final StreamSubscription<void> _completionSubscription;
  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    unawaited(_completionSubscription.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/dog_bark.mp3'));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add assets/sounds/dog_bark.mp3 to play the sound.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('My favorite animal is dog', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Our dog is cute.', style: textTheme.bodyMedium),
              const SizedBox(height: 20),
              GestureDetector(
                onDoubleTap: () => setState(() => _showHeart = !_showHeart),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/favorite_dog.jpg',
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of a dog, my favorite animal',
                          errorBuilder: (context, error, stackTrace) =>
                              ColoredBox(
                                color: colors.tertiaryContainer,
                                child: Center(
                                  child: Icon(
                                    Icons.pets,
                                    size: 96,
                                    color: colors.onTertiaryContainer,
                                  ),
                                ),
                              ),
                        ),
                        if (_showHeart)
                          Center(
                            child: Icon(
                              Icons.favorite,
                              size: 88,
                              color: colors.tertiary,
                              semanticLabel: 'Favorite animal',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.graphic_eq : Icons.volume_up),
                label: Text(_isPlaying ? 'Barking...' : 'Bark'),
              ),
              const SizedBox(height: 12),
              Text(
                'Dog barked $_playCount ${_playCount == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
