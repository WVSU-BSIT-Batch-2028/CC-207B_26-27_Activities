import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 5 Exercise',
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

  static const List<Widget> _screens = [ProfileScreen(), PetScreen()];

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
  ProfileInfo(icon: Icons.favorite, label: 'Hobbies', value: 'Reading, Watching Dramas/Movies, Baking/Cooking, Listening to Music'),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                  for (final info in profileInfos) InfoTile(info: info),
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
                    Text('My Biography', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(biography, style: textTheme.bodyMedium),
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
          ],
        ),
      ),
    ),
    );
  }
}