import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Profile App',
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
    const titles = ['Christian Paul De la Cruz', 'My Pet', 'Gallery'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
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

const List<ProfileInfo> profileInfos = [
  ProfileInfo(icon: Icons.school_outlined, label: 'Course', value: 'BSIT'),
  ProfileInfo(
    icon: Icons.apartment_outlined,
    label: 'School',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.calendar_month_outlined,
    label: 'Year and Section',
    value: 'BSIT 3A',
  ),
];

const List<String> hobbies = [
  'Cooking',
  'Reading books',
  'Travelling',
  'Gardening',
  'Running',
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

const List<ClassSlot> classSchedule = [
  ClassSlot(day: 'Monday', time: '7:00–9:00', subject: 'Human Computer Interaction'),
  ClassSlot(day: 'Monday', time: '1:00–3:00', subject: 'Web System'),
  ClassSlot(day: 'Tuesday', time: '1:00–2:30 PM', subject: 'Technoprenuership'),
  ClassSlot(day: 'Tuesday', time: '4:00–5:30', subject: 'Research'),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/profile_illustration.jpg',
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                            semanticLabel: 'Profile illustration',
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Christian Paul De la Cruz',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'LIVING LIFE TO THE FULLEST, MEMENTO MORI',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'A little about me',
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        for (final info in profileInfos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                        const SizedBox(height: 12),
                        Table(
                          border: TableBorder.all(
                            color: colors.outlineVariant,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(78),
                            1: FixedColumnWidth(102),
                            2: FlexColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: colors.secondaryContainer,
                              ),
                              children: [
                                _ScheduleCell(
                                  'Day',
                                  bold: true,
                                  color: colors.onSecondaryContainer,
                                ),
                                _ScheduleCell(
                                  'Time',
                                  bold: true,
                                  color: colors.onSecondaryContainer,
                                ),
                                _ScheduleCell(
                                  'Subject',
                                  bold: true,
                                  color: colors.onSecondaryContainer,
                                ),
                              ],
                            ),
                            for (final slot in classSchedule)
                              TableRow(
                                children: [
                                  _ScheduleCell(slot.day),
                                  _ScheduleCell(slot.time),
                                  _ScheduleCell(slot.subject),
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
      ),
    );
  }
}

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell(this.text, {this.bold = false, this.color});

  final String text;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({required this.info, super.key});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: colors.secondaryContainer,
            foregroundColor: colors.onSecondaryContainer,
            child: Icon(info.icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(info.value, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ],
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
  Photo(asset: 'assets/images/gallery/photo_01.jpg', caption: 'Photo 1'),
  Photo(asset: 'assets/images/gallery/photo_02.jpg', caption: 'Photo 2'),
  Photo(asset: 'assets/images/gallery/photo_03.jpg', caption: 'Photo 3'),
  Photo(asset: 'assets/images/gallery/photo_04.jpg', caption: 'Photo 4'),
  Photo(asset: 'assets/images/gallery/photo_05.jpg', caption: 'Photo 5'),
  Photo(asset: 'assets/images/gallery/photo_06.jpg', caption: 'Photo 6'),
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
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 160,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: [
        for (final photo in galleryPhotos)
          InkWell(
            onTap: () => _open(photo),
            borderRadius: BorderRadius.circular(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    photo.asset,
                    fit: BoxFit.cover,
                    semanticLabel: photo.caption,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_photo_alternate_outlined),
                            const SizedBox(height: 4),
                            Text(
                              'Add photo ${galleryPhotos.indexOf(photo) + 1}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
                        semanticLabel: 'Favorite photo',
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({required this.photo, super.key});

  final Photo photo;

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
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                  errorBuilder: (context, error, stackTrace) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_photo_alternate_outlined, size: 72),
                      const SizedBox(height: 8),
                      Text('Add ${photo.asset.split('/').last} to this gallery.'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Make favorite'),
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
  late final StreamSubscription<void> _completionSubscription;
  bool _isPlaying = false;
  bool _isFavorite = false;
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    unawaited(_completionSubscription.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });

    try {
      await _player.play(AssetSource('sounds/dog_bark.wav'));
    } on PlatformException catch (error, stackTrace) {
      if (mounted) setState(() => _isPlaying = false);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> _confirmReset() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('This will set the bark count back to zero.'),
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

    if (shouldReset == true) {
      setState(() => _barkCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meet the sample dog.',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onDoubleTap: () {
                              setState(() => _isFavorite = !_isFavorite);
                            },
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/favorite_dog.jpg',
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Photo of a dog',
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Icon(
                                        _isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey(_isFavorite),
                                        color: colors.error,
                                        size: 32,
                                        semanticLabel: _isFavorite
                                            ? 'Marked as favorite'
                                            : 'Not marked as favorite',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isPlaying ? null : _playSound,
                            icon: Icon(
                              _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                            ),
                            label: Text(
                              _isPlaying ? 'Playing...' : 'Play sample bark',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'The sample dog has barked $_barkCount '
                            '${_barkCount == 1 ? 'time' : 'times'}.',
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: OutlinedButton(
                            onPressed: _barkCount == 0 ? null : _confirmReset,
                            child: const Text('Reset count'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Double-tap the picture to toggle the heart.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
