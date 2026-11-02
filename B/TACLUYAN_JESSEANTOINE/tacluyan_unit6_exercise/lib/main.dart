import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const String studentName = 'Jesse Antoine G. Taclyan';
const String petName = 'Coby';
const String animalDescription = 'This is my pet, coby.';

const String yearAndSection = 'BSIT 3-B';
const String favoriteGame = 'Tetris';
const String favoriteFood = 'Chicken Nuggets';

const List<String> hobbies = [
  'Gaming',
  'Skateboarding',
  'Listening to music',
  'Watching movies',
  'Drawing',
];

const List<ClassSlot> classSlots = [
  ClassSlot(day: 'Monday', time: '9:00–12:00 PM', subject: 'Security Compliance and Governance'),
  ClassSlot(day: 'Tuesday', time: '7:00 AM–9:00 AM', subject: 'Web Systems and Technologies'),
  ClassSlot(day: 'Wednesday', time: '10:00–12:00 PM', subject: 'Security Compliance and Governance'),
  ClassSlot(day: 'Thursday', time: '7:00–10:00 AM', subject: 'Web Systems and Technologies'),
];

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
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
        children: const [
          ProfileScreen(),
          PetScreen(),
          GalleryScreen(),
        ],
      ),
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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.school_outlined, label: 'Course', value: 'BSIT'),
    ProfileInfo(
      icon: Icons.groups_outlined,
      label: 'Year and Section',
      value: yearAndSection,
    ),
    ProfileInfo(
      icon: Icons.sports_esports,
      label: 'Favorite Game',
      value: favoriteGame,
    ),
    ProfileInfo(
      icon: Icons.restaurant_outlined,
      label: 'Favorite Food',
      value: favoriteFood,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(studentName)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/my_photo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $studentName',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BSIT student who enjoys learning new things.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final info in infos) InfoTile(info: info),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'I am a BSIT student who enjoys learning about '
                        'technology, playing games, and exploring new skills. '
                        'I hope to improve my programming abilities and create '
                        'useful applications.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Hobbies', style: theme.textTheme.titleLarge),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Class Schedule',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(76),
                          1: FixedColumnWidth(112),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                            ),
                            children: [
                              _scheduleCell('Day', theme, isHeader: true),
                              _scheduleCell('Time', theme, isHeader: true),
                              _scheduleCell('Subject', theme, isHeader: true),
                            ],
                          ),
                          for (final slot in classSlots)
                            TableRow(
                              children: [
                                _scheduleCell(slot.day, theme),
                                _scheduleCell(slot.time, theme),
                                _scheduleCell(slot.subject, theme),
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
      ),
    );
  }

  static Widget _scheduleCell(
    String value,
    ThemeData theme, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        value,
        style: isHeader
            ? theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodySmall,
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
  bool _showHeart = false;
  int _playCount = 0;

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
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  Future<void> _confirmResetCount() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('Are you sure you want to reset the count to 0?'),
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

    if (answer == true && mounted) {
      setState(() => _playCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Meet $petName',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                animalDescription,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Semantics(
                image: true,
                label: 'Photo of $petName.',
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/my_pet.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of $petName',
                          ),
                          if (_showHeart)
                            Center(
                              child: Icon(
                                Icons.favorite,
                                size: 72,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play $petName sound'),
              ),
              const SizedBox(height: 12),
              Text(
                '$petName sound played $_playCount '
                '${_playCount == 1 ? 'time' : 'times'}.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmResetCount,
                child: const Text('Reset count'),
              ),
              const SizedBox(height: 8),
              Text(
                'Double-tap the photo to show or hide the heart.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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

  static const List<Photo> photos = [
    Photo(
      asset: 'assets/images/gallery/gallery_01.jpg',
      caption: 'Tropical Beach',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_02.jpg',
      caption: 'Forest Path',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_03.jpg',
      caption: 'Sunset Hills',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_04.jpg',
      caption: 'Wildflowers',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_05.jpg',
      caption: 'Mountain Lake',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_06.jpg',
      caption: 'City Lights',
    ),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  Widget _buildPhotoTile(Photo photo) {
    final bool isFavorite = _favoriteAsset == photo.asset;

    return InkWell(
      onTap: () => _open(photo),
      borderRadius: BorderRadius.circular(12),
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
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.58),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                photo.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isFavorite)
            Positioned(
              top: 6,
              right: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.star, color: Colors.amber, size: 22),
                ),
              ),
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
        children: [
          for (final photo in photos) _buildPhotoTile(photo),
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
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                    width: double.infinity,
                  ),
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
