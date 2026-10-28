import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// Content
const String Name = 'John Israel Mercado';
const String Tagline = 'Building dificult things to make life easier';
const String PhotoPath = 'assets/images/me.jpg';
const String Bio =
    'I usually build difficult things to make life easier. I enjoy learning new technologies '
    'and applying them to things that can be useful. Currently, I am a student of WVSU studying  '
    'Information Technology and I look forward to getting a job nad enjoy myself to the fullest.';

const String petName = 'HOOTIE';
const String petPhotoPath = 'assets/images/favAnimal.jpg';
const String petSoundPath = 'sounds/barnOwlSound.mp3';
const String petVerb = 'Screeched';
const String petNote =
    'My Favorite animal is a Barn Owl, It is cute but scary when it screches';

const Color seedColor = Colors.indigo;

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.school, label: 'School', value: 'WVSU'),
  ProfileInfo(
    icon: Icons.menu_book,
    label: 'Course',
    value: 'BS Information Technology',
  ),
  ProfileInfo(
    icon: Icons.sports_tennis,
    label: 'Hobbies',
    value: 'Coding, Playing Games, Watching Movies, Reading',
  ),
  ProfileInfo(
    icon: Icons.location_on,
    label: 'Location',
    value: 'Iloilo, Philippines',
  ),
  ProfileInfo(
    icon: Icons.email,
    label: 'Email',
    value: 'johnisrael.mercado@wvsu.edu.ph',
  ),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit 5 Exercise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seedColor, useMaterial3: true),
      home: const HomeShell(),
    );
  }
}

// Shell with bottom navigation bar
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [ProfileScreen(), PetScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: 'Favorite Animal',
          ),
        ],
      ),
    );
  }
}

// PROFILE SCREEN
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
    return ListTile(
      leading: Icon(info.icon, color: theme.colorScheme.primary),
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
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: ClipOval(
                    child: Image.asset(
                      PhotoPath,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $Name',
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 48),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Name, style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(Tagline, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [for (final info in infos) InfoTile(info: info)],
              ),
            ),
            const SizedBox(height: 16),

            // Biography
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(Bio, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PET SCREEN
class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
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
      await _player.play(AssetSource(petSoundPath));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorite Animal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        petPhotoPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of my favorite animal, $petName',
                        errorBuilder: (_, __, ___) => Container(
                          color: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.pets, size: 96),
                        ),
                      ),
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
            const SizedBox(height: 8),
            Text(
              petNote.isEmpty
                  ? 'Double-tap the photo to give $petName a heart.'
                  : petNote,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Play $petName\'s sound'),
            ),
            const SizedBox(height: 16),
            Text(
              '$petName has $petVerb $_playCount '
              '${_playCount == 1 ? 'time' : 'times'}.',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
