import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CC 207B Unit 5 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue), 
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
    PetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: colors.primary),
          const SizedBox(width: 16),
          SizedBox(
            width: 110,
            child: Text(info.label, style: textTheme.labelLarge),
          ),
          Expanded(
            child: Text(info.value, style: textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _fullName = 'Alyanna Bianca S. Serra';
  static const String _tagline = '3rd-year BSIT student at WVSU';

  static const List<ProfileInfo> _infos = [
    ProfileInfo(
        icon: Icons.cake, label: 'Birthdate', value: 'March 21, 2006'),
    ProfileInfo(
        icon: Icons.home, label: 'Address', value: 'Cabatuan, Iloilo, Philippines'),
    ProfileInfo(
        icon: Icons.email, label: 'Email', value: 'alyannabianca.serra@wvsu.edu.ph'),
    ProfileInfo(
        icon: Icons.school,
        label: 'Education',
        value: 'West Visayas State University'),
    ProfileInfo(
        icon: Icons.computer,
        label: 'Course',
        value: 'Bachelor of Science in Information Technology'),
    ProfileInfo(
        icon: Icons.favorite, label: 'Hobbies', value: 'Sketching, Watching Movies, Playing Games'),
  ];

 
static const String _biography =
    '¡Hola, mi amigo! I\'m Yana, a 3rd-year BSIT student at West Visayas State University, where technology meets creativity and sometimes a little debugging chaos. '
    'When I\'m not busy with schoolwork, you\'ll probably find me sketching, watching movies, and playing games, my favorite ways to unwind and keep myself sane from academic stress. '
    'Thanks for stopping by and getting to know me! I hope this little introduction gives you a glimpse of who I am, what I love, and the creative ideas I have yet to bring to life. After all, I\'m still learning and definitely not done yet! ';

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(_fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of $_fullName',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_fullName, style: textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(_tagline, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (final info in _infos) InfoTile(info: info),
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
                    Text(_biography, style: textTheme.bodyMedium),
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
  // TODO: change to your pet's details. No pet? Use a favorite animal and
  // say so on the screen (e.g. petName = 'Dog (my favorite animal)').
  static const String _petName = 'Mingkay';
  static const String _verb = 'meowed';

  final AudioPlayer _player = AudioPlayer(); // created once
  bool _isPlaying = false;
  bool _liked = false;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose(); // release what you created
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _count++;
    });
    try {

      await _player.play(AssetSource('sounds/cute-meow.wav'));
    } catch (e) {

      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo with double-tap heart (GestureDetector + Stack)
            GestureDetector(
              onDoubleTap: () => setState(() => _liked = !_liked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/images/mingkay.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        semanticLabel: 'Photo of my pet, $_petName',
                      ),
                    ),
                  ),
                  if (_liked)
                    Icon(
                      Icons.favorite,
                      size: 96,
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Meet $_petName', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),

            // Sound button with feedback
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
            ),
            const SizedBox(height: 16),

            // Counter
            Text(
              '$_petName has $_verb $_count ${_count == 1 ? 'time' : 'times'}.',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}