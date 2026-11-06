import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

import 'book.dart';
import 'open_library_api.dart';
import 'movie.dart';
import 'omdb_api.dart';
import 'pick.dart';
import 'contentful_source.dart';


void main() {
  runApp(const MyApp());
}

// ==========================================
// MAIN APP
// ==========================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bryan Roy Cartera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

// ==========================================
// HOME SHELL
// ==========================================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProfileScreen(),
      const PetScreen(),
      const GalleryScreen(),
      const ShelfScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
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
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.shelves),
            selectedIcon: Icon(Icons.shelves),
            label: 'Shelf',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PHOTO CLASS
// ==========================================

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

const List<Photo> galleryPhotos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'My First Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'My Second Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'My Third Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'My Fourth Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'My Fifth Photo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'My Sixth Photo',
  ),
];

// ==========================================
// CLASS SLOT
// ==========================================

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

// ==========================================
// MY HOBBIES
// ==========================================

const List<String> myHobbies = [
  'Gaming',
  'Coding',
  'Listening to Music',
  'Playing Basketball',
  'Exploring Technology',
];

// ==========================================
// MY CLASS SCHEDULE
// ==========================================

const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Monday',
    time: '8:00 AM - 10:00 AM',
    subject: 'Methods of Research in Computing',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '10:00 AM - 12:00 PM',
    subject: 'Application Development and Emerging Technologies',
  ),
  ClassSlot(
    day: 'Wednesday',
    time: '1:00 PM - 3:00 PM',
    subject: 'Technopreneurship',
  ),
  ClassSlot(
    day: 'Thursday',
    time: '8:00 AM - 10:00 AM',
    subject: 'Web Systems and Technologies',
  ),
];

// ==========================================
// PROFILE INFO
// ==========================================

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

// ==========================================
// INFO TILE
// ==========================================

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          info.icon,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        info.label,
        style: theme.textTheme.labelLarge,
      ),
      subtitle: Text(
        info.value,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

// ==========================================
// PROFILE SCREEN
// ==========================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const infos = <ProfileInfo>[
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'BS Information Technology',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Iloilo City, Philippines',
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: 'Interests',
      value: 'Technology and app development',
    ),
    ProfileInfo(
      icon: Icons.flag,
      label: 'Goal',
      value: 'Become a skilled IT professional',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget tableCell(String text, {bool isHeader = false}) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          softWrap: true,
          style: isHeader
              ? theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                )
              : theme.textTheme.bodyMedium,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bryan Roy Cartera'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PROFILE INFORMATION
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Semantics(
                      image: true,
                      label: 'Photo of Bryan Roy Cartera',
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/images/Profile.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bryan Roy Cartera',
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Learning today, building tomorrow!',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Get to Know Me',
              style: theme.textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Card(
              child: Column(
                children: [
                  for (final info in infos)
                    InfoTile(info: info),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // MY HOBBIES
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in myHobbies)
                          Chip(
                            label: Text(hobby),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // MY CLASS SCHEDULE
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FixedColumnWidth(75),
                        1: FixedColumnWidth(115),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            tableCell('Day', isHeader: true),
                            tableCell('Time', isHeader: true),
                            tableCell('Subject', isHeader: true),
                          ],
                        ),
                        for (final slot in classSchedule)
                          TableRow(
                            children: [
                              tableCell(slot.day),
                              tableCell(slot.time),
                              tableCell(slot.subject),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // MY BIOGRAPHY
            Card(
              color: theme.colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am Bryan Roy Cartera, a BS Information '
                      'Technology student who enjoys learning about '
                      'technology, exploring new ideas, and developing '
                      'my programming skills. I believe every challenge '
                      'is an opportunity to learn and grow.',
                      style: theme.textTheme.bodyMedium,
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

// ==========================================
// PET SCREEN
// ==========================================

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
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  // PLAY DOG SOUND
  Future<void> _playSound() async {
    try {
      await _player.stop();
      await _player.setVolume(1.0);

      await _player.play(
        AssetSource('sounds/petsound.wav'),
      );

      if (!mounted) return;

      setState(() {
        _barkCount++;
        _isPlaying = true;
      });
    } catch (error, stackTrace) {
      debugPrint('Audio playback error: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio error: $error'),
        ),
      );
    }
  }

  // RESET COUNT CONFIRMATION DIALOG
  Future<void> _confirmReset() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Bark Count?'),
          content: const Text(
            'Are you sure you want to reset your dog\'s bark count to zero?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true && mounted) {
      setState(() {
        _barkCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Best Friend'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Meet My Dog!',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Double-tap the photo to show some love!',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // DOG PHOTO AND HEART EFFECT
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _showHeart = !_showHeart;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Semantics(
                              image: true,
                              label: 'Photo of my dog',
                              child: Image.asset(
                                'assets/images/Pet.jpg',
                                width: double.infinity,
                                height: 280,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (_showHeart)
                            Icon(
                              Icons.favorite,
                              size: 100,
                              color: theme.colorScheme.error,
                              shadows: const [
                                Shadow(
                                  blurRadius: 15,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PLAY DOG SOUND BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isPlaying ? null : _playSound,
                        icon: Icon(
                          _isPlaying
                              ? Icons.hourglass_top
                              : Icons.volume_up,
                        ),
                        label: Text(
                          _isPlaying
                              ? 'Playing...'
                              : 'Play Dog Sound',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BARK COUNTER
                    Text(
                      'My dog has barked $_barkCount times.',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // RESET COUNT BUTTON
                    OutlinedButton.icon(
                      onPressed: _barkCount == 0
                          ? null
                          : _confirmReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset count'),
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

// ==========================================
// GALLERY SCREEN
// ==========================================

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(photo: photo),
      ),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        centerTitle: true,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in galleryPhotos)
            InkWell(
              onTap: () => _open(photo),
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                      ),
                    ),
                  ),
                  if (favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
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


// ==========================================
// SHELF SCREEN
// ==========================================

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite_outline), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Books'),
              Tab(icon: Icon(Icons.movie_outlined), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksTab(),
            BooksSearchTab(),
            MoviesSearchTab(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MY PICKS TAB
// ==========================================

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final PickSource _source = ContentfulPickSource();
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = _source.fetchPicks();
    setState(() {
      _picksFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 100),
                const Icon(Icons.cloud_off, size: 48),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Could not load your picks.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Center(child: Text('Pull down to try again.')),
              ],
            ),
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Icon(Icons.favorite_border, size: 48),
                SizedBox(height: 12),
                Center(child: Text('No picks found.')),
                SizedBox(height: 8),
                Center(child: Text('Pull down to refresh.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              final isBook = pick.kind.toLowerCase() == 'book';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: Icon(
                    isBook ? Icons.menu_book : Icons.movie,
                    size: 36,
                  ),
                  title: Text(pick.title),
                  subtitle: Text(pick.note),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PickDetailScreen(pick: pick),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ==========================================
// BOOK SEARCH TAB
// ==========================================

class BooksSearchTab extends StatefulWidget {
  const BooksSearchTab({super.key});

  @override
  State<BooksSearchTab> createState() => _BooksSearchTabState();
}

class _BooksSearchTabState extends State<BooksSearchTab> {
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  List<Book> _books = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;

  void _onChanged(String value) {
    _debounce?.cancel();

    if (value.trim().length < 3) {
      setState(() {
        _books = [];
        _loading = false;
        _searched = false;
        _error = null;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _search(value.trim()),
    );
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
      _searched = true;
    });

    try {
      final results = await _api.search(query);
      if (!mounted) return;

      setState(() {
        _books = results;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _books = [];
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _copyId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.id));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied book ID: ${book.id}')),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter at least 3 letters',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_error!),
                      ),
                    )
                  : !_searched
                      ? const Center(
                          child: Text('Search for a book to get started.'),
                        )
                      : _books.isEmpty
                          ? const Center(child: Text('No books found.'))
                          : ListView.builder(
                              itemCount: _books.length,
                              itemBuilder: (context, index) {
                                final book = _books[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: book.coverId != null
                                        ? Image.network(
                                            'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                            width: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.book),
                                          )
                                        : const Icon(Icons.book, size: 40),
                                    title: Text(book.title),
                                    subtitle: Text(
                                      'Year: ${book.year?.toString() ?? 'N/A'}',
                                    ),
                                    trailing: IconButton(
                                      tooltip: 'Copy book ID',
                                      icon: const Icon(Icons.copy),
                                      onPressed: () => _copyId(book),
                                    ),
                                  ),
                                );
                              },
                            ),
        ),
      ],
    );
  }
}

// ==========================================
// PHOTO SCREEN
// ==========================================

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop<bool>(context, true);
                },
                child: const Text('Make favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ==========================================
// MOVIE SEARCH TAB
// ==========================================

class MoviesSearchTab extends StatefulWidget {
  const MoviesSearchTab({super.key});

  @override
  State<MoviesSearchTab> createState() => _MoviesSearchTabState();
}

class _MoviesSearchTabState extends State<MoviesSearchTab> {
  final OmdbApi _api = OmdbApi();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  List<Movie> _movies = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;

  void _onChanged(String value) {
    _debounce?.cancel();

    if (value.trim().length < 3) {
      setState(() {
        _movies = [];
        _loading = false;
        _searched = false;
        _error = null;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _search(value.trim()),
    );
  }

  Future<void> _search(String query) async {
    setState(() {
      _loading = true;
      _error = null;
      _searched = true;
    });

    try {
      final results = await _api.search(query);
      if (!mounted) return;

      setState(() {
        _movies = results;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _movies = [];
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _copyId(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied IMDb ID: ${movie.imdbId}')),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'OMDb API key is missing.\n\n'
            'Run the app with --dart-define=OMDB_KEY=your_key '
            'or use --dart-define-from-file=cms.json.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 letters',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_error!),
                      ),
                    )
                  : !_searched
                      ? const Center(
                          child: Text('Search for a movie to get started.'),
                        )
                      : _movies.isEmpty
                          ? const Center(child: Text('No movies found.'))
                          : ListView.builder(
                              itemCount: _movies.length,
                              itemBuilder: (context, index) {
                                final movie = _movies[index];
                                final hasPoster = movie.poster.isNotEmpty &&
                                    movie.poster != 'N/A';

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: hasPoster
                                        ? Image.network(
                                            movie.poster,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                              Icons.movie,
                                              size: 40,
                                            ),
                                          )
                                        : const Icon(Icons.movie, size: 40),
                                    title: Text(movie.title),
                                    subtitle: Text('Year: ${movie.year}'),
                                    trailing: IconButton(
                                      tooltip: 'Copy IMDb ID',
                                      icon: const Icon(Icons.copy),
                                      onPressed: () => _copyId(movie),
                                    ),
                                  ),
                                );
                              },
                            ),
        ),
      ],
    );
  }
}


// ==========================================
// PICK DETAIL SCREEN
// ==========================================

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({
    super.key,
    required this.pick,
  });

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Map<String, dynamic>> _detailsFuture;

  static const String _omdbKey =
      String.fromEnvironment('OMDB_KEY');

  @override
  void initState() {
    super.initState();
    _detailsFuture = _fetchDetails();
  }

  Future<Map<String, dynamic>> _fetchDetails() async {
    final pick = widget.pick;

    if (pick.kind.trim().toLowerCase() == 'book') {
      final id = pick.externalId.split('/').last;
      final uri = Uri.https(
        'openlibrary.org',
        '/works/$id.json',
      );
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(
          'Open Library error: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rawDescription = data['description'];
      String description = 'No description yet.';

      if (rawDescription is String) {
        description = rawDescription;
      } else if (rawDescription is Map<String, dynamic>) {
        description =
            rawDescription['value']?.toString() ??
            'No description yet.';
      }

      return {
        'title': data['title']?.toString() ?? pick.title,
        'description': description,
        'coverUrl': data['covers'] is List &&
                (data['covers'] as List).isNotEmpty
            ? 'https://covers.openlibrary.org/b/id/'
                '${(data['covers'] as List).first}-L.jpg'
            : null,
      };
    }

    if (_omdbKey.isEmpty) {
      throw Exception(
        'OMDb API key is missing. Check OMDB_KEY in cms.json.',
      );
    }

    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': _omdbKey,
        'i': pick.externalId,
        'plot': 'short',
      },
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('OMDb error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      throw Exception(data['Error']?.toString() ?? 'Movie not found.');
    }

    return {
      'title': data['Title']?.toString() ?? pick.title,
      'description': data['Plot']?.toString() ?? 'No plot available.',
      'coverUrl': data['Poster']?.toString() == 'N/A'
          ? null
          : data['Poster']?.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final isBook = pick.kind.trim().toLowerCase() == 'book';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load details.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final details = snapshot.data!;
          final coverUrl = details['coverUrl'] as String?;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (coverUrl != null && coverUrl.isNotEmpty)
                Center(
                  child: Image.network(
                    coverUrl,
                    height: 260,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      isBook ? Icons.menu_book : Icons.movie,
                      size: 100,
                    ),
                  ),
                )
              else
                Center(
                  child: Icon(
                    isBook ? Icons.menu_book : Icons.movie,
                    size: 100,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                details['title']?.toString() ?? pick.title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                pick.note,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                isBook ? 'Description' : 'Plot',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                details['description']?.toString() ??
                    'No description available.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        },
      ),
    );
  }
}
