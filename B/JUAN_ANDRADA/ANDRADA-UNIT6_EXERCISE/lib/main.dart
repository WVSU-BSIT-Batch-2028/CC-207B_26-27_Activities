import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// App + theme
// ---------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juan Andrada',
      debugShowCheckedModeBanner: false,
      // Change this one color and every screen follows.
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeShell: bottom navigation between Profile, My Pet and Gallery
// ---------------------------------------------------------------------------

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
      // IndexedStack keeps the pet counter when you switch tabs.
      body: IndexedStack(index: _selectedIndex, children: _screens),
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
            icon: Icon(Icons.pets),
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

// ---------------------------------------------------------------------------
// Profile data model
// ---------------------------------------------------------------------------

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

// One class in the weekly schedule
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

// ---------------------------------------------------------------------------
// Profile screen (stateless: it only shows information)
// ---------------------------------------------------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String fullName = 'Juan Miguel Rashley Andrada';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: 'Course and Section',
      value: 'BS Information Technology, 3-B',
    ),
    ProfileInfo(
      icon: Icons.home,
      label: 'Hometown',
      value: 'Leon, Iloilo',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Spaghetti',
    ),
    ProfileInfo(
      icon: Icons.pets,
      label: 'Pet',
      value: 'Louie, my cat',
    ),
  ];

  // Hobbies are shown as chips, not as an information row
  static const List<String> hobbies = [
    'Gym',
    'Sports',
    'Games',
    'Watching movies',
    'Eating',
  ];

  static const List<ClassSlot> classes = [
    ClassSlot(
      day: 'Mon',
      time: '9:00 AM - 12:00 PM',
      subject: 'CIT 251 Security Compliance and Governance',
    ),
    ClassSlot(
      day: 'Mon',
      time: '1:00 - 3:00 PM',
      subject: 'CIT 212 Networking 2',
    ),
    ClassSlot(
      day: 'Mon',
      time: '3:00 - 6:00 PM',
      subject: 'CC 207B Applications Development and Emerging Technologies',
    ),
    ClassSlot(
      day: 'Tue',
      time: '7:00 - 9:00 AM',
      subject: 'CIT 210 Web Systems and Technologies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final headerStyle =
        textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: const Text('Juan Miguel Andrada')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile row: photo on the left, name and tagline on the right
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/me.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Juan Miguel Rashley Andrada',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        'BSIT student, gym regular, and spaghetti lover.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Information section built from the list (no copy-paste)
            Card(
              child: Column(
                children: [
                  for (final info in infos) InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Hobbies as chips: Wrap moves chips to the next line when full
            Card(
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
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Class schedule: a Table so every row shares the same columns
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
                        0: FixedColumnWidth(56),
                        1: FixedColumnWidth(120),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                          ),
                          children: [
                            _cell(Text('Day', style: headerStyle)),
                            _cell(Text('Time', style: headerStyle)),
                            _cell(Text('Subject', style: headerStyle)),
                          ],
                        ),
                        for (final slot in classes)
                          TableRow(
                            children: [
                              _cell(Text(slot.day, style: textTheme.bodySmall)),
                              _cell(
                                Text(slot.time, style: textTheme.bodySmall),
                              ),
                              _cell(
                                Text(slot.subject, style: textTheme.bodySmall),
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

            // Biography
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "I'm Juan Miguel Rashley Andrada, a BSIT 3-B student at "
                      'West Visayas State University, and I grew up in Leon, '
                      'Iloilo. Outside of class, I spend most of my free time '
                      'at the gym and playing sports, which keep me disciplined '
                      'and energized for school. I enjoy building apps and '
                      'learning how technology can solve everyday problems. '
                      'And if you ever want to make my day, a plate of '
                      'spaghetti always works.',
                      style: textTheme.bodyMedium,
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

  // Same padding for every table cell
  static Widget _cell(Widget child) =>
      Padding(padding: const EdgeInsets.all(8), child: child);
}

// One row in the information section
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

// ---------------------------------------------------------------------------
// Pet screen (stateful: it reacts to taps)
// ---------------------------------------------------------------------------

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const String petName = 'Louie';

  // Created once, released in dispose()
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;

  bool _isPlaying = false;
  bool _showHeart = false;
  int _meowCount = 0;

  @override
  void initState() {
    super.initState();
    // Turn the button back on when the sound finishes
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _meowCount++;
    });

    try {
      // AssetSource already adds "assets/" in front of this path
      await _player.play(AssetSource('sounds/meow.mp3'));
    } catch (e) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  // Ask before resetting. The dialog gives back a bool?: true from Reset,
  // false from Cancel, null when it is closed by tapping outside it.
  Future<void> _confirmReset() async {
    final bool? reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: Text("This sets $petName's meow count back to 0."),
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
    if (reset == true && mounted) {
      setState(() => _meowCount = 0);
    }
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final timesWord = _meowCount == 1 ? 'time' : 'times';

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo with double-tap heart
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/images/pet.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of $petName, my cat',
                          ),
                        ),
                      ),
                      if (_showHeart)
                        Icon(
                          Icons.favorite,
                          size: 120,
                          color: theme.colorScheme.error,
                          semanticLabel: 'Heart',
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Double-tap the photo to show some love.',
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  petName,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Sound button
                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Playing...' : "Play $petName's meow"),
                ),
                const SizedBox(height: 16),

                // Counter
                Text(
                  '$petName has meowed $_meowCount $timesWord.',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Reset button: disabled while there is nothing to reset
                OutlinedButton(
                  onPressed: _meowCount == 0 ? null : _confirmReset,
                  child: const Text('Reset count'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gallery data
// ---------------------------------------------------------------------------

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/images/gallery/gym.jpg', caption: 'Training at the gym'),
  Photo(
    asset: 'assets/images/gallery/basketball.jpg',
    caption: 'Playing basketball',
  ),
  Photo(
    asset: 'assets/images/gallery/spaghetti.jpg',
    caption: 'My favorite food: spaghetti',
  ),
  Photo(
    asset: 'assets/images/gallery/leon.jpg',
    caption: 'My hometown, Leon, Iloilo',
  ),
  Photo(
    asset: 'assets/images/gallery/wvsu.jpg',
    caption: 'West Visayas State University',
  ),
  Photo(asset: 'assets/images/gallery/louie.jpg', caption: 'Louie, my cat'),
];

// ---------------------------------------------------------------------------
// Gallery screen (stateful: it remembers the favorite photo)
// ---------------------------------------------------------------------------

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Only one favorite: we store just its asset path (null = none yet)
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    // push<bool> completes with what PhotoScreen pops:
    // true from "Make favorite", null from the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true && mounted) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in galleryPhotos)
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
                  // Star on top of the favorite photo
                  if (_favoriteAsset == photo.asset)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: colors.surface,
                        child: Icon(
                          Icons.star,
                          size: 20,
                          color: colors.primary,
                          semanticLabel: 'Favorite',
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

// ---------------------------------------------------------------------------
// Photo screen (stateless: it only shows one photo and sends an answer back)
// ---------------------------------------------------------------------------

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.cover,
                    semanticLabel: photo.caption,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.star),
                  label: const Text('Make favorite'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}