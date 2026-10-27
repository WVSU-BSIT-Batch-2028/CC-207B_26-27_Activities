import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF000A05);
    const accentColor = Color(0xFFFB3640);

    return MaterialApp(
      title: 'Justin Jerrickho Amaguin',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: accentColor,
              brightness: Brightness.dark,
            ).copyWith(
              primary: accentColor,
              onPrimary: Colors.white,
              secondary: accentColor,
              onSecondary: Colors.white,
              surface: backgroundColor,
            ),
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [ProfileScreen(), MyPetScreen(), GalleryScreen()],
      ),
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _fullName = 'Justin Jerrickho Amaguin';

  static const List<String> hobbies = [
    'Video editing',
    'Football',
    'Video games',
    'LARPing',
    'Volleyball',
  ];

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Gmail',
      value: 'justinamaguin818@gmail.com',
    ),
    ProfileInfo(icon: Icons.school_outlined, label: 'Course', value: 'CC 207B'),
    ProfileInfo(
      icon: Icons.edit_outlined,
      label: 'Skills',
      value: 'Editing, coding, leadership',
    ),
    ProfileInfo(
      icon: Icons.coffee_outlined,
      label: 'Fun fact',
      value: 'Addicted to coffee',
    ),
  ];

  Widget _scheduleCell(String text, {bool header = false}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: header ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(_fullName)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      image: true,
                      label: 'Photo of $_fullName',
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: const AssetImage(
                          'assets/images/headshot.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_fullName, style: theme.textTheme.headlineSmall),
                          Text('Halloooo', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('About Me', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [for (final info in infos) InfoTile(info: info)],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final hobby in hobbies)
                                      Chip(label: Text(hobby)),
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
                                Text(
                                  'My Class Schedule',
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                const Text('Times shown in 24-hour format'),
                                const SizedBox(height: 8),
                                Table(
                                  border: TableBorder.all(
                                    color: theme.colorScheme.outline,
                                  ),
                                  columnWidths: const {
                                    0: FixedColumnWidth(48),
                                    1: FixedColumnWidth(96),
                                    2: FlexColumnWidth(),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                      ),
                                      children: [
                                        _scheduleCell('Day', header: true),
                                        _scheduleCell('Time', header: true),
                                        _scheduleCell('Subject', header: true),
                                      ],
                                    ),
                                    for (final slot in classSchedule)
                                      TableRow(
                                        children: [
                                          _scheduleCell(slot.day),
                                          _scheduleCell(slot.time),
                                          _scheduleCell(slot.subject),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'I enjoy video editing because it lets me turn raw '
                          'clips into stories. I like experimenting with '
                          'cuts, transitions, music, and pacing to make each '
                          'video engaging. I hope to keep improving my skills '
                          'and create polished videos that people enjoy '
                          'watching. :>',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class MyPetScreen extends StatefulWidget {
  const MyPetScreen({super.key});

  @override
  State<MyPetScreen> createState() => _MyPetScreenState();
}

class _MyPetScreenState extends State<MyPetScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription<void> _completionSubscription;
  int _meowCount = 0;
  bool _isPlaying = false;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
      });
    });
  }

  Future<void> _playMeow() async {
    setState(() {
      _isPlaying = true;
      _meowCount++;
    });

    try {
      await _audioPlayer.play(AssetSource('sounds/Meow.mp3'));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not play the meow sound: $error')),
      );
    }
  }

  Future<void> _resetCount() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset count?'),
          content: const Text('Do you want to reset the meow count to zero?'),
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
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _meowCount = 0;
    });
  }

  @override
  void dispose() {
    unawaited(_completionSubscription.cancel());
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            _showHeart = !_showHeart;
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                _isPlaying
                                    ? 'assets/images/PopcatOpen.jpg'
                                    : 'assets/images/PopcatClosed.webp',
                                fit: BoxFit.cover,
                                semanticLabel: _isPlaying
                                    ? 'Popcat with mouth open'
                                    : 'Popcat with mouth closed',
                              ),
                              if (_showHeart)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Icon(
                                      Icons.favorite,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('PopCat', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      'PopCat is my favorite animal.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PopCat has meowed $_meowCount '
                      '${_meowCount == 1 ? 'time' : 'times'}.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _meowCount == 0 ? null : _resetCount,
                      child: const Text('Reset count'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _isPlaying ? null : _playMeow,
                      icon: const Icon(Icons.volume_up),
                      label: Text(_isPlaying ? 'Playing...' : 'Play meow'),
                    ),
                  ],
                ),
              ),
            ),
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
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'Human Nga Mga Handum Montage Scene',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'Human Nga Mga Handum Chime Close-up Scene',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'Human Nga Mga Handum After Bagyo Scene',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'Human Nga Mga Handum Chapel Conflict Scene',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'Human Nga Mga Handum Isko Scene',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'Human Nga Mga Handum After Bagyo Old Production Scene',
  ),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (!mounted || makeFavorite != true) return;

    setState(() {
      _favoriteAsset = photo.asset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 600,
        childAspectRatio: 1920 / 790,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in galleryPhotos)
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
                      semanticLabel: photo.caption,
                    ),
                    if (_favoriteAsset == photo.asset)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                            semanticLabel: 'Favorite photo',
                          ),
                        ),
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
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

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
      ),
    );
  }
}

class ClassSlot {
  const ClassSlot(this.day, this.time, this.subject);

  final String day;
  final String time;
  final String subject;
}

// Times use the 24-hour clock.
const List<ClassSlot> classSchedule = [
  ClassSlot('Mon', '09:00-12:00', 'CIT 246 - IT Project Management'),
  ClassSlot(
    'Mon',
    '13:00-15:00',
    'CIT 212 - Networking 2 (Advanced Networking)',
  ),
  ClassSlot(
    'Mon',
    '15:00-18:00',
    'CC 207B - Applications Development and Emerging Technologies',
  ),
  ClassSlot('Tue', '07:00-09:00', 'CIT 210 - Web Systems and Technologies'),
  ClassSlot('Tue', '11:30-13:00', 'BA 234 - Technopreneurship'),
  ClassSlot('Tue', '13:00-14:30', 'CC 208 - Methods of Research in Computing'),
  ClassSlot('Tue', '15:00-18:00', 'CIT 213 - Human Computer Interaction 2'),
  ClassSlot('Wed', '10:00-12:00', 'CIT 246 - IT Project Management'),
  ClassSlot(
    'Wed',
    '13:00-16:00',
    'CIT 212 - Networking 2 (Advanced Networking)',
  ),
  ClassSlot(
    'Wed',
    '16:00-18:00',
    'CC 207B - Applications Development and Emerging Technologies',
  ),
  ClassSlot('Thu', '07:00-10:00', 'CIT 210 - Web Systems and Technologies'),
  ClassSlot('Thu', '11:30-13:00', 'BA 234 - Technopreneurship'),
  ClassSlot('Thu', '13:00-14:30', 'CC 208 - Methods of Research in Computing'),
  ClassSlot('Thu', '16:00-18:00', 'CIT 213 - Human Computer Interaction 2'),
];
