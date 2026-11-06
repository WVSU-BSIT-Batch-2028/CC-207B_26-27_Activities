import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 6 Exercise',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal, 
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2C3E50), 
        foregroundColor: Colors.white,     
        centerTitle: true,
        elevation: 2,
  ),
      ),
      home: const HomeShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_rounded),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_rounded),
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

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({required this.day, required this.time, required this.subject});
} 

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(info.icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 110,
            child: Text(
              info.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
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
    final theme = Theme.of(context);

    final List<ProfileInfo> infos = [
      const ProfileInfo(
        icon: Icons.cake_outlined,
        label: 'Birthday',
        value: 'Secret (but its in June 28, 2006)',
      ),
      const ProfileInfo(
        icon: Icons.location_on_outlined,
        label: 'Address',
        value: 'Roxas City, Capiz, Philippines',
      ),
      const ProfileInfo(
        icon: Icons.phone_outlined,
        label: 'Phone Number',
        value: '  +63 911 223 3449',
      ),
      const ProfileInfo(
        icon: Icons.music_note_outlined,
        label: 'Current Favorite Song',
        value: '  Cover song of From the Start by Good Kid',
      ),
      const ProfileInfo(
        icon: Icons.star_outline,
        label: 'Favorite Artists',
        value: '      Eve (the Japanese Singer), Ado, natori',
      ),
    ];

    final List<String> hobbies = const [
      'Gaming',
      'Football',
      'Sleeping',
      'Watching Movies',
      'Watching Animes',
    ];

    final List<ClassSlot> classes = const [
      ClassSlot(day: 'Mon', time: '09:00 AM', subject: 'CIT 246 - IT Project Management'),
      ClassSlot(day: 'Mon', time: '01:00 PM', subject: 'CIT 212 - Networking 2'),
      ClassSlot(day: 'Mon', time: '03:00 PM', subject: 'CC 207B - Applicaions Development and Emerging Technologies'),
      ClassSlot(day: 'Tue', time: '07:00 AM', subject: 'CIT 210 - Web Systems and Technologies'),
      ClassSlot(day: 'Tue', time: '11:30 AM', subject: 'BA 234 - Technopreneurship'),
      ClassSlot(day: 'Tue', time: '01:00 PM', subject: 'CC 208 - Methods of Research in Computing'),
      ClassSlot(day: 'Tue', time: '03:00 PM', subject: 'CIT 213 - Human Computer Interaction 2'),
      ClassSlot(day: 'Wed', time: '09:00 AM', subject: 'CIT 246 - IT Project Management'),
      ClassSlot(day: 'Wed', time: '01:00 PM', subject: 'CIT 212 - Networking 2'),
      ClassSlot(day: 'Wed', time: '04:00 PM', subject: 'CC 207B - Applicaions Development and Emerging Technologies'),
      ClassSlot(day: 'Thu', time: '07:00 AM', subject: 'CIT 210 - Web Systems and Technologies'),
      ClassSlot(day: 'Thu', time: '11:30 AM', subject: 'BA 234 - Technopreneurship'),
      ClassSlot(day: 'Thu', time: '01:00 PM', subject: 'CC 208 - Methods of Research in Computing'),
      ClassSlot(day: 'Thu', time: '04:00 PM', subject: 'CIT 213 - Human Computer Interaction 2'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carlo Jay Degala'), 
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/Pic3.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Carlo Jay Degala',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carlo Jay Degala',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'An Average student in WVSU',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Information Section Container
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final info in infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            //Hobbies
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies)
                          Chip(
                            label: Text(hobby),
                            avatar: const Icon(Icons.local_activity_rounded, size: 16),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Class Shedule
            Card(
              elevation: 0,
              color: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: theme.colorScheme.outlineVariant,
                        width: 1,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FixedColumnWidth(95),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Day',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Subject',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final slot in classes)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(slot.day),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(slot.time),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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

            // Biography Card Section
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_pin_rounded,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'My Biography',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'I grew up in Roxas City, Capiz. I am a person who loves to play games up to a unhealthy degree. I played football in my highschool years but quitted due to burnout of playing too much. Now in the current time I now like to sleep alot if I had the chance. Would watch some zombie movies if I had the time as I am a avid horror genre fan. Ultimately, I am just a normal person who tries to do his best whenever I can.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Gallery Screen
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? favoriteAsset;

  // List of at least 6 photos[cite: 1]
  final List<Photo> photos = const [
    Photo(asset: 'assets/images/gallery/GalleryPic1.jpg', caption: 'Camellya Meme'),
    Photo(asset: 'assets/images/gallery/GalleryPic2.jpg', caption: 'Castorice Meme'),
    Photo(asset: 'assets/images/gallery/GalleryPic3.jpg', caption: 'Dog is Cooked'),
    Photo(asset: 'assets/images/gallery/GalleryPic4.jpg', caption: 'Aeon of Voracity in Disguise(The left one)'),
    Photo(asset: 'assets/images/gallery/GalleryPic5.jpg', caption: 'That is a Chill Guy'),
    Photo(asset: 'assets/images/gallery/GalleryPic6.jpg', caption: 'Cat the pinnacle of a Car'),
    Photo(asset: 'assets/images/gallery/GalleryPic7.jpg', caption: 'Arleccino in Japanese themed clothes'),
    Photo(asset: 'assets/images/gallery/GalleryPic8.jpg', caption: 'Furina in Japanese themed clothes'),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
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
                  if (favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 28,
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
//

// Photo Screen
class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              height: 50,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.star_rounded),
                label: const Text('Make favorite'),
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
  State<PetScreen> createState() => PetScreenState();
}

class PetScreenState extends State<PetScreen> {
  late final AudioPlayer _player;
  bool isPlaying = false;
  int barkCount = 0;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> playSound() async {
    setState(() {
      isPlaying = true;
      barkCount++;
    });
    await _player.play(AssetSource('sounds/Lemon Barking.mp3'));
  }

  Future<void> _resetCount() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Count'),
        content: const Text('Are you sure you want to reset the bark count?'),
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

    if (shouldReset == true) {
      setState(() {
        barkCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lemon Beagle (His name is Lemon)'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    showHeart = !showHeart;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Pic2.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Lemon the Lemon Beagle',
                    ),
                    if (showHeart)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.5, end: 1.0),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.redAccent.withOpacity(0.9),
                              size: 100,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Double-tap the photo to put love on my dog pls!',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                'Lemon has barked $barkCount time${barkCount == 1 ? '' : 's'}.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FilledButton.icon(
                onPressed: isPlaying ? null : playSound,
                icon: Icon(
                  isPlaying ? Icons.hourglass_top_rounded : Icons.volume_up_rounded,
                  size: 18, 
                ),
                label: Text(
                  isPlaying ? 'Playing Sound...' : 'Play Pet Sound',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: OutlinedButton.icon(
                onPressed: barkCount == 0 ? null : _resetCount,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset count'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
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