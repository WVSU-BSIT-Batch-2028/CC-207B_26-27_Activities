import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const Unit5ExerciseApp());
}

class Unit5ExerciseApp extends StatelessWidget {
  const Unit5ExerciseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const dustyOrchid = Color(0xFFD56989);
    const petalGlaze = Color(0xFFEA9CAF);
    const powderedLilacGrey = Color(0xFFF3EEF1);
    const sorbetStem = Color(0xFFC2DC80);

    return MaterialApp(
      title: 'Unit 5 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
		fontFamily: 'Georgia',
        scaffoldBackgroundColor: dustyOrchid,
        fontFamilyFallback: const ['sans-serif'],
        
        colorScheme: const ColorScheme.light(
          surface: petalGlaze,
          primary: sorbetStem,
          onSurface: powderedLilacGrey,
          onPrimary: powderedLilacGrey,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: dustyOrchid,
          foregroundColor: powderedLilacGrey,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: powderedLilacGrey,
          ),
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: dustyOrchid,
          indicatorColor: petalGlaze,
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: sorbetStem),
          ),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              color: powderedLilacGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        cardTheme: const CardThemeData(
          color: petalGlaze,
          elevation: 2,
        ),

        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: powderedLilacGrey,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: powderedLilacGrey,
          ),
          bodyLarge: TextStyle(
            color: powderedLilacGrey,
          ),
          bodyMedium: TextStyle(
            color: powderedLilacGrey,
          ),
          labelLarge: TextStyle(
            color: powderedLilacGrey,
          ),
        ),
      ),
      home: const HomeShell(),
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
    const sorbetStem = Color(0xFFC2DC80);
    const powderedLilacGrey = Color(0xFFF3EEF1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(info.icon, color: sorbetStem),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              info.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: powderedLilacGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              info.value,
              style: const TextStyle(
                color: powderedLilacGrey,
              ),
            ),
          ),
        ],
      ),
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

  final List<Widget> _screens = const [
    ProfileScreen(),
    PetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
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
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> infos = const [
    ProfileInfo(
      icon: Icons.cake,
      label: 'Birthdate',
      value: 'June 28, 2005',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Address',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email,
      label: 'Email',
      value: 'aecielle.cervantes@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.book,
      label: 'Course',
      value: 'BS in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.favorite,
      label: 'Hobbies',
      value: 'Sleeping, Baking, Gaming, Travelling',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const powderedLilacGrey = Color(0xFFF3EEF1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aecielle Cervantes Exercise 5'),
        centerTitle: true,
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
                    'assets/images/profile.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Aecielle Cervantes',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aecielle Cervantes',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: powderedLilacGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BSIT 3B Student',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    for (final info in infos) InfoTile(info: info),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Get to know Aecielle...',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: powderedLilacGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hi! I’m Aecielle, an IT student at West Visayas State University with a passion for beautiful UI design and mobile development. When I’m not writing clean code, you’ll find me baking cinnamon rolls, exploring new places, or playing video games. I love bringing creative ideas to life through thoughtful technology!',
                      style: Theme.of(context).textTheme.bodyMedium,
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

// 2. Pet Screen (Stateful)
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoved = false;
  int _soundCount = 0;

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
    setState(() {
      _isPlaying = true;
      _soundCount++;
    });
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    const sorbetStem = Color(0xFFC2DC80);
    const powderedLilacGrey = Color(0xFFF3EEF1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet, Gin Bilog'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isLoved = !_isLoved;
                });
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/pet.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet',
                    ),
                  ),
                  if (_isLoved)
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 36,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: sorbetStem,
                foregroundColor: const Color(0xFF4A5D18),
              ),
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Meow'),
            ),
            const SizedBox(height: 12),

            Text(
              'Gin Bilog meowed $_soundCount times.',
              style: const TextStyle(
                color: powderedLilacGrey,
                fontSize: 16,
              ),
            ),
			
			Text(
              'Double tap to make her feel loved!',
              style: const TextStyle(
                color: powderedLilacGrey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}