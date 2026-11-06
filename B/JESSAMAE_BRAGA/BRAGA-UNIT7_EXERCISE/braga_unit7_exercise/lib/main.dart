import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';

const omdbKey = String.fromEnvironment('OMDB_KEY');
const contentfulSpaceId =
    String.fromEnvironment('CONTENTFUL_SPACE_ID');

const contentfulToken =
    String.fromEnvironment('CONTENTFUL_DELIVERY_TOKEN');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Braga Unit 7 Exercise',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 87, 169, 91)
      ),
      home: const HomeShell(title: 'Jessa Mae C. Braga'),
    );
  }
}

//HomeShell
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.title});

  final String title;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProfileScreen(),
      const MyPetScreen(),
      const GalleryScreen(),
      const ShelfScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person), 
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
            ),
          NavigationDestination(
            icon: Icon(Icons.pets), 
            selectedIcon: Icon(Icons.pets),
            label: 'My Pet',
            ),
          NavigationDestination(
            icon: Icon(Icons.photo_library), 
            selectedIcon: Icon(Icons.photo_library),
            label: 'Gallery',
            ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark), 
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Shelf',
            )
        ]
        ),
    
    );
  }
}

//Profile Information
class ProfileInfo {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfo(
    {
      required this.icon,
      required this.label,
      required this.value,
    }
  );
}

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
      leading: Icon(
        info.icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        info.label,
        style: theme.textTheme.bodySmall,
      ),
      subtitle: Text(
        info.value,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

//List of Hobbies
final List<String> hobbies = [
  'Creative Writing',
  'Reading',
  'Gaming',
  'Drawing',
  'Listening to Music',
];

//Classlot
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

final List<ClassSlot> classSchedule = [
  const ClassSlot(
    day: 'Monday',
    time: '9:00-12:00',
    subject: 'IT Project Management',
  ),
  const ClassSlot(
    day: 'Tuesday',
    time: '7:00-9:00',
    subject: 'Web Systems and Technologies',
  ),
  const ClassSlot(
    day: 'Wednesday',
    time: '1:00-4:00',
    subject: 'Networking',
  ),
  const ClassSlot(
    day: 'Thursday',
    time: '11:30-1:00',
    subject: 'Technopreneurship',
  ),
];

//Books
class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  Book({
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

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final url = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': query,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load books');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;

    return docs
        .map((item) => Book.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getDetails(String workId) async {
    final url = Uri.https(
      'openlibrary.org',
      '/works/$workId.json',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load book details');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

//Movies
class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String poster;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbID: json['imdbID'] as String,
    title: json['Title'] as String,
    year: json['Year'] as String,
    poster: json['Poster'] as String,
  );
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class OmdbApi {
  Future<List<Movie>> search(String query) async {
    final url = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        's': query,
      },
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw ApiException('Failed to load movies');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';

      if (error == 'Movie not found!') {
        return const [];
      }

      throw ApiException(error);
    }

    final movies = json['Search'] as List<dynamic>? ?? [];

    return movies
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  Future<Map<String, dynamic>> getDetails(String imdbID) async {
    final url = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        'i': imdbID,
        'plot': 'short',
      },
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw ApiException('Failed to load movie details');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }

    return json;
  }
}

//Pick(CMS)
class Pick {
  final String title;
  final String kind;
  final String externalId;
  final String note;

  Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;

    return Pick(
      title: fields['title'] as String? ?? '',
      kind: fields['kind'] as String? ?? '',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
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
  final String token;
  final String environment;

  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$spaceId/environments/$environment/entries',
      {
        'content_type': 'pick',
        'limit': '100',
      },
    );

    final headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    final json = await getJson(
      client,
      uri,
      cms: 'Contentful',
      headers: headers,
    );

    final data = json as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    return items.map((item) {
      return Pick.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}

class CmsException implements Exception {
  const CmsException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<Object?> getJson(
  http.Client client,
  Uri uri, {
  required String cms,
  Map<String, String> headers = const {},
}) async {
  final http.Response response;

  try {
    response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw CmsException('$cms took too long to answer. Try again.');
  } on http.ClientException {
    throw const CmsException(
      'No connection. Check your internet and try again.',
    );
  }

  return decodeOrThrow(response, cms);
}

Object? decodeOrThrow(http.Response response, String cms) {
  final code = response.statusCode;

  switch (code) {
    case 200:
      return jsonDecode(response.body);

    case 401 || 403:
      throw CmsException(
        '$cms refused the request ($code). Check your token and the read permission.',
      );

    case 404:
      throw CmsException(
        '$cms could not find the events (404). Check the URL and the content type name.',
      );

    case >= 500:
      throw CmsException(
        '$cms is having problems ($code). Try again later.',
      );

    default:
      throw CmsException('$cms answered $code.');
  }
}

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  MyPicksTabState createState() => MyPicksTabState();
}

class MyPicksTabState extends State<MyPicksTab> {
  late Future<List<Pick>> _futurePicks;

  late final PickSource source = ContentfulPickSource(
    http.Client(),
    spaceId: contentfulSpaceId,
    token: contentfulToken,
  );

  @override
  void initState() {
    super.initState();

    _futurePicks = source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = source.fetchPicks();

    setState(() {
      _futurePicks = future;
    });

    try {
      await future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<List<Pick>>(
              future: _futurePicks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 150),
                      Center(child: Text('Error: ${snapshot.error}')),
                    ],
                  );
                }

                final picks = snapshot.data ?? [];

                if (picks.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 150),
                      Center(child: Text('No picks available yet.')),
                    ],
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: picks.length,
                  itemBuilder: (context, index) {
                    final pick = picks[index];

                    return ListTile(
                      leading: Icon(
                        pick.kind.toLowerCase() == 'book'
                            ? Icons.menu_book_sharp
                            : Icons.movie,
                      ),
                      title: Text(pick.title),
                      subtitle: Text(pick.note),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PickDetailScreen(pick: pick),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
  void refresh() {
    _refresh();
  }
}


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
  late Future<Map<String, dynamic>> _details;

  @override
  void initState() {
    super.initState();
    _details = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() {
    if (widget.pick.kind.toLowerCase() == 'book') {
      return OpenLibraryApi().getDetails(widget.pick.externalId);
    } else {
      return OmdbApi().getDetails(widget.pick.externalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBook = widget.pick.kind.toLowerCase() == 'book';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pick.title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final json = snapshot.data!;

          final description = isBook
              ? switch (json['description']) {
                  final String text => text,
                  {'value': final String text} => text,
                  _ => 'No description yet.',
                }
              : json['Plot'] as String? ?? 'No summary available.';

          final image = isBook
              ? json['covers'] is List &&
                      (json['covers'] as List).isNotEmpty
                  ? 'https://covers.openlibrary.org/b/id/${(json['covers'] as List).first}-L.jpg'
                  : null
              : json['Poster'] != 'N/A'
                  ? json['Poster'] as String?
                  : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Book cover or movie poster
                if (image != null)
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      image,
                      height: 250,
                      width: 170,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 100,
                        );
                      },
                    ),
                  )
                else
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 100,
                    ),
                  ),

                const SizedBox(height: 20),

                // Title
                Text(
                  widget.pick.title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 6),

                // Type and external ID
                Text(
                  '${isBook ? 'Book' : 'Movie'} · '
                  '${isBook ? 'Open Library' : 'OMDb'} '
                  '${widget.pick.externalId}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),

                const SizedBox(height: 24),

                // Recommendation container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why I recommend it',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '“${widget.pick.note}”',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

               
                Text(
                  isBook ? 'Summary' : 'Plot Summary',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 10),

                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
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


//Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const infos = <ProfileInfo>[
      ProfileInfo(
        icon: Icons.cake,
        label: 'Age',
        value: '20',
      ),
      ProfileInfo(
        icon: Icons.person,
        label: 'Sex',
        value: 'Female',
      ),
      ProfileInfo(
        icon: Icons.school,
        label: 'Course',
        value: 'Bachelor of Science in Information Technology',
      ),
      ProfileInfo(
        icon: Icons.calendar_month,
        label: 'Year Level',
        value: 'Third Year',
      ),
      ProfileInfo(
        icon: Icons.pets,
        label: 'Favorite Animal',
        value: 'Wolf',
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Semantics(
                  image: true,
                  label: 'Photo of Jessa Mae C. Braga',
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/my_photo.jpg'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Jessa Mae C. Braga',
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Learning, Trying, Surviving.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Personal Information',
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        for (final hobby in hobbies)
                          Chip(
                            label: Text(hobby),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am just a simple person trying my luck here in the city. '
                      'Living in the province and commuting to school every day has become part '
                      'of my routine. It can be tiring, but it allows me to pursue my '
                      'dreams and keep moving forward. Road trips at dawn and chasing '
                      'the night make my days worthwhile. Although this journey can be '
                      'draining, it is also fulfilling, reminding me that every sacrifice '
                      'has a purpose.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Class Schedule',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(76),
                        1: FixedColumnWidth(82),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final heading in ['Day', 'Time', 'Subject'])
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  heading,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (final slot in classSchedule)
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

//Pet Screen
class MyPetScreen extends StatefulWidget {
  const MyPetScreen({super.key});

  @override
  State<MyPetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<MyPetScreen> {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _showHeart = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();

    _player.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });
    });
  }


  Future<void> _playSound() async {
    if (_isPlaying) return;

    setState(() {
      _isPlaying = true;
      _playCount++;
    });

    try {
      await _player.play(
        AssetSource('sounds/fav_animal_sound.mp3'),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
        _playCount--;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to play the sound. Check your audio asset.'),
        ),
      );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
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
                    child: Image.asset(
                      'assets/images/fav_animal.jpg',
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'A photo of my favorite animal, Lupus',
                    ),
                  ),

                  if (_showHeart)
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 300,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Lupus the Wolf',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
                'I do not have a pet, so I chose the wolf as my favorite '
                'animal. I find wolves interesting because of their unique '
                'features and loyalty to their pack. They also have a '
                'mysterious aura that makes them fascinating to me.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: Icon(
                _isPlaying ? Icons.hourglass_top : Icons.volume_up,
              ),
              label: Text(
                _isPlaying ? 'Playing...' : 'Play to Hear Lupus',
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: _playCount == 0
                  ? null
                  : () async {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset count?'),
                          content: const Text(
                            'Are you sure you want to reset the count to zero?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        setState(() {
                          _playCount = 0;
                        });
                      }
                    },
              child: const Text('Reset count'),
            ),

            const SizedBox(height: 16),

            Text(
              'Lupus has howled $_playCount '
              '${_playCount == 1 ? 'time' : 'times'}.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'Double-tap the photo to show or hide the heart.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//Gallery Screen
class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

final List<Photo> photos = [
  const Photo(
    asset: 'assets/images/gallery/image1.jpeg',  
    caption: 'A Bittersweet Goodbye'
  ),
  const Photo(
    asset: 'assets/images/gallery/image2.jpg',  
    caption: 'Blurring Encounter'
  ),
  const Photo(
    asset: 'assets/images/gallery/image3.jpg',  
    caption: 'Solely'
  ),
  const Photo(
    asset: 'assets/images/gallery/image4.jpg',  
    caption: 'Memory of the Lenses'
  ),
  const Photo(
    asset: 'assets/images/gallery/image5.jpg',  
    caption: 'Morning'
  ),
  const Photo(
    asset: 'assets/images/gallery/image6.jpg',  
    caption: 'Eyes of a Wolf'
    ),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (makeFavorite == true) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
      ),
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

                  // E. Show a star on the favorite photo
                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
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

//Photo Screen
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
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

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myPicksKey = GlobalKey<MyPicksTabState>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          actions: [
            IconButton(
              onPressed: () {
                myPicksKey.currentState?.refresh();
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh My Picks',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.favorite),
                text: 'My Picks'
              ),
              Tab(
                icon: Icon(Icons.menu_book),
                text: 'Books'
              ),
              Tab(
                icon: Icon(Icons.movie),
                text: 'Movies'
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyPicksTab(key: myPicksKey),
            const BooksTab(),
            const MoviesTab(),
          ],
        ),
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
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _results,
              builder: (context, snapshot) {
                if (_results == null) {
                  return const Center(
                    child: Text('Search for a book.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final books = snapshot.data ?? [];

                if (books.isEmpty) {
                  return const Center(
                    child: Text('Nothing found.'),
                  );
                }

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return ListTile(
                      leading: book.coverId != null
                          ? Image.network(
                              'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.book, size: 40);
                              },
                            )
                          : const Icon(Icons.book, size: 40),

                      title: Text(book.title),

                      subtitle: Text(
                        '${book.authors.isNotEmpty ? book.authors.first : 'Unknown author'}'
                        '${book.year != null ? ' • ${book.year}' : ''}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy Book ID',
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: book.workId),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied ${book.workId}'),
                            ),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'OMDb API key is missing.\n\n'
            'Run the app using:\n'
            'flutter run --dart-define=OMDB_KEY=YOUR_KEY',
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
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.movie),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _results,
              builder: (context, snapshot) {
                if (_results == null) {
                  return const Center(
                    child: Text('Search for a movie.'),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final movies = snapshot.data ?? [];

                if (movies.isEmpty) {
                  return const Center(
                    child: Text('Nothing found.'),
                  );
                }

                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];

                    return ListTile(
                      leading: movie.poster != 'N/A' &&
                              movie.poster.isNotEmpty
                          ? Image.network(
                              movie.poster,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return const Icon(
                                  Icons.movie,
                                  size: 40,
                                );
                              },
                            )
                          : const Icon(Icons.movie, size: 40),

                      title: Text(movie.title),

                      subtitle: Text(movie.year),

                      trailing: IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy IMDb ID',
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: movie.imdbID),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Copied ${movie.imdbID}',
                              ),
                            ),
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