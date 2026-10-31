import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const String kMyName = 'Pearl Trihsa Bantillo';
const String kMyPhoto = 'assets/images/profile.jpg';
const String kPetName = 'Mingkit';
const String kPetPhoto = 'assets/images/pet.jpg';
const String kPetSound = 'sounds/pet_sound.mp3';

void main() => runApp(const ProfileApp());

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  colorSchemeSeed: const Color.fromARGB(255, 59, 91, 68),
  useMaterial3: true,

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 58, 91, 67),
      foregroundColor: Colors.white,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 36, 65, 44),
      side: const BorderSide(
        color: Color.fromARGB(255, 56, 89, 64),
        width: 1.5,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 51, 81, 60),
    ),
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
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
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
            icon: Icon(Icons.photo_outlined),
            selectedIcon: Icon(Icons.photo),
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

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> kPhotos = [
  Photo(asset: 'assets/images/gallery/photo1.jpe', caption: 'Photo 1'),
  Photo(asset: 'assets/images/gallery/photo2.jpe', caption: 'Photo 2'),
  Photo(asset: 'assets/images/gallery/photo3.jpe', caption: 'Photo 3'),
  Photo(asset: 'assets/images/gallery/photo4.jpe', caption: 'Photo 4'),
  Photo(asset: 'assets/images/gallery/photo5.jpe', caption: 'Photo 5'),
  Photo(asset: 'assets/images/gallery/photo6.jpe', caption: 'Photo 6'),
];

const List<String> kHobbies = [
  'Watching Movies',
  'Sketching',
  'Make-up',
  'Bouquet Making',
  'Daydreaming',
  'watching cats',
];

class ClassSlot {
  final String subject;
  final String day;
  final String time;
  final String room;

  const ClassSlot({
    required this.subject,
    required this.day,
    required this.time,
    required this.room,
  });
}

const List<ClassSlot> kClassSchedule = [
  ClassSlot(
    subject: 'Human-Computer Interaction 2',
    day: 'Monday',
    time: '7:00 AM - 9:00 AM',
    room: 'ICT 106',
  ),
  ClassSlot(
    subject: 'Application Development',
    day: 'Tuesday',
    time: '9:00 AM - 12:00 PM',
    room: 'ICT 307',
  ),
  ClassSlot(
    subject: 'IT Project Management',
    day: 'Wednesday',
    time: '10:00 PM - 12:00 PM',
    room: 'ICT 307',
  ),
  ClassSlot(
    subject: 'Technopreneurship',
    day: 'Thursday',
    time: '1:00 PM - 2:30 PM',
    room: 'ICT 107',
  ),
];

const List<ProfileInfo> kInfos = [
  ProfileInfo(
    icon: Icons.school,
    label: 'Course',
    value: 'BS Information Technology',
  ),
  ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'July 11, 2006'),
  ProfileInfo(
    icon: Icons.location_on,
    label: 'Location',
    value: 'Iloilo, Philippines',
  ),
  ProfileInfo(icon: Icons.email, label: 'Email', value: 'ptrihsa@gmail.com'),
  ProfileInfo(
    icon: Icons.favorite,
    label: 'Favorite Food',
    value: 'Chicken Inasal',
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(kMyName)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 24),
              Text('Information', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final info in kInfos) InfoTile(info: info),
              const SizedBox(height: 16),
              const _HobbiesCard(),
              const SizedBox(height: 16),
              const _BiographyCard(),
              const SizedBox(height: 16),
              const _ClassScheduleCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            kMyPhoto,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            semanticLabel: 'Photo of $kMyName',
            errorBuilder: (context, error, stackTrace) => Container(
              width: 96,
              height: 96,
              color: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kMyName, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(info.value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BiographyCard extends StatelessWidget {
  const _BiographyCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: const Color.fromARGB(255, 249, 236, 252),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color.fromARGB(255, 239, 166, 228),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Biography', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'I am an Information Technology student who enjoys '
              'exploring my creative side through drawing, designing, and '
              'other artistic activities. I love watching movies, making'
              ' bouquets,  and spending time with my cats. I am also '
              'interested in learning new things, improving my skills, and'
              'discovering different ways to express my creativity.',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _HobbiesCard extends StatelessWidget {
  const _HobbiesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 246, 213, 237),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color.fromARGB(255, 240, 178, 229),
          width: 1.2,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 190,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Hobbies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final hobby in kHobbies) Chip(label: Text(hobby)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassScheduleCard extends StatelessWidget {
  const _ClassScheduleCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: const Color.fromARGB(255, 251, 251, 250),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color.fromARGB(255, 237, 234, 230),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Class Schedule', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 420,
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(95),
                    1: FixedColumnWidth(160),
                    2: FlexColumnWidth(),
                  },
                  border: TableBorder.all(color: theme.dividerColor),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Day',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Subject',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    for (final slot in kClassSchedule)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(slot.day),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(slot.time),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(slot.subject),
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
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: InteractiveViewer(
                  child: Image.asset(photo.asset, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Make favorite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _openPhoto(Photo photo) async {
    final isFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PhotoScreen(photo: photo)),
    );

    if (isFavorite == true) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
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
          for (final photo in kPhotos)
            GestureDetector(
              onTap: () => _openPhoto(photo),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
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

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSub;
  bool _isPlaying = false;
  bool _liked = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _completeSub = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _completeSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _count++;
    });
    try {
      await _player.play(AssetSource(kPetSound));
    } catch (e) {
      if (mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not play the sound.')),
        );
      }
    }
  }

  void _toggleLike() => setState(() => _liked = !_liked);
  Future<void> _resetCount() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: const Text('Are you sure you want to reset the meow count?'),
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

    if (confirmed == true) {
      setState(() => _count = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onDoubleTap: _toggleLike,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          kPetPhoto,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of my pet $kPetName',
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: theme.colorScheme.secondaryContainer,
                                child: Icon(
                                  Icons.pets,
                                  size: 96,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                        ),
                      ),
                      if (_liked)
                        Center(
                          child: Icon(
                            Icons.favorite,
                            size: 96,
                            color: theme.colorScheme.error,
                            semanticLabel: 'Liked',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Double-tap the photo to give $kPetName some love.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlaying ? 'Playing...' : 'Hear $kPetName'),
              ),
              const SizedBox(height: 16),
              Text(
                '$kPetName meowed $_count ${_count == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _count == 0 ? null : _resetCount,
                child: const Text('Reset count'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
