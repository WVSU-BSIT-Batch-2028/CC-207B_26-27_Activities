import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FernandezProfileApp());
}

class FernandezProfileApp extends StatelessWidget {
  const FernandezProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF8D6E63);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fritz Marick Fernandez',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: brown,
          brightness: Brightness.light,
          surface: const Color(0xFFFFFBF7),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
        appBarTheme: const AppBarTheme(centerTitle: false),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 1),
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

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const ProfileScreen(),
      const PetScreen(),
      const GalleryScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
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
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
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

const profileInfos = <ProfileInfo>[
  ProfileInfo(
    icon: Icons.cake_outlined,
    label: 'Birthday',
    value: 'March 25, 2006',
  ),
  ProfileInfo(
    icon: Icons.location_on_outlined,
    label: 'Address',
    value: 'Iloilo City, Philippines',
  ),
  ProfileInfo(
    icon: Icons.school_outlined,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.email_outlined,
    label: 'Email',
    value: 'fmafernandez325@gmail.com',
  ),
  ProfileInfo(
    icon: Icons.computer_outlined,
    label: 'Course',
    value: 'BS Information Technology, Cybersecurity major',
  ),
  ProfileInfo(
    icon: Icons.code_outlined,
    label: 'Skills',
    value:
        'Full-stack web development, JavaScript, Java, IoT, and cybersecurity',
  ),
  ProfileInfo(
    icon: Icons.work_outline,
    label: 'Experience',
    value: 'VP for R&D at SPARKHUB and Cyb Robotics; English tutor',
  ),
  ProfileInfo(
    icon: Icons.favorite_outline,
    label: 'Interests',
    value: 'Web apps, IoT devices, security tools, coding, and design',
  ),
];

const hobbies = <String>[
  'Coding',
  'Cybersecurity',
  'Robotics',
  'Gaming',
  'Volleyball',
  'Billiards',
  'Calisthenics',
  'Board games',
  'Walking',
];

class ClassSlot {
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });

  final String day;
  final String time;
  final String subject;
}

const classSchedule = <ClassSlot>[
  ClassSlot(
    day: 'Mon',
    time: '7:00 AM - 9:00 AM',
    subject: 'Human Computer Interaction 2 (CIT 213)',
  ),
  ClassSlot(
    day: 'Mon',
    time: '10:30 AM - 12:00 PM',
    subject: 'Security & Governance (CIT 251)',
  ),
  ClassSlot(
    day: 'Mon',
    time: '1:00 PM - 3:00 PM',
    subject: 'Web Systems & Technologies (CIT 210)',
  ),
  ClassSlot(
    day: 'Mon',
    time: '4:00 PM - 5:59 PM',
    subject: 'Methods of Research in Computing (CC 208)',
  ),
  ClassSlot(
    day: 'Tue',
    time: '9:00 AM - 12:00 PM',
    subject: 'Applications Development & Emerging Technologies (CC 207B)',
  ),
  ClassSlot(
    day: 'Tue',
    time: '1:00 PM - 2:30 PM',
    subject: 'Technopreneurship (BA 234)',
  ),
  ClassSlot(
    day: 'Tue',
    time: '3:00 PM - 5:59 PM',
    subject: 'Networking 2 (CIT 212)',
  ),
  ClassSlot(
    day: 'Wed',
    time: '7:00 AM - 9:00 AM',
    subject: 'Human Computer Interaction 2 (CIT 213)',
  ),
  ClassSlot(
    day: 'Wed',
    time: '10:30 AM - 12:00 PM',
    subject: 'Security & Governance (CIT 251)',
  ),
  ClassSlot(
    day: 'Wed',
    time: '1:00 PM - 3:00 PM',
    subject: 'Web Systems & Technologies (CIT 210)',
  ),
  ClassSlot(
    day: 'Wed',
    time: '4:00 PM - 5:59 PM',
    subject: 'Methods of Research in Computing (CC 208)',
  ),
  ClassSlot(
    day: 'Thu',
    time: '9:00 AM - 12:00 PM',
    subject: 'Applications Development & Emerging Technologies (CC 207B)',
  ),
  ClassSlot(
    day: 'Thu',
    time: '1:00 PM - 2:30 PM',
    subject: 'Technopreneurship (BA 234)',
  ),
  ClassSlot(
    day: 'Thu',
    time: '4:00 PM - 5:59 PM',
    subject: 'Networking 2 (CIT 212)',
  ),
];

class InfoTile extends StatelessWidget {
  const InfoTile({required this.info, super.key});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        child: Icon(info.icon),
      ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Fritz Marick A. Fernandez')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'Illustrated profile photo of Fritz Marick Fernandez',
                          image: true,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.jpg',
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fritz Marick A. Fernandez',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'IT student, creative problem-solver, and lifelong learner.',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Get to know me', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        for (final info in profileInfos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Hobbies', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final hobby in hobbies)
                              Chip(label: Text(hobby)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Class Schedule',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Table(
                          border: TableBorder.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(54),
                            1: FixedColumnWidth(82),
                            2: FlexColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                              ),
                              children: const [
                                _ScheduleCell('Day', bold: true),
                                _ScheduleCell('Time', bold: true),
                                _ScheduleCell('Subject', bold: true),
                              ],
                            ),
                            for (final slot in classSchedule)
                              TableRow(
                                children: [
                                  _ScheduleCell(slot.day),
                                  _ScheduleCell(slot.time),
                                  _ScheduleCell(slot.subject),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'I am Fritz Marick Fernandez, a third-year BS Information Technology student '
                          'majoring in Cybersecurity at West Visayas State University. I am a full-stack '
                          'developer who builds web apps, IoT devices, and security-minded tools. My projects '
                          'include the JT Smiles Dental Clinic website, PADANE smart walking stick web app, '
                          'SPARKHUB and Cyb Robotics websites, plus Arduino and ESP32 prototypes. I also serve '
                          'as VP for Research and Development in SPARKHUB and Cyb Robotics. I enjoy turning '
                          'local problems in Iloilo into practical, accessible, and creative digital solutions.',
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

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell(this.text, {this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
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
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _showHeart = false;
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });
    try {
      await _player.play(AssetSource('sounds/capybara.mp3'));
    } catch (error) {
      if (mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The pet sound could not be played: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Leonardo DiCapybara')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Meet my favorite animal',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Semantics(
                        label: 'A capybara named Leonardo DiCapybara',
                        image: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: AspectRatio(
                            aspectRatio: 1.35,
                            child: Image.asset(
                              'assets/images/capybara.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _showHeart ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.favorite,
                          size: 88,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Double-tap Leonardo to show some love.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Card(
                  color: theme.colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Text(
                          'Leonardo has made a happy sound $_barkCount ${_barkCount == 1 ? 'time' : 'times'}.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: _isPlaying ? null : _playSound,
                          icon: Icon(
                            _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                          ),
                          label: Text(
                            _isPlaying ? 'Playing...' : 'Play pet sound',
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _barkCount == 0 ? null : _confirmReset,
                          child: const Text('Reset count'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Leonardo DiCapybara is my favorite animal companion. '
                  'This playful capybara reminds me to stay calm, curious, and friendly.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset() async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text(
          'This will set Leonardo’s bark count back to zero.',
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
    if (reset == true && mounted) {
      setState(() => _barkCount = 0);
    }
  }
}

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const photos = <Photo>[
  Photo(
    asset: 'assets/images/gallery/gallery_1.jpg',
    caption: 'A new dish I tried',
  ),
  Photo(asset: 'assets/images/gallery/gallery_2.jpg', caption: 'My Pretty GF'),
  Photo(
    asset: 'assets/images/gallery/gallery_3.jpg',
    caption: 'Me and my wife',
  ),
  Photo(
    asset: 'assets/images/gallery/gallery_4.jpg',
    caption: 'Favorite movie studio',
  ),
  Photo(asset: 'assets/images/gallery/gallery_5.jpg', caption: 'Fav Snack'),
  Photo(
    asset: 'assets/images/gallery/gallery_6.jpg',
    caption: 'Random funny pic',
  ),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true && mounted) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            Semantics(
              label: photo.caption,
              button: true,
              child: InkWell(
                onTap: () => _open(photo),
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(photo.asset, fit: BoxFit.cover),
                    ),
                    if (_favoriteAsset == photo.asset)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(Icons.star, color: Colors.amber, size: 30),
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

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({required this.photo, super.key});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Semantics(
                  label: photo.caption,
                  image: true,
                  child: Image.asset(photo.asset, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
