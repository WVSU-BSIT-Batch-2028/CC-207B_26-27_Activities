import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

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

const List<ProfileInfo> infos = [
  ProfileInfo(icon: Icons.school, label: 'Course', value: 'BSIT'),
  ProfileInfo(
    icon: Icons.account_balance,
    label: 'School',
    value: 'West Visayas State University',
  ),
  ProfileInfo(
    icon: Icons.restaurant,
    label: 'Favorite Food',
    value: 'Anything on the table except fish',
  ),
  ProfileInfo(icon: Icons.location_city, label: 'City', value: 'Iloilo City'),
  ProfileInfo(icon: Icons.pets, label: 'Pet', value: 'Tilap'),
];

const List<String> hobbies = [
  'Watching movies',
  'Logging movies on Letterboxd',
  'Catching up on sleep',
  'Playing with my cats',
  'Taking photos',
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

const List<ClassSlot> schedule = [
  ClassSlot(
    day: 'Mon',
    time: '9:00-12:00',
    subject: 'CIT 246 IT Project Management',
  ),
  ClassSlot(day: 'Mon', time: '1:00-3:00', subject: 'CIT 212 Networking 2'),
  ClassSlot(day: 'Mon', time: '3:00-6:00', subject: 'CC 207B Apps Development'),
  ClassSlot(day: 'Tue', time: '7:00-9:00', subject: 'CIT 210 Web Systems'),
  ClassSlot(
    day: 'Tue',
    time: '11:30-1:00',
    subject: 'BA 234 Technopreneurship',
  ),
  ClassSlot(day: 'Tue', time: '1:00-2:30', subject: 'CC 208 Research Methods'),
  ClassSlot(day: 'Tue', time: '3:00-6:00', subject: 'CIT 213 HCI 2'),
  ClassSlot(
    day: 'Wed',
    time: '10:00-12:00',
    subject: 'CIT 246 IT Project Management',
  ),
  ClassSlot(day: 'Wed', time: '1:00-4:00', subject: 'CIT 212 Networking 2'),
  ClassSlot(day: 'Wed', time: '4:00-6:00', subject: 'CC 207B Apps Development'),
  ClassSlot(day: 'Thu', time: '7:00-9:00', subject: 'CIT 210 Web Systems'),
  ClassSlot(
    day: 'Thu',
    time: '11:30-1:00',
    subject: 'BA 234 Technopreneurship',
  ),
  ClassSlot(day: 'Thu', time: '1:00-2:30', subject: 'CC 208 Research Methods'),
  ClassSlot(day: 'Thu', time: '4:00-6:00', subject: 'CIT 213 HCI 2'),
];

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label),
      subtitle: Text(info.value),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile and Pet',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
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
          // Update the selected tab so the matching screen is displayed.
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'My Pet'),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark),
            label: 'Shelf',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Moses John Hermosura')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 104,
                    height: 104,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Moses John Hermosura',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moses John Hermosura',
                        style: textTheme.headlineSmall,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sagad mag standing sa modern jeep',
                          maxLines: 1,
                          softWrap: false,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final info in infos) InfoTile(info: info),
            SizedBox(
              width: double.infinity,
              child: Card(
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
                      "I am Moses, 20, and currently a 3rd Year BSIT student at West Visayas State University. I enjoy going to school, especially after midterms, since it's the time of the school year when all we do is check papers and do nothing. I love watching movies and playing with my cats. I love all my cats, but I want to highlight Tilap because she is an orphan. I hope my program brings me success in the future so my cats and I can live comfortably.",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Class Schedule', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Table(
                        border: TableBorder.all(color: colors.outline),
                        columnWidths: const {
                          0: FixedColumnWidth(48),
                          1: FixedColumnWidth(92),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                            ),
                            children: const [
                              ScheduleCell('Day', bold: true),
                              ScheduleCell('Time', bold: true),
                              ScheduleCell('Subject', bold: true),
                            ],
                          ),
                          for (final slot in schedule)
                            TableRow(
                              children: [
                                ScheduleCell(slot.day),
                                ScheduleCell(slot.time),
                                ScheduleCell(slot.subject),
                              ],
                            ),
                        ],
                      ),
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

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  bool _showHeart = false;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/meow.mp3'));
    } catch (error) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
      debugPrint('Failed to play Tilap\'s meow: $error');
    }
  }

  Future<void> _confirmReset() async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Tilap has meowed $_playCount times. Start again from zero?',
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
    if (ok == true && mounted) {
      setState(() => _playCount = 0);
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      _showHeart = !_showHeart;
                    });
                  },
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/cat.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Tilap, my cat',
                          ),
                        ),
                        if (_showHeart)
                          Center(
                            child: Icon(
                              Icons.favorite,
                              size: 72,
                              color: theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tilap is my pet cat',
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play meow'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Tilap has meowed $_playCount times.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmReset,
                child: const Text('Reset count'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'IVOS Zild shot by me',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'IVOS Zild shot by me again',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'IVOS Zild shot by me yet again',
  ),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'IVOS Zild again'),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'IVOS Zild again?!',
  ),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'IVOS, shot by me'),
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
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.cover,
                  semanticLabel: photo.caption,
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

class ScheduleCell extends StatelessWidget {
  const ScheduleCell(this.text, {super.key, this.bold = false});

  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall
            ?.copyWith(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(children: [PicksTab(), BooksTab(), MoviesTab()]),
      ),
    );
  }
}

class ApiException implements Exception {
  ApiException(this.message);

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

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;
    return [for (final doc in docs) Book.fromJson(doc as Map<String, dynamic>)];
  }
}

/// A cover or poster. Shows an icon when there is no URL or it fails to load.
class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.icon,
    required this.label,
  });

  final String? url;
  final double width;
  final double height;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final placeholder = SizedBox(
      width: width,
      height: height,
      child: Icon(icon, size: width * 0.7),
    );
    if (url == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        semanticLabel: label,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final OpenLibraryApi api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = api.search(query);
      });
    });
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search books, e.g. hobbit',
              border: OutlineInputBorder(),
            ),
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
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Something went wrong: ${snapshot.error}',
                          ),
                        ),
                      );
                    }
                    final books = snapshot.data!;
                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final subtitle = [
                          if (book.authors.isNotEmpty) book.authors.first,
                          if (book.year != null) '${book.year}',
                        ].join(' · ');
                        return ListTile(
                          leading: CoverImage(
                            url: book.coverId == null
                                ? null
                                : 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                            width: 40,
                            height: 56,
                            icon: Icons.menu_book,
                            label: 'Cover of ${book.title}',
                          ),
                          title: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(subtitle),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy ID',
                            onPressed: () => _copyId(book.workId),
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

// Passed with --dart-define-from-file, never written in the code.
const omdbKey = String.fromEnvironment('OMDB_KEY');

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
      // OMDb says "N/A" when there is no poster.
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class OmdbApi {
  OmdbApi({this.key = omdbKey});

  final String key;

  Future<List<Movie>> search(String query) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': key,
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('OMDb error ${response.statusCode}');
    }
    if (response.statusCode == 401) {
      throw ApiException(
        'OMDb rejected the API key (401). Activate it from the email link, then restart the app.',
      );
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const []; // empty, not an error
      throw ApiException(error); // e.g. "Invalid API key!"
    }
    final results = json['Search'] as List<dynamic>;
    return [
      for (final item in results) Movie.fromJson(item as Map<String, dynamic>),
    ];
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = api.search(query);
      });
    });
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No OMDb key yet. Run the app with:\n\n'
            'flutter run --dart-define=OMDB_KEY=your-key',
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
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search movies, e.g. interstellar',
              border: OutlineInputBorder(),
            ),
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
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Something went wrong: ${snapshot.error}',
                          ),
                        ),
                      );
                    }
                    final movies = snapshot.data!;
                    if (movies.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: CoverImage(
                            url: movie.poster,
                            width: 40,
                            height: 56,
                            icon: Icons.movie,
                            label: 'Poster of ${movie.title}',
                          ),
                          title: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy ID',
                            onPressed: () => _copyId(movie.imdbId),
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

// Passed with --dart-define-from-file, never written in the code.
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

/// A problem the user should read: no internet, wrong token, and so on.
class CmsException implements Exception {
  const CmsException(this.message);

  final String message;

  @override
  String toString() => message;
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
  final String kind; // 'book' or 'movie'
  final String externalId;
  final String note;

  bool get isBook => kind == 'book';
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  ContentfulPickSource(
    this.client, {
    required this.spaceId,
    required this.token,
    this.environment = 'master',
  });

  final http.Client client;
  final String spaceId;
  final String token; // the read-only Delivery token, never the Management one
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    if (spaceId.isEmpty || token.isEmpty) {
      throw const CmsException(
        'Contentful is not set up. Run the app with --dart-define-from-file '
        'pointing to your secrets file.',
      );
    }
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {'content_type': 'pick', 'order': 'sys.createdAt', 'limit': '100'},
    );
    final http.Response response;
    try {
      response = await client
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const CmsException(
        'Contentful took too long to answer. Try again.',
      );
    } on http.ClientException {
      throw const CmsException(
        'No connection. Check your internet and try again.',
      );
    }
    final code = response.statusCode;
    switch (code) {
      case 200:
        break;
      case 401 || 403:
        throw CmsException(
          'Contentful refused the request ($code). Check your token and the read permission.',
        );
      case 404:
        throw const CmsException(
          'Contentful could not find the picks (404). Check the space ID and the content type name.',
        );
      case >= 500:
        throw CmsException(
          'Contentful is having problems ($code). Try again later.',
        );
      default:
        throw CmsException('Contentful answered $code.');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items.map((item) {
      final fields = item['fields'] as Map<String, dynamic>;
      final sys = item['sys'] as Map<String, dynamic>;
      return Pick(
        id: sys['id'] as String,
        title: fields['title'] as String? ?? '',
        kind: fields['kind'] as String? ?? '',
        externalId: fields['externalId'] as String? ?? '',
        note: fields['note'] as String? ?? '',
      );
    }).toList();
  }
}

class PicksTab extends StatefulWidget {
  const PicksTab({super.key, this.source});

  /// Tests pass a fake source. The app uses Contentful.
  final PickSource? source;

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab> {
  late final PickSource _source;
  late Future<List<Pick>> _picks;

  @override
  void initState() {
    super.initState();
    _source =
        widget.source ??
        ContentfulPickSource(http.Client(), spaceId: cmsSpace, token: cmsToken);
    _picks = _source.fetchPicks(); // starts here, not in build()
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() {
      _picks = next;
    });
    try {
      await next;
    } catch (_) {
      // The FutureBuilder shows the error.
    }
  }

  Widget _scrollable(List<Widget> children) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: children,
  );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picks,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _scrollable(const [
              SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              ),
            ]);
          }
          if (snapshot.hasError) {
            return _scrollable([
              const SizedBox(height: 48),
              const Icon(Icons.cloud_off, size: 48),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('${snapshot.error}', textAlign: TextAlign.center),
              ),
              Center(
                child: FilledButton(
                  onPressed: _refresh,
                  child: const Text('Try again'),
                ),
              ),
            ]);
          }
          final picks = snapshot.data!;
          if (picks.isEmpty) {
            return _scrollable(const [
              SizedBox(
                height: 240,
                child: Center(child: Text('No picks yet.')),
              ),
            ]);
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
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
                  MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PickDetails {
  const PickDetails({this.imageUrl, this.year, required this.summary});
  final String? imageUrl;
  final String? year;
  final String summary;
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});
  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<PickDetails> _details;

  @override
  void initState() {
    super.initState();
    _details = widget.pick.isBook ? _loadBook() : _loadMovie();
  }

  Future<PickDetails> _loadBook() async {
    final response = await http.get(
      Uri.https('openlibrary.org', '/works/${widget.pick.externalId}.json'),
    );
    if (response.statusCode != 200) {
      throw ApiException('Open Library error ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = (json['covers'] as List<dynamic>?)
        ?.whereType<int>()
        .where((c) => c > 0)
        .toList();
    return PickDetails(
      imageUrl: (covers == null || covers.isEmpty)
          ? null
          : 'https://covers.openlibrary.org/b/id/${covers.first}-M.jpg',
      year: json['first_publish_date'] as String?,
      summary: description,
    );
  }

  Future<PickDetails> _loadMovie() async {
    if (omdbKey.isEmpty) {
      throw ApiException('OMDB_KEY is empty. Run with --dart-define-from-file.');
    }
    final response = await http.get(
      Uri.https('www.omdbapi.com', '/', {
        'apikey': omdbKey,
        'i': widget.pick.externalId,
        'plot': 'short',
      }),
    );
    if (response.statusCode != 200) {
      throw ApiException('OMDb error ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    final poster = json['Poster'] as String?;
    return PickDetails(
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      year: json['Year'] as String?,
      summary: (json['Plot'] as String?) ?? 'No description yet.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<PickDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load details.\n${snapshot.error}'),
              ),
            );
          }
          final d = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: d.imageUrl == null
                    ? Icon(
                        pick.isBook ? Icons.menu_book : Icons.movie,
                        size: 96,
                      )
                    : Image.network(
                        d.imageUrl!,
                        height: 240,
                        errorBuilder: (_, _, _) => Icon(
                          pick.isBook ? Icons.menu_book : Icons.movie,
                          size: 96,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Text(pick.title, style: Theme.of(context).textTheme.headlineSmall),
              Text(
                '${pick.isBook ? 'Book' : 'Movie'}'
                '${d.year == null ? '' : ' · ${d.year}'}',
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('Why I recommend it'),
                  subtitle: Text(pick.note),
                ),
              ),
              const SizedBox(height: 16),
              Text(d.summary),
            ],
          );
        },
      ),
    );
  }
}