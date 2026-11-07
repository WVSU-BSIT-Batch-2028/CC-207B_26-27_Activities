import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String omdbKey = String.fromEnvironment('OMDB_KEY');
const String cmsUrl = String.fromEnvironment('CMS_URL');

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daniella Dayrit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9EAD6D),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const ProfileHomePage(),
    );
  }
}

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  int _selectedPage = 0;
  bool _isPlaying = false;
  bool _isLiked = false;
  int _barkCount = 0;
  final AudioPlayer _player = AudioPlayer();

  static const _ink = Color(0xFF25251F);
  static const _muted = Color(0xFF77776F);
  static const _sage = Color(0xFF9EAD6D);
  static const _softSage = Color(0xFFF1F4E9);

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
    if (_isPlaying) return;
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });
    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _resetCount() async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('This will set Cookie\'s bark count back to zero.'),
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
    if (reset == true && mounted) setState(() => _barkCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildProfilePage(),
      _buildPetPage(),
      const GalleryScreen(),
      const ShelfScreen(),
    ];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedPage, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPage,
        onDestinationSelected: (index) => setState(() => _selectedPage = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'My profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Cookie',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Shelf',
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset('assets/images/myprofile.jpeg', width: 112, height: 132, fit: BoxFit.cover),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daniella\nDayrit', style: TextStyle(color: _ink, fontSize: 29, height: 1.02, fontWeight: FontWeight.w700)),
                    SizedBox(height: 12),
                    Text('BS Information Technology', style: TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Antique, Philippines', style: TextStyle(color: _muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _infoBanner(),
          const SizedBox(height: 26),
          _sectionTitle('About me'),
          const SizedBox(height: 12),
          const Text(
            'I’m Daniella, a student from Antique pursuing a Bachelor of Science in Information Technology at West Visayas State University – College of Information and Communications Technology. I enjoy getting involved in organizations and finding creative ways to learn.',
            style: TextStyle(color: _muted, fontSize: 13, height: 1.65),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Personal details'),
          const SizedBox(height: 12),
          _detailRow(Icons.email_outlined, 'Email', 'daniella.dayrit@wvsu.edu.ph'),
          _detailRow(Icons.phone_outlined, 'Phone', '09362000895'),
          _detailRow(Icons.school_outlined, 'Education', 'WVSU – College of Information and Communications Technology'),
          _detailRow(Icons.menu_book_outlined, 'Course', 'BS Information Technology'),
          const SizedBox(height: 18),
          _hobbiesCard(),
          const SizedBox(height: 18),
          _scheduleCard(),
        ],
      ),
    );
  }

  Widget _infoBanner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: _softSage, borderRadius: BorderRadius.circular(16)),
        child: const Row(
          children: [
            Icon(Icons.cake_outlined, size: 18, color: _ink),
            SizedBox(width: 10),
            Text('BIRTHDAY', style: TextStyle(color: _muted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .7)),
            Spacer(),
            Text('March 9, 2006', style: TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _hobbiesCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('My Hobbies', icon: Icons.auto_awesome_outlined),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(avatar: Icon(Icons.mic_none), label: Text('Singing')),
                  Chip(avatar: Icon(Icons.music_note), label: Text('Dancing')),
                  Chip(avatar: Icon(Icons.bedtime_outlined), label: Text('Sleeping')),
                  Chip(avatar: Icon(Icons.camera_alt_outlined), label: Text('Photography')),
                  Chip(avatar: Icon(Icons.menu_book), label: Text('Reading')),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _scheduleCard() {
    const slots = [
      ClassSlot('Monday', '8:00 AM', 'Mobile App Development'),
      ClassSlot('Tuesday', '10:00 AM', 'Database Management'),
      ClassSlot('Wednesday', '1:00 PM', 'Web Systems and Technologies'),
      ClassSlot('Thursday', '3:00 PM', 'Information Assurance'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('My Class Schedule', icon: Icons.calendar_month_outlined),
            const SizedBox(height: 14),
            Table(
              border: TableBorder.all(color: Colors.black12),
              columnWidths: const {0: FixedColumnWidth(78), 1: FixedColumnWidth(78), 2: FlexColumnWidth()},
              children: [
                _scheduleRow('Day', 'Time', 'Subject', header: true),
                for (final slot in slots) _scheduleRow(slot.day, slot.time, slot.subject),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _scheduleRow(String day, String time, String subject, {bool header = false}) => TableRow(
        decoration: header ? BoxDecoration(color: ThemeData().colorScheme.primaryContainer) : null,
        children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(day, style: TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal))),
          Padding(padding: const EdgeInsets.all(8), child: Text(time, style: TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal))),
          Padding(padding: const EdgeInsets.all(8), child: Text(subject, style: TextStyle(fontWeight: header ? FontWeight.bold : FontWeight.normal))),
        ],
      );

  Widget _buildPetPage() => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('A place in my heart', style: TextStyle(color: _muted, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Cookie', style: TextStyle(color: _ink, fontSize: 34, fontWeight: FontWeight.w700)),
            const SizedBox(height: 18),
            GestureDetector(
              onDoubleTap: () => setState(() => _isLiked = !_isLiked),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(width: double.infinity, height: 290, color: const Color(0xFFF8F6F1), child: Image.asset('assets/images/mypet.png', fit: BoxFit.contain)),
                  ),
                  if (_isLiked) const Icon(Icons.favorite, color: Colors.pink, size: 68),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(onPressed: _isPlaying ? null : _playSound, icon: const Icon(Icons.volume_up_outlined), label: Text(_isPlaying ? 'Playing...' : 'Play bark')),
            const SizedBox(height: 14),
            Text('Cookie has barked $_barkCount time${_barkCount == 1 ? '' : 's'}.', style: const TextStyle(color: _ink, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _barkCount == 0 ? null : _resetCount,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset count'),
            ),
            const SizedBox(height: 22),
            _sectionTitle('My sweet Cookie'),
            const SizedBox(height: 12),
            const Text('Cookie was a sweet and lovable Aspin who brought so much happiness and love into my life. Cookie was more than just a pet: Cookie was family, a source of comfort, and a precious companion.', style: TextStyle(color: _muted, fontSize: 14, height: 1.7)),
          ],
        ),
      );

  Widget _sectionTitle(String title, {IconData? icon}) => Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 19, color: _sage), const SizedBox(width: 8)],
          Text(title, style: const TextStyle(color: _ink, fontSize: 19, fontWeight: FontWeight.w700)),
        ],
      );

  Widget _detailRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 19, color: _sage),
            const SizedBox(width: 12),
            SizedBox(width: 76, child: Text(label, style: const TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w600))),
            Expanded(child: Text(value, style: const TextStyle(color: _ink, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500))),
          ],
        ),
      );
}

class Photo {
  const Photo({required this.asset, required this.caption});
  final String asset;
  final String caption;
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const photos = [
    Photo(asset: 'assets/images/gallery/beach.jpeg', caption: 'Beach day'),
    Photo(asset: 'assets/images/gallery/cafe.jpeg', caption: 'Cafe memory'),
    Photo(asset: 'assets/images/gallery/cookie.png', caption: 'Cookie'),
    Photo(asset: 'assets/images/gallery/firstdogs.jpeg', caption: 'My first dogs'),
    Photo(asset: 'assets/images/gallery/parangal.jpeg', caption: 'Parangal'),
    Photo(asset: 'assets/images/gallery/profile.jpeg', caption: 'My profile'),
  ];

  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
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
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(photo.asset, fit: BoxFit.cover, semanticLabel: photo.caption),
                  ),
                  if (_favoriteAsset == photo.asset)
                    const Positioned(top: 8, right: 8, child: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.star, color: Colors.amber))),
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
          children: [
            Expanded(child: Center(child: Image.asset(photo.asset, fit: BoxFit.contain, semanticLabel: photo.caption))),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.pop(context, true), icon: const Icon(Icons.star), label: const Text('Make favorite'))),
          ],
        ),
      ),
    );
  }
}

class ClassSlot {
  const ClassSlot(this.day, this.time, this.subject);
  final String day;
  final String time;
  final String subject;
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
    this.authors = const [],
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final rawAuthors = json['author_name'] as List<dynamic>? ?? const [];
    final keyValue = (json['key'] as String?) ?? '';

    return Book(
      workId: keyValue.split('/').last,
      title: (json['title'] as String?) ?? 'Untitled',
      authors: rawAuthors.map((value) => value.toString()).toList(),
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  String get authorText => authors.isEmpty ? 'Unknown author' : authors.first;
  String get coverUrl => coverId == null ? '' : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final safeQuery = query.trim();
    if (safeQuery.length < 3) return const [];

    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': safeQuery,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library request failed with ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = decoded['docs'] as List<dynamic>? ?? const [];
    return docs
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Book> fetchById(String id) async {
    final uri = Uri.https('openlibrary.org', '/works/$id.json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library request failed with ${response.statusCode}.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final covers = json['covers'] as List<dynamic>? ?? const [];
    return Book(
      workId: id,
      title: (json['title'] as String?) ?? 'Untitled',
      authors: (json['authors'] as List<dynamic>? ?? const [])
          .map((item) => (item['author']?['key'] ?? '').toString())
          .where((item) => item.isNotEmpty)
          .toList(),
      year: json['first_publish_year'] as int?,
      coverId: covers.isEmpty ? null : int.tryParse(covers.first.toString()),
    );
  }
}

class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    this.year,
    this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: (json['imdbID'] as String?) ?? '',
      title: (json['Title'] as String?) ?? 'Untitled',
      year: (json['Year'] as String?) ?? 'Unknown year',
      poster: (json['Poster'] as String?) ?? '',
    );
  }

  final String imdbId;
  final String title;
  final String? year;
  final String? poster;

  bool get hasPoster => poster != null && poster!.isNotEmpty && poster != 'N/A';
}

class OmdbApi {
  const OmdbApi();

  Future<List<Movie>> search(String query) async {
    if (omdbKey.isEmpty) {
      throw const ApiException('Add --dart-define=OMDB_KEY=your-key to enable movie searches.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      's': query,
      'type': 'movie',
    });

    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw ApiException('OMDb request failed with ${response.statusCode}.');
    }
    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }

    final searchResults = json['Search'] as List<dynamic>? ?? const [];
    return searchResults
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Movie> fetchById(String id) async {
    if (omdbKey.isEmpty) {
      throw const ApiException('Add --dart-define=OMDB_KEY=your-key to enable movie details.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbKey,
      'i': id,
      'plot': 'short',
    });

    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw ApiException('OMDb request failed with ${response.statusCode}.');
    }
    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'Movie not found');
    }

    return Movie.fromJson(json);
  }
}

enum PickKind { book, movie }

class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final rawKind = (json['kind'] as String? ?? '').toLowerCase();
    return Pick(
      id: (json['id'] ?? json['_id'] ?? json['documentId'] ?? '').toString(),
      title: (json['title'] as String?) ?? 'Untitled',
      kind: rawKind == 'movie' ? PickKind.movie : PickKind.book,
      externalId: (json['externalId'] as String?) ?? '',
      note: (json['note'] as String?) ?? '',
    );
  }

  final String id;
  final String title;
  final PickKind kind;
  final String externalId;
  final String note;
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class DemoPickSource implements PickSource {
  const DemoPickSource();

  @override
  Future<List<Pick>> fetchPicks() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const [
      Pick(
        id: 'demo-book-1',
        title: 'The Hobbit',
        kind: PickKind.book,
        externalId: 'OL27482W',
        note: 'A charming story of adventure, courage, and friendship that still inspires me.',
      ),
      Pick(
        id: 'demo-book-2',
        title: 'Pride and Prejudice',
        kind: PickKind.book,
        externalId: 'OL82574W',
        note: 'Sharp, witty, and timeless — this classic still feels fresh and clever.',
      ),
      Pick(
        id: 'demo-movie-1',
        title: 'How to Lose a Guy in 10 Days',
        kind: PickKind.movie,
        externalId: 'tt0457939',
        note: 'A fun, romantic comedy with playful chemistry and a very memorable storyline.',
      ),
      Pick(
        id: 'demo-movie-2',
        title: 'Tangled',
        kind: PickKind.movie,
        externalId: 'tt0398286',
        note: 'A colorful, charming fairy-tale adventure with heart, humor, and great music.',
      ),
    ];
  }
}

class CmsPickSource implements PickSource {
  CmsPickSource({required this.baseUrl}) : assert(baseUrl.isNotEmpty);

  final String baseUrl;

  @override
  Future<List<Pick>> fetchPicks() async {
    final url = baseUrl.trimRight();
    final uri = Uri.parse('${url.endsWith('/') ? url : '$url/'}picks');
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw ApiException('CMS request failed with ${response.statusCode}.');
    }

    final dynamic decoded = jsonDecode(response.body);
    final rows = switch (decoded) {
      final List list => list,
      final Map map when map['data'] is List => map['data'],
      final Map map when map['picks'] is List => map['picks'],
      _ => const <dynamic>[],
    };

    return rows
        .map((item) => Pick.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: 'My Picks'),
            Tab(text: 'Books'),
            Tab(text: 'Movies'),
          ],
        ),
        body: TabBarView(
          children: [
            MyPicksTab(),
            BookSearchTab(),
            MovieSearchTab(),
          ],
        ),
      ),
    );
  }
}

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  PickSource get source => cmsUrl.isEmpty ? const DemoPickSource() : CmsPickSource(baseUrl: cmsUrl);
  List<Pick> _picks = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  Future<void> _loadPicks() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final picks = await source.fetchPicks();
      if (!mounted) return;
      setState(() {
        _picks = picks;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPicks,
      child: ListView.builder(
        itemCount: _picks.length,
        itemBuilder: (context, index) {
          final pick = _picks[index];
          final isBook = pick.kind == PickKind.book;
          return ListTile(
            leading: CircleAvatar(
              child: Icon(isBook ? Icons.book : Icons.movie),
            ),
            title: Text(pick.title),
            subtitle: Text(pick.note),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
            ),
          );
        },
      ),
    );
  }
}

class BookSearchTab extends StatefulWidget {
  const BookSearchTab({super.key});

  @override
  State<BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends State<BookSearchTab> {
  final OpenLibraryApi _api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      setState(() => _results = Future.value(const []));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _results = _api.search(query));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Search books by title',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _results,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final books = snapshot.data ?? const [];
                if (books.isEmpty) {
                  return const Center(child: Text('Nothing found'));
                }

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      leading: book.coverId == null
                          ? const CircleAvatar(child: Icon(Icons.book_outlined))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                book.coverUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              ),
                            ),
                      title: Text(book.title),
                      subtitle: Text('${book.authorText} • ${book.year ?? 'Unknown year'}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: book.workId));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Copied ${book.workId}')),
                            );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSearchTab extends StatefulWidget {
  const MovieSearchTab({super.key});

  @override
  State<MovieSearchTab> createState() => _MovieSearchTabState();
}

class _MovieSearchTabState extends State<MovieSearchTab> {
  final OmdbApi _api = const OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      setState(() => _results = Future.value(const []));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _results = _api.search(query));
    });
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
          padding: EdgeInsets.all(18),
          child: Text(
            'Add --dart-define=OMDB_KEY=your-key to enable movie searches.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Search movies by title',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _results,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final movies = snapshot.data ?? const [];
                if (movies.isEmpty) {
                  return const Center(child: Text('Nothing found'));
                }

                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      leading: movie.hasPoster
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie.poster!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              ),
                            )
                          : const CircleAvatar(child: Icon(Icons.movie_outlined)),
                      title: Text(movie.title),
                      subtitle: Text(movie.year ?? 'Unknown year'),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: movie.imdbId));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Copied ${movie.imdbId}')),
                            );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
  late final Future<Map<String, dynamic>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  Future<Map<String, dynamic>> _loadDetail() async {
    if (widget.pick.kind == PickKind.book) {
      final bookDetailUri = Uri.https('openlibrary.org', '/works/${widget.pick.externalId}.json');
      final response = await http.get(bookDetailUri);
      if (response.statusCode != 200) {
        throw ApiException('Open Library detail request failed with ${response.statusCode}.');
      }

      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final description = switch (jsonMap['description']) {
        final String text => text,
        final Map map when map['value'] is String => map['value'] as String,
        _ => 'No description yet.',
      };

      final coverId = (jsonMap['covers'] as List<dynamic>? ?? const []).firstOrNull;
      return {
        'title': (jsonMap['title'] as String?) ?? widget.pick.title,
        'image': coverId == null ? null : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
        'summary': description,
        'note': widget.pick.note,
      };
    }

    final movie = await const OmdbApi().fetchById(widget.pick.externalId);
    return {
      'title': movie.title,
      'image': movie.hasPoster ? movie.poster : null,
      'summary': 'No summary yet.',
      'note': widget.pick.note,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final detail = snapshot.data ?? {};
          final image = detail['image'] as String?;
          final title = detail['title'] as String? ?? widget.pick.title;
          final summary = detail['summary'] as String? ?? 'No description yet.';
          final note = detail['note'] as String? ?? widget.pick.note;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 260,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.image_not_supported, size: 80),
                  ),
                const SizedBox(height: 20),
                Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text('Your note', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(note, style: const TextStyle(height: 1.6)),
                const SizedBox(height: 20),
                Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(summary, style: const TextStyle(height: 1.6)),
              ],
            ),
          );
        },
      ),
    );
  }
}
