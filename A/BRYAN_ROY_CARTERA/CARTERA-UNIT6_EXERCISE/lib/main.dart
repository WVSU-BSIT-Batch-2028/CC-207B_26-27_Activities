
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MAIN APP
// ==========================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bryan Roy Cartera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

// ==========================================
// HOME SHELL
// ==========================================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProfileScreen(),
      const PetScreen(),
      const GalleryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
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
        ],
      ),
    );
  }
}

// ==========================================
// PHOTO CLASS
// ==========================================

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

const List<Photo> galleryPhotos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'My First Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'My Second Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'My Third Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'My Fourth Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'My Fifth Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'My Sixth Photo',
  ),
];

// ==========================================
// CLASS SLOT
// ==========================================

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

// ==========================================
// MY HOBBIES
// ==========================================

const List<String> myHobbies = [
  'Gaming',
  'Coding',
  'Listening to Music',
  'Playing Basketball',
  'Exploring Technology',
];

// ==========================================
// MY CLASS SCHEDULE
// ==========================================

const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Monday',
    time: '8:00 AM - 10:00 AM',
    subject: 'Methods of Research in Computing',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '10:00 AM - 12:00 PM',
    subject: 'Application Development and Emerging Technologies',
  ),
  ClassSlot(
    day: 'Wednesday',
    time: '1:00 PM - 3:00 PM',
    subject: 'Technopreneurship',
  ),
  ClassSlot(
    day: 'Thursday',
    time: '8:00 AM - 10:00 AM',
    subject: 'Web Systems and Technologies',
  ),
];

// ==========================================
// PROFILE INFO
// ==========================================

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

// ==========================================
// INFO TILE
// ==========================================

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          info.icon,
          color: theme.colorScheme.onSecondaryContainer,
        ),
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

// ==========================================
// PROFILE SCREEN
// ==========================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'BS Information Technology',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: 'Interests',
      value: 'Technology and app development',
    ),
    ProfileInfo(
      icon: Icons.flag,
      label: 'Goal',
      value: 'Become a skilled IT professional',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget tableCell(String text, {bool isHeader = false}) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          softWrap: true,
          style: isHeader
              ? theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                )
              : theme.textTheme.bodyMedium,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bryan Roy Cartera'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PROFILE INFORMATION
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Semantics(
                      image: true,
                      label: 'Photo of Bryan Roy Cartera',
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/images/Profile.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bryan Roy Cartera',
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Learning today, building tomorrow!',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Get to Know Me',
              style: theme.textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Card(
              child: Column(
                children: [
                  for (final info in infos)
                    InfoTile(info: info),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // MY HOBBIES
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in myHobbies)
                          Chip(
                            label: Text(hobby),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // MY CLASS SCHEDULE
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FixedColumnWidth(75),
                        1: FixedColumnWidth(115),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            tableCell('Day', isHeader: true),
                            tableCell('Time', isHeader: true),
                            tableCell('Subject', isHeader: true),
                          ],
                        ),
                        for (final slot in classSchedule)
                          TableRow(
                            children: [
                              tableCell(slot.day),
                              tableCell(slot.time),
                              tableCell(slot.subject),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // MY BIOGRAPHY
            Card(
              color: theme.colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am Bryan Roy Cartera, a BS Information '
                      'Technology student who enjoys learning about '
                      'technology, exploring new ideas, and developing '
                      'my programming skills. I believe every challenge '
                      'is an opportunity to learn and grow.',
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

// ==========================================
// PET SCREEN
// ==========================================

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _showHeart = false;
  int _barkCount = 0;

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

  // PLAY DOG SOUND
  Future<void> _playSound() async {
    try {
      await _player.stop();
      await _player.setVolume(1.0);

      await _player.play(
        AssetSource('sounds/petsound.wav'),
      );

      if (!mounted) return;

      setState(() {
        _barkCount++;
        _isPlaying = true;
      });
    } catch (error, stackTrace) {
      debugPrint('Audio playback error: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio error: $error'),
        ),
      );
    }
  }

  // RESET COUNT CONFIRMATION DIALOG
  Future<void> _confirmReset() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Bark Count?'),
          content: const Text(
            'Are you sure you want to reset your dog\'s bark count to zero?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true && mounted) {
      setState(() {
        _barkCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Best Friend'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Meet My Dog!',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Double-tap the photo to show some love!',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // DOG PHOTO AND HEART EFFECT
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _showHeart = !_showHeart;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Semantics(
                              image: true,
                              label: 'Photo of my dog',
                              child: Image.asset(
                                'assets/images/Pet.jpg',
                                width: double.infinity,
                                height: 280,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (_showHeart)
                            Icon(
                              Icons.favorite,
                              size: 100,
                              color: theme.colorScheme.error,
                              shadows: const [
                                Shadow(
                                  blurRadius: 15,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PLAY DOG SOUND BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isPlaying ? null : _playSound,
                        icon: Icon(
                          _isPlaying
                              ? Icons.hourglass_top
                              : Icons.volume_up,
                        ),
                        label: Text(
                          _isPlaying
                              ? 'Playing...'
                              : 'Play Dog Sound',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BARK COUNTER
                    Text(
                      'My dog has barked $_barkCount times.',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // RESET COUNT BUTTON
                    OutlinedButton.icon(
                      onPressed: _barkCount == 0
                          ? null
                          : _confirmReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset count'),
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

// ==========================================
// GALLERY SCREEN
// ==========================================

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(photo: photo),
      ),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        centerTitle: true,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in galleryPhotos)
            InkWell(
              onTap: () => _open(photo),
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                      ),
                    ),
                  ),
                  if (favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
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

// ==========================================
// PHOTO SCREEN
// ==========================================

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop<bool>(context, true);
                },
                child: const Text('Make favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
