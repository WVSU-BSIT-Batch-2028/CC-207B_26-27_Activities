import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'shelf/shelf_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CC 207B Unit 7 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8D5BA),
        ).copyWith(
          primary: const Color(0xFF8CC5A2),
          onPrimary: const Color(0xFF123524),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDFF3E6),
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
    ShelfScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Shelf',
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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: colors.primary),
          const SizedBox(width: 16),
          SizedBox(
            width: 110,
            child: Text(info.label, style: textTheme.labelLarge),
          ),
          Expanded(
            child: Text(info.value, style: textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _fullName = 'Alyanna Bianca S. Serra';
  static const String _tagline = '3rd-year BSIT student at WVSU';

  // Part C-a: the Hobbies row was removed from here (now shown as chips).
  static const List<ProfileInfo> _infos = [
    ProfileInfo(
        icon: Icons.cake, label: 'Birthdate', value: 'March 21, 2006'),
    ProfileInfo(
        icon: Icons.home,
        label: 'Address',
        value: 'Cabatuan, Iloilo, Philippines'),
    ProfileInfo(
        icon: Icons.email,
        label: 'Email',
        value: 'alyannabianca.serra@wvsu.edu.ph'),
    ProfileInfo(
        icon: Icons.school,
        label: 'Education',
        value: 'West Visayas State University'),
    ProfileInfo(
        icon: Icons.computer,
        label: 'Course',
        value: 'Bachelor of Science in Information Technology'),
  ];

  static const String _biography =
      '¡Hola, mi amigo! I\'m Yana, a 3rd-year BSIT student at West Visayas State University, where technology meets creativity and sometimes a little debugging chaos. '
      'When I\'m not busy with schoolwork, you\'ll probably find me sketching, watching movies, and playing games, my favorite ways to unwind and keep myself sane from academic stress. '
      'Thanks for stopping by and getting to know me! I hope this little introduction gives you a glimpse of who I am, what I love, and the creative ideas I have yet to bring to life. After all, I\'m still learning and definitely not done yet! ';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(_fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $_fullName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_fullName, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(_tagline, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (final info in _infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Part C-a: hobbies as chips
            const HobbiesCard(),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(_biography, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Part C-b: class schedule table
            const ScheduleCard(),
          ],
        ),
      ),
    );
  }
}

const List<String> hobbies = [
  'Sketching',
  'Watching Movies',
  'Playing Games',
  'Learning Languages',
  'Quality Time with My Pets',
];

class HobbiesCard extends StatelessWidget {
  const HobbiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Hobbies', style: Theme.of(context).textTheme.titleLarge),
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

const List<ClassSlot> schedule = [
  ClassSlot(day: 'Mon', time: '7:00-9:00', subject: 'CIT 213 HCI 2'),
  ClassSlot(day: 'Tue', time: '9:00-12:00', subject: 'CC 207B App Dev'),
  ClassSlot(day: 'Wed', time: '1:00-4:00', subject: 'CIT 210 Web Systems'),
  ClassSlot(day: 'Thu', time: '4:00-6:00', subject: 'CIT 212 Networking 2'),
];

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Class Schedule',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: colors.outlineVariant),
              columnWidths: const {
                0: FixedColumnWidth(52),
                1: FixedColumnWidth(100),
                2: FlexColumnWidth(),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: colors.primaryContainer),
                  children: [
                    _cell('Day', bold: true),
                    _cell('Time', bold: true),
                    _cell('Subject', bold: true),
                  ],
                ),
                for (final slot in schedule)
                  TableRow(children: [
                    _cell(slot.day),
                    _cell(slot.time),
                    _cell(slot.subject),
                  ]),
              ],
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
  static const String _petName = 'Mingkay';
  static const String _verb = 'meowed';

  final AudioPlayer _player = AudioPlayer(); 
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
    _player.dispose(); 
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _count++;
    });
    try {
      await _player.play(AssetSource('sounds/cute-meow.wav'));
    } catch (e) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _confirmReset() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
            '$_petName has $_verb $_count ${_count == 1 ? 'time' : 'times'}. Start again from zero?'),
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
      ),
    );

    if (confirmed == true) {
      setState(() => _count = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _liked = !_liked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/mingkay.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        semanticLabel: 'Photo of my pet, $_petName',
                      ),
                    ),
                  ),
                  if (_liked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Meet $_petName', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Sound button with feedback
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
            ),
            const SizedBox(height: 16),

            // Counter
            Text(
              '$_petName has $_verb $_count ${_count == 1 ? 'time' : 'times'}.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: _count == 0 ? null : _confirmReset,
              child: const Text('Reset count'),
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

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/book.jpg', caption: 'coffee and this'),
  Photo(asset: 'assets/images/gallery/bread.jpg', caption: 'bread & pastries'),
  Photo(asset: 'assets/images/gallery/plushy.jpg', caption: 'my favorite sanrio character'),
  Photo(asset: 'assets/images/gallery/pop.jpg', caption: 'no caption'),
  Photo(asset: 'assets/images/gallery/rawr.jpg', caption: '1 lucky rawr from Pepper'),
  Photo(asset: 'assets/images/gallery/soda.jpg', caption: 'someone\'s favorite soda'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset; 

  Future<void> _open(Photo photo) async {
    // push<bool> completes with what PhotoScreen pops:
    // true from "Make favorite", null from the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
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
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
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
                  if (photo.asset == _favoriteAsset)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.star, color: Colors.amber),
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
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
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