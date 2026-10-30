import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

const String profileBio = '''
I’m a 3rd-year BS Information Technology student majoring in Cybersecurity at West Visayas State University, where I’ve maintained a Silver Awardee standing across all semesters.

I specialize in full-stack web development, distributed database architectures, interactive desktop applications, and IoT flood monitoring systems.

Core Technical Toolkit:
Python, Java, C++, PHP, SQL, Spring Boot, Next.js, React, and PostgreSQL.

Highlights & Achievements:

• IoT & Embedded Systems: Architected a long-range flood monitoring prototype using Arduino UNO microcontrollers and LoRa wireless modules with conductive sensors for synchronized LED and sound alerts.

• Full-Stack & Distributed Systems: Built the Faith Laundry Shop Management System to automate load-based pricing and analytics, and designed a Master-Slave distributed database for the MangMarick Catering POS System to prevent double-booking across locations.

• Software Applications: Created TaskTrackr (a project management platform with dual-channel email/in-app reminders) and a JavaFX Cinema Booking System featuring interactive seat maps and dynamic QR-embedded PDF tickets.

• Hackathons: Placed in the Top 5 at the AI Fest Hackathon as a Backend/AI Developer, integrating machine learning APIs with a React interface and pitching our working MVP to industry judges under tight deadlines.

To complement my software engineering background, I’m actively strengthening my networking and security foundation through the Cisco Networking Academy. I have completed the CCNA: Introduction to Networking certificate and am continuing training in cybersecurity and routing essentials.
''';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BRILLANTES - Unit 6 Exercise',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
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
  int _selectedIndex = 1;

  static const List<Widget> _screens = [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
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

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                info.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text('${info.label}:', style: textTheme.titleMedium),
              const SizedBox(width: 8),
              Expanded(
                child: Text(info.value, style: textTheme.bodyMedium),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<String> hobbies = const [
    'Reading',
    'Badminton',
    'Watching movies',
    'Traveling',
    'Coding',
    'Photography',
  ];

  final List<ClassSlot> classes = const [
    ClassSlot(day: 'Mon', time: '7:00-9:00', subject: 'CIT 213'),
    ClassSlot(day: 'Tue', time: '9:00-12:00', subject: 'CC 207B'),
    ClassSlot(day: 'Wed', time: '1:00-3:00', subject: 'CIT 307'),
    ClassSlot(day: 'Thu', time: '10:00-12:00', subject: 'Cit 305'),
    ClassSlot(day: 'Thu', time: '4:00-6:00', subject: 'Cit 212'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const profilePhoto = 'assets/images/my_photo.jpg';

    final infos = <ProfileInfo>[
      const ProfileInfo(
        icon: Icons.cake,
        label: 'Birthday',
        value: 'March 16, 2005',
      ),
      const ProfileInfo(
        icon: Icons.school,
        label: 'Course',
        value: 'BS Information Technology Major in Cybersecurity',
      ),
      const ProfileInfo(
        icon: Icons.location_on,
        label: 'Location',
        value: 'Barotac Nuevo, Iloilo, Philippines',
      ),
      const ProfileInfo(
        icon: Icons.language,
        label: 'Languages',
        value: 'English and Filipino',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Luisa Rose Brillantes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Semantics(
                    label: 'Photo of Luisa Rose Brillantes',
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(profilePhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Luisa Rose Brillantes',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'IT student • Cybersecurity enthusiast',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final info in infos) InfoTile(info: info),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Hobbies',
                    style: textTheme.titleLarge,
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
                    border: TableBorder.all(color: Colors.grey.shade400),
                    columnWidths: const {
                      0: FixedColumnWidth(70),
                      1: FixedColumnWidth(110),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Day',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                      for (final slot in classes)
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Biography', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    profileBio,
                    style: textTheme.bodyMedium?.copyWith(height: 1.5),
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

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _playBarkSound() async {
    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      // ignored intentionally
    }
  }

  void _incrementBark() {
    setState(() {
      _barkCount++;
    });
    _playBarkSound();
  }

  Future<void> _resetCountDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset the count?'),
          content: const Text('Start again from zero?'),
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
        );
      },
    );

    if (result == true) {
      setState(() {
        _barkCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/my_pet.jpg',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
                semanticLabel: 'My pet photo',
              ),
              const SizedBox(height: 20),
              Text(
                'Bark Count',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                '$_barkCount',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: _incrementBark,
                icon: const Icon(Icons.play_circle_fill_rounded),
                iconSize: 70,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _barkCount == 0 ? null : _resetCountDialog,
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
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Photo> _photos = const [
    Photo(asset: 'assets/images/gallery/1.jpg', caption: 'BSIT Peeps'),
    Photo(asset: 'assets/images/gallery/2.jpg', caption: 'Graduation'),
    Photo(asset: 'assets/images/gallery/3.jpg', caption: 'Books'),
    Photo(asset: 'assets/images/gallery/4.jpg', caption: 'Pitik'),
    Photo(asset: 'assets/images/gallery/5.jpg', caption: 'Bench'),
    Photo(asset: 'assets/images/gallery/6.JPG', caption: 'Groupie'),
  ];

  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (makeFavorite == true) {
      setState(() {
        _favoriteAsset = photo.asset;
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
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in _photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      photo.asset,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                  if (_favoriteAsset == photo.asset)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 18,
                        ),
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
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  photo.asset,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.star),
              label: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
