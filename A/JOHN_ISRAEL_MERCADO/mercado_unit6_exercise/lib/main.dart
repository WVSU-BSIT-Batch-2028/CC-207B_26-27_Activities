import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const String Name = 'John Israel Mercado';
const String Tagline = 'Building difficult things to make life easier';
const String PhotoPath = 'assets/images/me.jpg';
const String Bio =
    'I usually build difficult things to make life easier. I enjoy learning new technologies '
    'and applying them to things that can be useful. Currently, I am a student of WVSU studying '
    'Information Technology and I look forward to getting a job and enjoy myself to the fullest.';

const String petName = 'HOOTIE';
const String petPhotoPath = 'assets/images/favAnimal.jpg';
const String petSoundPath = 'sounds/barnOwlSound.mp3';
const String petVerb = 'Screeched';
const String petNote =
    'My Favorite animal is a Barn Owl, It is cute but scary when it screeches';

const Color seedColor = Colors.indigo;

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.school, label: 'School', value: 'WVSU'),
  ProfileInfo(
    icon: Icons.menu_book,
    label: 'Course',
    value: 'BS Information Technology',
  ),
  ProfileInfo(
    icon: Icons.location_on,
    label: 'Location',
    value: 'Iloilo, Philippines',
  ),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'johnisrael.mercado@wvsu.edu.ph',
  ),
];

const List<String> hobbies = [
  'Coding',
  'Playing Games',
  'Watching Movies',
  'Reading',
  'Music',
  'Writing',
];
const List<ClassSlot> schedule = [
  ClassSlot(
    'Monday',
    '7:00-9:00 AM\nICT 106',
    'CIT 213 - Human Computer Interaction 2',
  ),
  ClassSlot(
    'Wednesday',
    '7:00-10:00 AM\nICT 306',
    'CIT 213 - Human Computer Interaction 2',
  ),
  ClassSlot(
    'Monday',
    '9:00 AM-12:00 PM\nICT 307',
    'CIT 246 - IT Project Management',
  ),
  ClassSlot(
    'Wednesday',
    '10:00 AM-12:00 PM\nICT 307',
    'CIT 246 - IT Project Management',
  ),
  ClassSlot(
    'Monday',
    '1:00-3:00 PM\nICT 307',
    'CIT 210 - Web Systems and Technologies',
  ),
  ClassSlot(
    'Wednesday',
    '1:00-4:00 PM\nICT 307',
    'CIT 210 - Web Systems and Technologies',
  ),
  ClassSlot('Monday', '3:00-4:00 PM\nICT 207', 'CIT 212 - Networking 2'),
  ClassSlot(
    'Monday',
    '4:00-5:30 PM\nICT 106',
    'CC 208 - Methods of Research in Computing',
  ),
  ClassSlot(
    'Wednesday',
    '4:00-5:30 PM\nICT 106',
    'CC 208 - Methods of Research in Computing',
  ),
  ClassSlot(
    'Tuesday',
    '9:00 AM-12:00 PM\nICT 307',
    'CC 207B - Applications Development and Emerging Technologies',
  ),
  ClassSlot('Tuesday', '1:00-2:30 PM\nICT 107', 'BA 234 - Technopreneurship'),
  ClassSlot('Tuesday', '4:00-6:00 PM\nICT 305', 'CIT 212 - Networking 2'),
  ClassSlot(
    'Thursday',
    '10:00 AM-12:00 PM\nICT 307',
    'CC 207B - Applications Development and Emerging Technologies',
  ),
  ClassSlot('Thursday', '1:00-2:30 PM\nICT 107', 'BA 234 - Technopreneurship'),
  ClassSlot('Thursday', '4:00-6:00 PM\nICT 305', 'CIT 212 - Networking 2'),
];

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/1.jpg',
    caption: 'Sunny Rainy Day in WVSU',
  ),
  Photo(
    asset: 'assets/images/gallery/2.jpg',
    caption: 'Minecraft Takes Over McDonalds',
  ),
  Photo(asset: 'assets/images/gallery/3.jpg', caption: 'Miss This Cat'),
  Photo(asset: 'assets/images/gallery/4.jpg', caption: 'FAVVV DESSERT in TGIF'),
  Photo(asset: 'assets/images/gallery/5.jpg', caption: 'McDo but Monochrome'),
  Photo(asset: 'assets/images/gallery/6.jpg', caption: 'Futuristic?????'),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 6 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seedColor, useMaterial3: true),
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
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'Favorite Animal',
          ),
          NavigationDestination(icon: Icon(Icons.photo), label: 'Gallery'),
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

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot(this.day, this.time, this.subject);
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
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: ClipOval(
                    child: Image.asset(
                      PhotoPath,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $Name',
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 48),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Name, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(Tagline, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [for (final info in infos) InfoTile(info: info)],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Card(
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
                          for (final hobby in hobbies) Chip(label: Text(hobby)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Card(
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
                      Table(
                        border: TableBorder.all(
                          color: theme.colorScheme.outline,
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FixedColumnWidth(48),
                          1: FixedColumnWidth(112),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                            ),
                            children: [
                              _cell('Day', bold: true),
                              _cell('Time', bold: true),
                              _cell('Subject', bold: true),
                            ],
                          ),
                          for (final slot in schedule)
                            TableRow(
                              children: [
                                _cell(slot.day.substring(0, 3)),
                                _cell(slot.time),
                                _cell(slot.subject),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(Bio, style: theme.textTheme.bodyMedium),
                    ],
                  ),
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
  bool _isLiked = false;
  int _playCount = 0;

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
      _playCount++;
    });
    try {
      await _player.play(AssetSource(petSoundPath));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: Text('This will set $petName\'s count back to 0.'),
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
    if (answer == true) {
      setState(() => _playCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorite Animal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        petPhotoPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of my favorite animal, $petName',
                        errorBuilder: (_, __, ___) => Container(
                          color: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.pets, size: 96),
                        ),
                      ),
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
            const SizedBox(height: 8),
            Text(
              petNote.isEmpty
                  ? 'Double-tap the photo to give $petName a heart.'
                  : petNote,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Play $petName\'s sound'),
            ),
            const SizedBox(height: 16),
            Text(
              '$petName has $petVerb $_playCount '
              '${_playCount == 1 ? 'time' : 'times'}.',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _playCount == 0 ? null : _confirmReset,
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
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  Widget _tile(Photo photo) {
    final isFavorite = photo.asset == _favoriteAsset;
    return GestureDetector(
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
              errorBuilder: (_, __, ___) => Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          if (isFavorite)
            const Positioned(
              top: 6,
              right: 6,
              child: Icon(Icons.star, color: Colors.amber, size: 28),
            ),
        ],
      ),
    );
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
        children: [for (final photo in photos) _tile(photo)],
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
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    photo.asset,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    semanticLabel: photo.caption,
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
