import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT'),
  ProfileInfo(
    icon: Icons.account_balance,
    label: 'School',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.restaurant,
    label: 'Favorite Food',
    value: 'Anything on the table except fish',
  ),
  ProfileInfo(icon: Icons.location_city, label: 'City', value: 'Iloilo City'),
  ProfileInfo(icon: Icons.pets, label: 'Pet', value: 'Tilap'),
];

const List<String> hobbies = [
  'Watching movies',
  'Logging movies on Letterboxd',
  'Catching up on sleep',
  'Playing with my cats',
  'Taking photos',
];

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

const List<ClassSlot> schedule = [
  ClassSlot(
    day: 'Mon',
    time: '9:00-12:00',
    subject: 'CIT 246 IT Project Management',
  ),
  ClassSlot(day: 'Mon', time: '1:00-3:00', subject: 'CIT 212 Networking 2'),
  ClassSlot(day: 'Mon', time: '3:00-6:00', subject: 'CC 207B Apps Development'),
  ClassSlot(day: 'Tue', time: '7:00-9:00', subject: 'CIT 210 Web Systems'),
  ClassSlot(
    day: 'Tue',
    time: '11:30-1:00',
    subject: 'BA 234 Technopreneurship',
  ),
  ClassSlot(day: 'Tue', time: '1:00-2:30', subject: 'CC 208 Research Methods'),
  ClassSlot(day: 'Tue', time: '3:00-6:00', subject: 'CIT 213 HCI 2'),
  ClassSlot(
    day: 'Wed',
    time: '10:00-12:00',
    subject: 'CIT 246 IT Project Management',
  ),
  ClassSlot(day: 'Wed', time: '1:00-4:00', subject: 'CIT 212 Networking 2'),
  ClassSlot(day: 'Wed', time: '4:00-6:00', subject: 'CC 207B Apps Development'),
  ClassSlot(day: 'Thu', time: '7:00-9:00', subject: 'CIT 210 Web Systems'),
  ClassSlot(
    day: 'Thu',
    time: '11:30-1:00',
    subject: 'BA 234 Technopreneurship',
  ),
  ClassSlot(day: 'Thu', time: '1:00-2:30', subject: 'CC 208 Research Methods'),
  ClassSlot(day: 'Thu', time: '4:00-6:00', subject: 'CIT 213 HCI 2'),
];

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label),
      subtitle: Text(info.value),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile and Pet',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
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
        children: const [ProfileScreen(), PetScreen(), GalleryScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          // Update the selected tab so the matching screen is displayed.
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Moses John Hermosura')),
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
                    width: 104,
                    height: 104,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Moses John Hermosura',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moses John Hermosura',
                        style: textTheme.headlineSmall,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sagad mag standing sa modern jeep',
                          maxLines: 1,
                          softWrap: false,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final info in infos) InfoTile(info: info),
            SizedBox(
              width: double.infinity,
              child: Card(
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
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      "I am Moses, 20, and currently a 3rd Year BSIT student at West Visayas State University. I enjoy going to school, especially after midterms, since it's the time of the school year when all we do is check papers and do nothing. I love watching movies and playing with my cats. I love all my cats, but I want to highlight Tilap because she is an orphan. I hope my program brings me success in the future so my cats and I can live comfortably.",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Class Schedule', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Table(
                        border: TableBorder.all(color: colors.outline),
                        columnWidths: const {
                          0: FixedColumnWidth(48),
                          1: FixedColumnWidth(92),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                            ),
                            children: const [
                              ScheduleCell('Day', bold: true),
                              ScheduleCell('Time', bold: true),
                              ScheduleCell('Subject', bold: true),
                            ],
                          ),
                          for (final slot in schedule)
                            TableRow(
                              children: [
                                ScheduleCell(slot.day),
                                ScheduleCell(slot.time),
                                ScheduleCell(slot.subject),
                              ],
                            ),
                        ],
                      ),
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
  bool _showHeart = false;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/meow.mp3'));
    } catch (error) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
      debugPrint('Failed to play Tilap\'s meow: $error');
    }
  }

  Future<void> _confirmReset() async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Tilap has meowed $_playCount times. Start again from zero?',
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
    if (ok == true && mounted) {
      setState(() => _playCount = 0);
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/cat.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Tilap, my cat',
                          ),
                        ),
                        if (_showHeart)
                          Center(
                            child: Icon(
                              Icons.favorite,
                              size: 72,
                              color: theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tilap is my pet cat',
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play meow'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Tilap has meowed $_playCount times.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmReset,
                child: const Text('Reset count'),
              ),
            ),
          ],
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

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'IVOS Zild shot by me',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'IVOS Zild shot by me again',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'IVOS Zild shot by me yet again',
  ),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'IVOS Zild again'),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'IVOS Zild again?!',
  ),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'IVOS, shot by me'),
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
    if (makeFavorite == true && mounted) {
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
                  if (photo.asset == _favoriteAsset)
                    const Positioned(
                      top: 4,
                      right: 4,
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
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

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
    );
  }
}

class ScheduleCell extends StatelessWidget {
  const ScheduleCell(this.text, {super.key, this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
