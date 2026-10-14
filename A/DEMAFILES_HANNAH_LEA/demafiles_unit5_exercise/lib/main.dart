import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color beige = Color(0xFFF5ECDD);
  static const Color beigeDark = Color(0xFFEADBC4);
  static const Color lightBrown = Color(0xFFB08968);
  static const Color brownText = Color(0xFF5C4430);
  static const Color brownMuted = Color(0xFF8C735B);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightBrown,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.beigeDark,
      onPrimaryContainer: AppColors.brownText,
      secondary: AppColors.brownMuted,
      onSecondary: AppColors.white,
      error: Color(0xFFB3261E),
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.brownText,
      onSurfaceVariant: AppColors.brownMuted,
      surfaceContainerHighest: AppColors.beigeDark,
      inversePrimary: AppColors.beige,
    );

    return MaterialApp(
      title: 'demafiles_Unit5_Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.beige,
          foregroundColor: AppColors.brownText,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          color: AppColors.beige,
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.beige,
          surfaceTintColor: Colors.transparent,
          indicatorColor: AppColors.lightBrown.withOpacity(0.35),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.lightBrown,
            foregroundColor: AppColors.white,
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info.value,
                  style: theme.textTheme.bodyMedium,
                ),
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

  final List<ProfileInfo> _profileInfos = const [
    ProfileInfo(
      icon: Icons.cake,
      label: 'Birthdate',
      value: 'October 12, 2005',
    ),
    ProfileInfo(
      icon: Icons.home,
      label: 'Address',
      value: 'Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'hannahlea.demafiles@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.interests,
      label: 'Hobbies',
      value: 'Reading, Photography, Journaling',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hannah Lea Demafiles'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/Profile.jpg',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Hannah Lea Demafiles',
                      errorBuilder: (context, error, stackTrace) => CircleAvatar(
                        radius: 45,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.person,
                            size: 45,
                            color: theme.colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hannah Lea Demafiles',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '3rd Year IT Student',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    children: [
                      for (final info in _profileInfos) InfoTile(info: info),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Biography',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'I am a 3rd year Information Technology student at West Visayas State University majoring in Software Development Technology who is also passionate about caring for animals. I have a pet dog named Maggie who is a source of joy and companionship in my life. I enjoy spending time with her, taking her for walks, and playing fetch. My love for animals extends beyond my own pet, as I am also a vice president of Christian Reformed Youth Movemment, where we unite all the youth in one mission. ',
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
  bool _isLiked = false;
  int _soundCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _soundCount++;
    });
    try {
      await _player.play(AssetSource('sounds/DogSound.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _toggleHeart() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: _toggleHeart,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            'assets/images/Maggie.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Maggie, my pet dog',
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.pets,
                                size: 80,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_isLiked)
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 80,
                          shadows: [
                            Shadow(color: Colors.black38, blurRadius: 12),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Maggie has barked $_soundCount times.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play Sound'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}