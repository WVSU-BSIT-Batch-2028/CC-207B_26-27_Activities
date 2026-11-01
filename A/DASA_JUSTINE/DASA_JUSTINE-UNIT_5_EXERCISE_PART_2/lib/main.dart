import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 5 Exerfluttcise',
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

  static const List<Widget> _screens = [
    ProfileScreen(),
    MyPetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
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
            icon: Icon(Icons.photo_outlined),
            selectedIcon: Icon(Icons.photo),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String profileName = 'Justine Luis Dasa';
  static const String nickName = 'jasteen';
  static const String profileTagline =
      'BSIT Student • Future Software Developer & Cybersecurity Expert';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.cake_outlined,
      label: 'Birthday',
      value: 'August 2, 2005',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Address',
      value: 'Roxas City, Capiz',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'justineluis.dasa@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.phone_outlined,
      label: 'Phone',
      value: '09100683277',
    ),
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.book_outlined,
      label: 'Course',
      value: 'BS Information Technology',
    ),
  ];

  static const List<String> hobbies = [
    'Playing games',
    'Playing guitar',
    'Solving Rubik\'s cubes',
    'Listening to music',
    'Learning technology',
  ];

  static const List<ClassSlot> classSchedule = [
    ClassSlot(
      day: 'Monday/Wednesday',
      time: '7:00-9:00 AM',
      subject: 'Human Computer Interaction 2',
    ),
    ClassSlot(
      day: 'Monday/Wednesday',
      time: '10:00-12:00 AM',
      subject: 'Security Compliance and Governance',
    ),
    ClassSlot(
      day: 'Monday/Wednesday',
      time: '1:00-3:00 PM',
      subject: 'Web Systems and Technologies',
    ),
    ClassSlot(
      day: 'Monday/Wednesday',
      time: '4:00-6:00 PM',
      subject: 'Research',
    ),
    ClassSlot(
      day: 'Tuesday/Thursday',
      time: '9:00-12:00 PM',
      subject: 'App Dev & Emerging Tech',
    ),
    ClassSlot(
      day: 'Tuesday/Thursday',
      time: '1:00-2:30 PM',
      subject: 'Technopreneurship',
    ),
    ClassSlot(
      day: 'Tuesday/Thursday',
      time: '3:00-6:00 PM',
      subject: 'Networking',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(nickName), centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Photo of $profileName',
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile.jpg',
                          width: 92,
                          height: 92,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.person,
                                size: 42,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profileName, style: textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(
                          profileTagline,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...[for (final info in infos) InfoTile(info: info)],
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'My Class Schedule',
                          style: textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Table(
                        border: TableBorder.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(96),
                          1: FixedColumnWidth(92),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            children: [
                              for (final heading in ['Day', 'Time', 'Subject'])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    heading,
                                    style: textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          for (final slot in classSchedule)
                            TableRow(
                              children: [
                                for (final value in [
                                  slot.day,
                                  slot.time,
                                  slot.subject,
                                ])
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      value,
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(
                        'My name is Justine Dasa, a Bachelor of Science in Information Technology (BSIT) student at West Visayas State University. I am passionate about technology, particularly software development, emerging technologies, and cybersecurity. I enjoy learning new skills, exploring innovative ideas, and improving my technical abilities. My goal is to become a successful software developer and cybersecurity expert who can develop useful applications, protect systems and networks from cyber threats, and apply cybersecurity principles to ensure data privacy, system security, and the safe use of technology.',
                        style: textTheme.bodyMedium,
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
}

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

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(
            info.icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(info.label),
          subtitle: Text(info.value),
        ),
      ),
    );
  }
}

class MyPetScreen extends StatefulWidget {
  const MyPetScreen({super.key});

  @override
  State<MyPetScreen> createState() => _MyPetScreenState();
}

class _MyPetScreenState extends State<MyPetScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isLiked = false;
  bool _isPlaying = false;
  int _playCount = 0;

  static const String petName = 'Ponyo';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPetSound() async {
    if (_isPlaying) {
      return;
    }

    setState(() {
      _isPlaying = true;
    });

    try {
      await _audioPlayer.play(AssetSource('sounds/pet_sound.mp3'));
      if (!mounted) {
        return;
      }
      setState(() {
        _playCount += 1;
      });
    } on Object catch (error, stackTrace) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = false;
      });
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'audio playback',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not play the pet sound.')),
      );
    }
  }

  Future<void> _confirmResetCount() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('Are you sure you want to reset the bark count?'),
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

    if (shouldReset == true && mounted) {
      setState(() {
        _playCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final petSentence = _playCount == 1
        ? '$petName has barked 1 time.'
        : '$petName has barked $_playCount times.';

    return Scaffold(
      appBar: AppBar(title: const Text('ponyo!')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                label: 'Photo of my pet $petName',
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
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
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Icon(
                                  Icons.pets,
                                  size: 90,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_isLiked)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Icon(
                            Icons.favorite,
                            color: Theme.of(context).colorScheme.error,
                            size: 52,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playPetSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play Sound'),
              ),
              const SizedBox(height: 12),
              Text(
                petSentence,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmResetCount,
                child: const Text('Reset count'),
              ),
            ],
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

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const List<Photo> _photos = [
    Photo(asset: 'assets/images/profile.jpg', caption: 'My profile photo'),
    Photo(asset: 'assets/images/pet.jpg', caption: 'Ponyo'),
    Photo(asset: 'assets/images/girlfriend.jpg', caption: 'girlfriend'),
    Photo(
      asset: 'assets/images/day-with-friends.jpg',
      caption: 'A day with friends',
    ),
    Photo(asset: 'assets/images/special-place.jpg', caption: 'A special place'),
    Photo(asset: 'assets/images/fun-moment.jpg', caption: 'A fun moment'),
  ];

  Photo? _favoritePhoto;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (context) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true && mounted) {
      setState(() {
        _favoritePhoto = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in _photos)
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _open(photo),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              photo.asset,
                              fit: BoxFit.cover,
                              semanticLabel: photo.caption,
                              errorBuilder: (context, error, stackTrace) {
                                return ColoredBox(
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: colorScheme.onSurfaceVariant,
                                      size: 36,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (identical(photo, _favoritePhoto))
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Icon(
                                key: ValueKey('favorite-${photo.caption}'),
                                Icons.star,
                                color: colorScheme.primary,
                                size: 30,
                                shadows: [
                                  Shadow(
                                    color: colorScheme.surface,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      child: Text(
                        photo.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      photo.asset,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      semanticLabel: photo.caption,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_outlined,
                            size: 72,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
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
      ),
    );
  }
}
