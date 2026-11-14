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
      title: 'Braga Unit 5 Exercise',
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
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined), 
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
            ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined), 
            selectedIcon: Icon(Icons.pets),
            label: 'My Pet',
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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