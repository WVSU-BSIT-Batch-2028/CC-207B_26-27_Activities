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
      title: 'BRILLANTES - Unit 5 Exercise',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
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

  static const List<Widget> _pages = <Widget>[
    ProfileScreen(),
    PetScreen(),
  ];

  void _onIndexChanged(int idx) => setState(() => _selectedIndex = idx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onIndexChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
        ],
      ),
    );
  }
}

// -------- Profile data model & tile --------
class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;
  const ProfileInfo({required this.icon, required this.label, required this.value});
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;
  const InfoTile({super.key, required this.info});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(info.icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('${info.label}:', style: t.titleMedium),
          const SizedBox(width: 8),
          Expanded(child: Text(info.value, style: t.bodyMedium)),
        ]),
      ),
      const Divider(height: 1),
    ]);
  }
}

// -------- Profile screen (stateless) --------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    const profilePhoto = 'assets/images/my_photo.jpg';

    final infos = <ProfileInfo>[
      const ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'March 16, 2005'),
      const ProfileInfo(icon: Icons.school, label: 'Course', value: 'BS Information Technology Major in Cybersecurity'),
      const ProfileInfo(icon: Icons.location_on, label: 'Location', value: 'Barotac Nuevo, Iloilo, Philippines'),
      const ProfileInfo(icon: Icons.sports_tennis, label: 'Hobbies', value: 'Playing Badminton | Watching movies | Playing ML'),
      const ProfileInfo(icon: Icons.language, label: 'Languages', value: 'English, Filipino'),
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, elevation: 2, title: const Text('Luisa Rose Brillantes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(children: [
                          Semantics(
                            label: 'Photo of Luisa Rose Brillantes',
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                image: DecorationImage(image: AssetImage(profilePhoto), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Luisa Rose Brillantes', style: t.headlineSmall),
                              const SizedBox(height: 6),
                              Text('IT student • Cybersecurity enthusiast', style: t.bodyMedium),
                            ]),
                          ),
                        ]),
                      ),
                    ),
          const SizedBox(height: 20),
          Text('Information', style: t.titleLarge),
          const SizedBox(height: 8),
          for (final info in infos) InfoTile(info: info),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('My Biography', style: t.titleLarge),
                const SizedBox(height: 8),
                Text(profileBio, style: t.bodyMedium?.copyWith(height: 1.5)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// -------- Pet screen (stateful) --------
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});
  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _playCount = 0;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      setState(() => _isPlaying = false);
    });
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });
    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (e) {
      setState(() => _isPlaying = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const petPhoto = 'assets/images/my_pet.jpg';
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(centerTitle: true, elevation: 2, title: const Text('My Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Expanded(
            child: GestureDetector(
              onDoubleTap: () => setState(() => _showHeart = !_showHeart),
              child: Stack(alignment: Alignment.center, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      petPhoto,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet',
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _showHeart ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary, size: 96),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Tooltip(
                      message: 'Play pet sound',
                      child: FilledButton.icon(
                        onPressed: _isPlaying ? null : _playSound,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(_isPlaying ? 'Playing...' : 'Play Sound'),
                      ),
                    ),
          const SizedBox(height: 12),
          Text('Jumong purred $_playCount time${_playCount == 1 ? '' : 's'}.', style: t.bodyMedium),
        ]),
      ),
    );
  }
}
