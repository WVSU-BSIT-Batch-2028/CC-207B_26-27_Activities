import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kenneth Mac Rene V. Anas | Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF69D2C8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF69D2C8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      themeMode: _themeMode,
      home: HomeShell(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeToggle: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          });
        },
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['Kenneth Mac Rene V. Anas', 'My Pet', 'My Gallery'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(titles[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: widget.onThemeToggle,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [ProfileScreen(), PetScreen(), GalleryScreen()],
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

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: colors.primary),
          const SizedBox(width: 16),
          SizedBox(
            width: 112,
            child: Text(info.label, style: textTheme.titleSmall),
          ),
          Expanded(child: Text(info.value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const hobbies = [
    'Gaming',
    'Reading',
    'Watching',
    'Gym',
    'Cooking',
    'Music',
  ];

  static const classSlots = [
    ClassSlot(
      day: 'Mon/Wed',
      time: '7:00-9:00/7:00-10:00',
      subject: 'CIT 213 Human-Computer Interaction 2',
    ),
    ClassSlot(
      day: 'Mon/Wed',
      time: '9:00-12:00/10:00-12:00',
      subject: 'CIT 246 IT Project Management',
    ),
    ClassSlot(
      day: 'Mon/Wed',
      time: '1:00-3:00/1:00-4:00',
      subject: 'CIT 212 Web Systems',
    ),
    ClassSlot(
      day: 'Mon/Wed',
      time: '4:00-5:30',
      subject: 'CC 208 Methods of Research',
    ),
    ClassSlot(
      day: 'Tue/Thur',
      time: '9:00-12:00/10:00-12:00',
      subject: 'CC 207B App Development',
    ),
    ClassSlot(
      day: 'Tue/Thur',
      time: '1:00-2:30',
      subject: 'BA 234 Technopreneurship',
    ),
    ClassSlot(
      day: 'Tue/Thur',
      time: '4:00-6:00',
      subject: 'CIT 212 Networking 2',
    ),
  ];

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'West Visayas State University, 2024 to present',
    ),
    ProfileInfo(
      icon: Icons.computer_outlined,
      label: 'Program',
      value: 'BS Information Technology, major in Software Development',
    ),
    ProfileInfo(
      icon: Icons.badge_outlined,
      label: 'Year level',
      value: 'Third year',
    ),
    ProfileInfo(
      icon: Icons.code,
      label: 'Focus',
      value: 'Software development and practical digital solutions',
    ),
    ProfileInfo(
      icon: Icons.groups_outlined,
      label: 'Strengths',
      value: 'Planning, teamwork, research, communication, and problem-solving',
    ),
    ProfileInfo(
      icon: Icons.terminal,
      label: 'Technologies',
      value: 'C++, Java, PHP, JavaScript, HTML, React, Next.js, and MySQL',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'Kennethmacrene.anas@wvsu.edu.ph',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of Kenneth Mac Rene V. Anas',
                        errorBuilder: (context, error, stackTrace) =>
                            ColoredBox(
                              color: colors.primaryContainer,
                              child: SizedBox(
                                width: 88,
                                height: 88,
                                child: Center(
                                  child: Text(
                                    'A',
                                    style: textTheme.headlineLarge?.copyWith(
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kenneth Mac Rene V. Anas',
                            style: textTheme.titleLarge?.copyWith(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Third-year IT student focused on Software Development.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('A little about me', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [for (final info in infos) InfoTile(info: info)],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: colors.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        'I am a third-year Information Technology student at '
                        'West Visayas State University, majoring in Software '
                        'Development. I enjoy building user-centered digital '
                        'solutions and combining software development with '
                        'project planning, research, problem-solving, clear '
                        'communication, and teamwork. I am growing my skills '
                        'through academic and practical projects.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('My Hobbies', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final hobby in hobbies)
                        Chip(
                          label: Text(hobby),
                          avatar: const Icon(Icons.favorite_outline, size: 18),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('My Class Schedule', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Table(
                    border: TableBorder.all(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    columnWidths: const {
                      0: FixedColumnWidth(52),
                      1: FixedColumnWidth(88),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                        ),
                        children: [
                          _ScheduleCell(
                            text: 'Day',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _ScheduleCell(
                            text: 'Time',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _ScheduleCell(
                            text: 'Subject',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      for (final slot in classSlots)
                        TableRow(
                          children: [
                            _ScheduleCell(text: slot.day),
                            _ScheduleCell(text: slot.time),
                            _ScheduleCell(text: slot.subject),
                          ],
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
  const _ScheduleCell({required this.text, this.style});

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

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  static const photos = [
    Photo(asset: 'assets/images/gallery/profile.jpg', caption: 'Profile portrait'),
    Photo(asset: 'assets/images/gallery/favorite_dog.jpg', caption: 'Our dog'),
    Photo(asset: 'assets/images/gallery/pochitar.jpg', caption: 'Pochita'),
    Photo(asset: 'assets/images/gallery/satory.jpg', caption: 'Homeless One'),
    Photo(asset: 'assets/images/gallery/favefood.jpg', caption: 'Fries'),
    Photo(asset: 'assets/images/gallery/dream.webp', caption: 'Dream GPU'),
  ];

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Photo? _favorite;

  Future<void> _open(Photo photo) async {
    final makeFavorite = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PhotoScreen(
          photo: photo,
          isFavorite: identical(_favorite, photo),
        ),
      ),
    );

    if (makeFavorite == true && mounted) {
      setState(() => _favorite = photo);
    } else if (makeFavorite == false && mounted) {
      setState(() {
        if (identical(_favorite, photo)) {
          _favorite = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.extent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          children: [
            for (final photo in GalleryScreen.photos)
              GestureDetector(
                onTap: () => _open(photo),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                      ),
                    ),
                    if (identical(_favorite, photo))
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 24,
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

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    super.key,
    required this.photo,
    this.isFavorite = false,
  });

  final Photo photo;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.cover,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(!isFavorite),
              icon: Icon(isFavorite ? Icons.star : Icons.star_border),
              label: Text(isFavorite ? 'Unfavorite' : 'Make favorite'),
              style: FilledButton.styleFrom(
                backgroundColor: isFavorite
                    ? colors.errorContainer
                    : colors.secondary,
                foregroundColor: isFavorite
                    ? colors.onErrorContainer
                    : colors.onSecondary,
              ),
            ),
          ],
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
      await _player.play(AssetSource('sounds/dog_bark.mp3'));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add assets/sounds/dog_bark.mp3 to play the sound.'),
        ),
      );
    }
  }

  Future<void> _confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Your dog has barked $_playCount '
          '${_playCount == 1 ? 'time' : 'times'}. Start again from zero?',
        ),
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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('My favorite animal is dog', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Our dog is cute.', style: textTheme.bodyMedium),
              const SizedBox(height: 20),
              GestureDetector(
                onDoubleTap: () => setState(() => _showHeart = !_showHeart),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/favorite_dog.jpg',
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of a dog, my favorite animal',
                          errorBuilder: (context, error, stackTrace) =>
                              ColoredBox(
                                color: colors.tertiaryContainer,
                                child: Center(
                                  child: Icon(
                                    Icons.pets,
                                    size: 96,
                                    color: colors.onTertiaryContainer,
                                  ),
                                ),
                              ),
                        ),
                        if (_showHeart)
                          Center(
                            child: Icon(
                              Icons.favorite,
                              size: 88,
                              color: colors.tertiary,
                              semanticLabel: 'Favorite animal',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.graphic_eq : Icons.volume_up),
                label: Text(_isPlaying ? 'Barking...' : 'Bark'),
              ),
              const SizedBox(height: 12),
              Text(
                'Dog barked $_playCount ${_playCount == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmReset,
                child: const Text('Reset count'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
