import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 6 Exercise',
      theme: ThemeData(colorSchemeSeed: const Color.fromARGB(255, 212, 47, 171)), 
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

  static const List<Widget> _screens = [ProfileScreen(), PetScreen(), GalleryScreen(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
          NavigationDestination(icon: Icon(Icons.photo), label: 'Gallery'),
        ],
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

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/sassy1.jpg',
    caption: 'Playful Sassy',
  ),
  Photo(
    asset: 'assets/images/gallery/sassy2.jpg',
    caption: 'Sleepy Sassy',
  ),
  Photo(
    asset: 'assets/images/gallery/sassy3.jpg',
    caption: 'Scared Sassy',
  ),
  Photo(
    asset: 'assets/images/gallery/sassy4.jpg',
    caption: 'Judgmental Sassy',
  ),
  Photo(
    asset: 'assets/images/gallery/sassy5.jpg',
    caption: 'Cutey Sassy',
  ),
  Photo(
    asset: 'assets/images/gallery/sassy6.jpg',
    caption: 'Smiling Sassy',
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
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            InkWell(
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
                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
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

  const PhotoScreen({
    super.key,
    required this.photo,
  });

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
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 350,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('★ Make favorite'),
              ),
            ),
          ],
        ),
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

const String fullName = 'Lianne Dane Yasa';
const String tagline = 'BSIT student who hates coding.';
const String biography =
    'Lianne aka Kira grew up in the province of Aklan and have been attending school hours away from her home ever since she was in kindergarten. '
    'She graduated her SHS from Aklan Valley High School as a STEM student. She is currently a BSIT student with specialization in Cybersecurity. '
    'After graduating from her undergraduate she plans to pursue Law School, and hopefully it would still be in WVSU. As being a lawyer have been her childhood dream ever since.';

const List<ProfileInfo> profileInfos = [
  ProfileInfo(icon: Icons.cake, label: 'Birthdate', value: 'July 11, 2006'),
  ProfileInfo(icon: Icons.home, label: 'Address', value: 'Pob. Balete, Aklan, Philippines'),
  ProfileInfo(icon: Icons.email, label: 'Email', value: 'liannedane.yasa@wvsu.edu.ph'),
  ProfileInfo(icon: Icons.school, label: 'Education', value: 'West Visayas State University'),
  ProfileInfo(icon: Icons.menu_book, label: 'Course', value: 'BS Information Technology'),
];

const List<String> hobbies = [
  'Reading', 
  'Watching Dramas/Movies', 
  'Baking/Cooking', 
  'Listening to Music',
];

const List<ClassSlot> classSchedule = [
  ClassSlot(day: 'Monday', time: '9:00 AM - 12:00 PM', subject: 'CIT 251 - Security Compliance and Governance'),
  ClassSlot(day: 'Monday', time: '1:00 PM -  3:00 PM', subject: 'CIT 212 - Networking 2'),
  ClassSlot(day: 'Monday', time: '3:00 PM -  6:00 PM', subject: 'CC 207B - Application Development and Emerging Technologies'),
  ClassSlot(day: 'Tuesday', time: '7:00 AM -  9:00 AM', subject: 'CIT 210 - Web System and Technologies'),
  ClassSlot(day: 'Tuesday', time: '11:30 AM - 1:00 PM', subject: 'BA 234 - Technopreneurship'),
  ClassSlot(day: 'Tuesday', time: '1:00 PM -  2:30 PM', subject: 'CC 208 - Methods of Research in Computing'),
  ClassSlot(day: 'Tuesday', time: '3:00 PM -  6:00 PM', subject: 'CIT 213 - Human Computer Interaction 2'),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [            
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/bme.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $fullName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(tagline, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            
            Card(
              child: Column(
                children: [
                  for (final info in profileInfos) 
                  InfoTile(info: info),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Card(
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
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(biography, style: textTheme.bodyMedium),
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
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: Theme.of(context).dividerColor,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(85),
                        1: FixedColumnWidth(110),
                      },
                      children: [
                        TableRow(
                          children: [
                            for (final heading in [
                              'Day',
                              'Time',
                              'Subject',
                            ])
                              Container(
                                color: ColorScheme.primaryContainer,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  heading,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
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
    );
  }
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label),
      subtitle: Text(info.value),
    );
  }
}


class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  
  static const String _petName = 'Sassy';
  static const String _soundVerb = 'barked';

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
      await _player.play(AssetSource('sounds/dogbark.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

   Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset bark count?'),
          content: const Text(
            'Are you sure you want to reset the bark count?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (answer == true) {
      setState(() {
        _playCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: Center (
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/sassygirl.jpg',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet, $_petName',
                    ),
                  ),
                  if (_isLiked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: Theme.of(context).colorScheme.error,
                    ),
                ],
              ),
            ),
      
            SizedBox(
            width: 250,
            child: FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play $_petName\'s bark'),
            ),
            ),
            Text(
              '$_petName has $_soundVerb $_playCount times.',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width:250, 
              child: OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmReset,
                child: const Text('Reset count'),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}