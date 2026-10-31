import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'models/class_slot.dart';
import 'screens/gallery_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final yellow = const Color(0xFFF5C542);
    final gray = const Color(0xFF4B4B4B);
    final softGray = const Color(0xFFE5E5E5);
    final cream = const Color(0xFFF8F8F8);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: yellow,
          brightness: Brightness.light,
        ).copyWith(
          primary: yellow,
          onPrimary: const Color(0xFF1F1F1F),
          secondary: gray,
          onSecondary: Colors.white,
          primaryContainer: const Color(0xFFFFE6A6),
          secondaryContainer: softGray,
          surface: Colors.white,
          onSurface: const Color(0xFF1F1F1F),
          tertiary: const Color(0xFFB9B9B9),
          outline: softGray,
        );

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: cream,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F1F1F),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFFE6A6),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? const TextStyle(fontWeight: FontWeight.w700)
                : const TextStyle(fontWeight: FontWeight.w500);
          }),
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
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              info.icon,
              color: colorScheme.onPrimaryContainer,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '${info.label}: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(text: info.value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HobbyCard extends StatelessWidget {
  const HobbyCard({super.key});

  static const hobbies = [
    'Playing video games',
    'Volleyball',
    'Listening to music',
    'Sleeping',
    'Doomscrolling',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Hobbies',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final hobby in hobbies) Chip(label: Text(hobby))],
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  static const classes = [
    ClassSlot(
      day: 'Monday',
      time: '7:00am - 9:00am\n4:00pm - 5:30pm',
      subject:
          'Human Computer Interaction 2\n'
          'Methods of Research in Computing',
    ),
    ClassSlot(
      day: 'Tuesday',
      time: '9:00am - 12:00pm',
      subject: 'Application Development and Emerging Technologies',
    ),
    ClassSlot(
      day: 'Wednesday',
      time: '7:00am - 10:00am\n4:00pm - 5:30pm',
      subject:
          'Human Computer Interaction 2\n'
          'Methods of Research in Computing',
    ),
    ClassSlot(
      day: 'Thursday',
      time: '10:00am - 12:00pm',
      subject: 'Application Development and Emerging Technologies',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final headerColor = Theme.of(context).colorScheme.primaryContainer;
    final headerStyle = const TextStyle(fontWeight: FontWeight.bold);

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Class Schedule',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.outline
                    .withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              columnWidths: const {
                0: FixedColumnWidth(96),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.7),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Day',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Time', style: headerStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Subject', style: headerStyle),
                    ),
                  ],
                ),
                for (final classSlot in classes)
                  TableRow(
                    decoration: BoxDecoration(
                      color: classes.indexOf(classSlot).isEven
                          ? Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.35)
                          : Theme.of(context).colorScheme.surface,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          classSlot.day,
                          maxLines: 1,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(classSlot.time),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(classSlot.subject),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProfileScreen(),
      const PetScreen(),
      const GalleryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'John Kim Alunan'
              : _selectedIndex == 1
              ? 'My Pet Apollo'
              : 'My Gallery',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: IndexedStack(index: _selectedIndex, children: screens),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets_rounded),
              label: 'My Pet Apollo',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library),
              label: 'Gallery',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final infos = <ProfileInfo>[
      const ProfileInfo(
        icon: Icons.cake_rounded,
        label: 'Birthdate',
        value: 'January 27, 2006',
      ),
      const ProfileInfo(
        icon: Icons.location_on_rounded,
        label: 'Address',
        value: 'Pakiad, Oton, Iloilo',
      ),
      const ProfileInfo(
        icon: Icons.email_rounded,
        label: 'Email',
        value: 'johnkimdela.alunan@wvsu.edu.ph',
      ),
      const ProfileInfo(
        icon: Icons.phone_rounded,
        label: 'Phone Number',
        value: '09998529737',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isWide ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isWide ? 54 : 46,
                      backgroundImage: const AssetImage(
                        'assets/images/profile_image.jpg',
                      ),
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Kim Alunan',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '3rd-year BSIT student • Cybersecurity',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Card(
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Get to know me!',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 18),
                              for (final info in infos) InfoTile(info: info),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Card(
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Biography',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'I am John Kim Alunan, a 3rd-year Bachelor of Science in Information Technology student at West Visayas State University Main Campus, specializing in Cybersecurity. Based in Pakiad, Oton, Iloilo, I am currently balancing my academic focus on coding and network systems with a dynamic range of personal interests. Outside of my technical pursuits, I enjoy staying active through volleyball and playing guitar and ukulele, unwinding with both online and offline gaming, and taking time to rest and recharge. Driven by a passion for technology and digital security, I continue to grow through learning and creating meaningful work in the field of IT.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Get to know me!',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 14),
                            for (final info in infos) InfoTile(info: info),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Biography',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'I am John Kim Alunan, a 3rd-year Bachelor of Science in Information Technology student at West Visayas State University Main Campus, specializing in Cybersecurity. Based in Pakiad, Oton, Iloilo, I am currently balancing my academic focus on coding and network systems with a dynamic range of personal interests. Outside of my technical pursuits, I enjoy staying active through volleyball and playing guitar and ukulele, unwinding with both online and offline gaming, and taking time to rest and recharge. Driven by a passion for technology and digital security, I continue to grow through learning and creating meaningful work in the field of IT.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const HobbyCard(),
              const SizedBox(height: 20),
              const ScheduleCard(),
            ],
          ),
        );
      },
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoved = false;
  int _meowCount = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
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
      _meowCount += 1;
    });

    try {
      await _audioPlayer.play(AssetSource('sounds/cat_meow.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _resetCount() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Apollo has meowed $_meowCount times. The count will start again from zero.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true && mounted) {
      setState(() {
        _meowCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        return Padding(
          padding: EdgeInsets.all(isWide ? 24 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                _isLoved = !_isLoved;
                              });
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Image.asset(
                                    'assets/images/pet_image.jpg',
                                    height: 520,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Photo of Apollo the cat',
                                  ),
                                ),
                                if (_isLoved)
                                  Positioned(
                                    top: 18,
                                    right: 18,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.82,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: colorScheme.primary,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: colorScheme.outline.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Apollo',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'My favorite little companion',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: colorScheme.secondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: _isPlaying ? null : _playPetSound,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(54),
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.volume_up_rounded),
                                label: Text(
                                  _isPlaying ? 'Playing...' : 'Play cat sound',
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Apollo has meowed $_meowCount times.',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: _meowCount == 0 ? null : _resetCount,
                                child: const Text('Reset count'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              _isLoved = !_isLoved;
                            });
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  'assets/images/pet_image.jpg',
                                  width: double.infinity,
                                  height: 350,
                                  fit: BoxFit.cover,
                                  semanticLabel: 'Photo of Apollo the cat',
                                ),
                              ),
                              if (_isLoved)
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.82,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: colorScheme.primary,
                                      size: 28,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isPlaying ? null : _playPetSound,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: Text(
                              _isPlaying ? 'Playing...' : 'Play cat sound',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Apollo has meowed $_meowCount times.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _meowCount == 0 ? null : _resetCount,
                          child: const Text('Reset count'),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
