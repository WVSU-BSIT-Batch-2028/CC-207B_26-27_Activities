import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// App root (old photography theme: sepia browns, aged paper, serif font)
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF7B5B3A))
        .copyWith(
          primary: const Color(0xFF6B4F32),
          onPrimary: const Color(0xFFF8F0E0),
          primaryContainer: const Color(0xFFE2CBA6),
          onPrimaryContainer: const Color(0xFF3B2A1A),
          secondaryContainer: const Color(0xFFDCC4A0),
          onSecondaryContainer: const Color(0xFF3B2A1A),
          surface: const Color(0xFFF3E7D3),
          onSurface: const Color(0xFF3B2A1A),
          onSurfaceVariant: const Color(0xFF6E5A45),
          surfaceContainerLow: const Color(0xFFEADBC0),
          surfaceContainer: const Color(0xFFE6D5B8),
          outlineVariant: const Color(0xFFC9B48F),
          error: const Color(0xFF9C3D2E),
        );

    return MaterialApp(
      title: 'Unit 6 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        fontFamily: 'Georgia',
        fontFamilyFallback: const ['Times New Roman', 'serif'],
        appBarTheme: AppBarTheme(
          centerTitle: true,
          scrolledUnderElevation: 0,
          shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeShell: Scaffold + NavigationBar. IndexedStack keeps every tab alive,
// so the bark count survives tab switches (Part A).
// ---------------------------------------------------------------------------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<String> _titles = ['Unit 6 Exercise', 'My Pet', 'Gallery'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The Gallery tab has its own AppBar (Part B), so skip this one there.
      appBar: _selectedIndex == 2
          ? null
          : AppBar(title: Text(_titles[_selectedIndex])),
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

// ---------------------------------------------------------------------------
// Data models
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

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

// ---------------------------------------------------------------------------
// Profile screen (stateless)
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Hobbies are no longer an information row (Part C-a).
  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT 3-A'),
    ProfileInfo(
      icon: Icons.apartment,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Lechon, Ice Cream',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Lapaz City, Iloilo',
    ),
  ];

  static const List<String> hobbies = [
    'Sleeping',
    'Gaming',
    'Chess',
    'Listening to music',
    'Cooking',
  ];

  static const List<ClassSlot> schedule = [
    ClassSlot(day: 'Mon', time: '7:00 AM-9:00 AM', subject: 'CIT 213'),
    ClassSlot(day: 'Mon', time: '9:00 AM-12:00 PM', subject: 'CIT 251'),
    ClassSlot(day: 'Mon', time: '1:00 PM-3:00 PM', subject: 'CIT 210'),
    ClassSlot(day: 'Mon', time: '4:00 PM-5:30 PM', subject: 'CC 208'),
    ClassSlot(day: 'Tue', time: '9:00 AM-12:00 PM', subject: 'CC 207B'),
    ClassSlot(day: 'Tue', time: '1:00 PM-2:30 PM', subject: 'BA 234'),
    ClassSlot(day: 'Tue', time: '3:00 PM-6:00 PM', subject: 'CIT 212'),
    ClassSlot(day: 'Wed', time: '7:00 AM-10:00 AM', subject: 'CIT 213'),
    ClassSlot(day: 'Wed', time: '10:00 AM-12:00 PM', subject: 'CIT 251'),
    ClassSlot(day: 'Wed', time: '1:00 PM-4:00 PM', subject: 'CIT 210'),
    ClassSlot(day: 'Wed', time: '4:00 PM-5:30 PM', subject: 'CC 208'),
    ClassSlot(day: 'Thu', time: '10:00 AM-12:00 PM', subject: 'CC 207B'),
    ClassSlot(day: 'Thu', time: '1:00 PM-2:30 PM', subject: 'BA 234'),
    ClassSlot(day: 'Thu', time: '4:00 PM-6:00 PM', subject: 'CIT 212'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    const bold = TextStyle(fontWeight: FontWeight.bold);
    final headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: colors.onPrimaryContainer,
    );
    final dayStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: colors.primary,
    );

    // Distinct days in order, used to tint every other day group.
    final days = [for (final slot in schedule) slot.day].toSet().toList();

    Widget cell(String text, {TextStyle? style}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Text(text, style: style),
      );
    }

    // One TableRow per class. The day is shown only on the first row of its
    // group, and every other day group gets a soft tint.
    TableRow classRow(int i) {
      final slot = schedule[i];
      final bool firstOfDay = i == 0 || schedule[i - 1].day != slot.day;
      final bool tinted = days.indexOf(slot.day).isOdd;
      return TableRow(
        decoration: BoxDecoration(
          color: tinted ? colors.secondaryContainer.withValues(alpha: 0.35) : null,
        ),
        children: [
          cell(firstOfDay ? slot.day : '', style: dayStyle),
          cell(slot.time),
          cell(slot.subject, style: bold),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile row
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/me.jpg',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  semanticLabel: 'Photo of Jose Emmanuel Sariego',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jose Emmanuel Sariego',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aspiring developer who loves building apps.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Information section (collection-for)
          Card(
            child: Column(
              children: [for (final info in infos) InfoTile(info: info)],
            ),
          ),
          const SizedBox(height: 16),

          // Part C-a: hobbies as Chips inside a Wrap
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
          const SizedBox(height: 16),

          // Part C-b: class schedule as a Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Class Schedule', style: textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    '1st Semester, A.Y. 2025-2026',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Table(
                      border: TableBorder.all(
                        color: colors.outlineVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      // Day and Time are fixed; Subject takes the rest.
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FixedColumnWidth(112),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                          ),
                          children: [
                            cell('Day', style: headerStyle),
                            cell('Time', style: headerStyle),
                            cell('Subject', style: headerStyle),
                          ],
                        ),
                        for (int i = 0; i < schedule.length; i++) classRow(i),
                      ],
                    ),
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
                  Text('Who\'s Jose?', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'I am an IT student who enjoys learning about technology, exploring programming, and discovering how things work behind the applications we use every day. As I continue my journey in Information Technology, I see every project and challenge as an opportunity to learn something new and improve my skills. I know I still have a lot to learn, but I am willing to put in the effort to grow and become better at what I do.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label),
      subtitle: Text(info.value),
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
  static const String _petName = 'Barnuts';
  static const String _soundWord = 'barked';

  // Lifecycle: create the player once, release it in dispose().
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _isLiked = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    // Re-enable the button when the sound finishes.
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
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
      _playCount++;
    });
    try {
      // AssetSource paths are relative to the assets/ folder.
      await _player.play(AssetSource('sounds/pet.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  // Part D-b: ask first. showDialog<bool> completes with what the dialog pops.
  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: const Text('The bark count will go back to 0.'),
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
    if (answer == true && mounted) {
      setState(() => _playCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo with double-tap heart
          GestureDetector(
            onDoubleTap: () => setState(() => _isLiked = !_isLiked),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(
                      'assets/images/pet.jpg',
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet, $_petName',
                    ),
                  ),
                  if (_isLiked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sound button
          FilledButton.icon(
            onPressed: _isPlaying ? null : _playSound,
            icon: const Icon(Icons.volume_up),
            label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
          ),
          const SizedBox(height: 16),

          // Counter
          Text(
            '$_petName has $_soundWord $_playCount '
            '${_playCount == 1 ? 'time' : 'times'}.',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Part D-a: disabled while the count is 0
          OutlinedButton(
            onPressed: _playCount == 0 ? null : _confirmReset,
            child: const Text('Reset count'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gallery (Part B)
// ---------------------------------------------------------------------------

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'MLBB Account'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'ME'),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Volleyball Team'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'MLBB Team'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Class Picturial'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Gallery'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Only one photo can be the favorite, so store just its asset path.
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
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      semanticLabel: photo.caption,
                    ),
                    if (photo.asset == _favoriteAsset)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(Icons.star, color: Colors.amber),
                      ),
                  ],
                ),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                // Center gives the image loose constraints, so it keeps its
                // own shape (portrait or landscape) and the rounded corners
                // hug the picture instead of the whole empty area.
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      semanticLabel: photo.caption,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: FilledButton.icon(
                // Pop with a result for the screen that pushed us.
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
