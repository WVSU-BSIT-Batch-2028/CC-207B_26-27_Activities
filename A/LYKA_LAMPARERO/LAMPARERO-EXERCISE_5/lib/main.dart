import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7A4E2D),
        useMaterial3: true,
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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [ProfileScreen(), PetScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
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

// ---------------- PROFILE ----------------

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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: Icon(info.icon),
      ),
      title: Text(info.label.toUpperCase(), style: text.labelSmall),
      subtitle: Text(info.value, style: text.titleMedium),
    );
  }
}

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value, style: text.titleLarge),
        Text(label, style: text.labelSmall),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String fullName = 'Lyka R. Lamparero';

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'Course & Year',
      value: 'BSIT 3A | Software Development Technology',
    ),
    ProfileInfo(
      icon: Icons.account_balance,
      label: 'School',
      value: 'West Visayas State University',
    ),
    ProfileInfo(
      icon: Icons.favorite,
      label: 'Things I Love',
      value:
          'Good food, quiet afternoons, no deadlines, unemployment, and '
          'staying in bed.',
    ),
    ProfileInfo(
      icon: Icons.free_breakfast,
      label: 'My Kind of Day',
      value:
          'No deadlines, no responsibilities, no rush. Just starting my '
          'day with coffee, nakatulala sa lolang nagwawalis na naka-daster.',
    ),
    ProfileInfo(
      icon: Icons.stairs,
      label: 'A Little Quirk About Me',
      value:
          'Mall escalators, overpasses, and unfamiliar high, open '
          'staircases? My natural enemies. If I have to cross an overpass '
          'alone, mag-jaywalk na lang ako, uy.',
    ),
    ProfileInfo(
      icon: Icons.restaurant,
      label: "Things I'm Learning",
      value:
          'How to eat alone in public without randomly laughing to myself '
          'pag may naalala akong nakakatawa.',
    ),
    ProfileInfo(
      icon: Icons.child_care,
      label: 'Something People Might Not Guess About Me',
      value: 'I have three children. Napulot ko sa Uniqlo kag Time Zone.',
    ),
  ];

  static const List<(String, String)> stats = [
    ('7', 'KAKAMPI'),
    ('2', 'KALABAN'),
    ('Pinoy', 'BREED'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card: photo, name, tagline, stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/me.png',
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Lyka R. Lamparero',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fullName, style: text.headlineSmall),
                              const SizedBox(height: 4),
                              Text(
                                'A daughter, a sister, and taga-hakop ka tae ka iro.',
                                style: text.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (final s in stats)
                            StatItem(value: s.$1, label: s.$2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('About Lyka', style: text.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [for (final info in infos) InfoTile(info: info)],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Biography', style: text.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Lyka Ricarto Lamparero was born and raised in La Paz, Iloilo City, '
                      'despite her parents being from Capiz and Aklan. She describes her '
                      'childhood as fairly ordinary, growing up sheltered and well cared '
                      'for. Her mother, a licensed teacher, played an early role in her '
                      'education, teaching her to read, write, and do basic mathematics '
                      'from a young age. She was even enrolled in daycare at just two '
                      'years old. Now a third-year Bachelor of Science in Information '
                      'Technology student specializing in Software Development Technology '
                      'at West Visayas State University, Lyka chose her course through a '
                      'decision that was planned on her part but unexpected to others. She '
                      'chose Software Development Technology partly to avoid networking '
                      'subjects. Looking ahead, Lyka hopes to build a career that she '
                      'genuinely enjoys, one that allows her to grow without feeling '
                      'constantly drained while providing financial security for herself '
                      'and her family.',
                      style: text.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- MY PET ----------------

class PetFact {
  final IconData icon;
  final String title;
  final String tag;
  final String body;

  const PetFact({
    required this.icon,
    required this.title,
    required this.tag,
    required this.body,
  });
}

class FactCard extends StatelessWidget {
  final PetFact fact;

  const FactCard({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              foregroundColor: scheme.onPrimaryContainer,
              child: Icon(fact.icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(fact.title, style: text.titleMedium),
                      ),
                      Text(fact.tag, style: text.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(fact.body, style: text.bodyMedium),
                ],
              ),
            ),
          ],
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
  static const String petName = 'Burgo';

  static const List<PetFact> facts = [
    PetFact(
      icon: Icons.hearing,
      title: 'The One-Eared Husky',
      tag: 'Appearance',
      body:
          "Huskies are known for their upright ears, but one of Burgo's "
          'ears often flops down. He was attacked by a bulldog when he was '
          'younger, which injured his ear and neck.',
    ),
    PetFact(
      icon: Icons.pets,
      title: 'The Paw of Attention',
      tag: 'Affection',
      body:
          "If you're eating and not sharing, or simply ignoring him, Burgo "
          'will use his paw to get your attention.',
    ),
    PetFact(
      icon: Icons.volume_up,
      title: 'Loud and Dramatic',
      tag: 'Habit',
      body:
          'Burgo used to howl whenever he heard his favorite phrase, '
          '"Ta, lakat ta!" He\'d also get excited just seeing his leash. '
          'Apparently, the word "walk" doesn\'t even need to be in the '
          'sentence.',
    ),
    PetFact(
      icon: Icons.visibility,
      title: 'Easy to Read',
      tag: 'Signature',
      body:
          'When Burgo gets curious, both ears stand straight up, his head '
          'tilts to one side, and a little bit of his tongue sticks out. You '
          'can tell something has caught his attention, especially when he '
          'sees himself in a mirror or on the front camera.',
    ),
    PetFact(
      icon: Icons.help_outline,
      title: 'The Unexpected Fun Fact',
      tag: 'Unique',
      body: "Burgo has only one testicle. That's it. That's the fact.",
    ),
  ];

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLiked = false;
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
    try {
      await _player.play(AssetSource('sounds/burgo_awoo.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meet $petName', style: text.headlineSmall),
            const SizedBox(height: 12),
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/burgo.jpg',
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $petName, a husky labrador mix',
                    ),
                  ),
                  const Positioned(
                    top: 12,
                    left: 12,
                    child: Chip(
                      avatar: Icon(Icons.pets, size: 18),
                      label: Text('Husky - Labrador Mix'),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: scheme.surface,
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked
                            ? scheme.error
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 12,
                    left: 12,
                    child: Chip(
                      avatar: Icon(Icons.touch_app, size: 18),
                      label: Text('Double-tap to send love'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '"Loud, dramatic, curious, and always asking for attention."',
              style: text.bodyLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Hear $petName!'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.graphic_eq),
                title: Text("$petName's Soundbox", style: text.titleSmall),
                subtitle: Text(
                  '$petName has barked $_count times.',
                  style: text.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("$petName's Fun Facts", style: text.titleLarge),
            const SizedBox(height: 8),
            for (final fact in facts) FactCard(fact: fact),
          ],
        ),
      ),
    );
  }
}
