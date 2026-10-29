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
      title: 'Braga Unit 6 Exercise',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 87, 169, 91)
      ),
      home: const HomeShell(title: 'Jessa Mae C. Braga'),
    );
  }
}

//HomeShell
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.title});

  final String title;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProfileScreen(),
      const MyPetScreen(),
      const GalleryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person), 
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
            ),
          NavigationDestination(
            icon: Icon(Icons.pets), 
            selectedIcon: Icon(Icons.pets),
            label: 'My Pet',
            ),
          NavigationDestination(
            icon: Icon(Icons.photo_library), 
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
            )
        ]
        ),
    
    );
  }
}

//Profile Information
class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo(
    {
      required this.icon,
      required this.label,
      required this.value,
    }
  );
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        info.icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        info.label,
        style: theme.textTheme.bodySmall,
      ),
      subtitle: Text(
        info.value,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

//List of Hobbies
final List<String> hobbies = [
  'Creative Writing',
  'Reading',
  'Gaming',
  'Drawing',
  'Listening to Music',
];

//Classlot
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

final List<ClassSlot> classSchedule = [
  const ClassSlot(
    day: 'Monday',
    time: '9:00-12:00',
    subject: 'IT Project Management',
  ),
  const ClassSlot(
    day: 'Tuesday',
    time: '7:00-9:00',
    subject: 'Web Systems and Technologies',
  ),
  const ClassSlot(
    day: 'Wednesday',
    time: '1:00-4:00',
    subject: 'Networking',
  ),
  const ClassSlot(
    day: 'Thursday',
    time: '11:30-1:00',
    subject: 'Technopreneurship',
  ),
];

//Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const infos = <ProfileInfo>[
      ProfileInfo(
        icon: Icons.cake,
        label: 'Age',
        value: '20',
      ),
      ProfileInfo(
        icon: Icons.person,
        label: 'Sex',
        value: 'Female',
      ),
      ProfileInfo(
        icon: Icons.school,
        label: 'Course',
        value: 'Bachelor of Science in Information Technology',
      ),
      ProfileInfo(
        icon: Icons.calendar_month,
        label: 'Year Level',
        value: 'Third Year',
      ),
      ProfileInfo(
        icon: Icons.pets,
        label: 'Favorite Animal',
        value: 'Wolf',
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Semantics(
                  image: true,
                  label: 'Photo of Jessa Mae C. Braga',
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/my_photo.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Jessa Mae C. Braga',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Learning, Trying, Surviving.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  for (final info in infos)
                    InfoTile(info: info),
                ],
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am just a simple person trying my luck here in the city. '
                      'Living in the province and commuting to school every day has become part '
                      'of my routine. It can be tiring, but it allows me to pursue my '
                      'dreams and keep moving forward. Road trips at dawn and chasing '
                      'the night make my days worthwhile. Although this journey can be '
                      'draining, it is also fulfilling, reminding me that every sacrifice '
                      'has a purpose.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(76),
                        1: FixedColumnWidth(82),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final heading in ['Day', 'Time', 'Subject'])
                              Padding(
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
          ],
        ),
      ),
    );
  }
}

//Pet Screen
class MyPetScreen extends StatefulWidget {
  const MyPetScreen({super.key});

  @override
  State<MyPetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<MyPetScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();

    _player.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });
    });
  }


  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(
        AssetSource('sounds/fav_animal_sound.mp3'),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
        _playCount--;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to play the sound. Check your audio asset.'),
        ),
      );
    }
  }


  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _showHeart = !_showHeart;
                });
              },

              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/fav_animal.jpg',
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'A photo of my favorite animal, Lupus',
                    ),
                  ),

                  if (_showHeart)
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 300,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Lupus the Wolf',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
                'I do not have a pet, so I chose the wolf as my favorite '
                'animal. I find wolves interesting because of their unique '
                'features and loyalty to their pack. They also have a '
                'mysterious aura that makes them fascinating to me.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(
                _isPlaying ? Icons.hourglass_top : Icons.volume_up,
              ),
              label: Text(
                _isPlaying ? 'Playing...' : 'Play to Hear Lupus',
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: _playCount == 0
                  ? null
                  : () async {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset count?'),
                          content: const Text(
                            'Are you sure you want to reset the count to zero?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        setState(() {
                          _playCount = 0;
                        });
                      }
                    },
              child: const Text('Reset count'),
            ),

            const SizedBox(height: 16),

            Text(
              'Lupus has howled $_playCount '
              '${_playCount == 1 ? 'time' : 'times'}.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'Double-tap the photo to show or hide the heart.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//Gallery Screen
class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

final List<Photo> photos = [
  const Photo(
    asset: 'assets/images/gallery/image1.jpeg',  
    caption: 'A Bittersweet Goodbye'
  ),
  const Photo(
    asset: 'assets/images/gallery/image2.jpg',  
    caption: 'Blurring Encounter'
  ),
  const Photo(
    asset: 'assets/images/gallery/image3.jpg',  
    caption: 'Solely'
  ),
  const Photo(
    asset: 'assets/images/gallery/image4.jpg',  
    caption: 'Memory of the Lenses'
  ),
  const Photo(
    asset: 'assets/images/gallery/image5.jpg',  
    caption: 'Morning'
  ),
  const Photo(
    asset: 'assets/images/gallery/image6.jpg',  
    caption: 'Eyes of a Wolf'
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
        title: const Text('My Gallery'),
      ),
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

                  // E. Show a star on the favorite photo
                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
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

//Photo Screen
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
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
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
    );
  }
}