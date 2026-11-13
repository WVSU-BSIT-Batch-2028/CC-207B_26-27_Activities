import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// Own information
// ---------------------------------------------------------------------------
const String kFullName = 'Justin Ace Ardeña';
const String kTagline = 'BSIT student 24/7 on Duty.';
const String kPhotoAsset = 'assets/images/profile.jpg';
const String kPetPhotoAsset = 'assets/images/pet.jpg';
const String kPetSoundAsset = 'sounds/pet_sound.wav'; // relative to assets/
const String kPetName = 'Sherbert';
const String kPetVerb = 'squeaked';
const String kBiography =
    'I am a Bachelor of Science in Information Technology student at West '
    'Visayas State University. I enjoy learning how networks work with '
    'Cybersecurity, solving problems through code, and spending time with my pet. '
    '(I dont actually like pets LMAO)';

const List<ProfileInfo> kInfos = [
  ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT'),
  ProfileInfo(icon: Icons.location_on, label: 'Location', value: 'Iloilo City'),
  ProfileInfo(
      icon: Icons.email, label: 'Email', value: 'justinace.ardena@wvsu.edu.ph'),
  ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Unli Chicken Wings!'),
  ProfileInfo(
      icon: Icons.pets, label: 'Imaginary Pet', value: 'Sherbert (Monkey)'),
];

// Edit these hobbies to match your own interests.
const List<String> kHobbies = [
  'Basketball',
  'Gaming',
  'Mukbang',
  'Coding',
  'Listening to music',
  'Cars',
];

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot(
      {required this.day, required this.time, required this.subject});
}

// BSIT 3A, 1st semester. Rooms stay in the Subject column so the table
// retains its Day / Time / Subject layout on small screens.
const List<ClassSlot> kClasses = [
  ClassSlot(
    day: 'Mon',
    time: '7:00 AM – 9:00 AM',
    subject: 'Human Computer Interaction 2\nICT 106',
  ),
  ClassSlot(
    day: 'Mon',
    time: '9:00 AM – 12:00 PM',
    subject: 'Security Governance\nICT 305',
  ),
  ClassSlot(
    day: 'Mon',
    time: '1:00 PM – 3:00 PM',
    subject: 'Web Systems & Technologies\nICT 307',
  ),
  ClassSlot(
    day: 'Mon',
    time: '4:00 PM – 5:30 PM',
    subject: 'Methods of Research & Computing\nICT 106',
  ),
  ClassSlot(
    day: 'Tue',
    time: '9:00 AM – 12:00 PM',
    subject: 'Applications Development & Emerging Technologies\nICT 307',
  ),
  ClassSlot(
    day: 'Tue',
    time: '1:00 PM – 2:30 PM',
    subject: 'Technopreneurship\nICT 107',
  ),
  ClassSlot(
    day: 'Tue',
    time: '3:00 PM – 6:00 PM',
    subject: 'Networking 2\nICT 305',
  ),
  ClassSlot(
    day: 'Wed',
    time: '7:00 AM – 10:00 AM',
    subject: 'Human Computer Interaction 2\nICT 306',
  ),
  ClassSlot(
    day: 'Wed',
    time: '10:00 AM – 12:00 PM',
    subject: 'Security Governance\nICT 305',
  ),
  ClassSlot(
    day: 'Wed',
    time: '1:00 PM – 4:00 PM',
    subject: 'Web Systems & Technologies\nICT 307',
  ),
  ClassSlot(
    day: 'Wed',
    time: '4:00 PM – 5:30 PM',
    subject: 'Methods of Research & Computing\nICT 106',
  ),
  ClassSlot(
    day: 'Thu',
    time: '10:00 AM – 12:00 PM',
    subject: 'Applications Development & Emerging Technologies\nICT 307',
  ),
  ClassSlot(
    day: 'Thu',
    time: '1:00 PM – 2:30 PM',
    subject: 'Technopreneurship\nICT 107',
  ),
  ClassSlot(
    day: 'Thu',
    time: '4:00 PM – 6:00 PM',
    subject: 'Networking 2\nICT 305',
  ),
];

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

// Replace these six files and edit the captions when you add your own photos.
const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Locked In'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'IT Life'),
  Photo(
      asset: 'assets/images/gallery/photo3.jpg',
      caption: 'Car Lover & Enthusiast'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Who am I'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'WVSU Life'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Basketball Life'),
];

// ---------------------------------------------------------------------------
// App root
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return MaterialApp(
      title: 'Unit 6 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the Pet screen's state (counter, heart) alive
      // while the user switches tabs.
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
          NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'My Pet'),
          NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library),
              label: 'Gallery'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile screen (all stateless)
// ---------------------------------------------------------------------------
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
    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyLarge),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(kFullName)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile row: circular photo + Expanded text column
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      kPhotoAsset,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $kFullName',
                      errorBuilder: (_, __, ___) => const SizedBox(
                        width: 96,
                        height: 96,
                        child: Icon(Icons.person, size: 64),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kFullName, style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(kTagline, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Information section built with collection-for
              Card(
                child: Column(
                  children: [
                    for (final info in kInfos) InfoTile(info: info),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Hobbies', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final hobby in kHobbies)
                            Chip(label: Text(hobby)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Class Schedule',
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Table(
                        border:
                            TableBorder.all(color: theme.colorScheme.outline),
                        columnWidths: const {
                          0: FixedColumnWidth(48),
                          1: FixedColumnWidth(76),
                          2: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                            ),
                            children: [
                              for (final heading in const [
                                'Day',
                                'Time',
                                'Subject'
                              ])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    heading,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          for (final slot in kClasses)
                            TableRow(
                              children: [
                                for (final value in [
                                  slot.day,
                                  slot.time,
                                  slot.subject
                                ])
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(value),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Biography
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(kBiography, style: theme.textTheme.bodyMedium),
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

// ---------------------------------------------------------------------------
// Pet screen (stateful)
// ---------------------------------------------------------------------------
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer(); // created once
  bool _isPlaying = false;
  bool _liked = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose(); // release what you created
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _count++;
    });
    try {
      // AssetSource looks inside the assets/ folder
      await _player.play(AssetSource(kPetSoundAsset));
    } catch (_) {
      // If the sound can't be played, don't leave the button disabled.
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _resetCount() async {
    final bool? reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: const Text('Reset the bark count to zero?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    // Cancel and dismissing the dialog leave the count unchanged.
    if (!mounted) return;
    if (reset == true) setState(() => _count = 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet Sherbert')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onDoubleTap: () => setState(() => _liked = !_liked),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          kPetPhotoAsset,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of my pet, $kPetName',
                          errorBuilder: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.pets, size: 96),
                          ),
                        ),
                      ),
                    ),
                    if (_liked)
                      Icon(Icons.favorite,
                          size: 96, color: theme.colorScheme.error),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlaying ? 'Playing...' : 'Make $kPetName bark'),
              ),
              const SizedBox(height: 16),
              Text(
                '$kPetName has $kPetVerb $_count '
                '${_count == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: _count == 0 ? null : _resetCount,
                child: const Text('Reset count'),
              ),
              const SizedBox(height: 4),
              Text(
                'Double-tap the photo to give $kPetName a heart.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gallery screen (stateful) and photo screen (stateless)
// ---------------------------------------------------------------------------
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    // true from Make favorite; null from the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (!mounted) return;
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: SafeArea(
        child: GridView.extent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          children: [
            for (final photo in photos)
              GestureDetector(
                onTap: () => _open(photo),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.photo, size: 48),
                        ),
                      ),
                      if (_favoriteAsset == photo.asset)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            semanticLabel: 'Favorite photo',
                            shadows: const [
                              Shadow(
                                  color: Colors.black, offset: Offset(-1, -1)),
                              Shadow(
                                  color: Colors.black, offset: Offset(1, -1)),
                              Shadow(
                                  color: Colors.black, offset: Offset(-1, 1)),
                              Shadow(color: Colors.black, offset: Offset(1, 1)),
                            ],
                          ),
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

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.photo, size: 96),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Make favorite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
