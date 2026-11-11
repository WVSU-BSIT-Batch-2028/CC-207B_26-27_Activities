import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'screens/shelf_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const pastelPink = Color(0xFFFFE8FB);
    const accentPink = Color(0xFFB85C9E);
    const ink = Color(0xFF3A2736);
    const softBorder = Color(0xFFF3D0EB);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sven Catalan Profile',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentPink,
          brightness: Brightness.light,
        ).copyWith(
          surface: Colors.white,
          onSurface: ink,
        ),
        scaffoldBackgroundColor: pastelPink,
        appBarTheme: const AppBarTheme(
          backgroundColor: pastelPink,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: softBorder),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: pastelPink,
          indicatorColor: const Color(0xFFF6C7E9),
          elevation: 0,
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: ink),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: accentPink,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

// IndexedStack keeps tab state alive while users move between Profile, My Pet, Gallery, and Shelf.
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
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfileScreen(),
          PetScreen(),
          GalleryScreen(),
          ShelfScreen(),
        ],
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
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Course',
      value: 'Bachelor of Science in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Location',
      value: 'Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'sven.catalan@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.lightbulb_outline,
      label: 'Goal',
      value: 'Build useful and creative apps',
    ),
  ];

  // Keep at least five hobbies here. Edit this list to match your own hobbies.
  static const hobbies = <String>[
    'Coding',
    'Music',
    'Photography',
    'Reading',
    'Gaming',
  ];

  // Sample class entries: replace the days, times, and subjects with your
  // actual class schedule before submitting the exercise.
  static const classSchedule = <ClassSlot>[
    ClassSlot(day: 'Monday', time: '8:00–9:30 AM', subject: 'CC 207B'),
    ClassSlot(day: 'Tuesday', time: '10:00–11:30 AM', subject: 'IT 111'),
    ClassSlot(day: 'Thursday', time: '8:00–9:30 AM', subject: 'NSTP 1'),
    ClassSlot(day: 'Friday', time: '1:00–2:30 PM', subject: 'CC 210'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sven Catalan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Profile picture of Sven Catalan',
                  image: true,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primaryContainer,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: Image.asset(
                          'assets/images/profile.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sven Catalan',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Student, learner, and aspiring app developer.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Get to know me', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  for (final info in infos) InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Hobbies', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                      child: Text(
                        'My Class Schedule',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Table(
                      border: TableBorder.all(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(76),
                        1: FixedColumnWidth(112),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final heading in const [
                              'Day',
                              'Time',
                              'Subject',
                            ])
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  heading,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (final slot in classSchedule)
                          TableRow(
                            children: [
                              _ScheduleCell(text: slot.day),
                              _ScheduleCell(text: slot.time),
                              _ScheduleCell(text: slot.subject),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'I am Sven Catalan, a BSIT student interested in technology and app development. I am currently learning Flutter and Dart to create useful and creative mobile applications. I enjoy coding, listening to music, and exploring new ideas. My goal is to continue improving my programming skills and become a better developer.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCell extends StatelessWidget {
  final String text;

  const _ScheduleCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
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

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        info.icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        info.label,
        style: theme.textTheme.labelLarge,
      ),
      subtitle: Text(
        info.value,
        style: theme.textTheme.bodyMedium,
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
  int _playCount = 0;
  StreamSubscription<void>? _completeSubscription;

  @override
  void initState() {
    super.initState();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount += 1;
    });

    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (error) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add assets/sounds/pet_sound.mp3, then try again.'),
        ),
      );
    }
  }

  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('Are you sure you want to reset the bark count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (answer == true && mounted) {
      setState(() => _playCount = 0);
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() => _isLiked = !_isLiked);
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Semantics(
                        label: 'Photo of Kiwi',
                        image: true,
                        child: Image.asset(
                          'assets/images/pet.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.pets,
                              size: 72,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isLiked)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: theme.colorScheme.surface,
                        child: Icon(
                          Icons.favorite,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kiwi, my favorite animal',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to show a heart.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Bark Count: $_playCount',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _playCount == 0 ? null : _confirmReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset count'),
            ),
          ],
        ),
      ),
    );
  }
}

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const photos = <Photo>[
    Photo(
      asset: 'assets/images/gallery/kiwi.jpg',
      caption: 'Kiwi',
    ),
    Photo(
      asset: 'assets/images/gallery/profile-picture.jpg',
      caption: 'Profile Picture',
    ),
    Photo(
      asset: 'assets/images/gallery/mountain-lake.png',
      caption: 'Mountain Lake',
    ),
    Photo(
      asset: 'assets/images/gallery/beach-sunset.png',
      caption: 'Beach Sunset',
    ),
    Photo(
      asset: 'assets/images/gallery/forest-trail.png',
      caption: 'Forest Trail',
    ),
    Photo(
      asset: 'assets/images/gallery/pink-flower.png',
      caption: 'Pink Flower',
    ),
  ];

  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    // PhotoScreen returns true for Make favorite and null for the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (makeFavorite == true && mounted) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  Widget _buildPhotoTile(Photo photo) {
    final isFavorite = _favoriteAsset == photo.asset;

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(photo),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                photo.asset,
                fit: BoxFit.cover,
                semanticLabel: photo.caption,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 40),
                ),
              ),
            ),
            if (isFavorite)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.star, color: Colors.amber, size: 22),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos) _buildPhotoTile(photo),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    photo.asset,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pop<bool>(context, true),
              icon: const Icon(Icons.star),
              label: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
