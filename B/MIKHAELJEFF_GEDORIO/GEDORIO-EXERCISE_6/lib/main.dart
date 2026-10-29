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
      title: 'Mikhael Jeff Gedorio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        cardTheme: CardThemeData(
          elevation: 0,
          color: const Color(0xFF151C30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
        ),
      ),
      home: const HomeShell(),
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
  Photo(asset: 'assets/images/gallery/1.jpg', caption: 'Photo 1'),
  Photo(asset: 'assets/images/gallery/2.jpg', caption: 'Photo 2'),
  Photo(asset: 'assets/images/gallery/3.jpg', caption: 'Photo 3'),
  Photo(asset: 'assets/images/gallery/4.jpg', caption: 'Photo 4'),
  Photo(asset: 'assets/images/gallery/5.jpg', caption: 'Photo 5'),
  Photo(asset: 'assets/images/gallery/6.jpg', caption: 'Photo 6'),
];

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

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
    const ProfileScreen(),
    const PetScreen(),
    const GalleryScreen(),
];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets_rounded),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library_rounded),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school_rounded,
      label: 'Course',
      value: 'BS Information Technology • 3rd Year',
    ),
    ProfileInfo(
      icon: Icons.sports_soccer_rounded,
      label: 'Interests',
      value: 'Coding and playing football',
    ),
    ProfileInfo(
      icon: Icons.code_rounded,
      label: 'Skills',
      value: 'Flutter and vibe coding',
    ),
    ProfileInfo(
      icon: Icons.functions_rounded,
      label: 'Problem solving',
      value: 'I love solving problems related to numbers',
    ),
    ProfileInfo(
      icon: Icons.work_outline_rounded,
      label: 'Part-time work',
      value: 'Virtual Assistant',
    ),
  ];

  static const schedule = <Map<String, String>>[
    {
      'subject': 'CIT 210 - Web Systems and Technologies',
      'day': 'Tuesday',
      'time': '7:00 AM - 9:00 AM',
      'room': 'ICT 307',
    },
    {
      'subject': 'CIT 210 - Web Systems and Technologies',
      'day': 'Thursday',
      'time': '7:00 AM - 10:00 AM',
      'room': 'ICT 307',
    },
    {
      'subject': 'CIT 246 - IT Project Management',
      'day': 'Monday',
      'time': '9:00 AM - 12:00 PM',
      'room': 'ICT 307',
    },
    {
      'subject': 'CIT 246 - IT Project Management',
      'day': 'Wednesday',
      'time': '10:00 AM - 12:00 PM',
      'room': 'ICT 307',
    },
    {
      'subject': 'BA 234 - Technopreneurship',
      'day': 'Tuesday',
      'time': '11:30 AM - 1:00 PM',
      'room': 'ICT 107',
    },
    {
      'subject': 'BA 234 - Technopreneurship',
      'day': 'Thursday',
      'time': '11:30 AM - 1:00 PM',
      'room': 'ICT 107',
    },
    {
      'subject': 'CIT 212 - Networking 2',
      'day': 'Monday',
      'time': '1:00 PM - 3:00 PM',
      'room': 'ICT 305',
    },
    {
      'subject': 'CIT 212 - Networking 2',
      'day': 'Wednesday',
      'time': '1:00 PM - 4:00 PM',
      'room': 'ICT 305',
    },
    {
      'subject': 'CC 208 - Methods of Research in Computing',
      'day': 'Tuesday',
      'time': '1:00 PM - 2:30 PM',
      'room': 'ICT 106',
    },
    {
      'subject': 'CC 208 - Methods of Research in Computing',
      'day': 'Thursday',
      'time': '1:00 PM - 2:30 PM',
      'room': 'ICT 106',
    },
    {
      'subject': 'CC 207B - Applications Development and Emerging Technologies',
      'day': 'Monday',
      'time': '3:00 PM - 6:00 PM',
      'room': 'ICT 301',
    },
    {
      'subject': 'CC 207B - Applications Development and Emerging Technologies',
      'day': 'Wednesday',
      'time': '4:00 PM - 6:00 PM',
      'room': 'ICT 301',
    },
    {
      'subject': 'CIT 213 - Human Computer Interaction 2',
      'day': 'Tuesday',
      'time': '3:00 PM - 6:00 PM',
      'room': 'ICT 301',
    },
    {
      'subject': 'CIT 213 - Human Computer Interaction 2',
      'day': 'Thursday',
      'time': '4:00 PM - 6:00 PM',
      'room': 'ICT 301',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Semantics(
                          image: true,
                          label: 'Photo of Mikhael Jeff Gedorio',
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor:
                                theme.colorScheme.primaryContainer,
                            backgroundImage:
                                const AssetImage('assets/images/profile.jpg'),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mikhael Jeff Gedorio',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Student • Athlete • Virtual Assistant',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // About me
                Text(
                  'A LITTLE ABOUT ME',
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      for (final info in infos) InfoTile(info: info),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Biography
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'My Biography',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'I am a 20-year-old student at West Visayas State '
                          'University who loves playing football, gaming, '
                          'and hanging out with friends. I enjoy solving '
                          'problems involving numbers, learning Flutter, and '
                          'exploring new ways to build useful apps. I also '
                          'work part-time as a Virtual Assistant.',
                          style: textTheme.bodyMedium?.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // My Hobbies
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'My Hobbies',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            Chip(
                              avatar: Icon(Icons.sports_soccer_rounded),
                              label: Text('Playing Football'),
                            ),
                            Chip(
                              avatar: Icon(Icons.code_rounded),
                              label: Text('Coding'),
                            ),
                            Chip(
                              avatar: Icon(Icons.sports_esports_rounded),
                              label: Text('Gaming'),
                            ),
                            Chip(
                              avatar: Icon(Icons.people_rounded),
                              label: Text('Hanging Out with Friends'),
                            ),
                            Chip(
                              avatar: Icon(Icons.functions_rounded),
                              label: Text('Solving Math Problems'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Class Schedule
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'My Class Schedule',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'First Semester • SY 2026–2027',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 18,
                            headingRowColor:
                                WidgetStatePropertyAll(
                              theme.colorScheme.primaryContainer,
                            ),
                            columns: const [
                              DataColumn(label: Text('Subject')),
                              DataColumn(label: Text('Day')),
                              DataColumn(label: Text('Time')),
                              DataColumn(label: Text('Room')),
                            ],
                            rows: schedule.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 220,
                                      child: Text(item['subject']!),
                                    ),
                                  ),
                                  DataCell(Text(item['day']!)),
                                  DataCell(Text(item['time']!)),
                                  DataCell(Text(item['room']!)),
                                ],
                              );
                            }).toList(),
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



class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(info.icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
                const SizedBox(height: 4),
                Text(info.value, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ],
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
      await _player.play(AssetSource('sounds/dog_bark.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not play the sound. Check assets/sounds/dog_bark.mp3.',
            ),
          ),
        );
      }
    }
  }

  // Show a confirmation dialog before resetting the bark count.
  Future<void> _confirmResetBarkCount() async {
    if (_playCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The bark count is already zero.'),
        ),
      );
      return;
    }

    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Bark Count?'),
          content: const Text(
            'Are you sure you want to reset Haru’s bark count to zero?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true && mounted) {
      setState(() {
        _playCount = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bark count has been reset.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet Haru'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'MY FOUR-LEGGED FRIEND',
                  style: textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A little bark, a lot of love.',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),

                // Haru's photo and heart effect
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(
                            'assets/images/haru.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Haru, my dog',
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: theme
                                    .colorScheme.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.pets_rounded,
                                      size: 72,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Add Haru’s photo to continue',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_showHeart)
                        Icon(
                          Icons.favorite_rounded,
                          size: 92,
                          color: theme.colorScheme.primary,
                          shadows: const [
                            Shadow(
                              blurRadius: 24,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.62),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Text(
                              'HARU  •  MY DOG',
                              style: textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  'Double-tap Haru’s photo to show or hide the heart.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 22),

                // Bark counter and controls
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.graphic_eq_rounded,
                          size: 34,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hear Haru',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _playCount == 0
                              ? 'Haru has not barked yet.'
                              : 'Haru has barked $_playCount '
                                  '${_playCount == 1 ? 'time' : 'times'}.',
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),

                        // Play bark button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isPlaying ? null : _playSound,
                            icon: Icon(
                              _isPlaying
                                  ? Icons.volume_up_rounded
                                  : Icons.play_arrow_rounded,
                            ),
                            label: Text(
                              _isPlaying ? 'Playing...' : 'Play bark',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Reset bark count button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _confirmResetBarkCount,
                            icon: const Icon(Icons.restart_alt_rounded),
                            label: const Text('Reset Bark Count'),
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



class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Photo? _favoritePhoto;

  Future<void> _openPhoto(Photo photo) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(photo: photo),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _favoritePhoto = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        backgroundColor: Colors.transparent,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: galleryPhotos.map((photo) {
          final isFavorite = _favoritePhoto?.asset == photo.asset;

          return GestureDetector(
            onTap: () => _openPhoto(photo),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.cover,
                    semanticLabel: photo.caption,
                  ),
                ),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      photo.caption,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (isFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.star,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
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
