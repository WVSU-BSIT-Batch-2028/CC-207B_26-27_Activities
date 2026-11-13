import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Leigh\'s Space!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 135, 221, 65),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 19, 73, 23),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeShell(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
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
            icon: Icon(Icons.image_outlined),
            selectedIcon: Icon(Icons.image),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'Hannah Leigh Fernandez';
  static const String _tagline =
      'Quit, don\'t quit... noodles... don\'t noodles.';

  static const List<ProfileInfo> _infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'BS Information Technology; 3RD YEAR - Software Development Track',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email_rounded,
      label: 'Email',
      value: 'hannahleigh.fernandez819@gmail.com',
    ),
    ProfileInfo(
      icon: Icons.cake_rounded,
      label: 'Birthday',
      value: 'August 19, 2006',
    ),
    ProfileInfo(
      icon: Icons.music_note_rounded,
      label: 'Favorite Music',
      value: 'Indie Pop, Game Osts, R&B, Rap',
    ),
    ProfileInfo(
      icon: Icons.grade_rounded,
      label: 'Fun fact',
      value: 'I want to become a mortician & pick up taxidermy as a hobby.',
    ),
  ];

  static const List<String> _hobbies = [
    'Gaming',
    'Drawing',
    'Reading Fanfiction',
    'Listening to Music',
    'Digital Art',
    'Watching Anime',
  ];

  static const List<ClassSlot> _classSchedule = [
    ClassSlot(
      day: 'Mon',
      time: '8:00 - 10:00 AM',
      subject: 'Human Computer Interaction',
    ),
    ClassSlot(
      day: 'Tue',
      time: '10:00 - 12:00 PM',
      subject: 'Technopreneurship',
    ),
    ClassSlot(day: 'Wed', time: '1:00 - 3:00 PM', subject: 'Networking 2'),
    ClassSlot(
      day: 'Thurs',
      time: '4:00 - 6:00 PM',
      subject: 'Web Systems & Technologies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('HANNAH LEIGH F. FERNANDEZ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _ProfilePhoto(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(_tagline, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Information section
              for (final info in _infos) InfoTile(info: info),
              const SizedBox(height: 16),

              // Hobbies
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Hobbies', style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final hobby in _hobbies)
                            Chip(label: Text(hobby)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Class Schedule
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Class Schedule', style: textTheme.titleLarge),
                      const SizedBox(height: 16),

                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(75),
                          1: FixedColumnWidth(105),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            children: [
                              for (final heading in ['Day', 'Time', 'Subject'])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    heading,
                                    style: textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          for (final slot in _classSchedule)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(slot.day),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(slot.time),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
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

              // Biography
              Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Hannah Leigh Fernandez is an Information Technology student who wants to make silly apps for silly reasons. '
                        'Growing up in a rural province and being a bit of a shut-in, she witnessed firsthand how technology evolved '
                        'and became a part of everyday life. Filling out Excel sheets and making animations in PowerPoint were what '
                        'first sparked her interest in tech, eventually leading her to programming. She stayed out of pure curiosity '
                        'and, of course, for the fun of it. '
                        'Currently, Leigh is still on her journey to learn more about software development at WVSU. She hopes to grow '
                        'into a developer who creates software that is fun, yet equally clear, accessible, and thoughtful.',
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

// Displays pfp
class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  static const double _size = 96;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/mainpic.jpg',
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        semanticLabel: 'Photo of Hannah Leigh Fernandez',
      ),
    );
  }
}

// Displays information
class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: scheme.onPrimary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
                Text(
                  info.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onPrimary,
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

// Pet screen + counter + audio
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const String _petName = 'Aster';

  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _isLiked = false;
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted && state == PlayerState.completed) {
        setState(() => _isPlaying = false);
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
      _barkCount++;
      _isPlaying = true;
    });
    // Sound logic (every 5th bark uses a different sound)
    final sound = _barkCount % 5 == 0
        ? 'sounds/astertsun.mp3'
        : 'sounds/asterbarking.mp3';
    try {
      await _player.play(AssetSource(sound));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _toggleHeart() => setState(() => _isLiked = !_isLiked);

  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset bark count?'),
          content: const Text(
            'Are you sure you want to reset Aster\'s bark count to zero?',
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

    if (answer == true) {
      setState(() {
        _barkCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timesLabel = _barkCount == 1 ? 'time' : 'times';

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet (Aster)')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Heart toggle
              GestureDetector(
                onDoubleTap: _toggleHeart,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          'assets/images/alpharlabos.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of my pet $_petName',
                        ),
                      ),
                    ),
                    // Heart overlay on top of the photo.
                    IgnorePointer(
                      child: AnimatedScale(
                        scale: _isLiked ? 1 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedOpacity(
                          opacity: _isLiked ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.favorite,
                            size: 96,
                            color: theme.colorScheme.error,
                            semanticLabel: 'Heart',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Double-tap the photo to give $_petName a heart.',
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Sound button
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
              ),
              const SizedBox(height: 8),

              // Counter
              Text(
                '$_petName has barked $_barkCount $timesLabel. Every 5th bark is a different sound!',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

               // Reset counter
              OutlinedButton(
                onPressed: _barkCount == 0 ? null : _confirmReset,
                child: const Text('Reset count'),
              ),
            ],
          ),
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

// gallery
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Photo> _photos = [
    const Photo(
      asset: 'assets/images/gallery/cat1.jpg',
      caption: 'Cool Cat #1',
    ),
    const Photo(
      asset: 'assets/images/gallery/cat2.jpg',
      caption: 'Cute Cat #2',
    ),
    const Photo(
      asset: 'assets/images/gallery/rabbit1.jpg',
      caption: 'Risky Rabbit #1',
    ),
    const Photo(
      asset: 'assets/images/gallery/rabbit2.jpg',
      caption: 'Rambuctios Rabbit #1',
    ),
    const Photo(
      asset: 'assets/images/gallery/tiger1.jpg',
      caption: 'Trippy Tiger #1',
    ),
    const Photo(
      asset: 'assets/images/gallery/tiger2.jpg',
      caption: 'Tart Tiger #2',
    ),
  ];

  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true) {
      setState(() {
        _favoriteAsset = photo.asset;
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
          for (final photo in _photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      photo.asset,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),

                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.star, color: Colors.amber, size: 30),
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
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
