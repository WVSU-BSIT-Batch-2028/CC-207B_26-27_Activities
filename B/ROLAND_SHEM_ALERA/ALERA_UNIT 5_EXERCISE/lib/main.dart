import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const String myName = 'Roland Shem Alera';
const String myTagline = '3rd-year BSIT student';
const String myBiography =
    "My nickname is Pepsi and I'm from Sipalay City, Negros Occidental. "
    "I'm currently studying Bachelor of Science in Information Technology. "
    "My hobbies are basketball, badminton, and fixing things that I can't fix. "
    "My goal is to be a millionaire while being lazy.";

const String myPhotoPath = 'assets/images/me.jpg';
const String petPhotoPath = 'assets/images/pet.jpg';
const String petSoundPath = 'sounds/bark.mp3';

const String petName = 'Sky';
const String petAction = 'barked';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 5 Exercise',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          ProfileScreen(),
          PetScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
            selectedIndex = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
        ],
      ),
    );
  }
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
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

       final List<ProfileInfo> infos = [
      const ProfileInfo(icon: Icons.badge, label: 'Nickname', value: 'Pepsi'),
      const ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'December 27, 2004'),
      const ProfileInfo(icon: Icons.home, label: 'Address', value: 'Sipalay City, Negros Occidental'),
      const ProfileInfo(icon: Icons.school, label: 'School', value: 'West Visayas State University'),
      const ProfileInfo(icon: Icons.computer, label: 'Course', value: 'BS Information Technology'),
      const ProfileInfo(icon: Icons.sports_basketball, label: 'Hobbies', value: 'Basketball, Badminton, Fixing things'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(myName),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    myPhotoPath,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $myName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myName, style: theme.textTheme.headlineSmall),
                      Text(myTagline, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  for (final info in infos) InfoTile(info: info),
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
                    Text('My Biography', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(myBiography, style: theme.textTheme.bodyMedium),
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

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  bool isPlaying = false;
  bool isLiked = false;
  int playCount = 0;

  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> playSound() async {
    setState(() {
      isPlaying = true;
      playCount = playCount + 1;
    });

    try {
      await player.play(AssetSource(petSoundPath));
    } catch (error) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
                child: Column(
          children: [
            const SizedBox(width: double.infinity),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isLiked = !isLiked;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                                   ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          petPhotoPath,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of $petName, my pet',
                        ),
                      ),
                    ),
                  ),
                  if (isLiked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to give $petName a heart',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: isPlaying ? null : playSound,
              icon: Icon(isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(isPlaying ? 'Playing...' : 'Play sound'),
            ),
            const SizedBox(height: 16),
            Text(
              '$petName has $petAction $playCount times.',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}