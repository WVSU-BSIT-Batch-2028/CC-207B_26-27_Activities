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
      title: 'Unit 5 Exercise',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
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
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ProfileScreen(),
    MyPetScreen(),
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
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String profileName = 'Justine Dasa';
  static const String profileTagline = 'BSIT Student • Future Software Developer';

  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.cake_outlined, label: 'Birthday', value: 'August 2, 2005'),
    ProfileInfo(icon: Icons.location_on_outlined, label: 'Address', value: 'Roxas City, Capiz'),
    ProfileInfo(icon: Icons.email_outlined, label: 'Email', value: 'justineluis.dasa@wvsu.edu.ph'),
    ProfileInfo(icon: Icons.phone_outlined, label: 'Phone', value: '09100683277'),
    ProfileInfo(icon: Icons.school_outlined, label: 'Education', value: 'West Visayas State University'),
    ProfileInfo(icon: Icons.book_outlined, label: 'Course', value: 'BS Information Technology'),
    ProfileInfo(icon: Icons.sports_esports_outlined, label: 'Hobbies', value: 'Games, guitar, Rubik\'s cube'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(profileName),
        centerTitle: false,
      ),
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
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                        Text(
                          profileName,
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileTagline,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...[
                for (final info in infos) InfoTile(info: info),
              ],
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Biography',
                        style: textTheme.titleLarge,
                      ),
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
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final petSentence = _playCount == 1
        ? '$petName has barked 1 time.'
        : '$petName has barked $_playCount times.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pet'),
      ),
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
                                color: Theme.of(context).colorScheme.primaryContainer,
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
            ],
          ),
        ),
      ),
    );
  }
}

