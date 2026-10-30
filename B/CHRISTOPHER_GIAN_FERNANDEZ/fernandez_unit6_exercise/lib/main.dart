import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christopher Gian S. Fernandez',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFEBEEF5),
          indicatorColor: Colors.blue.shade100,
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
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
    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(info.value, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

final List<ProfileInfo> infos = [
  const ProfileInfo(
    icon: Icons.school,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
  const ProfileInfo(
    icon: Icons.code,
    label: 'Skills',
    value: 'HTML, CSS, Java, and C++',
  ),
  const ProfileInfo(
    icon: Icons.location_on,
    label: 'Location',
    value: 'Iloilo, Philippines',
  ),
  const ProfileInfo(
    icon: Icons.favorite,
    label: 'Interests',
    value: 'Photography, Astronomy, and Gaming',
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<String> hobbies = const [
    'Photography',
    'Programming',
    'Technology',
    'Gaming',
    'Watching Movies',
  ];

  final List<ClassSlot> schedule = const [
    ClassSlot(day: 'Monday', time: '9 AM - 12 PM', subject: 'CIT 246'),
    ClassSlot(day: 'Tuesday', time: '7 AM - 9 AM', subject: 'CIT 210'),
    ClassSlot(day: 'Wednesday', time: '1 PM - 4 PM', subject: 'CIT 212'),
    ClassSlot(day: 'Thursday', time: '4 PM - 6 PM', subject: 'CIT 213'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Christopher Gian S. Fernandez')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/DSC_0219.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Gian',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Christopher Gian S. Fernandez',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'An aspiring IT professional and photographer.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('About Me', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final info in infos) InfoTile(info: info),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am an Information Technology student who '
                      'enjoys learning about programming and '
                      'technology. I also enjoy photography and '
                      'exploring new ways to improve my skills.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
            const SizedBox(height: 24),

            const SizedBox(height: 12),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Class Schedule',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(90),
                          1: FixedColumnWidth(120),
                          2: FlexColumnWidth(),
                        },
                        border: TableBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Day',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Subject',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          for (final slot in schedule)
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
          ],
        ),
      ),
    );
  }
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

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late final AudioPlayer _audioPlayer;

  bool _isPlaying = false;
  bool _isLiked = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _audioPlayer.play(AssetSource('sounds/pet_sound.wav'));
    } catch (error) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to play the sound. Check the audio file.'),
          ),
        );
      }
    }
  }

  Future<void> _confirmResetCounter() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Play Counter?'),
        content: const Text(
          'Are you sure you want to reset Miming\'s play counter?',
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
      ),
    );

    if (shouldReset == true && mounted) {
      setState(() {
        _playCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Miming the GOAT')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/pet.jpg',
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet',
                    ),
                  ),
                  if (_isLiked)
                    const Icon(Icons.favorite, color: Colors.red, size: 80),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Meet Miming!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This is my favorite animal companion.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Play Sound'),
            ),
            const SizedBox(height: 16),
            Text(
              'Miming roared $_playCount '
              '${_playCount == 1 ? 'time' : 'times'}.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _playCount == 0 ? null : _confirmResetCounter,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset count'),
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to ${_isLiked ? 'remove' : 'add'} '
              'a heart.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
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
          children: [
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
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

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Photo> photos = const [
    Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Photo 1'),
    Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'Photo 2'),
    Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Photo 3'),
    Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Photo 4'),
    Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Photo 5'),
    Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Photo 6'),
  ];

  Photo? favoritePhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () async {
                final isFavorite = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoScreen(photo: photo),
                  ),
                );

                if (isFavorite == true) {
                  setState(() {
                    favoritePhoto = photo;
                  });
                }
              },
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
                  if (favoritePhoto == photo)
                    const Positioned(
                      top: 6,
                      right: 6,
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
