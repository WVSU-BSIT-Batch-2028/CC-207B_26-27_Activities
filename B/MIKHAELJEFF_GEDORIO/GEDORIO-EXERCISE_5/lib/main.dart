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
      title: 'Mikhael Jeff Gedorio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF151C30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
        ),
      ),
      home: const HomeShell(),
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

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const ProfileScreen(),
      const PetScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets_rounded),
            label: 'My Pet',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school_rounded,
      label: 'Course',
      value: 'BS Information Technology • 3rd Year',
    ),
    ProfileInfo(
      icon: Icons.sports_soccer_rounded,
      label: 'Interests',
      value: 'Coding and playing football',
    ),
    ProfileInfo(
      icon: Icons.code_rounded,
      label: 'Skills',
      value: 'Flutter and vibe coding',
    ),
    ProfileInfo(
      icon: Icons.functions_rounded,
      label: 'Problem solving',
      value: 'I love solving problems related to numbers',
    ),
    ProfileInfo(
      icon: Icons.work_outline_rounded,
      label: 'Part-time work',
      value: 'Virtual Assistant',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Semantics(
                          image: true,
                          label: 'Photo of Mikhael Jeff Gedorio',
                          child:CircleAvatar(
                              radius: 44,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              backgroundImage: const AssetImage('assets/images/profile.jpg'),
                            ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mikhael Jeff Gedorio',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Student • Athlete • Virtual Assistant',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text('A LITTLE ABOUT ME', style: textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.5,
                )),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      for (final info in infos) InfoTile(info: info),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 10),
                            Text('My Biography',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'I am a 20-year-old student at West Visayas State '
                          'University who loves playing football, gaming, '
                          'and hanging out with friends. I enjoy solving '
                          'problems involving numbers, learning Flutter, and '
                          'exploring new ways to build useful apps. I also '
                          'work part-time as a Virtual Assistant.',
                          style: textTheme.bodyMedium?.copyWith(height: 1.6),
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
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(info.icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
                const SizedBox(height: 4),
                Text(info.value, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ],
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
      await _player.play(AssetSource('sounds/dog_bark.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not play the sound. Check assets/sounds/dog_bark.mp3.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet Haru'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'MY FOUR-LEGGED FRIEND',
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A little bark, a lot of love.',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(
                            'assets/images/haru.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Haru, my dog',
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: theme.colorScheme.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.pets_rounded,
                                        size: 72,
                                        color: theme.colorScheme.primary),
                                    const SizedBox(height: 12),
                                    Text('Add Haru’s photo to continue',
                                        style: textTheme.bodyMedium),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_showHeart)
                        Icon(
                          Icons.favorite_rounded,
                          size: 92,
                          color: theme.colorScheme.primary,
                          shadows: const [
                            Shadow(blurRadius: 24, color: Colors.black54),
                          ],
                        ),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.62),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Text('HARU  •  MY DOG',
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Double-tap Haru’s photo to show or hide the heart.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.graphic_eq_rounded,
                            size: 34, color: theme.colorScheme.primary),
                        const SizedBox(height: 8),
                        Text('Hear Haru', style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(height: 6),
                        Text(
                          _playCount == 0
                              ? 'Haru has not barked yet.'
                              : 'Haru has barked $_playCount '
                                  '${_playCount == 1 ? 'time' : 'times'}.',
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isPlaying ? null : _playSound,
                            icon: Icon(_isPlaying
                                ? Icons.volume_up_rounded
                                : Icons.play_arrow_rounded),
                            label: Text(_isPlaying ? 'Playing...' : 'Play bark'),
                          ),
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
