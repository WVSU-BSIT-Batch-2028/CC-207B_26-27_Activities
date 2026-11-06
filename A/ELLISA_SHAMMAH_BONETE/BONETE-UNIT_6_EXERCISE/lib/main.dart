import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Profile & My Pet',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 9, 100, 35),
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
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 
          ? ProfileScreen.fullName 
          : _selectedIndex == 1 
            ? 'My Pet'
            : 'My Gallery',
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [ProfileScreen(), PetScreen(), GalleryScreen(),],
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 3),
                Text(info.value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String fullName = 'Ellisa Shammah Bonete';
  static const String tagline = 'Curious mind. Future IT professional.';  
  
  static const List<String> hobbies = [
    'Sleeping',
    'Coding',
    'Exploring new ideas',
    'Creative design',
    'Learning new technologies',
  ];

  static const List<ClassSlot> classSchedule = [
    ClassSlot(
      day: 'Mon',
      time: '7:00-9:00 AM',
      subject: 'CIT 213 Human Computer Interaction 2',
    ),
    ClassSlot(
      day: 'Tue',
      time: '09:00-12:00 PM',
      subject: 'CC207B Applications Development and Emerging Technologies',
    ),
    ClassSlot(
      day: 'Wed',
      time: '1:00-4:00 PM',
      subject: 'CIT 210 Web Systems and Technologies',
    ),
    ClassSlot(
      day: 'Thu',
      time: '4:00-6:00 PM',
      subject: 'CIT 212 Networking 2',
    ),
  ];

  static const String biography =
      'I am an Information Technology student who enjoys learning, '
      'solving problems, and exploring how technology can improve '
      'everyday life. I love working on creative projects and building '
      'useful applications. My goal is to keep growing as a developer '
      'and create solutions that make a positive difference.';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Course',
      value: 'Bachelor of Science in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.apartment_outlined,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Location',
      value: 'Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.code_outlined,
      label: 'Favorite Technology',
      value: 'React, Flutter, and Dart',
    ),
    ProfileInfo(
      icon: Icons.flag_outlined,
      label: 'Personal Goal',
      value: 'Build useful and accessible apps',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 340;
    final avatarSize = narrow ? 76.0 : 106.0;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                            semanticLabel:
                                'Profile image of Ellisa Shammah Bonete',
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: theme.textTheme.headlineSmall,
                                softWrap: true,
                              ),
                              const SizedBox(height: 6),
                              Text(tagline, style: theme.textTheme.bodyMedium),
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
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About Me', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),

                        for (final info in infos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Hobbies',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final hobby in hobbies)
                              Chip(
                                label: Text(hobby),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text(biography, style: theme.textTheme.bodyMedium),
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),

                        Table(
                          border: TableBorder.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(62),
                            1: FixedColumnWidth(100),
                            2: FlexColumnWidth(),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme.primaryContainer,
                              ),
                              children: [
                                for (final heading in [
                                  'Day',
                                  'Time',
                                  'Subject',
                                ])
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      heading,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            for (final slot in classSchedule)
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
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

class PetDetails {
  final String name;
  final String animal;
  final String soundVerb;
  final String? note;

  const PetDetails({
    required this.name,
    required this.animal,
    required this.soundVerb,
    this.note,
  });
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const PetDetails pet = PetDetails(
    name: 'Mochi',
    animal: 'Rabbit',
    soundVerb: 'squeaked',
    note: 'This is my favorite animal: this rabbit illustration is not a '
        'photo of my own pet since I do not have a pet.',
  );

  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<void> _completionSubscription;

  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _completionSubscription.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() => _isPlaying = true);

    try {
      await _player.play(AssetSource('sounds/pet_sound.wav'));
      if (!mounted) return;
      setState(() => _playCount++);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not play the sound. Check the sound asset.'),
        ),
      );
    }
  }
  
  Future<void> _confirmReset() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Count?'),
        content: const Text(
          "Are you sure you want to reset Mochi's sound count to 0?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (shouldReset == true) {
      setState(() {
        _playCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Meet ${pet.name}!',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  pet.animal,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(
                            'assets/images/pet.png',
                            fit: BoxFit.cover,
                            semanticLabel:
                                'Illustration of ${pet.name} the ${pet.animal}',
                          ),
                        ),
                      ),
                      if (_showHeart)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Icon(
                            Icons.favorite,
                            size: 50,
                            color: theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _showHeart
                      ? 'Favorited! Double-tap again to remove the heart.'
                      : 'Double-tap the picture to show a heart.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: Icon(
                    _isPlaying ? Icons.graphic_eq : Icons.volume_up_rounded,
                  ),
                  label: Text(_isPlaying ? 'Playing...' : 'Play rabbit sound'),
                ),
                const SizedBox(height: 12),
                Text(
                  '${pet.name} has ${pet.soundVerb} $_playCount '
                  '${_playCount == 1 ? 'time' : 'times'}.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),                
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _playCount == 0 ? null : _confirmReset,
                  child: const Text('Reset count'),
                ),
                if (pet.note != null) ...[
                  const SizedBox(height: 18),
                  Text(
                    pet.note!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

const List<Photo> galleryPhotos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'My First Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'My Second Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'My Third Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'My Fourth Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'My Fifth Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'My Sixth Photo',
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
      MaterialPageRoute(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
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
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 24,
                        ),
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
  final Photo photo;

  const PhotoScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.star),
                label: const Text('Make favorite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
