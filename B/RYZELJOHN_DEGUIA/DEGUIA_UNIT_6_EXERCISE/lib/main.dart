import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ProfilePetApp());

const Color _backgroundColor = Color(0xFFDDEBF5);
const Color _accentColor = Color(0xFF9099A0);
const String profileName = 'Ryzel John De Guia';

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _accentColor,
      primary: _accentColor,
      surface: _backgroundColor,
    );

    return MaterialApp(
      title: 'My Profile and Pet',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: _accentColor,
          foregroundColor: colorScheme.onSurface,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onSurface,
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colorScheme.surfaceContainerHighest
                  : _accentColor,
            ),
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

  static const List<Widget> _screens = [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];
  static const List<String> _titles = [profileName, 'My Pet', 'Gallery'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
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
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
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

const List<ProfileInfo> profileInfos = [
  ProfileInfo(
    icon: Icons.school_outlined,
    label: 'School',
    value: 'West Visayas State University',
  ),
  ProfileInfo(icon: Icons.class_outlined, label: 'Class', value: 'CC 207B'),
  ProfileInfo(icon: Icons.code, label: 'Learning', value: 'Flutter and Dart'),
  ProfileInfo(
    icon: Icons.pets_outlined,
    label: 'Favorite animal',
    value: 'Owl',
  ),
  ProfileInfo(
    icon: Icons.phone_android,
    label: 'Project',
    value: 'Profile and My Pet app',
  ),
];

const List<String> hobbies = [
  'Gaming',
  'Watching movies',
  'Photography',
  'Listening to music',
  'Traveling',
];

class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });

  final String day;
  final String time;
  final String subject;
}

const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Monday',
    time: '9:00 AM - 12:00 PM',
    subject: 'CIT 212 - Networking 2 (Advanced Networking)',
  ),
  ClassSlot(
    day: 'Monday',
    time: '1:00 PM - 3:00 PM',
    subject: 'CC 208 - Methods of Research in Computing',
  ),
  ClassSlot(
    day: 'Monday',
    time: '3:00 PM - 6:00 PM',
    subject: 'CC 207B - Applications Development and Emerging Technologies',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '11:30 AM - 1:00 PM',
    subject: 'CIT 251 - Security Compliance and Governance',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '1:00 PM - 2:30 PM',
    subject: 'CIT 213 - Human Computer Interaction 2',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '3:00 PM - 6:00 PM',
    subject: 'CC 207B - Applications Development and Emerging Technologies',
  ),
];

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(info.icon, color: colors.primary),
      title: Text(info.label, style: textTheme.labelLarge),
      subtitle: Text(info.value, style: textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Semantics(
                    image: true,
                    label: 'Photo of $profileName',
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            ColoredBox(
                              color: colors.primaryContainer,
                              child: SizedBox(
                                width: 92,
                                height: 92,
                                child: Icon(
                                  Icons.person,
                                  color: colors.onPrimaryContainer,
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
                        Text(profileName, style: textTheme.headlineSmall),
                        Text(
                          'Learning Flutter and Dart, one widget at a time',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (final info in profileInfos) InfoTile(info: info),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Hobbies', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Class Schedule', style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(color: colors.outlineVariant),
                        columnWidths: const {
                          0: FixedColumnWidth(62),
                          1: FixedColumnWidth(112),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                            ),
                            children: [
                              _ScheduleCell(
                                'Day',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                              _ScheduleCell(
                                'Time',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                              _ScheduleCell(
                                'Subject',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                          for (final slot in classSchedule)
                            TableRow(
                              children: [
                                _ScheduleCell(slot.day),
                                _ScheduleCell(slot.time),
                                _ScheduleCell(slot.subject),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'I am a 3rd-year BSIT major trying to navigate life, pass my subjects, and learn as much as I can along the way. My offline (and online) hours revolve around gaming, catching up on good movies, and capturing aesthetics through photography. Working hard now so my future self can enjoy the comfortable, wealthy life I’m aiming for.',
                        style: textTheme.bodyMedium,
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

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: style),
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
      await _player.play(AssetSource('sounds/owl_hoot.mp3'));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add the audio file at assets/sounds/owl_hoot.mp3.'),
        ),
      );
    }
  }

  Future<void> _confirmResetCount() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: const Text('Do you want to reset the owl hoot count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true && mounted) {
      setState(() => _playCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('My Favorite Animal: Owl', style: textTheme.headlineSmall),
              Text(
                'A favorite animal, not my pet',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Semantics(
                image: true,
                label: 'Photo of an owl',
                child: GestureDetector(
                  key: const Key('pet-photo'),
                  onDoubleTap: () => setState(() => _showHeart = !_showHeart),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/owl.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                ColoredBox(
                                  color: colors.primaryContainer,
                                  child: Icon(
                                    Icons.pets,
                                    color: colors.onPrimaryContainer,
                                    size: 72,
                                  ),
                                ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _showHeart
                                  ? Icon(
                                      Icons.favorite,
                                      key: const ValueKey('liked'),
                                      color: colors.primary,
                                      size: 36,
                                    )
                                  : const SizedBox.shrink(
                                      key: ValueKey('not-liked'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlaying ? 'Playing...' : 'Play owl hoot'),
              ),
              const SizedBox(height: 12),
              Text(
                'The owl has hooted $_playCount ${_playCount == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmResetCount,
                child: const Text('Reset count'),
              ),
              const SizedBox(height: 12),
              Text(
                'Double-tap the photo to show or hide a heart.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/images/gallery/angryBirds.webp', caption: 'Angry Birds'),
  Photo(asset: 'assets/images/gallery/potato.webp', caption: 'Potato'),
  Photo(asset: 'assets/images/gallery/chikawa.jpg', caption: 'Chikawa'),
  Photo(asset: 'assets/images/gallery/riceNew.webp', caption: 'Rice'),
  Photo(asset: 'assets/images/gallery/bear.jpg', caption: 'Bear'),
  Photo(asset: 'assets/images/gallery/owl.jpg', caption: 'Owl'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  void _toggleFavorite(Photo photo) {
    setState(() {
      _favoriteAsset = _favoriteAsset == photo.asset ? null : photo.asset;
    });
  }

  void _openPhoto(Photo photo) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => PhotoScreen(photo: photo)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GridView.extent(
      maxCrossAxisExtent: 160,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: [
        for (final photo in galleryPhotos)
          Semantics(
            image: true,
            label: photo.caption,
            child: GestureDetector(
              onTap: () => _openPhoto(photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(photo.asset, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                          child: Text(
                            photo.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        tooltip: _favoriteAsset == photo.asset
                            ? 'Remove favorite'
                            : 'Set as favorite',
                        onPressed: () => _toggleFavorite(photo),
                        icon: Icon(
                          _favoriteAsset == photo.asset
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: colors.shadow, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Center(
        child: Semantics(
          image: true,
          label: photo.caption,
          child: InteractiveViewer(
            child: Image.asset(photo.asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
