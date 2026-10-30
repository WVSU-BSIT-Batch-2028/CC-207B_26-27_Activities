import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renz Ramos',
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
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF20584F)
                  : const Color(0xFF68736F),
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
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
  final List<Widget> _screens = const [
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
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _schedule = [
    ['Monday', 'CC 207B', '1:00 - 3:00 PM'],
    ['Tuesday', 'Web Development', '9:00 - 11:00 AM'],
    ['Wednesday', 'Database Systems', '1:00 - 3:00 PM'],
    ['Thursday', 'Mobile Programming', '9:00 - 11:00 AM'],
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
                const SizedBox(height: 30),
                Text(
                  'A few details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF173B36),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const _InfoRow(label: 'Course', value: 'BSIT 3B, WVSU'),
                const _InfoRow(label: 'Birthday', value: 'Month DD, YYYY'),
                const _InfoRow(label: 'Address', value: 'Iloilo City'),
                const _InfoRow(label: 'Favorite food', value: 'Tsoklet'),
                const _InfoRow(label: 'Email', value: 'blabla@gmail.com'),
                const SizedBox(height: 18),
                Text(
                  'Hobbies',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF173B36),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: Icon(Icons.code, size: 18),
                      label: Text('Coding'),
                    ),
                    Chip(
                      avatar: Icon(Icons.sports_esports, size: 18),
                      label: Text('Gaming'),
                    ),
                    Chip(
                      avatar: Icon(Icons.sports_tennis, size: 18),
                      label: Text('Badminton'),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Text(
                  'Class schedule',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF173B36),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Day')),
                        DataColumn(label: Text('Subject')),
                        DataColumn(label: Text('Time')),
                      ],
                      rows: _schedule
                          .map(
                            (row) => DataRow(
                              cells: row
                                  .map((value) => DataCell(Text(value)))
                                  .toList(),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF20584F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'mimings that are astig.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      height: 1.55,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF737E78),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF243D37),
                fontWeight: FontWeight.w600,
              ),
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
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _count++;
    });
    await _player.play(AssetSource('sounds/meow.wav'));
  }

  Future<void> _confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset meow count?'),
        content: const Text('This will set the meow count back to zero.'),
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
    if (shouldReset == true && mounted) setState(() => _count = 0);
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
                  children: [
                    Expanded(
                      child: Text(
                        'Meet Ming',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF173B36),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: _showHeart ? 'Remove heart' : 'Show heart',
                      onPressed: () => setState(() => _showHeart = !_showHeart),
                      icon: Icon(
                        _showHeart ? Icons.favorite : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _isPlaying ? null : _playSound,
                        icon: const Icon(Icons.volume_up),
                        label: Text(_isPlaying ? 'Playing...' : 'Play a meow'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Reset meow count',
                      onPressed: _confirmReset,
                      icon: const Icon(Icons.restart_alt),
                    ),
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
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const photos = [
    ('assets/images/MING1.jpg', 'Ming says hello'),
    ('assets/images/MING2.jpg', 'Professional napper'),
    ('assets/images/MING3.jpg', 'Ming enjoys the view'),
    ('assets/images/MING4.jpg', 'A cozy afternoon'),
    ('assets/images/MING5.jpg', 'Ming looking curious'),
    ('assets/images/MING6.jpg', 'Best friends forever'),
  ];

  Future<void> _openPhoto(
    BuildContext context,
    String path,
    String caption,
  ) async {
    final answer = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoDetailScreen(path: path, caption: caption),
      ),
    );
    if (answer != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(answer)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GALLERY',
          style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.w800),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.9,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _openPhoto(context, photo.$1, photo.$2),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      photo.$1,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      photo.$2,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final String path;
  final String caption;

  const PhotoDetailScreen({
    super.key,
    required this.path,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PHOTO')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(path, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                caption,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () =>
                    Navigator.pop(context, 'Answer received for “$caption”.'),
                icon: const Icon(Icons.send),
                label: const Text('Send answer back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
