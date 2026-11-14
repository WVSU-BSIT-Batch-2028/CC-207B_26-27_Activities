import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

ThemeData buildPinkTheme() {
  const plum = Color(0xFF3B0A1A);

  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFFFB6F92)).copyWith(
    primary: const Color(0xFFFB6F92),
    onPrimary: plum,
    primaryContainer: const Color(0xFFFFC2D1),
    onPrimaryContainer: plum,
    secondary: const Color(0xFFFF8FAB),
    onSecondary: plum,
    secondaryContainer: const Color(0xFFFFB3C6),
    onSecondaryContainer: plum,
    surface: const Color(0xFFFFE5EC),
    onSurface: plum,
    onSurfaceVariant: const Color(0xFF7A2E48),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    cardTheme: CardThemeData(
      color: scheme.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.primaryContainer,
      indicatorColor: scheme.primary,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eumee Sodusta',
      debugShowCheckedModeBanner: false,
      theme: buildPinkTheme(),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------
// HomeShell: Scaffold + NavigationBar with two destinations
// ---------------------------------------------------------------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eumee Sodusta')),
      // IndexedStack keeps the Pet screen's counter when you switch tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfileScreen(),
          PetScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Profile data
// ---------------------------------------------------------------
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

const List<ProfileInfo> profileInfos = [
  ProfileInfo(
    icon: Icons.cake,
    label: 'Birthday',
    value: 'May 8, 2006',
  ),
  ProfileInfo(
    icon: Icons.home,
    label: 'Address',
    value: 'Brgy. Duyan-Duyan, Sta. Barbara',
  ),
  ProfileInfo(
    icon: Icons.school,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.computer,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
  ProfileInfo(
    icon: Icons.favorite,
    label: 'Hobbies',
    value: 'Reading, Crocheting, Watching Movies, Singing',
  ),
];

// One row of the information section
class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label, style: textTheme.labelLarge),
      subtitle: Text(info.value, style: textTheme.bodyMedium),
    );
  }
}

// ---------------------------------------------------------------
// Profile screen (stateless)
// ---------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/Me.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  semanticLabel: 'Photo of Eumee Sodusta',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Eumee S. Sodusta', style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      "Nakakapagod na siyang intindihin pero wala akong "
                      "magagawa major subject ko 'yon eh",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Information section
          Card(
            child: Column(
              children: [
                for (final info in profileInfos) InfoTile(info: info),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Biography
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Biography', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    "Hi! I’m a third-year BSIT student at West Visayas State "
                    "University. I’m someone who enjoys trying new things and "
                    "exploring different interests. Recently, I’ve started "
                    "getting into hiking, and I also enjoy traveling and "
                    "discovering new places. During my free time, I like "
                    "reading ebooks, especially manga and manhwa, and watching "
                    "movies and series like Game of Thrones. I also enjoy "
                    "singing and spending time with people I’m comfortable "
                    "with. I’m still discovering new things about myself as I "
                    "go through college, and I look forward to gaining more "
                    "experiences, learning new skills, and making the most "
                    "out of life.",
                    style: textTheme.bodyMedium,
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

// ---------------------------------------------------------------
// My Pet screen (stateful)
// ---------------------------------------------------------------
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _showHeart = false;
  int _barkCount = 0;

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
      _barkCount++;
    });
    try {
      // AssetSource looks inside the assets/ folder
      await _player.play(AssetSource('sounds/Bark.mp3'));
    } catch (_) {
      // If the sound fails to load, don't leave the button stuck on "Playing..."
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

     return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo with double-tap heart
          GestureDetector(
            onDoubleTap: () => setState(() => _showHeart = !_showHeart),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      'assets/images/Mochi.png',
                      fit: BoxFit.cover,
                      semanticLabel:
                          'Photo of Mochi, a white dog with brown spots',
                    ),
                  ),
                ),
              
                if (_showHeart)
                  Icon(
                    Icons.favorite,
                    size: 96,
                    color: colorScheme.primary,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('Meet Mochi', style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Mochi is my 8-year-old dog, half Japanese Spitz and half '
            'Shih Tzu. She is white with brown spots, very active, and '
            'very clingy.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Sound button
          FilledButton.icon(
            onPressed: _isPlaying ? null : _playSound,
            icon: Icon(_isPlaying ? Icons.volume_up : Icons.pets),
            label: Text(_isPlaying ? 'Playing...' : 'Hear Mochi bark'),
          ),
          const SizedBox(height: 12),

          // Counter
          Text(
            'Mochi has barked $_barkCount '
            '${_barkCount == 1 ? 'time' : 'times'}.',
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