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
      title: 'Unit 5 Exercise',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal, // Modern teal theme kept
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2C3E50), // Lighter dark color (soft dark slate)
        foregroundColor: Colors.white,      // Text and icon color
        centerTitle: true,
        elevation: 2,
  ),
      ),
      home: const HomeShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_rounded),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(info.icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: Text(
              info.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<ProfileInfo> infos = [
      const ProfileInfo(
        icon: Icons.cake_outlined,
        label: 'Birthday',
        value: 'Secret (but its in June 28, 2006)',
      ),
      const ProfileInfo(
        icon: Icons.location_on_outlined,
        label: 'Address',
        value: 'Roxas City, Capiz, Philippines',
      ),
      const ProfileInfo(
        icon: Icons.phone_outlined,
        label: 'Phone Number',
        value: '  +63 911 223 3449',
      ),
      const ProfileInfo(
        icon: Icons.music_note_outlined,
        label: 'Current Favorite Song',
        value: '  Cover song of From the Start by Good Kid',
      ),
      const ProfileInfo(
        icon: Icons.star_outline,
        label: 'Favorite Artists',
        value: '      Eve (the Japanese Singer), Ado, natori',
      ),
      const ProfileInfo(
        icon: Icons.code_rounded,
        label: 'Hobbies',
        value: 'Gaming, Football, Sleeping, Watching Movies and Animes',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carlo Jay Degala'), 
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/Pic3.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Carlo Jay Degala',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carlo Jay Degala',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'An Average student in WVSU',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Information Section Container
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final info in infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Biography Card Section
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_pin_rounded,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'My Biography',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'I grew up in Roxas City, Capiz. I am a person who loves to play games up to a unhealthy degree. I played football in my highschool years but quitted due to burnout of playing too much. Now in the current time I now like to sleep alot if I had the chance. Would watch some zombie movies if I had the time as I am a avid horror genre fan. Ultimately, I am just a normal person who tries to do his best whenever I can.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => PetScreenState();
}

class PetScreenState extends State<PetScreen> {
  late final AudioPlayer _player;
  bool isPlaying = false;
  int barkCount = 0;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> playSound() async {
    setState(() {
      isPlaying = true;
      barkCount++;
    });
    await _player.play(AssetSource('sounds/Lemon Barking.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lemon Beagle (His name is Lemon)'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    showHeart = !showHeart;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Pic2.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Lemon the Lemon Beagle',
                    ),
                    if (showHeart)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.5, end: 1.0),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.redAccent.withOpacity(0.9),
                              size: 100,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Double-tap the photo to put love on my dog pls!',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                'Lemon has barked $barkCount time${barkCount == 1 ? '' : 's'}.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FilledButton.icon(
                onPressed: isPlaying ? null : playSound,
                icon: Icon(
                  isPlaying ? Icons.hourglass_top_rounded : Icons.volume_up_rounded,
                  size: 18, // Slightly smaller icon
                ),
                label: Text(
                  isPlaying ? 'Playing Sound...' : 'Play Pet Sound',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Compact padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}