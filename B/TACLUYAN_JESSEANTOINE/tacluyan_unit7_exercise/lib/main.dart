import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String studentName = 'Your Full Name';
const String petName = 'Your Pet Name';
const String animalDescription = 'This is my pet.';

const String yearAndSection = 'Your Year and Section';
const String favoriteGame = 'Your favorite game';
const String favoriteFood = 'Your favorite food';

const String omdbKey = String.fromEnvironment('OMDB_KEY');
const String cmsUrl = String.fromEnvironment(
  'CMS_URL',
  defaultValue: 'http://localhost:1337',
);

const List<String> hobbies = [
  'Gaming',
  'Coding',
  'Listening to music',
  'Watching movies',
  'Exploring technology',
];

const List<ClassSlot> classSlots = [
  ClassSlot(day: 'Monday', time: '8:00–10:00 AM', subject: 'Networking 1'),
  ClassSlot(day: 'Tuesday', time: '10:00 AM–12:00 PM', subject: 'Programming'),
  ClassSlot(day: 'Wednesday', time: '1:00–3:00 PM', subject: 'Database'),
  ClassSlot(day: 'Thursday', time: '8:00–10:00 AM', subject: 'Web Development'),
];

void main() {
  runApp(const ProfilePetApp());
}

class ProfilePetApp extends StatelessWidget {
  const ProfilePetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            icon: Icon(Icons.bookmarks_outlined),
            selectedIcon: Icon(Icons.bookmarks),
            label: 'Shelf',
          ),
        ],
      ),
    );
  }
}

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

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
}

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(info.icon, color: theme.colorScheme.primary),
      title: Text(info.label, style: theme.textTheme.labelLarge),
      subtitle: Text(info.value, style: theme.textTheme.bodyMedium),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<ProfileInfo> infos = [
    ProfileInfo(icon: Icons.school_outlined, label: 'Course', value: 'BSIT'),
    ProfileInfo(
      icon: Icons.groups_outlined,
      label: 'Year and Section',
      value: yearAndSection,
    ),
    ProfileInfo(
      icon: Icons.sports_esports,
      label: 'Favorite Game',
      value: favoriteGame,
    ),
    ProfileInfo(
      icon: Icons.restaurant_outlined,
      label: 'Favorite Food',
      value: favoriteFood,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(studentName)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/my_photo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of $studentName',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BSIT student who enjoys learning new things.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final info in infos) InfoTile(info: info),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Biography', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'I am a BSIT student who enjoys learning about '
                        'technology, playing games, and exploring new skills. '
                        'I hope to improve my programming abilities and create '
                        'useful applications.',
                        style: theme.textTheme.bodyMedium,
                      ),
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
                      Text('My Hobbies', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
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
                        columnWidths: const {
                          0: FixedColumnWidth(76),
                          1: FixedColumnWidth(112),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                            ),
                            children: [
                              _scheduleCell('Day', theme, isHeader: true),
                              _scheduleCell('Time', theme, isHeader: true),
                              _scheduleCell('Subject', theme, isHeader: true),
                            ],
                          ),
                          for (final slot in classSlots)
                            TableRow(
                              children: [
                                _scheduleCell(slot.day, theme),
                                _scheduleCell(slot.time, theme),
                                _scheduleCell(slot.subject, theme),
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
        ),
      ),
    );
  }

  static Widget _scheduleCell(
    String value,
    ThemeData theme, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        value,
        style: isHeader
            ? theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodySmall,
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
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
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
      _playCount++;
    });

    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    }
  }

  Future<void> _confirmResetCount() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: const Text('Are you sure you want to reset the count to 0?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (answer == true && mounted) {
      setState(() => _playCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Meet $petName',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                animalDescription,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Semantics(
                image: true,
                label: 'Photo of $petName.',
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() => _showHeart = !_showHeart);
                  },
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/my_pet.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of $petName',
                          ),
                          if (_showHeart)
                            Center(
                              child: Icon(
                                Icons.favorite,
                                size: 72,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? 'Playing...' : 'Play $petName sound'),
              ),
              const SizedBox(height: 12),
              Text(
                '$petName sound played $_playCount '
                '${_playCount == 1 ? 'time' : 'times'}.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmResetCount,
                child: const Text('Reset count'),
              ),
              const SizedBox(height: 8),
              Text(
                'Double-tap the photo to show or hide the heart.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  static const List<Photo> photos = [
    Photo(
      asset: 'assets/images/gallery/gallery_01.jpg',
      caption: 'Tropical Beach',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_02.jpg',
      caption: 'Forest Path',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_03.jpg',
      caption: 'Sunset Hills',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_04.jpg',
      caption: 'Wildflowers',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_05.jpg',
      caption: 'Mountain Lake',
    ),
    Photo(
      asset: 'assets/images/gallery/gallery_06.jpg',
      caption: 'City Lights',
    ),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  Widget _buildPhotoTile(Photo photo) {
    final bool isFavorite = _favoriteAsset == photo.asset;

    return InkWell(
      onTap: () => _open(photo),
      borderRadius: BorderRadius.circular(12),
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
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.58),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                photo.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isFavorite)
            Positioned(
              top: 6,
              right: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.star, color: Colors.amber, size: 22),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos) _buildPhotoTile(photo),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                    width: double.infinity,
                  ),
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

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    required this.year,
    required this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final rawKey = json['key'] as String? ?? '';
    final rawAuthors = json['author_name'];
    final authors = rawAuthors is List
        ? rawAuthors.whereType<String>().toList()
        : <String>[];
    final rawYear = json['first_publish_year'];
    final rawCover = json['cover_i'];

    return Book(
      workId: rawKey.split('/').last,
      title: json['title'] as String? ?? 'Untitled book',
      authors: authors,
      year: rawYear is int ? rawYear : int.tryParse('$rawYear'),
      coverId: rawCover is int ? rawCover : int.tryParse('$rawCover'),
    );
  }
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final rawPoster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'Untitled movie',
      year: json['Year'] as String? ?? 'Year unavailable',
      poster: rawPoster == null || rawPoster == 'N/A' ? null : rawPoster,
    );
  }
}

class MediaDetails {
  final String title;
  final String year;
  final String summary;
  final String? imageUrl;

  const MediaDetails({
    required this.title,
    required this.year,
    required this.summary,
    required this.imageUrl,
  });
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
      throw ApiException('Open Library request failed (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'];
    if (docs is! List) return const [];

    return docs
        .whereType<Map>()
        .map((item) => Book.fromJson(Map<String, dynamic>.from(item)))
        .where((book) => book.workId.isNotEmpty)
        .toList();
  }

  Future<MediaDetails> details(String workId) async {
    final response = await http.get(
      Uri.https('openlibrary.org', '/works/$workId.json'),
    );

    if (response.statusCode != 200) {
      throw ApiException('Open Library details failed (${response.statusCode}).');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final summary = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    final covers = json['covers'];
    final coverId = covers is List && covers.isNotEmpty && covers.first is int
        ? covers.first as int
        : null;
    final firstPublishDate = json['first_publish_date'] as String? ?? '';
    final yearMatch = RegExp(r'\b(1[0-9]{3}|20[0-9]{2})\b').firstMatch(firstPublishDate);

    return MediaDetails(
      title: json['title'] as String? ?? 'Book details',
      year: yearMatch?.group(0) ?? 'Year unavailable',
      summary: summary,
      imageUrl: coverId == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
    );
  }
}

class OmdbApi {
  final String apiKey;

  const OmdbApi(this.apiKey);

  Map<String, dynamic> _decodeResponse(http.Response response, String action) {
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        json = decoded;
      } else if (decoded is Map) {
        json = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      json = null;
    }

    if (response.statusCode != 200) {
      final message = json?['Error'] as String?;
      throw ApiException(
        message ?? 'OMDb $action failed (${response.statusCode}).',
      );
    }

    if (json == null) {
      throw ApiException('OMDb returned an unreadable response for $action.');
    }

    return json;
  }

  Future<List<Movie>> search(String query) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Add your key in omdb-key.txt and run RUN_UNIT7_EXERCISE.cmd.',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey.trim(),
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    final json = _decodeResponse(response, 'search');

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }

    final results = json['Search'];
    if (results is! List) return const [];
    return results
        .whereType<Map>()
        .map((item) => Movie.fromJson(Map<String, dynamic>.from(item)))
        .where((movie) => movie.imdbId.isNotEmpty)
        .toList();
  }

  Future<MediaDetails> details(String imdbId) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Add your key in omdb-key.txt and run RUN_UNIT7_EXERCISE.cmd.',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey.trim(),
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    final json = _decodeResponse(response, 'details');

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }

    final rawPoster = json['Poster'] as String?;
    return MediaDetails(
      title: json['Title'] as String? ?? 'Movie details',
      year: json['Year'] as String? ?? 'Year unavailable',
      summary: json['Plot'] as String? ?? 'No summary available.',
      imageUrl: rawPoster == null || rawPoster == 'N/A' ? null : rawPoster,
    );
  }
}

class Pick {
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final source = json['attributes'] is Map
        ? Map<String, dynamic>.from(json['attributes'] as Map)
        : json;
    return Pick(
      title: source['title'] as String? ?? 'Untitled pick',
      kind: source['kind'] as String? ?? 'book',
      externalId: source['externalId'] as String? ?? '',
      note: source['note'] as String? ?? '',
    );
  }
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class StrapiPickSource implements PickSource {
  final String baseUrl;

  const StrapiPickSource(this.baseUrl);

  @override
  Future<List<Pick>> fetchPicks() async {
    final root = baseUrl.replaceFirst(RegExp(r'/$'), '');
    final uri = Uri.parse('$root/api/picks').replace(
      queryParameters: {'pagination[pageSize]': '100'},
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException('Strapi request failed (${response.statusCode}). Check that Strapi is running and Public > Pick > find is enabled.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'];
    if (data is! List) return const [];

    final picks = data
        .whereType<Map>()
        .map((item) => Pick.fromJson(Map<String, dynamic>.from(item)))
        .where((pick) => pick.externalId.isNotEmpty)
        .toList();
    picks.sort((a, b) => a.title.compareTo(b.title));
    return picks;
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
              Tab(text: 'My Picks', icon: Icon(Icons.favorite_outline)),
              Tab(text: 'Books', icon: Icon(Icons.menu_book)),
              Tab(text: 'Movies', icon: Icon(Icons.movie_outlined)),
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

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final PickSource _source = const StrapiPickSource(cmsUrl);
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    _future = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() => _future = next);
    try {
      await next;
    } catch (_) {}
  }

  void _openPick(Pick pick) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(Icons.error_outline, size: 42),
                const SizedBox(height: 12),
                Text('${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text('Pull down to try again.', textAlign: TextAlign.center),
              ],
            );
          }
          final picks = snapshot.data ?? const <Pick>[];
          if (picks.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: const [
                SizedBox(height: 100),
                Center(child: Text('No picks yet.')),
                Center(child: Text('Pull down to refresh.')),
              ],
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final pick = picks[index];
              final isBook = pick.kind == 'book';
              return ListTile(
                leading: Icon(isBook ? Icons.menu_book : Icons.movie),
                title: Text(pick.title),
                subtitle: Text(pick.note),
                isThreeLine: true,
                onTap: () => _openPick(pick),
              );
            },
          );
        },
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
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Future<List<Book>>? _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChange);
  }

  void _handleSearchChange() {
    _debounce?.cancel();
    final query = _searchController.text.trim();

    setState(() {
      _query = query;
      _future = null;
    });

    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _future = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _copyId(Book book) {
    Clipboard.setData(ClipboardData(text: book.workId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${book.workId}')),
    );
  }

  Widget _bookResults() {
    if (_future == null) {
      return Center(
        child: Text(
          _query.length < 3
              ? 'Enter at least 3 letters to search for books.'
              : 'Waiting to search...',
        ),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final books = snapshot.data ?? const <Book>[];
        if (books.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }

        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final book = books[index];
            final author = book.authors.isEmpty
                ? 'Author unavailable'
                : book.authors.first;
            final year = book.year?.toString() ?? 'Year unavailable';

            return ListTile(
              leading: _CoverThumbnail(
                imageUrl: book.coverId == null
                    ? null
                    : 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                fallback: Icons.menu_book,
              ),
              title: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('$author â€¢ $year'),
              trailing: IconButton(
                tooltip: 'Copy Open Library ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(book),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter at least 3 letters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _bookResults()),
      ],
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi _api = const OmdbApi(omdbKey);
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChange);
  }

  void _handleSearchChange() {
    _debounce?.cancel();
    final query = _searchController.text.trim();

    setState(() {
      _query = query;
      _future = null;
    });

    if (query.length < 3 || omdbKey.trim().isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _future = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _copyId(Movie movie) {
    Clipboard.setData(ClipboardData(text: movie.imdbId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${movie.imdbId}')),
    );
  }

  Widget _movieResults() {
    if (omdbKey.trim().isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'To search movies, add your free OMDb API key to omdb-key.txt and run RUN_UNIT7_EXERCISE.cmd.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_future == null) {
      return Center(
        child: Text(
          _query.length < 3
              ? 'Enter at least 3 letters to search for movies.'
              : 'Waiting to search...',
        ),
      );
    }

    return FutureBuilder<List<Movie>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }

        final movies = snapshot.data ?? const <Movie>[];
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }

        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              leading: _CoverThumbnail(
                imageUrl: movie.poster,
                fallback: Icons.movie,
              ),
              title: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(movie.year),
              trailing: IconButton(
                tooltip: 'Copy IMDb ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(movie),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 letters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _movieResults()),
      ],
    );
  }
}

class _CoverThumbnail extends StatelessWidget {
  final String? imageUrl;
  final IconData fallback;

  const _CoverThumbnail({required this.imageUrl, required this.fallback});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return SizedBox(width: 54, height: 72, child: Icon(fallback, size: 34));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        imageUrl!,
        width: 54,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => SizedBox(
          width: 54,
          height: 72,
          child: Icon(fallback, size: 34),
        ),
      ),
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<MediaDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadDetails();
  }

  Future<MediaDetails> _loadDetails() {
    if (widget.pick.kind == 'book') {
      return OpenLibraryApi().details(widget.pick.externalId);
    }
    return (const OmdbApi(omdbKey)).details(widget.pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<MediaDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }
          final details = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (details.imageUrl != null)
                  Center(
                    child: Image.network(
                      details.imageUrl!,
                      height: 260,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        height: 160,
                        child: Icon(Icons.image_not_supported_outlined, size: 64),
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    height: 150,
                    child: Icon(Icons.menu_book, size: 64),
                  ),
                const SizedBox(height: 16),
                Text(details.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(details.year, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My note', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(widget.pick.note),
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
                        Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(details.summary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

