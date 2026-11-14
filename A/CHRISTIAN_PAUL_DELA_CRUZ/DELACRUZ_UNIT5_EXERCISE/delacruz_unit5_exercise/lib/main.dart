import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christian Paul De la Cruz',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
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
    final titles = ['Christian Paul De la Cruz', 'My Pet'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
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
  ProfileInfo(icon: Icons.school_outlined, label: 'Course', value: 'BSIT'),
  ProfileInfo(
    icon: Icons.apartment_outlined,
    label: 'School',
    value: 'WVSU College of ICT',
  ),
  ProfileInfo(
    icon: Icons.location_on_outlined,
    label: 'Location',
    value: 'Iloilo City, Philippines',
  ),
  ProfileInfo(
    icon: Icons.interests_outlined,
    label: 'Interests',
    value: 'Music, writing stories, cooking, and playing games',
  ),
  ProfileInfo(
    icon: Icons.calendar_month_outlined,
    label: 'Year and Section',
    value: 'BSIT 3A',
  ),
  ProfileInfo(
    icon: Icons.favorite_border,
    label: 'Favorite Animal',
    value: 'Dog',
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/profile_illustration.jpg',
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Christian Paul De la Cruz',
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Christian Paul De la Cruz',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'BSIT student • Learning by building',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'A little about me',
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        for (final info in profileInfos) InfoTile(info: info),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'I am Christian Paul De la Cruz, a BSIT student at '
                          'WVSU College of ICT. This profile is a small '
                          'introduction built with Flutter, and a place to '
                          'share more about my interests, hobbies, and goals.',
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

class InfoTile extends StatelessWidget {
  const InfoTile({required this.info, super.key});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: colors.secondaryContainer,
            foregroundColor: colors.onSecondaryContainer,
            child: Icon(info.icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(info.value, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ],
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
  bool _isFavorite = false;
  int _barkCount = 0;

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
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });

    try {
      await _player.play(AssetSource('sounds/dog_bark.wav'));
    } on PlatformException catch (error, stackTrace) {
      if (mounted) setState(() => _isPlaying = false);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dogs are my favorite animal.',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onDoubleTap: () {
                              setState(() => _isFavorite = !_isFavorite);
                            },
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/favorite_dog.jpg',
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Photo of a dog',
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Icon(
                                        _isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey(_isFavorite),
                                        color: colors.error,
                                        size: 32,
                                        semanticLabel: _isFavorite
                                            ? 'Marked as favorite'
                                            : 'Not marked as favorite',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isPlaying ? null : _playSound,
                            icon: Icon(
                              _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                            ),
                            label: Text(
                              _isPlaying ? 'Playing...' : 'Play sample bark',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'The sample dog has barked $_barkCount '
                            '${_barkCount == 1 ? 'time' : 'times'}.',
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Double-tap the picture to toggle the heart.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
