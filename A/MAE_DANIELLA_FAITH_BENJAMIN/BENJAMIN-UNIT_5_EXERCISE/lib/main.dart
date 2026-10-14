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
      title: 'Mae and Ami',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        appBarTheme: AppBarThemeData(
          backgroundColor: const Color(0xFFF4DEE2),
          scrolledUnderElevation: 0,
        ),
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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [ProfileScreen(), PetScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info.icon, color: theme.colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(info.value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Profile screen: StatelessWidget.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.cake_outlined,
      label: 'Birthdate',
      value: 'March 7, 2006',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Address',
      value: 'Sebaste, Antique, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'maedaniellafaith.benjamin@wvsuedu.ph',
    ),
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'West Visayas State University - Main Campus',
    ),
    ProfileInfo(
      icon: Icons.menu_book_outlined,
      label: 'Course',
      value: 'Bachelor of Science in Information Technology',
    ),
    ProfileInfo(
      icon: Icons.code_outlined,
      label: 'Specialization',
      value: 'Software Development and Technologies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mae Daniella Faith Benjamin'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of Mae Daniella Faith Benjamin',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mae Daniella Faith Benjamin',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aspiring front-end developer.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Personal Information', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        for (final info in infos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text(
                          'Hi, I’m Mae, a third-year BSIT student '
                          'with a growing passion for web development '
                          'and building technology that solves '
                          'real-world problems. I enjoy exploring '
                          'new tools, turning ideas into functional '
                          'applications, and creating user-focused '
                          'digital experiences while continuously '
                          'learning and growing as a developer.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
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

// My Pet screen: StatefulWidget.
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  bool showHeart = false;
  int playCount = 0;

  @override
  void initState() {
    super.initState();

    player.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> playSound() async {
    if (isPlaying) return;

    setState(() {
      isPlaying = true;
    });

    try {
      await player.play(AssetSource('sounds/rabbit_sound.mp3'));

      if (!mounted) return;

      setState(() {
        playCount++;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to play the rabbit sound.')),
      );
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Meet Ami!',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Rabbits are my favorite animals, '
                  'so I chose Ami to feature in this app.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      showHeart = !showHeart;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/ami.jpg',
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          semanticLabel: 'Photo of Ami the rabbit',
                        ),
                      ),
                      if (showHeart)
                        Icon(
                          Icons.favorite,
                          size: (theme.iconTheme.size ?? 24) * 3,
                          color: theme.colorScheme.primary,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Double-tap the photo to show or hide a heart.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: isPlaying ? null : playSound,
                  icon: Icon(isPlaying ? Icons.hourglass_top : Icons.volume_up),
                  label: Text(isPlaying ? 'Playing...' : 'Play Ami’s Sound'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ami has squeaked $playCount times.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
