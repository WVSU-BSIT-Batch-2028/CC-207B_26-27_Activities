import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const Unit5App());
}

/// Main Application Entry Point
class Unit5App extends StatelessWidget {
  const Unit5App({super.key});

  @override
  Widget build(BuildContext context) {
    // Cats & Soup inspired palette: Warm, earthy, pastel
    const Color appBg = Color(0xFFF2EADC); // Soft parchment/beige
    const Color borderBrown = Color(0xFF7A6559); // Hand-drawn ink brown
    const Color cardBg = Color(0xFFFCF9F2); // Creamy off-white
    const Color accentGreen = Color(0xFFC5D8B4); // Muted sage green
    const Color accentPink = Color(0xFFEAAFB1); // Soft rose

    return MaterialApp(
      title: 'Cee Arthur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: appBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: borderBrown,
          primary: borderBrown,
          secondary: accentGreen,
          tertiary: accentPink,
          surface: cardBg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: appBg,
          foregroundColor: borderBrown,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        // Stylized Bottom Navigation
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: cardBg,
          indicatorColor: accentGreen,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: borderBrown,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: borderBrown),
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

// =============================================================================
// NAVIGATION SHELL
// =============================================================================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [ProfileScreen(), PetScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF7A6559), width: 2.5)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
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
              label: 'Mini Room',
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PROFILE SCREEN & MODELS
// =============================================================================

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
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary, width: 2.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: Icon(
                info.icon,
                color: theme.colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary.withAlpha(180),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> _profileInfos = const [
    ProfileInfo(
      icon: Icons.cake_rounded,
      label: 'BIRTHDATE',
      value: 'August 18, 2004',
    ),
    ProfileInfo(
      icon: Icons.favorite_rounded,
      label: 'PASSIONS',
      value: 'Otters & Cats',
    ),
    ProfileInfo(
      icon: Icons.sports_esports_rounded,
      label: 'GAMING',
      value: 'Single-Player RPGs & Racing Simulators',
    ),
    ProfileInfo(
      icon: Icons.fitness_center_rounded,
      label: 'LIFESTYLE',
      value: 'Fitness Enthusiast & Fragrances',
    ),
    ProfileInfo(
      icon: Icons.tv_rounded,
      label: 'WATCHING',
      value: 'The Bear ("Yes, Chef!")',
    ),
    ProfileInfo(
      icon: Icons.school_rounded,
      label: 'EDUCATION',
      value: 'BS in Information Technology - WVSU',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MY PROFILE',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top ID Card
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2.5,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.5,
                      ),
                      // If you kept profile.jpg instead of regenerating as .png, change this line!
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cee Arthur',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Lv. 20 Explorer',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Profile Info List (Exercise Requirement: collection-for loop)
            for (final info in _profileInfos) InfoTile(info: info),

            const SizedBox(height: 12.0),

            // Biography Section (Using the new UI Wood Board asset)
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/ui_wood_board.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2.5,
                ),
              ),
              child: Container(
                // Semi-transparent overlay to ensure text is readable against the wood pattern
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withAlpha(200),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'My Biography',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Text(
                      'Hey there! I am an IT student at West Visayas State University who loves building cool software. '
                      'When I am off the clock, you will find me grinding in single-player RPGs, hitting clean laps in racing simulators, or pushing weight at the gym. '
                      'Huge fan of otters and cats, collector of fine fragrances, and currently hooked on the intense kitchen energy of "The Bear".',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MY PET SCREEN (THE MINI ROOM)
// =============================================================================

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLiked = false;

  // Exercise Requirement: State variables
  int _affection = 0;
  int _squeakCount = 0;

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

  // Exercise Requirement: Audio feature + counter state
  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _squeakCount++;
    });
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

  // Exercise Requirement: Double-tap interaction
  void _feedPet() {
    setState(() {
      _affection += 15;
      _isLiked = true;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLiked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MINI ROOM',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // The "Room" Layered Frame
            Expanded(
              child: GestureDetector(
                onDoubleTap: _feedPet,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 3.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Layer 1: Background Room
                        Image.asset(
                          'assets/images/room_bg.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),

                        // Layer 2: Transparent Otter Character
                        Image.asset(
                          'assets/images/pet.jpg',
                          height: 300,
                          fit: BoxFit.contain,
                        ),

                        // Layer 3: Affection Bar overlay
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withAlpha(230),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite_rounded,
                                  color: theme.colorScheme.tertiary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$_affection / 1000',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Floating Heart Animation
                        if (_isLiked)
                          Icon(
                            Icons.favorite_rounded,
                            color: theme.colorScheme.tertiary,
                            size: 100,
                            shadows: const [
                              Shadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Squeak Counter & Hints (Restored Exercise Requirement)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    '🦦 My otter has squeaked $_squeakCount times!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '💡 Double-tap the room to feed and send love!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary.withAlpha(180),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons Panel
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    theme,
                    icon: Icons.restaurant_rounded,
                    label: 'Feed',
                    onTap: _feedPet,
                  ),
                  _buildActionButton(
                    theme,
                    icon: _isPlaying
                        ? Icons.graphic_eq_rounded
                        : Icons.music_note_rounded,
                    label: _isPlaying ? '...' : 'Play',
                    onTap: _isPlaying ? null : _playSound,
                  ),
                  _buildActionButton(
                    theme,
                    icon: Icons.checkroom_rounded,
                    label: 'Dress',
                    onTap: () {}, // Future feature placeholder
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF2EADC),
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
