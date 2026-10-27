import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 5 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeShell(),
    );
  }
}

// ======================================================
// Navigation shell
// ======================================================

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
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
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

// ======================================================
// Profile screen (stateless widgets only)
// ======================================================

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
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(info.icon, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(info.value, style: theme.textTheme.bodyLarge),
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

  // EDIT: change these values to your own details
  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.cake_outlined,
      label: 'Birthdate',
      value: 'March 16, 2006',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Address',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'juancarlos.moje@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.computer_outlined,
      label: 'Course',
      value: 'BS Information Technology',
    ),
    ProfileInfo(
      icon: Icons.sports_esports_outlined,
      label: 'Hobbies',
      value: 'Coding, Badminton',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Juan Carlos Moje')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------- Profile row ----------
                Card(
                  color: colors.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.primary,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/me.jpg',
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              semanticLabel: 'Photo of Juan Carlos Moje',
                              errorBuilder: (context, error, stack) =>
                                  SizedBox(
                                width: 88,
                                height: 88,
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Juan Carlos Moje',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Aspiring developer', // EDIT: your tagline
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Information section ----------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        for (final info in infos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Biography ----------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text(
                          // EDIT: write one paragraph about yourself
                          'I am a student at West Visayas State University '
                          'who enjoys building apps and learning new '
                          'technologies. I like turning ideas into working '
                          'software, and I am always looking for ways to '
                          'improve my skills one project at a time.',
                          style: textTheme.bodyMedium?.copyWith(height: 1.5),
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

// ======================================================
// Pet screen (StatefulWidget + setState)
// ======================================================

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _liked = false;
  int _playCount = 0;

  static const String petName = 'Lurk';
  static const String petBreed = 'Doberman';
  static const String petAction = 'barked';

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
      _playCount++;
    });
    try {
      // AssetSource looks inside the assets/ folder
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------- Photo (double-tap for a heart) ----------
                GestureDetector(
                  onDoubleTap: () => setState(() => _liked = !_liked),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              'assets/images/pet.jpg',
                              fit: BoxFit.cover,
                              semanticLabel:
                                  'Photo of $petName, my pet $petBreed',
                              errorBuilder: (context, error, stack) =>
                                  ColoredBox(
                                color: colors.surfaceContainerHighest,
                                child: Icon(
                                  Icons.pets,
                                  size: 72,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedScale(
                          scale: _liked ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          child: Icon(
                            Icons.favorite,
                            size: 112,
                            color: colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Double-tap the photo to show some love',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Name and breed ----------
                Row(
                  children: [
                    Text(petName, style: textTheme.headlineMedium),
                    const SizedBox(width: 12),
                    const Chip(
                      avatar: Icon(Icons.pets, size: 18),
                      label: Text(petBreed),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---------- Sound + counter ----------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.icon(
                          onPressed: _isPlaying ? null : _playSound,
                          icon: Icon(
                            _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                          ),
                          label: Text(
                            _isPlaying ? 'Playing...' : 'Hear $petName',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$petName has $petAction $_playCount '
                          '${_playCount == 1 ? 'time' : 'times'}.',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
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