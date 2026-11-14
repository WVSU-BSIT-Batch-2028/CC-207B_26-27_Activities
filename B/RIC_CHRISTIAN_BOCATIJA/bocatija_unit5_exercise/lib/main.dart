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

class Photo {
  final String asset;
  final String caption;
  const Photo({required this.asset, required this.caption});
}

class ClassSlot {
  final String day;
  final String time;
  final String subject;
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
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

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(), // Added 3rd Screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens, // IndexedStack keeps states alive
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF7A6559), width: 2.5)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) =>
              setState(() => _selectedIndex = index),
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
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library_rounded),
              label: 'Gallery',
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

  final List<String> _hobbies = const [
    'Otters & Cats',
    'Single-Player RPGs',
    'Racing Sims',
    'Gym / Fitness',
    'Fragrances',
  ];

  final List<ClassSlot> _schedule = const [
    ClassSlot(day: 'Mon', time: '8:00-9:30', subject: 'CC 206 App Development'),
    ClassSlot(day: 'Tue', time: '10:00-11:30', subject: 'CS 311 Algorithms'),
    ClassSlot(day: 'Wed', time: '8:00-9:30', subject: 'CC 206 App Development'),
    ClassSlot(
      day: 'Thu',
      time: '1:00-2:30',
      subject: 'CS 313 Operating Systems',
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

            // Profile Info List
            for (final info in _profileInfos) InfoTile(info: info),
            const SizedBox(height: 12.0),

            // Hobbies as Chips
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.colorScheme.primary, width: 2.5),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in _hobbies)
                          Chip(
                            label: Text(
                              hobby,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.secondary
                                .withAlpha(100),
                            side: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Class Schedule as Table
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.colorScheme.primary, width: 2.5),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(50),
                        1: FixedColumnWidth(90),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Day',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Subject',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final slot in _schedule)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot.day,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot.time,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot.subject,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Biography Section
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

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _squeakCount++;
    });
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

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

  // Reset Dialog function
  Future<void> _showResetDialog() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.5,
            ),
          ),
          title: Text(
            'Reset the count?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            'Your otter has squeaked $_squeakCount times. Start again from zero?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Reset',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      setState(() => _squeakCount = 0);
    }
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
                        Image.asset(
                          'assets/images/room_bg.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/pet.jpg',
                          height: 300,
                          fit: BoxFit.contain,
                        ),
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
            const SizedBox(height: 8),

            // Reset Button added here
            OutlinedButton.icon(
              onPressed: _squeakCount == 0 ? null : _showResetDialog,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: _squeakCount == 0
                      ? Colors.grey
                      : theme.colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                color: _squeakCount == 0
                    ? Colors.grey
                    : theme.colorScheme.primary,
              ),
              label: Text(
                'Reset count',
                style: TextStyle(
                  color: _squeakCount == 0
                      ? Colors.grey
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

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
                    onTap: () {},
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

// =============================================================================
// GALLERY SCREENS
// =============================================================================

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  final List<Photo> _photos = const [
    Photo(
      asset: 'assets/images/gallery/pic1.jpg',
      caption: 'Otter at the beach',
    ),
    Photo(asset: 'assets/images/gallery/pic2.jpg', caption: 'Gym session'),
    Photo(asset: 'assets/images/gallery/pic3.jpg', caption: 'Fragrance haul'),
    Photo(asset: 'assets/images/gallery/pic4.jpg', caption: 'Racing Sim Setup'),
    Photo(asset: 'assets/images/gallery/pic5.jpg', caption: 'Batchoy night'),
    Photo(asset: 'assets/images/gallery/pic6.jpg', caption: 'Coding late'),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MY GALLERY',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        padding: const EdgeInsets.all(8.0),
        children: [
          for (final photo in _photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                  if (_favoriteAsset == photo.asset)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star_rounded,
                        color: theme.colorScheme.tertiary,
                        size: 32,
                        shadows: const [
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.5,
                      ),
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

class PhotoScreen extends StatelessWidget {
  final Photo photo;
  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          photo.caption,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary, width: 3),
                image: DecorationImage(
                  image: AssetImage(photo.asset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.star_rounded, color: Colors.white),
                label: const Text(
                  'Make favorite',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
