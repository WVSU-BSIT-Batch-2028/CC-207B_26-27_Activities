import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christopher Gian S. Fernandez',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFEBEEF5),
          indicatorColor: Colors.blue.shade100,
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
    ShelfScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
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
            icon: Icon(Icons.auto_stories),
            label: 'My Shelf',
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

class InfoTile extends StatelessWidget {
  final ProfileInfo info;

  const InfoTile({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(info.icon),
      title: Text(info.label, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(info.value, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

final List<ProfileInfo> infos = [
  const ProfileInfo(
    icon: Icons.school,
    label: 'Course',
    value: 'Bachelor of Science in Information Technology',
  ),
  const ProfileInfo(
    icon: Icons.code,
    label: 'Skills',
    value: 'HTML, CSS, Java, and C++',
  ),
  const ProfileInfo(
    icon: Icons.location_on,
    label: 'Location',
    value: 'Iloilo, Philippines',
  ),
  const ProfileInfo(
    icon: Icons.favorite,
    label: 'Interests',
    value: 'Photography, Astronomy, and Gaming',
  ),
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<String> hobbies = const [
    'Photography',
    'Programming',
    'Technology',
    'Gaming',
    'Watching Movies',
  ];

  final List<ClassSlot> schedule = const [
    ClassSlot(day: 'Monday', time: '9 AM - 12 PM', subject: 'CIT 246'),
    ClassSlot(day: 'Tuesday', time: '7 AM - 9 AM', subject: 'CIT 210'),
    ClassSlot(day: 'Wednesday', time: '1 PM - 4 PM', subject: 'CIT 212'),
    ClassSlot(day: 'Thursday', time: '4 PM - 6 PM', subject: 'CIT 213'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Christopher Gian S. Fernandez')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/DSC_0219.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of Gian',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Christopher Gian S. Fernandez',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'An aspiring IT professional and photographer.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('About Me', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final info in infos) InfoTile(info: info),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am an Information Technology student who '
                      'enjoys learning about programming and '
                      'technology. I also enjoy photography and '
                      'exploring new ways to improve my skills.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Hobbies',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
            const SizedBox(height: 24),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(90),
                        1: FixedColumnWidth(120),
                        2: FlexColumnWidth(),
                      },
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Day',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Time',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Subject',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        for (final slot in schedule)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(slot.day),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(slot.time),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(slot.subject),
                              ),
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
    );
  }
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

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late final AudioPlayer _audioPlayer;

  bool _isPlaying = false;
  bool _isLiked = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _audioPlayer.play(AssetSource('sounds/pet_sound.wav'));
    } catch (error) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to play the sound. Check the audio file.'),
          ),
        );
      }
    }
  }

  Future<void> _confirmResetCounter() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Play Counter?'),
        content: const Text(
          'Are you sure you want to reset Miming\'s play counter?',
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
      ),
    );

    if (shouldReset == true && mounted) {
      setState(() {
        _playCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Miming the GOAT')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/pet.jpg',
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of my pet',
                    ),
                  ),
                  if (_isLiked)
                    const Icon(Icons.favorite, color: Colors.red, size: 80),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Meet Miming!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This is my favorite animal companion.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
              label: Text(_isPlaying ? 'Playing...' : 'Play Sound'),
            ),
            const SizedBox(height: 16),
            Text(
              'Miming roared $_playCount '
              '${_playCount == 1 ? 'time' : 'times'}.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _playCount == 0 ? null : _confirmResetCounter,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset count'),
            ),
            const SizedBox(height: 8),
            Text(
              'Double-tap the photo to ${_isLiked ? 'remove' : 'add'} '
              'a heart.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class Photo {
  final String asset;
  final String caption;

  const Photo({required this.asset, required this.caption});
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
          children: [
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  child: Image.asset(photo.asset, fit: BoxFit.contain),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
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

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Photo> photos = const [
    Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Photo 1'),
    Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'Photo 2'),
    Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Photo 3'),
    Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Photo 4'),
    Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Photo 5'),
    Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Photo 6'),
  ];

  Photo? favoritePhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () async {
                final isFavorite = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoScreen(photo: photo),
                  ),
                );

                if (isFavorite == true) {
                  setState(() {
                    favoritePhoto = photo;
                  });
                }
              },
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
                  if (favoritePhoto == photo)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.star, color: Colors.amber, size: 30),
                    ),
                ],
              ),
            ),
        ],
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
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [MyPicksTab(), BooksTab(), MoviesTab()],
        ),
      ),
    );
  }
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
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String,
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String? ?? 'Unknown',
      poster: json['Poster'] as String? ?? 'N/A',
    );
  }
}

class Pick {
  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    return Pick(
      id: json['sys']['id'] as String,
      title: json['fields']['title'] as String,
      kind: json['fields']['kind'] as String,
      externalId: json['fields']['externalId'] as String,
      note: json['fields']['note'] as String? ?? '',
    );
  }
}

abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  final http.Client client;

  ContentfulPickSource(this.client);

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$cmsSpace/environments/master/entries',
      {'content_type': 'pick', 'limit': '100'},
    );

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $cmsToken'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Contentful error: ${response.statusCode} ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final items = json['items'] as List<dynamic>;

    return items.map((item) {
      return Pick.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final http.Client _client;
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    final pick = widget.pick;

    if (pick.kind.toLowerCase() == 'book') {
      final uri = Uri.https(
        'openlibrary.org',
        '/works/${pick.externalId}.json',
      );

      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Open Library error: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };

      int? coverId;
      final covers = json['covers'] as List<dynamic>?;

      if (covers != null) {
        for (final cover in covers) {
          if (cover is int) {
            coverId = cover;
            break;
          }
        }
      }

      return {
        'title': json['title'] ?? pick.title,
        'year': 'Book',
        'summary': description,
        'image': coverId != null
            ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
            : null,
      };
    }

    if (pick.kind.toLowerCase() == 'movie') {
      if (omdbApiKey.isEmpty) {
        throw Exception('OMDb API key is missing.');
      }

      final uri = Uri.https('www.omdbapi.com', '/', {
        'apikey': omdbApiKey,
        'i': pick.externalId,
        'plot': 'short',
      });

      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw Exception('OMDb error: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['Response'] == 'False') {
        throw Exception(json['Error'] ?? 'Movie not found.');
      }

      final poster = json['Poster'] as String? ?? 'N/A';

      return {
        'title': json['Title'] ?? pick.title,
        'year': json['Year'] ?? 'Unknown',
        'summary': json['Plot'] ?? 'No plot available.',
        'image': poster != 'N/A' ? poster : null,
      };
    }

    throw Exception('Unknown pick type: ${pick.kind}');
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;

    return Scaffold(
      appBar: AppBar(title: const Text('Pick Details')),
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
                  'Unable to load details.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final details = snapshot.data!;

          final image = details['image'] as String?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Center(
                    child: Image.network(
                      image,
                      height: 300,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 200,
                          child: Icon(Icons.image_not_supported, size: 64),
                        );
                      },
                    ),
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Icon(Icons.image_not_supported, size: 64),
                    ),
                  ),

                const SizedBox(height: 24),

                Text(
                  details['title'] as String,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  details['year'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const Divider(height: 32),

                Text(
                  'Why I Recommend It',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(pick.note, style: Theme.of(context).textTheme.bodyLarge),

                const SizedBox(height: 24),

                Text('Summary', style: Theme.of(context).textTheme.titleLarge),

                const SizedBox(height: 8),

                Text(
                  details['summary'] as String,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MyPicksTabState extends State<MyPicksTab> {
  late final ContentfulPickSource _source;
  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();

    _source = ContentfulPickSource(http.Client());
    _picksFuture = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = _source.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // FutureBuilder will display the error state.
    }
  }

  @override
  void dispose() {
    _source.client.close();
    super.dispose();
  }

  Widget _message(String message, {Widget? action}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, textAlign: TextAlign.center),
                if (action != null) ...[const SizedBox(height: 12), action],
              ],
            ),
          ),
        ),
      ],
    );
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
            child: _message(
              'Unable to load your picks.\n${snapshot.error}',
              action: TextButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ),
          );
        }

        final picks = snapshot.data ?? [];

        if (picks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: _message('No picks available yet.'),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];

              return ListTile(
                leading: Icon(
                  pick.kind.toLowerCase() == 'book'
                      ? Icons.menu_book
                      : Icons.movie,
                  size: 32,
                ),
                title: Text(
                  pick.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(pick.note),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PickDetailScreen(pick: pick),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

const String omdbApiKey = String.fromEnvironment('OMDB_API_KEY');
const String cmsSpace = String.fromEnvironment('CMS_SPACE');
const String cmsToken = String.fromEnvironment('CMS_TOKEN');

class OmdbApi {
  final http.Client client;

  OmdbApi(this.client);

  Future<List<Movie>> search(String query) async {
    if (omdbApiKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': omdbApiKey,
      's': query,
      'type': 'movie',
      'page': '1',
    });

    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('OMDb error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      throw Exception(json['Error'] ?? 'No movies found.');
    }

    final results = json['Search'] as List<dynamic>;

    return results.map((item) {
      return Movie.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi api = OmdbApi(http.Client());

  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();

    final query = text.trim();

    if (query.length < 3) {
      setState(() {
        _results = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _results = api.search(query);
      });
    });
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied IMDb ID: $id')));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    api.client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter a movie title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Search for at least 3 characters.'))
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final movies = snapshot.data ?? [];

                    if (movies.isEmpty) {
                      return const Center(child: Text('No movies found.'));
                    }

                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];

                        return ListTile(
                          leading: movie.poster != 'N/A'
                              ? Image.network(
                                  movie.poster,
                                  width: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.movie, size: 40);
                                  },
                                )
                              : const Icon(Icons.movie, size: 40),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy IMDb ID',
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

class OpenLibraryApi {
  final http.Client client;

  OpenLibraryApi(this.client);

  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });

    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Open Library error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final docs = json['docs'] as List<dynamic>;

    return docs.map((item) {
      return Book.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final OpenLibraryApi api = OpenLibraryApi(http.Client());

  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();

    final query = text.trim();

    if (query.length < 3) {
      setState(() {
        _results = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _results = api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    api.client.close();
    super.dispose();
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied book ID: $id')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter a book title or author',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Search for at least 3 characters.'))
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final books = snapshot.data ?? [];

                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }

                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];

                        final author = book.authors.isNotEmpty
                            ? book.authors.first
                            : 'Unknown author';

                        return ListTile(
                          leading: book.coverId != null
                              ? Image.network(
                                  'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                  width: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.menu_book,
                                      size: 40,
                                    );
                                  },
                                )
                              : const Icon(Icons.menu_book, size: 40),
                          title: Text(book.title),
                          subtitle: Text(
                            '$author · ${book.year ?? 'Year unknown'}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copy book ID',
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
