import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const Unit6ExerciseApp());
}

class Unit6ExerciseApp extends StatelessWidget {
  const Unit6ExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const dustyOrchid = Color(0xFFD56989);
    const petalGlaze = Color(0xFFEA9CAF);
    const powderedLilacGrey = Color(0xFFF3EEF1);
    const sorbetStem = Color(0xFFC2DC80);

    return MaterialApp(
      title: 'Unit 6 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: dustyOrchid,
        fontFamilyFallback: const ['sans-serif'],
        
        colorScheme: const ColorScheme.light(
          surface: petalGlaze,
          primary: sorbetStem,
          onSurface: powderedLilacGrey,
          onPrimary: powderedLilacGrey,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: dustyOrchid,
          foregroundColor: powderedLilacGrey,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: powderedLilacGrey,
          ),
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: dustyOrchid,
          indicatorColor: petalGlaze,
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: sorbetStem),
          ),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: powderedLilacGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        cardTheme: const CardThemeData(
          color: petalGlaze,
          elevation: 2,
        ),

        chipTheme: ChipThemeData(
          backgroundColor: petalGlaze,
          labelStyle: const TextStyle(
            color: powderedLilacGrey,
            fontWeight: FontWeight.bold,
          ),
          side: const BorderSide(color: sorbetStem),
        ),

        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: powderedLilacGrey,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: powderedLilacGrey,
          ),
          bodyLarge: TextStyle(
            color: powderedLilacGrey,
          ),
          bodyMedium: TextStyle(
            color: powderedLilacGrey,
          ),
          labelLarge: TextStyle(
            color: powderedLilacGrey,
          ),
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

  const ClassSlot(this.day, this.time, this.subject);
}

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/gallery/1.png', caption: 'Pink Blossom'),
  Photo(asset: 'assets/gallery/2.png', caption: 'Lily Bloom'),
  Photo(asset: 'assets/gallery/3.png', caption: 'Orchid Petal'),
  Photo(asset: 'assets/gallery/4.png', caption: 'Gerbera Daisy'),
  Photo(asset: 'assets/gallery/5.png', caption: 'Petal Dew'),
  Photo(asset: 'assets/gallery/6.png', caption: 'Lotus Flower'),
];

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    const sorbetStem = Color(0xFFC2DC80);
    const powderedLilacGrey = Color(0xFFF3EEF1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(info.icon, color: sorbetStem),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              info.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: powderedLilacGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info.value,
              style: const TextStyle(
                color: powderedLilacGrey,
              ),
            ),
          ),
        ],
      ),
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
            icon: Icon(Icons.collections_outlined),
            selectedIcon: Icon(Icons.collections),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> infos = const [
    ProfileInfo(
      icon: Icons.cake,
      label: 'Birthdate',
      value: 'June 28, 2005',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Address',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'aecielle.cervantes@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.book,
      label: 'Course',
      value: 'BS in Information Technology',
    ),
  ];

  final List<String> hobbies = const [
    'Sleeping',
    'Baking',
    'Gaming',
    'Travelling',
    'Painting',
    'Badminton',
  ];

  final List<ClassSlot> schedule = const [
    ClassSlot('Mon', '9:00-12:00', 'CIT 246 IT Project Management'),
    ClassSlot('Tue', '7:00-9:00', 'CIT 210 Web System and Technology'),
    ClassSlot('Wed', '1:00-4:00', 'CIT 212 Networking 2'),
    ClassSlot('Thu', '4:00-6:00', 'CIT 213 Human Computer Interaction 2'),
    ClassSlot('Fri', '3:00-6:00', 'CC 207B Application Development and Emerging Technologies'),
  ];

  @override
  Widget build(BuildContext context) {
    const powderedLilacGrey = Color(0xFFF3EEF1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aecielle Cervantes Exercise 6'),
        centerTitle: true,
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
                    'assets/images/profile.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Aecielle Cervantes',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aecielle Cervantes',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: powderedLilacGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BSIT 3B Student',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    for (final info in infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Hobbies',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: powderedLilacGrey,
                      ),
                    ),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Class Schedule',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: powderedLilacGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(55),
                        1: FixedColumnWidth(100),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(6),
                              child: Text(
                                'Day',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A5D18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6),
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A5D18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6),
                              child: Text(
                                'Subject',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A5D18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final slot in schedule)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(slot.day),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(slot.time),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Get to know Aecielle...',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: powderedLilacGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hi! I’m Aecielle, an IT student at West Visayas State University with a passion for beautiful UI design and mobile development. When I’m not writing clean code, you’ll find me baking cinnamon rolls, exploring new places, or playing video games. I love bringing creative ideas to life through thoughtful technology!',
                      style: Theme.of(context).textTheme.bodyMedium,
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

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoved = false;
  int _soundCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
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
      _isPlaying = true;
      _soundCount++;
    });
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

  Future<void> _confirmReset() async {
    final bool? reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Gin Bilog has meowed $_soundCount times. Start again from zero?',
        ),
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

    if (reset == true) {
      setState(() {
        _soundCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sorbetStem = Color(0xFFC2DC80);
    const powderedLilacGrey = Color(0xFFF3EEF1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet, Gin Bilog'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isLoved = !_isLoved;
                });
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/pet.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet',
                    ),
                  ),
                  if (_isLoved)
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 36,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: sorbetStem,
                foregroundColor: const Color(0xFF4A5D18),
              ),
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Meow'),
            ),
            const SizedBox(height: 12),

            Text(
              'Gin Bilog meowed $_soundCount times.',
              style: const TextStyle(
                color: powderedLilacGrey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              'Double tap to make her feel loved!',
              style: const TextStyle(
                color: powderedLilacGrey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: powderedLilacGrey,
                side: const BorderSide(color: powderedLilacGrey),
              ),
              onPressed: _soundCount == 0 ? null : _confirmReset,
              child: const Text('Reset count'),
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
  String? _favoriteAsset;

  Future<void> _openPhoto(Photo photo) async {
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
            GestureDetector(
              onTap: () => _openPhoto(photo),
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
                  if (_favoriteAsset == photo.asset)
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

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(photo.asset, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.star),
                label: const Text('Make favorite'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}