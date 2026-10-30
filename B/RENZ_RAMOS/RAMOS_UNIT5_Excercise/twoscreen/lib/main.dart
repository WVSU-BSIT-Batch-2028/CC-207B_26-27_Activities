import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ---------------------------------------------------------------------------
// App root: MaterialApp + theme (change Colors.indigo to your own color)
// ---------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 5 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF286B60),
          brightness: Brightness.light,
          surface: const Color(0xFFF4F6F1),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F6F1),
          foregroundColor: Color(0xFF173B36),
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFF4F6F1),
          indicatorColor: const Color(0xFFD7E9E2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
                color: states.contains(WidgetState.selected)
                    ? const Color(0xFF20584F)
                    : const Color(0xFF68736F),
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w700
                    : FontWeight.w500,
              )),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeShell: holds the selected index + NavigationBar
// ---------------------------------------------------------------------------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  // IndexedStack keeps the Pet screen's state (counter, heart) when switching tabs
  final List<Widget> _screens = const [ProfileScreen(), PetScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data class for one profile row
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
// One row of information
// ---------------------------------------------------------------------------
class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE2ECE6),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(info.icon, color: theme.colorScheme.primary, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF737E78),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  info.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF243D37),
                    fontWeight: FontWeight.w600,
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

// ---------------------------------------------------------------------------
// Profile screen (stateless)
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // TODO: replace with your own details (at least 5 rows)
  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT 3B, WVSU'),
    ProfileInfo(icon: Icons.cake, label: 'Birthday', value: 'Month DD, YYYY'),
    ProfileInfo(icon: Icons.location_on, label: 'Address', value: 'Iloilo City'),
    ProfileInfo(icon: Icons.sports_esports, label: 'Hobbies', value: 'Coding, Gaming'),
    ProfileInfo(icon: Icons.restaurant, label: 'Favorite Food', value: 'Tsoklet'),
    ProfileInfo(icon: Icons.email, label: 'Email', value: 'blabla@gmail.com'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.4,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: const Color(0xFF286B60),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'RR',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Renz Emmanuel Ramos',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF173B36),
                              fontWeight: FontWeight.w800,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Aspiring developer and badminton player',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF64716C),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'A few details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF173B36),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '06 FACTS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF7C8781),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFDCE3DD)),
                for (final info in infos) ...[
                  InfoTile(info: info),
                  const Divider(height: 1, color: Color(0xFFDCE3DD)),
                ],
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF20584F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MY STORY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFB9D9CC),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Write one paragraph about yourself here: where you '
                        'are from, what you study, what you enjoy, and what '
                        'you hope to do after graduation.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// My Pet screen (stateful)
// ---------------------------------------------------------------------------
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _showHeart = false;
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
    // AssetSource looks inside the assets/ folder
    await _player.play(AssetSource('sounds/meow.wav'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MING',
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.4,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onDoubleTap: () => setState(() => _showHeart = !_showHeart),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/images/MING2.jpg',
                          width: double.infinity,
                          height: 340,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of my pet Ming',
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xCC173B36),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'MING  /  PROFESSIONAL NAPPER',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ),
                      if (_showHeart)
                        const Icon(
                          Icons.favorite,
                          size: 96,
                          color: Color(0xFFE77960),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 23),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meet Ming',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF173B36),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'A little more loved with every meow.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF64716C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: _showHeart ? 'Remove heart' : 'Show heart',
                      onPressed: () => setState(() => _showHeart = !_showHeart),
                      style: IconButton.styleFrom(
                        foregroundColor: const Color(0xFFB84D40),
                        backgroundColor: const Color(0xFFF8E2DC),
                        fixedSize: const Size(50, 50),
                      ),
                      icon: Icon(
                        _showHeart ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, color: Color(0xFFDCE3DD)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _isPlaying ? null : _playSound,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF286B60),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.volume_up),
                        label: Text(_isPlaying ? 'Playing...' : 'Play a meow'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_count',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: const Color(0xFF173B36),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'MEOWS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF737E78),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} //changes