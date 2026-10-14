import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// Old Money Color Palette
// ---------------------------------------------------------------------------
const Color forestGreen = Color(0xFF263D32);
const Color deepGreen = Color(0xFF1C2D25);
const Color cream = Color(0xFFF5F0E5);
const Color warmBeige = Color(0xFFE8DFCE);
const Color mutedGold = Color(0xFFB49A63);
const Color darkBrown = Color(0xFF453B30);
const Color softWhite = Color(0xFFFCFAF5);

// ---------------------------------------------------------------------------
// App root
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: forestGreen,
      brightness: Brightness.light,
      primary: forestGreen,
      onPrimary: cream,
      secondary: mutedGold,
      onSecondary: deepGreen,
      surface: softWhite,
      onSurface: darkBrown,
    );

    return MaterialApp(
      title: 'Unit 5 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: cream,
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: forestGreen,
          foregroundColor: cream,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 21,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: cream,
          ),
        ),
        cardTheme: CardThemeData(
          color: softWhite,
          elevation: 2,
          shadowColor: deepGreen.withValues(alpha: 0.10),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: warmBeige, width: 1),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: deepGreen,
          indicatorColor: mutedGold.withValues(alpha: 0.25),
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontFamily: 'Georgia',
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? mutedGold : cream.withValues(alpha: 0.75),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected ? mutedGold : cream.withValues(alpha: 0.75),
            );
          }),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: forestGreen,
          textColor: darkBrown,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: forestGreen,
            foregroundColor: cream,
            disabledBackgroundColor: warmBeige,
            disabledForegroundColor: darkBrown.withValues(alpha: 0.65),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: mutedGold, width: 1),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Georgia',
            color: forestGreen,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Georgia',
            color: forestGreen,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Georgia',
            color: forestGreen,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Georgia',
            color: darkBrown,
            fontSize: 14,
            height: 1.7,
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeShell: Scaffold + NavigationBar, selected index kept in State
// ---------------------------------------------------------------------------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<String> _titles = ['Unit 5 Exercise', 'My Pet'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [ProfileScreen(), PetScreen()],
      ),
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

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Profile screen (stateless)
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT 3-A'),
    ProfileInfo(
      icon: Icons.apartment,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.sports_esports,
      label: 'Hobbies',
      value: 'Coding, Gaming',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: 'Favorite Food',
      value: 'Lechon, Ice Cream',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Lapaz City, Iloilo',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mutedGold, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/me.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Jose Emmanuel Sariego',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jose Emmanuel Sariego',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Aspiring developer who loves building apps.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Card(
            child: Column(
              children: [
                for (int i = 0; i < infos.length; i++) ...[
                  InfoTile(info: infos[i]),
                  if (i < infos.length - 1)
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: warmBeige,
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Who\'s Jose?', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                      color: mutedGold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'I am an IT student who enjoys learning about technology, exploring programming, and discovering how things work behind the applications we use every day. As I continue my journey in Information Technology, I see every project and challenge as an opportunity to learn something new and improve my skills. I know I still have a lot to learn, but I am willing to put in the effort to grow and become better at what I do.',
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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: warmBeige),
        ),
        child: Icon(info.icon, color: forestGreen, size: 21),
      ),
      title: Text(
        info.label,
        style: const TextStyle(
          fontFamily: 'Georgia',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: forestGreen,
        ),
      ),
      subtitle: Text(
        info.value,
        style: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: 13,
          color: darkBrown,
          height: 1.5,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pet screen (stateful)
// ---------------------------------------------------------------------------
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const String _petName = 'Barnuts';
  static const String _soundWord = 'barked';

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
      await _player.play(AssetSource('sounds/pet.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onDoubleTap: () => setState(() => _isLiked = !_isLiked),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: softWhite,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: mutedGold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: deepGreen.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset(
                        'assets/images/pet.jpg',
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of my pet, $_petName',
                      ),
                    ),
                    if (_isLiked)
                      Icon(
                        Icons.favorite,
                        size: 96,
                        color: theme.colorScheme.error,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _isPlaying ? null : _playSound,
            icon: const Icon(Icons.volume_up),
            label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
          ),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                '$_petName has $_soundWord $_playCount '
                '${_playCount == 1 ? 'time' : 'times'}.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
