import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Me & Lurk | Unit 6',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF27665B),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

// ======================================================
// Navigation shell
// ======================================================

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
    GalleryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
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

// ======================================================
// Profile screen (stateless widgets only)
// ======================================================

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
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(info.icon, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(info.value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // EDIT: change these values to your own details
  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.cake_outlined,
      label: 'Birthdate',
      value: 'March 16, 2006',
    ),
    ProfileInfo(
      icon: Icons.location_on_outlined,
      label: 'Address',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'juancarlos.moje@wvsu.edu.ph',
    ),
    ProfileInfo(
      icon: Icons.school_outlined,
      label: 'Education',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.computer_outlined,
      label: 'Course',
      value: 'BS Information Technology',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Juan Carlos Moje')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------- Profile row ----------
                Card(
                  color: colors.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.primary, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/me.jpg',
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              semanticLabel: 'Photo of Juan Carlos Moje',
                              errorBuilder: (context, error, stack) => SizedBox(
                                width: 88,
                                height: 88,
                                child: Icon(
                                  Icons.person,
                                  size: 48,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Juan Carlos Moje',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Aspiring developer', // EDIT: your tagline
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Information section ----------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        for (final info in infos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Unit 6 profile additions ----------
                const HobbiesCard(),
                const SizedBox(height: 16),
                const ScheduleCard(),
                const SizedBox(height: 16),
                // ---------- Biography ----------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text(
                          // EDIT: write one paragraph about yourself
                          'I am a student at West Visayas State University '
                          'who enjoys building apps and learning new '
                          'technologies. I like turning ideas into working '
                          'software, and I am always looking for ways to '
                          'improve my skills one project at a time.',
                          style: textTheme.bodyMedium?.copyWith(height: 1.5),
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

// ======================================================
// Pet screen (StatefulWidget + setState)
// ======================================================

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<void> _completion;
  bool _isPlaying = false;
  bool _liked = false;
  int _playCount = 0;

  static const String petName = 'Lurk';
  static const String petBreed = 'Doberman';
  static const String petAction = 'barked';

  @override
  void initState() {
    super.initState();
    _completion = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _completion.cancel();
    _player.dispose(); // release what you created
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    try {
      // Professor's starter pattern: AssetSource looks inside assets/.
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
      if (mounted) setState(() => _playCount++);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not play the sound. Please try again.'),
        ),
      );
    }
  }

  Future<void> _resetCount() async {
    final bool? reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Lurk has barked $_playCount times. Start again from zero?',
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
    if (mounted && reset == true) setState(() => _playCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------- Photo (double-tap for a heart) ----------
                GestureDetector(
                  onDoubleTap: () => setState(() => _liked = !_liked),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              'assets/images/pet.jpg',
                              fit: BoxFit.cover,
                              semanticLabel:
                                  'Photo of $petName, my pet $petBreed',
                              errorBuilder: (context, error, stack) =>
                                  ColoredBox(
                                    color: colors.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.pets,
                                      size: 72,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        AnimatedScale(
                          scale: _liked ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          child: Icon(
                            Icons.favorite,
                            size: 112,
                            color: colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Double-tap the photo to show some love',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Name and breed ----------
                Row(
                  children: [
                    Text(petName, style: textTheme.headlineMedium),
                    const SizedBox(width: 12),
                    const Chip(
                      avatar: Icon(Icons.pets, size: 18),
                      label: Text(petBreed),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---------- Sound + counter ----------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.icon(
                          onPressed: _isPlaying ? null : _playSound,
                          icon: Icon(
                            _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                          ),
                          label: Text(
                            _isPlaying ? 'Playing...' : 'Hear $petName',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$petName has $petAction $_playCount '
                          '${_playCount == 1 ? 'time' : 'times'}.',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _playCount == 0 ? null : _resetCount,
                          child: const Text('Reset count'),
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

// Unit 6: personal lists and a table.
const List<String> hobbies = [
  'Badminton',
  'Playing games',
  'Reading comics',
  'Watching movies and shows',
  'Collecting Beyblades and watches',
];

class ClassSlot {
  final String day;
  final String time;
  final String subject;
  const ClassSlot({
    required this.day,
    required this.time,
    required this.subject,
  });
}

// Class schedule supplied by Juan Carlos.
const List<ClassSlot> classSlots = [
  ClassSlot(day: 'Mon', time: '9 AM–12 PM', subject: 'CIT 251'),
  ClassSlot(day: 'Mon', time: '1–3 PM', subject: 'CIT 212'),
  ClassSlot(day: 'Mon', time: '4–6 PM', subject: 'CC 207H'),
  ClassSlot(day: 'Tue', time: '7–9 AM', subject: 'CC 210'),
];

class HobbiesCard extends StatelessWidget {
  const HobbiesCard({super.key});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Hobbies', style: Theme.of(context).textTheme.titleLarge),
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

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget cell(String text, {bool header = false}) => Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: header ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Class Schedule', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('My weekly classes', style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.all(color: theme.colorScheme.outlineVariant),
              columnWidths: const {
                0: FixedColumnWidth(48),
                1: FixedColumnWidth(84),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                  ),
                  children: [
                    cell('Day', header: true),
                    cell('Time', header: true),
                    cell('Subject', header: true),
                  ],
                ),
                for (final slot in classSlots)
                  TableRow(
                    children: [
                      cell(slot.day),
                      cell(slot.time),
                      cell(slot.subject),
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

// Unit 6: push a photo route and receive a nullable bool result.
class Photo {
  final String asset;
  final String caption;
  const Photo({required this.asset, required this.caption});
}

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/profile.jpg', caption: 'My portrait'),
  Photo(asset: 'assets/images/gallery/lurk.jpg', caption: 'Lurk the Doberman'),
  Photo(
    asset: 'assets/images/gallery/mountains.jpg',
    caption: 'Mountain escape',
  ),
  Photo(asset: 'assets/images/gallery/forest.jpg', caption: 'Forest trail'),
  Photo(asset: 'assets/images/gallery/coast.jpg', caption: 'By the coast'),
  Photo(asset: 'assets/images/gallery/lake.jpg', caption: 'Quiet waters'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favorite;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (mounted && makeFavorite == true) {
      setState(() => _favorite = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Tap a photo to explore it and choose your favorite.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: GridView.extent(
                maxCrossAxisExtent: 160,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.all(8),
                children: [
                  for (final photo in photos)
                    Semantics(
                      button: true,
                      selected: _favorite == photo.asset,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          key: ValueKey(photo.asset),
                          onTap: () => _open(photo),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  photo.asset,
                                  fit: BoxFit.cover,
                                  semanticLabel: photo.caption,
                                ),
                              ),
                              if (_favorite == photo.asset)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                    child: Icon(
                                      Icons.star,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      semanticLabel: 'Favorite photo',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final Photo photo;
  const PhotoScreen({super.key, required this.photo});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(photo.caption)),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.star_outline),
              label: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    ),
  );
}
