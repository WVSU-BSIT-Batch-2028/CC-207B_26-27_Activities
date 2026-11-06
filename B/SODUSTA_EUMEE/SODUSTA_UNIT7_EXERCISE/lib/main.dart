import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
const omdbKey = String.fromEnvironment('OMDB_KEY');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');


void main() {
  runApp(const MyApp());
  
}

ThemeData buildPinkTheme() {
  const plum = Color(0xFF3B0A1A);

  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFFFB6F92)).copyWith(
    primary: const Color(0xFFFB6F92),
    onPrimary: plum,
    primaryContainer: const Color(0xFFFFC2D1),
    onPrimaryContainer: plum,
    secondary: const Color(0xFFFF8FAB),
    onSecondary: plum,
    secondaryContainer: const Color(0xFFFFB3C6),
    onSecondaryContainer: plum,
    surface: const Color(0xFFFFE5EC),
    onSurface: plum,
    onSurfaceVariant: const Color(0xFF7A2E48),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    cardTheme: CardThemeData(
      color: scheme.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.primaryContainer,
      indicatorColor: scheme.primary,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eumee Sodusta',
      debugShowCheckedModeBanner: false,
      theme: buildPinkTheme(),
      home: const HomeShell(),
    );
  }
}

// ---------------------------------------------------------------
// HomeShell: Scaffold + NavigationBar with three destinations
// ---------------------------------------------------------------
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
      // Gallery and Shelf have their own AppBar, so hide this one there
      appBar: _selectedIndex >= 2
          ? null
          : AppBar(title: const Text('Eumee Sodusta')),
      // IndexedStack keeps every screen alive when you switch tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfileScreen(),
          PetScreen(),
          GalleryScreen(),
          ShelfScreen(),
        ],
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
            icon: Icon(Icons.pets),
            label: 'My Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_library_outlined),
            selectedIcon: Icon(Icons.local_library),
            label: 'Shelf',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Profile data
// ---------------------------------------------------------------
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

const List<ProfileInfo> profileInfos = [
  ProfileInfo(
    icon: Icons.cake,
    label: 'Birthday',
    value: 'May 8, 2006',
  ),
  ProfileInfo(
    icon: Icons.home,
    label: 'Address',
    value: 'Brgy. Duyan-Duyan, Sta. Barbara',
  ),
  ProfileInfo(
    icon: Icons.school,
    label: 'Education',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.computer,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
];

// One row of the information section
class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label, style: textTheme.labelLarge),
      subtitle: Text(info.value, style: textTheme.bodyMedium),
    );
  }
}

const List<String> hobbies = [
  'Reading',
  'Crocheting',
  'Watching Movies',
  'Singing',
  'Hiking',
  'Traveling',
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

// Replace these with your real classes
const List<ClassSlot> schedule = [
  ClassSlot(
    day: 'Mon',
    time: '9:00-12:00 AM\n1:00-3:00 PM\n3:00-6:00 PM',
    subject: 'CIT 251\nCIT 212\nCC 207B',
  ),
  ClassSlot(
    day: 'Tue',
    time: '7:00-9:00 AM\n12:00-1:00 PM\n1:00-2:30 PM\n3:00-6:00 PM',
    subject: 'CIT 210\nBA 234\nCC 208\nCIT 213',
  ),
  ClassSlot(
    day: 'Wed',
    time: '10:00-12:00 AM\n1:00-4:00 PM\n4:00-6:00 PM',
    subject: 'CIT 251\nCIT 212\nCC 207B',
  ),
  ClassSlot(
    day: 'Thu',
    time: '7:00-10:00 AM\n12:00-1:00 PM\n1:00-2:30 PM\n4:00-6:00 PM',
    subject: 'CIT 210\nBA 234\nCC 208\nCIT 213',
  ),
];

// ---------------------------------------------------------------
// Profile screen (stateless)
// ---------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _cell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/Me.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  semanticLabel: 'Photo of Eumee Sodusta',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Eumee S. Sodusta', style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      "Nakakapagod na siyang intindihin pero wala akong "
                      "magagawa major subject ko 'yon eh",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Information section
          Card(
            child: Column(
              children: [
                for (final info in profileInfos) InfoTile(info: info),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hobbies as chips
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Hobbies', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final hobby in hobbies) Chip(label: Text(hobby)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Biography
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Biography', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    "Hi! I’m a third-year BSIT student at West Visayas State "
                    "University. I’m someone who enjoys trying new things and "
                    "exploring different interests. Recently, I’ve started "
                    "getting into hiking, and I also enjoy traveling and "
                    "discovering new places. During my free time, I like "
                    "reading ebooks, especially manga and manhwa, and watching "
                    "movies and series like Game of Thrones. I also enjoy "
                    "singing and spending time with people I’m comfortable "
                    "with. I’m still discovering new things about myself as I "
                    "go through college, and I look forward to gaining more "
                    "experiences, learning new skills, and making the most "
                    "out of life.",
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Class schedule as a table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Class Schedule', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: colorScheme.outline),
                    columnWidths: const {
                      0: FixedColumnWidth(56),
                      1: FixedColumnWidth(130),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                        ),
                        children: [
                          _cell('Day', bold: true),
                          _cell('Time', bold: true),
                          _cell('Subject', bold: true),
                        ],
                      ),
                      for (final slot in schedule)
                        TableRow(
                          children: [
                            _cell(slot.day),
                            _cell(slot.time),
                            _cell(slot.subject),
                          ],
                        ),
                    ],
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

// ---------------------------------------------------------------
// My Pet screen (stateful)
// ---------------------------------------------------------------
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
      _barkCount++;
    });
    try {
      await _player.play(AssetSource('sounds/Bark.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Mochi has barked $_barkCount '
          '${_barkCount == 1 ? 'time' : 'times'}. Start again from zero?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (answer == true && mounted) {
      setState(() => _barkCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo with double-tap heart
              GestureDetector(
                onDoubleTap: () => setState(() => _showHeart = !_showHeart),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          'assets/images/Mochi.png',
                          fit: BoxFit.cover,
                          semanticLabel:
                              'Photo of Mochi, a white dog with brown spots',
                        ),
                      ),
                    ),
                    if (_showHeart)
                      Icon(
                        Icons.favorite,
                        size: 96,
                        color: colorScheme.primary,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text('Meet Mochi', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Mochi is my 8-year-old dog, half Japanese Spitz and half '
                'Shih Tzu. She is white with brown spots, very active, and '
                'very clingy.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Sound button
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: Icon(_isPlaying ? Icons.volume_up : Icons.pets),
                label: Text(_isPlaying ? 'Playing...' : 'Hear Mochi bark'),
              ),
              const SizedBox(height: 12),

              // Counter
              Text(
                'Mochi has barked $_barkCount '
                '${_barkCount == 1 ? 'time' : 'times'}.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Reset button (disabled while the count is 0)
              OutlinedButton(
                onPressed: _barkCount == 0 ? null : _confirmReset,
                child: const Text('Reset count'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Gallery
// ---------------------------------------------------------------
class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

// Change the captions to your own
const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/1.jpg', caption: 'SineSindak'),
  Photo(asset: 'assets/images/gallery/2.jpg', caption: 'Night Jog'),
  Photo(asset: 'assets/images/gallery/3.jpg', caption: 'Cup of Joe Concert'),
  Photo(asset: 'assets/images/gallery/4.jpg', caption: 'Swimming'),
  Photo(asset: 'assets/images/gallery/5.jpg', caption: 'Food'),
  Photo(asset: 'assets/images/gallery/6.jpg', caption: 'Japanese Cafe'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    // push<bool> completes with what PhotoScreen pops:
    // true from "Make favorite", null from the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
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
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                  if (photo.asset == _favoriteAsset)
                    const Positioned(
                      top: 4,
                      right: 4,
                      child: Icon(Icons.star, color: Colors.amber),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.star),
                  label: const Text('Make favorite'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Shelf: My Picks, Books and Movies
// ---------------------------------------------------------------
class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: TabBar(
            labelColor: colors.onPrimary,
            unselectedLabelColor: colors.onPrimary.withValues(alpha: 0.6),
            indicatorColor: colors.onPrimary,
            tabs: const [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksTab(),
            BooksTab(),
            MoviesTab(),
          ],
        ),
      ),
    );
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        workId: (json['key'] as String).split('/').last,
        title: json['title'] as String,
        // author_name is missing for some books, and it is a list.
        authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );
}

class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String? ?? '',
      // OMDb sends "N/A" when there is no poster.
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class OmdbApi {
  OmdbApi([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw const ApiException('OMDb took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    // OMDb answers a wrong key with 401 and a JSON message, so read it too.
    if (response.statusCode != 200 && response.statusCode != 401) {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    final results = json['Search'] as List<dynamic>? ?? const [];
    return [for (final m in results) Movie.fromJson(m as Map<String, dynamic>)];
  }

    Future<PickDetails> details(String imdbId) async {
    if (omdbKey.isEmpty) {
      throw const ApiException('Movie details need an OMDb key in cms.json.');
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw const ApiException('OMDb took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    if (response.statusCode != 200 && response.statusCode != 401) {
      throw ApiException('OMDb answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    final plot = json['Plot'] as String?;
    return PickDetails(
      title: json['Title'] as String? ?? 'Untitled',
      subtitle: 'Movie · ${json['Year'] ?? ''}',
      summary: (plot == null || plot == 'N/A') ? 'No description yet.' : plot,
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final _api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = _api.search(query);
      });
    });
  }

  Future<void> _copyId(Movie movie) async {
    await Clipboard.setData(ClipboardData(text: movie.imdbId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied ${movie.imdbId}')));
  }

  Widget _poster(Movie movie) {
    const icon = Icon(Icons.movie_outlined);
    final url = movie.poster;
    if (url == null) return const SizedBox(width: 40, child: icon);
    return SizedBox(
      width: 40,
      height: 56,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // No key: show how to pass it instead of searching.
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Movie search needs an OMDb key. Run the app with '
            '--dart-define=OMDB_KEY=your-key '
            '(or put OMDB_KEY in cms.json and use --dart-define-from-file).',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search movies, e.g. interstellar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    final movies = snapshot.data ?? const <Movie>[];
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, i) {
                        final movie = movies[i];
                        return ListTile(
                          leading: _poster(movie),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            tooltip: 'Copy ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyId(movie),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class OpenLibraryApi {
  OpenLibraryApi([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const ApiException('Open Library took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>? ?? const [];
    return [for (final d in docs) Book.fromJson(d as Map<String, dynamic>)];
  }

    Future<PickDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw const ApiException('Open Library took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Open Library answered ${response.statusCode}.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final description = switch (json['description']) {
      final String text => text, // "description": "..."
      {'value': final String text} => text, // {"type": ..., "value": "..."}
      _ => 'No description yet.',
    };
    final covers = (json['covers'] as List<dynamic>? ?? const [])
        .whereType<int>()
        .where((c) => c > 0);
    return PickDetails(
      title: json['title'] as String? ?? 'Untitled',
      subtitle: 'Book · Open Library $workId',
      summary: description,
      imageUrl: covers.isEmpty
          ? null
          : 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg',
    );
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final _api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = _api.search(query); // a new Future for the FutureBuilder
      });
    });
  }

  Future<void> _copyId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.workId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied ${book.workId}')));
  }

  Widget _cover(Book book) {
    const icon = Icon(Icons.image_not_supported_outlined);
    final id = book.coverId;
    if (id == null) return const SizedBox(width: 40, child: icon);
    return SizedBox(
      width: 40,
      height: 56,
      child: Image.network(
        'https://covers.openlibrary.org/b/id/$id-M.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search books, e.g. hobbit',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    final books = snapshot.data ?? const <Book>[];
                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, i) {
                        final book = books[i];
                        final author =
                            book.authors.isEmpty ? 'Unknown author' : book.authors.first;
                        return ListTile(
                          leading: _cover(book),
                          title: Text(book.title),
                          subtitle: Text(
                            book.year == null ? author : '$author · ${book.year}',
                          ),
                          trailing: IconButton(
                            tooltip: 'Copy ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () => _copyId(book),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  bool get isBook => kind.trim().toLowerCase() == 'book';
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource([http.Client? client])
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (cmsSpace.isEmpty || cmsToken.isEmpty) {
      throw const ApiException(
        'My Picks needs your Contentful values. Run the app with '
        '--dart-define-from-file=cms.json.',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$cmsSpace/environments/master/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '100'},
    );
    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: {'Authorization': 'Bearer $cmsToken'})
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw const ApiException('Contentful took too long. Try again.');
    } on http.ClientException {
      throw const ApiException('No connection. Check your internet.');
    }
    final code = response.statusCode;
    switch (code) {
      case 200:
        break;
      case 401 || 403:
        throw ApiException(
          'Contentful refused the request ($code). Check your token.',
        );
      case 404:
        throw const ApiException(
          'Contentful could not find the picks (404). '
          'Check the Space ID and the content type name.',
        );
      case >= 500:
        throw ApiException('Contentful is having problems ($code). Try again later.');
      default:
        throw ApiException('Contentful answered $code.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>? ?? const [];
    final picks = <Pick>[];
    for (final item in items) {
      final fields = item['fields'] as Map<String, dynamic>;
      picks.add(Pick(
        id: item['sys']['id'] as String,
        title: fields['title'] as String? ?? '',
        kind: fields['kind'] as String? ?? '',
        externalId: fields['externalId'] as String? ?? '',
        note: fields['note'] as String? ?? '',
      ));
    }
    return picks;
  }
}

/// What the detail screen shows, whichever API it came from.
class PickDetails {
  const PickDetails({
    required this.title,
    required this.subtitle,
    required this.summary,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String summary;
  final String? imageUrl;
}

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final PickSource _source = ContentfulPickSource();
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    _future = _source.fetchPicks(); // starts once, not in build()
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _source.fetchPicks();
    });
    try {
      await _future;
    } catch (_) {
      // The FutureBuilder already shows the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        final picks = snapshot.data ?? const <Pick>[];
        return RefreshIndicator(
          onRefresh: _refresh,
          child: picks.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: Center(
                        child: Text('No picks yet. Add some in Contentful.'),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: picks.length,
                  separatorBuilder: (context, i) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final pick = picks[i];
                    return ListTile(
                      leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
                      title: Text(pick.title),
                      subtitle: Text(
                        pick.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PickDetailScreen(pick: pick),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<PickDetails> _future;

  @override
  void initState() {
    super.initState();
    final pick = widget.pick;
    _future = pick.isBook
        ? OpenLibraryApi().details(pick.externalId)
        : OmdbApi().details(pick.externalId);
  }

  Widget _image(String? url) {
    const placeholder = SizedBox(
      height: 240,
      child: Center(child: Icon(Icons.image_not_supported_outlined, size: 64)),
    );
    if (url == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => placeholder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<PickDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }
          final d = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _image(d.imageUrl)),
                    const SizedBox(height: 16),
                    Text(d.title, style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(d.subtitle, style: textTheme.labelMedium),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Why I recommend it', style: textTheme.titleSmall),
                            const SizedBox(height: 4),
                            Text(widget.pick.note),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(d.summary, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}