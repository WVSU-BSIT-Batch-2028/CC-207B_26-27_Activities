import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ProfilePetApp());

const Color _backgroundColor = Color(0xFFDDEBF5);
const Color _accentColor = Color(0xFF9099A0);
const String profileName = 'Ryzel John De Guia';

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _accentColor,
      primary: _accentColor,
      surface: _backgroundColor,
    );

    return MaterialApp(
      title: 'My Profile and Pet',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: _accentColor,
          foregroundColor: colorScheme.onSurface,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onSurface,
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colorScheme.surfaceContainerHighest
                  : _accentColor,
            ),
          ),
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
  int _selectedIndex = 0;

  static const List<Widget> _screens = [ProfileScreen(), PetScreen()];
  static const List<String> _titles = [profileName, 'My Pet'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
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

const List<ProfileInfo> profileInfos = [
  ProfileInfo(
    icon: Icons.school_outlined,
    label: 'School',
    value: 'West Visayas State University',
  ),
  ProfileInfo(icon: Icons.class_outlined, label: 'Class', value: 'CC 207B'),
  ProfileInfo(icon: Icons.code, label: 'Learning', value: 'Flutter and Dart'),
  ProfileInfo(
    icon: Icons.pets_outlined,
    label: 'Favorite animal',
    value: 'Owl',
  ),
  ProfileInfo(
    icon: Icons.phone_android,
    label: 'Project',
    value: 'Profile and My Pet app',
  ),
];

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(info.icon, color: colors.primary),
      title: Text(info.label, style: textTheme.labelLarge),
      subtitle: Text(info.value, style: textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Semantics(
                    image: true,
                    label: 'Photo of $profileName',
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            ColoredBox(
                              color: colors.primaryContainer,
                              child: SizedBox(
                                width: 92,
                                height: 92,
                                child: Icon(
                                  Icons.person,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profileName, style: textTheme.headlineSmall),
                        Text(
                          'Learning Flutter and Dart, one widget at a time',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (final info in profileInfos) InfoTile(info: info),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'I am a 3rd-year BSIT major trying to navigate life, pass my subjects, and learn as much as I can along the way. My offline (and online) hours revolve around gaming, catching up on good movies, and capturing aesthetics through photography. Working hard now so my future self can enjoy the comfortable, wealthy life I’m aiming for.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<void> _completionSubscription;
  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    unawaited(_completionSubscription.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/owl_hoot.mp3'));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add the audio file at assets/sounds/owl_hoot.mp3.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('My Favorite Animal: Owl', style: textTheme.headlineSmall),
              Text(
                'A favorite animal, not my pet',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Semantics(
                image: true,
                label: 'Photo of an owl',
                child: GestureDetector(
                  key: const Key('pet-photo'),
                  onDoubleTap: () => setState(() => _showHeart = !_showHeart),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/owl.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                ColoredBox(
                                  color: colors.primaryContainer,
                                  child: Icon(
                                    Icons.pets,
                                    color: colors.onPrimaryContainer,
                                    size: 72,
                                  ),
                                ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _showHeart
                                  ? Icon(
                                      Icons.favorite,
                                      key: const ValueKey('liked'),
                                      color: colors.primary,
                                      size: 36,
                                    )
                                  : const SizedBox.shrink(
                                      key: ValueKey('not-liked'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                label: Text(_isPlaying ? 'Playing...' : 'Play owl hoot'),
              ),
              const SizedBox(height: 12),
              Text(
                'The owl has hooted $_playCount ${_playCount == 1 ? 'time' : 'times'}.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Double-tap the photo to show or hide a heart.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
