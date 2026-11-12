import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'screens/books_screen.dart';
import 'screens/movies_screen.dart';
import 'screens/picks_screen.dart';

void main() {
  runApp(const MyApp());
}

// Custom Palette
class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color beige = Color(0xFFF5ECDD);
  static const Color beigeDark = Color(0xFFEADBC4);
  static const Color lightBrown = Color(0xFFB08968);
  static const Color brownText = Color(0xFF5C4430);
  static const Color brownMuted = Color(0xFF8C735B);
}

// Data Models
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
      title: 'demafiles_unit7_exercise',
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
          indicatorColor: AppColors.lightBrown.withValues(alpha: 0.35),
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
    GalleryScreen(),
    ShelfScreen(),
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
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Shelf',
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
  ];

  final List<ClassSlot> _schedule = const [
    ClassSlot(day: 'Mon', time: '7:00 - 9:00 AM', subject: 'Human Computer Interaction 2 (ICT 106)'),
    ClassSlot(day: 'Mon', time: '9:00 - 12:00 PM', subject: 'IT Project Management (ICT 507)'),
    ClassSlot(day: 'Mon', time: '1:00 - 3:00 PM', subject: 'Web Systems & Technologies (ICT 507)'),
    ClassSlot(day: 'Mon', time: '4:00 - 5:30 PM', subject: 'Methods of Research & Computing (ICT 106)'),
    ClassSlot(day: 'Tue', time: '9:00 - 12:00 PM', subject: 'Apps Dev & Emerging Tech (ICT 307)'),
    ClassSlot(day: 'Tue', time: '1:00 - 2:30 PM', subject: 'Technopreneurship (ICT 107)'),
    ClassSlot(day: 'Tue', time: '3:00 - 6:00 PM', subject: 'Networking 2 (ICT 305)'),
    ClassSlot(day: 'Wed', time: '7:00 - 10:00 AM', subject: 'Human Computer Interaction 2 (ICT 306)'),
    ClassSlot(day: 'Wed', time: '10:00 - 12:00 PM', subject: 'IT Project Management (ICT 307)'),
    ClassSlot(day: 'Wed', time: '1:00 - 4:00 PM', subject: 'Web Systems & Technologies (ICT 307)'),
    ClassSlot(day: 'Wed', time: '4:00 - 5:30 PM', subject: 'Methods of Research & Computing (ICT 106)'),
    ClassSlot(day: 'Thu', time: '10:00 - 12:00 PM', subject: 'Apps Dev & Emerging Tech (ICT 307)'),
    ClassSlot(day: 'Thu', time: '1:00 - 2:30 PM', subject: 'Technopreneurship (ICT 107)'),
    ClassSlot(day: 'Thu', time: '4:00 - 6:00 PM', subject: 'Networking 2 (ICT 305)'),
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

              // Hobbies Section with Wrap and Chips
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hobbies & Interests',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: const [
                          Chip(avatar: Icon(Icons.book, size: 18), label: Text('Reading')),
                          Chip(avatar: Icon(Icons.camera_alt, size: 18), label: Text('Photography')),
                          Chip(avatar: Icon(Icons.edit_note, size: 18), label: Text('Journaling')),
                          Chip(avatar: Icon(Icons.sports_tennis, size: 18), label: Text('Badminton')),
                          Chip(avatar: Icon(Icons.pets, size: 18), label: Text('Pet Care')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Class Schedule Table Section
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class Schedule',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(
                          color: theme.colorScheme.outlineVariant,
                          width: 1,
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(55),
                          1: FixedColumnWidth(110),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Day', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer)),
                              ),
                            ],
                          ),
                          for (final slot in _schedule)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(slot.day),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(slot.time),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(slot.subject),
                                ),
                              ],
                            ),
                        ],
                      ),
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
                        'I am a 3rd year Information Technology student at West Visayas State University majoring in Software Development Technology who is also passionate about caring for animals. I have a pet dog named Maggie who is a source of joy and companionship in my life. I enjoy spending time with her, taking her for walks, and playing fetch. My love for animals extends beyond my own pet, as I am also a vice president of Christian Reformed Youth Movement, where we unite all the youth in one mission.',
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

  Future<void> _showResetDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text('Maggie has barked $_soundCount times. Start again from zero?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _soundCount = 0;
      });
    }
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _isPlaying ? null : _playSound,
                    icon: const Icon(Icons.volume_up),
                    label: Text(_isPlaying ? 'Playing...' : 'Play Sound'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _soundCount == 0 ? null : _showResetDialog,
                    child: const Text('Reset count'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gallery Screen
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? favoriteAsset;

  // Make sure photo path names match files inside assets/images/gallery/
  final List<Photo> photos = const [
    Photo(asset: 'assets/images/gallery/pic1.jpg', caption: 'Ice Cream'),
    Photo(asset: 'assets/images/gallery/pic2.jpg', caption: 'Bibimbap Meal'),
    Photo(asset: 'assets/images/gallery/pic3.jpg', caption: 'Bantillo et al.'),
    Photo(asset: 'assets/images/gallery/pic4.jpg', caption: 'Hanging out with friends'),
    Photo(asset: 'assets/images/gallery/pic5.jpg', caption: 'Lomi & Kiray'),
    Photo(asset: 'assets/images/gallery/pic6.jpg', caption: 'Sleepy Kiray'),
    Photo(asset: 'assets/images/gallery/pic7.jpg', caption: 'Family Photo'),
    Photo(asset: 'assets/images/gallery/pic8.jpg', caption: 'Sassy Maggie'),
    Photo(asset: 'assets/images/gallery/pic9.jpg', caption: 'Cutie Maggie'),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                  ),
                  if (favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.star, color: Colors.amber, size: 28),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Fullscreen Photo Detail Screen
class PhotoScreen extends StatelessWidget {
  final Photo photo;
  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.star),
                label: const Text('Make favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shelf Screen (My Picks / Books / Movies)
class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PicksScreen(),
            BooksScreen(),
            MoviesScreen(),
          ],
        ),
      ),
    );
  }
}