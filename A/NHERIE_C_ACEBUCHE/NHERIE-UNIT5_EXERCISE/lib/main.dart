import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nherie C. Acebuche - Profile & Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomeShell(),
    );
  }
}

/// Stateful navigation shell containing the Scaffold and NavigationBar.
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

/// Model class representing one item in the Information section.
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

/// Stateless Profile Screen displaying student information.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> _profileInfos = [
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Program & Year Level',
      value: 'BS Information Technology – 3rd Year',
    ),
    ProfileInfo(
      icon: Icons.account_balance_outlined,
      label: 'School',
      value: 'West Visayas State University – Main Campus',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'nherie.acebuche@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.code_outlined,
      label: 'Programming Languages',
      value: 'Java, HTML, CSS, JS, React, PHP, MySQL',
    ),
    ProfileInfo(
      icon: Icons.brush_outlined,
      label: 'Creative Skills',
      value: 'Charcoal Painting, Drawing, Animation, Character Design',
    ),
    ProfileInfo(
      icon: Icons.sports_volleyball_outlined,
      label: 'Hobbies',
      value: 'Charcoal Painting, Gardening, Playing Volleyball',
    ),
    ProfileInfo(
      icon: Icons.lightbulb_outline,
      label: 'Technical Interests',
      value: 'Software Development, Project Management, Systems Analysis',
    ),
    ProfileInfo(
      icon: Icons.format_quote_outlined,
      label: 'Motto in Life',
      value: 'Creare. Crescere. Audere. (To create. To grow. To dare.)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nherie C. Acebuche'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/nherie.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Nherie C. Acebuche',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nherie C. Acebuche',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create with imagination, grow with patience, and discover with courage.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Information Section Header
            Text(
              'Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            // Card wrapping InfoTiles built with collection-for
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    for (final info in _profileInfos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Biography Section
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'I am Nherie C. Acebuche, a Bachelor of Science in Information Technology student at West Visayas State University – Main Campus. With a background in ICT and multimedia, I enjoy exploring the connection between creativity and technology. My passion for art began when I was young, when a simple pencil and an eraser were all I had to bring my imagination to life. Over time, this grew into a love for drawing and charcoal painting. I also enjoy gardening and planting vegetables, which have taught me to appreciate patience and the process of nurturing growth. Currently, I am exploring different paths in technology, particularly software development, project management, and systems analysis, as I discover where my interests and strengths fit best. I believe that growth is a continuous journey of learning, creating, and discovering.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Reusable Stateless tile for a single information row.
class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            info.icon,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  info.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful Screen for the pet featuring photo gesture, audio playback, and play counter.
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _barkCount = 0;
  bool _hasHeart = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
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
      _barkCount++;
    });
    try {
      // AssetSource looks inside the assets/ folder
      await _player.play(AssetSource('sounds/pet_sound.wav'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  void _toggleHeart() {
    setState(() {
      _hasHeart = !_hasHeart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String countText = _barkCount == 1
        ? 'Chocho has barked 1 time.'
        : 'Chocho has barked $_barkCount times.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title & Subtitle
            Text(
              'Chocho 🐶',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Double-tap the photo to show some love!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Large Pet Photo with Rounded Corners, Semantic Label & Heart Toggle Gesture
            GestureDetector(
              onDoubleTap: _toggleHeart,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image.asset(
                      'assets/images/chocho.jpg',
                      width: double.infinity,
                      height: 340,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Chocho the dog',
                    ),
                  ),
                  if (_hasHeart)
                    AnimatedScale(
                      scale: _hasHeart ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.elasticOut,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 72,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sound Playback Button
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.music_note),
              label: Text(_isPlaying ? 'Playing...' : 'Hear Chocho Bark'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Play Counter
            Text(
              countText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
