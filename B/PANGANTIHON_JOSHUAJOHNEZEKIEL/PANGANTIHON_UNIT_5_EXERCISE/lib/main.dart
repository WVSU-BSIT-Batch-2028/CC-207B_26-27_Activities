import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seededTheme = ThemeData(
      colorSchemeSeed: const Color(0xFF176B55),
      useMaterial3: true,
    );
    final colorScheme = seededTheme.colorScheme.copyWith(
      surface: const Color(0xFFF4F1E8),
    );
    final baseTheme = seededTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.primary),
    );

    return MaterialApp(
      title: 'Joshua Pangantihon',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: baseTheme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          indicatorColor: colorScheme.primaryContainer,
          labelTextStyle: WidgetStatePropertyAll(
            baseTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textTheme: baseTheme.textTheme.copyWith(
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.08,
          ),
          titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(height: 1.55),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isProfile = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isProfile ? 'Joshua John Ezekiel Pangantihon' : 'My Pet',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
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
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets_rounded),
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

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(info.icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    info.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    info.value,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(icon: Icons.school_rounded, label: 'Program', value: 'BSIT'),
    ProfileInfo(
      icon: Icons.groups_rounded,
      label: 'Year / Section',
      value: 'BSIT-3B',
    ),
    ProfileInfo(
      icon: Icons.menu_book_rounded,
      label: 'Course',
      value: 'CC 207B Application Development',
    ),
    ProfileInfo(
      icon: Icons.cake_rounded,
      label: 'Birthdate',
      value: 'January 2, 2006',
    ),
    ProfileInfo(
      icon: Icons.brush_rounded,
      label: 'Hobbies',
      value: 'Painting and drawing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROFILE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Semantics(
                          image: true,
                          label: 'Photo of Joshua John Ezekiel Pangantihon',
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.56,
                                ),
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profile.jpg',
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Joshua John Ezekiel Pangantihon',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'BSIT student',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary.withValues(
                                    alpha: 0.82,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const _SectionHeading(
                eyebrow: 'THE DETAILS',
                title: 'A few things about me',
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    for (final info in infos) ...[
                      InfoTile(info: info),
                      if (info != infos.last)
                        Divider(
                          height: 1,
                          indent: 56,
                          color: colorScheme.outlineVariant,
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                color: colorScheme.secondaryContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Biography',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'I am a BSIT-3B student learning to develop applications, hoping to make a lot of money in doing so. I desire to realize my ideas throught technological innovations, and imagine ideas that can probably contribute to society. Finally, I have acquired skills throughout my journey in exploring technology, but I can still say there is still more to learn.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }
}

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<void>? _completionSubscription;
  bool _isPlaying = false;
  bool _isLoved = false;
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();
    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  Future<void> _playBark() async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);

    try {
      await _audioPlayer.play(AssetSource('sounds/dog_barking.mp3'));
      if (mounted) setState(() => _barkCount++);
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  void dispose() {
    unawaited(_completionSubscription?.cancel());
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 620;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 720,
              maxHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                compact ? 6 : 12,
                16,
                compact ? 6 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionHeading(eyebrow: 'Dawg', title: 'Meet my dog'),
                  SizedBox(height: compact ? 6 : 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: GestureDetector(
                        onDoubleTap: () => setState(() => _isLoved = !_isLoved),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Semantics(
                              image: true,
                              label: 'Photo of my dog',
                              child: Image.asset(
                                'assets/images/dog.webp',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              left: 16,
                              top: 16,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withValues(
                                    alpha: 0.92,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'MY FAVORITE SIDEKICK',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: AnimatedScale(
                                scale: _isLoved ? 1 : 0.75,
                                duration: const Duration(milliseconds: 180),
                                child: AnimatedOpacity(
                                  opacity: _isLoved ? 1 : 0,
                                  duration: const Duration(milliseconds: 180),
                                  child: CircleAvatar(
                                    backgroundColor: colorScheme.tertiary,
                                    foregroundColor: colorScheme.onTertiary,
                                    child: const Icon(Icons.favorite_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 8 : 12),
                  Container(
                    padding: EdgeInsets.all(compact ? 12 : 14),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Barks and personality.',
                          style: compact
                              ? theme.textTheme.titleMedium
                              : theme.textTheme.titleLarge,
                        ),
                        SizedBox(height: compact ? 2 : 4),
                        Text(
                          _barkCount == 1
                              ? 'My dog has barked once.'
                              : 'My dog has barked $_barkCount times.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: compact ? 6 : 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _isPlaying ? null : _playBark,
                            icon: Icon(
                              _isPlaying
                                  ? Icons.graphic_eq_rounded
                                  : Icons.volume_up_rounded,
                            ),
                            label: Text(
                              _isPlaying ? 'Playing...' : 'Play a bark',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: compact ? 4 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Double-tap the photo to leave a heart.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
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
