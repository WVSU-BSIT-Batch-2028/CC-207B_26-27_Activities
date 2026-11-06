import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ProfilePetApp());

const Color _backgroundColor = Color(0xFFDDEBF5);
const Color _accentColor = Color(0xFF9099A0);
const String profileName = 'Ryzel John De Guia';
const String _omdbApiKey = String.fromEnvironment(
  'OMDB_API_KEY',
  defaultValue: '',
);
const String _strapiBaseUrl = String.fromEnvironment(
  'STRAPI_BASE_URL',
  defaultValue: 'http://localhost:1337',
);

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

  static const List<Widget> _screens = [
    ProfileScreen(),
    PetScreen(),
    GalleryScreen(),
    ShelfScreen(),
  ];
  static const List<String> _titles = [
    profileName,
    'My Pet',
    'Gallery',
    'My Shelf',
  ];

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
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Shelf',
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

const List<String> hobbies = [
  'Gaming',
  'Watching movies',
  'Photography',
  'Listening to music',
  'Traveling',
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

const List<ClassSlot> classSchedule = [
  ClassSlot(
    day: 'Monday',
    time: '9:00 AM - 12:00 PM',
    subject: 'CIT 212 - Networking 2 (Advanced Networking)',
  ),
  ClassSlot(
    day: 'Monday',
    time: '1:00 PM - 3:00 PM',
    subject: 'CC 208 - Methods of Research in Computing',
  ),
  ClassSlot(
    day: 'Monday',
    time: '3:00 PM - 6:00 PM',
    subject: 'CC 207B - Applications Development and Emerging Technologies',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '11:30 AM - 1:00 PM',
    subject: 'CIT 251 - Security Compliance and Governance',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '1:00 PM - 2:30 PM',
    subject: 'CIT 213 - Human Computer Interaction 2',
  ),
  ClassSlot(
    day: 'Tuesday',
    time: '3:00 PM - 6:00 PM',
    subject: 'CC 207B - Applications Development and Emerging Technologies',
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Class Schedule', style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Table(
                        border: TableBorder.all(color: colors.outlineVariant),
                        columnWidths: const {
                          0: FixedColumnWidth(62),
                          1: FixedColumnWidth(112),
                          2: FlexColumnWidth(),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                            ),
                            children: [
                              _ScheduleCell(
                                'Day',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                              _ScheduleCell(
                                'Time',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                              _ScheduleCell(
                                'Subject',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                          for (final slot in classSchedule)
                            TableRow(
                              children: [
                                _ScheduleCell(slot.day),
                                _ScheduleCell(slot.time),
                                _ScheduleCell(slot.subject),
                              ],
                            ),
                        ],
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

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell(this.text, {this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: style),
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

  Future<void> _confirmResetCount() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset count?'),
        content: const Text('Do you want to reset the owl hoot count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset == true && mounted) {
      setState(() => _playCount = 0);
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
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _playCount == 0 ? null : _confirmResetCount,
                child: const Text('Reset count'),
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

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/images/gallery/angryBirds.webp', caption: 'Angry Birds'),
  Photo(asset: 'assets/images/gallery/potato.webp', caption: 'Potato'),
  Photo(asset: 'assets/images/gallery/chikawa.jpg', caption: 'Chikawa'),
  Photo(asset: 'assets/images/gallery/riceNew.webp', caption: 'Rice'),
  Photo(asset: 'assets/images/gallery/bear.jpg', caption: 'Bear'),
  Photo(asset: 'assets/images/gallery/owl.jpg', caption: 'Owl'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  void _toggleFavorite(Photo photo) {
    setState(() {
      _favoriteAsset = _favoriteAsset == photo.asset ? null : photo.asset;
    });
  }

  void _openPhoto(Photo photo) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => PhotoScreen(photo: photo)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GridView.extent(
      maxCrossAxisExtent: 160,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: [
        for (final photo in galleryPhotos)
          Semantics(
            image: true,
            label: photo.caption,
            child: GestureDetector(
              onTap: () => _openPhoto(photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(photo.asset, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                          child: Text(
                            photo.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: IconButton(
                        tooltip: _favoriteAsset == photo.asset
                            ? 'Remove favorite'
                            : 'Set as favorite',
                        onPressed: () => _toggleFavorite(photo),
                        icon: Icon(
                          _favoriteAsset == photo.asset
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: colors.shadow, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
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
      body: Center(
        child: Semantics(
          image: true,
          label: photo.caption,
          child: InteractiveViewer(
            child: Image.asset(photo.asset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

class Book {
  const Book({
    required this.key,
    required this.title,
    required this.authorNames,
    required this.publishYear,
    required this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? '';
    final workId = key.contains('/') ? key.split('/').last : key;
    final publishYears = json['publish_year'] as List<dynamic>?;
    final firstPublishYear = json['first_publish_year'];
    final publishYear =
        publishYears
            ?.map((value) => value.toString())
            .firstWhere((value) => value.isNotEmpty, orElse: () => '') ??
        (firstPublishYear?.toString() ?? '');
    return Book(
      key: workId,
      title: json['title'] as String? ?? 'Unknown Title',
      authorNames:
          (json['author_name'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
              .join(', ') ??
          'Unknown Author',
      publishYear: publishYear.isEmpty ? 'Unknown' : publishYear,
      coverId: json['cover_i'] as int?,
    );
  }

  final String key;
  final String title;
  final String authorNames;
  final String publishYear;
  final int? coverId;

  String get coverUrl {
    if (coverId == null) return '';
    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }

  bool get hasCover => coverId != null;
}

class Movie {
  const Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'Unknown Title',
      year: json['Year'] as String? ?? 'Unknown',
      poster: json['Poster'] as String? ?? '',
      type: json['Type'] as String? ?? 'movie',
    );
  }

  final String imdbID;
  final String title;
  final String year;
  final String poster;
  final String type;

  bool get hasPoster => poster.isNotEmpty && poster != 'N/A';
}

class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? json;
    return Pick(
      id: json['id'] as int? ?? 0,
      title: attributes['title'] as String? ?? '',
      kind: attributes['kind'] as String? ?? '',
      externalId:
          attributes['externalId'] as String? ??
          attributes['externalID'] as String? ??
          '',
      note: attributes['note'] as String? ?? '',
    );
  }

  final int id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  bool get isBook => kind == 'book';
  bool get isMovie => kind == 'movie';
}

// ============================================================================
// API CLASSES
// ============================================================================

class OpenLibraryApi {
  static const _baseUrl = 'openlibrary.org';
  static const _searchPath = '/search.json';

  Future<List<Book>> searchBooks(String query) async {
    final uri = Uri.https(_baseUrl, _searchPath, {'q': query, 'limit': '20'});

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Open Library error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = data['docs'] as List<dynamic>? ?? [];

    return docs
        .map((doc) => Book.fromJson(doc as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> fetchWorkDetails(String workId) async {
    final uri = Uri.https(_baseUrl, '/works/$workId.json');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Open Library work error: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchBookDetails(String id) async {
    final normalizedId = id.trim().split('/').last;
    if (normalizedId.endsWith('W')) {
      return fetchWorkDetails(normalizedId);
    }

    final editionUri = Uri.https(_baseUrl, '/books/$normalizedId.json');
    final editionResponse = await http.get(editionUri);

    if (editionResponse.statusCode != 200) {
      throw Exception(
        'Open Library could not find book ID "$normalizedId" '
        '(${editionResponse.statusCode}). Use an ID ending in M or W.',
      );
    }

    final edition = jsonDecode(editionResponse.body) as Map<String, dynamic>;
    final works = edition['works'] as List<dynamic>?;
    final workKey = works?.firstOrNull;

    if (workKey is! Map<String, dynamic> || workKey['key'] is! String) {
      return edition;
    }

    final workId = (workKey['key'] as String).split('/').last;
    try {
      final work = await fetchWorkDetails(workId);
      return {...edition, ...work};
    } on Exception {
      return edition;
    }
  }
}

class OmdbApi {
  final String apiKey;
  static const _baseUrl = 'http://www.omdbapi.com/';

  OmdbApi({required this.apiKey});

  Future<List<Movie>> searchMovies(String query) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'OMDb API key is missing. Run with '
        '--dart-define=OMDB_API_KEY=YOUR_KEY.',
      );
    }

    final uri = Uri.parse(
      '$_baseUrl?apikey=$apiKey&s=${Uri.encodeComponent(query)}&type=movie',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('OMDb error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      final message = data['Error'] as String? ?? 'No results found';
      throw Exception(message);
    }

    final search = data['Search'] as List<dynamic>? ?? [];

    return search
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> fetchMovieDetails(String imdbID) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'OMDb API key is missing. Run with '
        '--dart-define=OMDB_API_KEY=YOUR_KEY.',
      );
    }

    final uri = Uri.parse('$_baseUrl?apikey=$apiKey&i=$imdbID&plot=full');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('OMDb detail error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['Response'] == 'False') {
      final message = data['Error'] as String? ?? 'Movie not found';
      throw Exception(message);
    }

    return data;
  }
}

// ============================================================================
// PICK SOURCE & STRAPI REPOSITORY
// ============================================================================

abstract class PickSource {
  Future<List<Pick>> getPicks();
  Future<Pick> getPick(int id);
}

class StrapiPickRepository implements PickSource {
  final String baseUrl;

  StrapiPickRepository({required this.baseUrl});

  @override
  Future<List<Pick>> getPicks() async {
    final uri = Uri.parse('$baseUrl/api/picks?populate=*');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Strapi error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = data['data'] as List<dynamic>? ?? [];

    return docs
        .map((doc) => Pick.fromJson(doc as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Pick> getPick(int id) async {
    final uri = Uri.parse('$baseUrl/api/picks/$id?populate=*');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Strapi error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final doc = data['data'] as Map<String, dynamic>? ?? {};

    return Pick.fromJson(doc);
  }
}

// ============================================================================
// BOOK SEARCH SCREEN
// ============================================================================

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final _controller = TextEditingController();
  final OpenLibraryApi _api = OpenLibraryApi();
  Timer? _debounce;
  List<Book> _results = [];
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _error = null;
      if (value.trim().length < 3) {
        _results = [];
        _isLoading = false;
      }
    });
    if (value.trim().length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _performSearch(value.trim());
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await _api.searchBooks(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _copyToClipboard(String externalId) {
    Clipboard.setData(ClipboardData(text: externalId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied Open Library ID: $externalId'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Search books (Open Library)',
              hintText: 'Type 3+ characters...',
              border: OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          else if (_results.isEmpty)
            const Center(
              child: Text('Enter 3+ characters to search for books.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final book = _results[index];
                return Card(
                  child: ListTile(
                    leading: book.hasCover
                        ? Image.network(
                            book.coverUrl,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.book),
                          )
                        : const Icon(Icons.book),
                    title: Text(book.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.authorNames),
                        const SizedBox(height: 4),
                        Text(
                          'Year: ${book.publishYear}   |   ID: ${book.key}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy Open Library ID',
                      onPressed: () => _copyToClipboard(book.key),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// MOVIE SEARCH SCREEN
// ============================================================================

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final _controller = TextEditingController();
  final OmdbApi _api = OmdbApi(apiKey: _omdbApiKey);
  Timer? _debounce;
  List<Movie> _results = [];
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _error = null;
      if (value.trim().length < 3) {
        _results = [];
        _isLoading = false;
      }
    });
    if (value.trim().length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _performSearch(value.trim());
      });
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await _api.searchMovies(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _copyToClipboard(String imdbID) {
    Clipboard.setData(ClipboardData(text: imdbID));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied IMDb ID: $imdbID'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Search movies (OMDb)',
              hintText: 'Type 3+ characters...',
              border: OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          else if (_results.isEmpty)
            const Center(
              child: Text('Enter 3+ characters to search for movies.'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final movie = _results[index];
                return Card(
                  child: ListTile(
                    leading: movie.hasPoster
                        ? Image.network(
                            movie.poster,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.movie),
                          )
                        : const Icon(Icons.movie),
                    title: Text(movie.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Year: ${movie.year}   |   Type: ${movie.type}'),
                        const SizedBox(height: 4),
                        Text(
                          'IMDb ID: ${movie.imdbID}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy IMDb ID',
                      onPressed: () => _copyToClipboard(movie.imdbID),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// MY PICKS TAB (Strapi CMS)
// ============================================================================

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final PickSource _repository = StrapiPickRepository(baseUrl: _strapiBaseUrl);
  List<Pick> _picks = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  Future<void> _loadPicks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final picks = await _repository.getPicks();
      if (mounted) {
        setState(() {
          _picks = picks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _openPickDetail(Pick pick) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadPicks,
      child: _isLoading && _picks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _picks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _loadPicks,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _picks.length,
              itemBuilder: (context, index) {
                final pick = _picks[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(pick.isBook ? '📖' : '🎬'),
                    ),
                    title: Text(pick.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kind: ${pick.kind.toUpperCase()}'),
                        Text('External ID: ${pick.externalId}'),
                        const SizedBox(height: 4),
                        Text(
                          pick.note,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openPickDetail(pick),
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================================
// PICK DETAIL SCREEN
// ============================================================================

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  final OpenLibraryApi _openLibraryApi = OpenLibraryApi();
  final OmdbApi _omdbApi = OmdbApi(apiKey: _omdbApiKey);
  Map<String, dynamic>? _details;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (widget.pick.isBook) {
        final details = await _openLibraryApi.fetchBookDetails(
          widget.pick.externalId,
        );
        if (mounted) {
          setState(() {
            _details = details;
            _isLoading = false;
          });
        }
      } else if (widget.pick.isMovie) {
        final details = await _omdbApi.fetchMovieDetails(
          widget.pick.externalId,
        );
        if (mounted) {
          setState(() {
            _details = details;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String? _extractDescription(Map<String, dynamic>? workData) {
    if (workData == null) return null;
    final description = workData['description'];
    if (description == null) return null;

    switch (description) {
      case String s:
        return s;
      case Map<String, dynamic> m:
        return m['value'] as String?;
      case List<dynamic> l:
        if (l.isNotEmpty && l.first is Map) {
          return (l.first as Map)['value'] as String?;
        }
        return l.first.toString();
      default:
        return description.toString();
    }
  }

  String _bookYear(Map<String, dynamic> details) {
    return details['first_publish_date'] as String? ?? 'Year unavailable';
  }

  String _bookCoverUrl(Map<String, dynamic> details) {
    final covers = details['covers'] as List<dynamic>?;
    final coverIds = covers?.whereType<int>().toList() ?? [];
    if (coverIds.isEmpty) return '';
    return 'https://covers.openlibrary.org/b/id/${coverIds.first}-L.jpg';
  }

  String _movieValue(Map<String, dynamic> details, String key) {
    return details[key] as String? ?? '$key unavailable';
  }

  Widget _coverImage(String url) {
    if (url.isEmpty || url == 'N/A') {
      return const SizedBox(
        height: 220,
        child: Center(child: Icon(Icons.image_not_supported, size: 64)),
      );
    }

    return SizedBox(
      height: 220,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            const Center(child: Icon(Icons.image_not_supported, size: 64)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: _isLoading && _details == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _details == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _loadDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.pick.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Chip(label: Text(widget.pick.isBook ? 'Book' : 'Movie')),
                  const SizedBox(height: 16),
                  if (_details != null) ...[
                    _coverImage(
                      widget.pick.isBook
                          ? _bookCoverUrl(_details!)
                          : _movieValue(_details!, 'Poster') ==
                                'Poster unavailable'
                          ? ''
                          : _movieValue(_details!, 'Poster'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Year: ${widget.pick.isBook ? _bookYear(_details!) : _movieValue(_details!, 'Year')}',
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Note from Strapi CMS:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(widget.pick.note),
                  const SizedBox(height: 16),
                  Text(
                    'External ID: ${widget.pick.externalId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (_details != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Extended Details:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (widget.pick.isBook) ...[
                      Text(
                        'Summary:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _extractDescription(_details) ??
                            'No description available.',
                      ),
                    ] else if (widget.pick.isMovie) ...[
                      Text(
                        'Summary:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(_movieValue(_details!, 'Plot')),
                    ],
                  ],
                ],
              ),
            ),
    );
  }
}

// ============================================================================
// SHELF SCREEN
// ============================================================================

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Picks', icon: Icon(Icons.list)),
            Tab(text: 'Books', icon: Icon(Icons.book)),
            Tab(text: 'Movies', icon: Icon(Icons.movie)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              MyPicksTab(),
              BookSearchScreen(),
              MovieSearchScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
