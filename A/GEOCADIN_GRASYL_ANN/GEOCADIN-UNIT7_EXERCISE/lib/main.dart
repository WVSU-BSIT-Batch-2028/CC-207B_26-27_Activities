import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';

// OMDb API KEY
const omdbKey = String.fromEnvironment('OMDB_KEY');

// BOOK MODEL

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
        authors: [
          ...?(json['author_name'] as List<dynamic>?)?.cast<String>(),
        ],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );
}

// OPEN LIBRARY API

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': query,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Open Library request failed: ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final docs = json['docs'] as List<dynamic>;

    return docs.map((item) {
      return Book.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  // GET BOOK DETAILS
  Future<Map<String, dynamic>> getDetails(String workId) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/works/$workId.json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Open Library details failed: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

// MOVIE MODEL

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

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        imdbId: json['imdbID'] as String,
        title: json['Title'] as String,
        year: json['Year'] as String,
        poster: json['Poster'] as String? ?? 'N/A',
      );
}

// API EXCEPTION

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

// OMDb API


class OmdbApi {
  Future<List<Movie>> search(String query) async {
    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        's': query,
        'type': 'movie',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'OMDb request failed: ${response.statusCode}',
      );
    }

    final json =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';

      if (error == 'Movie not found!') {
        return const [];
      }

      throw ApiException(error);
    }

    final results = json['Search'] as List<dynamic>? ?? [];

    return results.map((item) {
      return Movie.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  // GET MOVIE DETAILS
  Future<Map<String, dynamic>> getDetails(String imdbId) async {
    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': omdbKey,
        'i': imdbId,
        'plot': 'short',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw ApiException(
        'OMDb details failed: ${response.statusCode}',
      );
    }

    final json =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (json['Response'] == 'False') {
      throw ApiException(
        json['Error'] as String? ?? 'OMDb error',
      );
    }

    return json;
  }
}


// CONTENTFUL CONFIGURATION
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsToken = String.fromEnvironment('CMS_TOKEN');

// PICK MODEL
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

  factory Pick.fromContentful(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;

    return Pick(
      title: _readField(fields['title']),
      kind: _readField(fields['kind']),
      externalId: _readField(fields['externalId']),
      note: _readField(fields['note']),
    );
  }
}

// READ CONTENTFUL FIELD
String _readField(dynamic field) {
  if (field is Map) {
    return field.values.first?.toString() ?? '';
  }

  return field?.toString() ?? '';
}

// PICK SOURCE INTERFACE
abstract class PickSource {
  Future<List<Pick>> fetchPicks();
}

// CONTENTFUL PICK SOURCE
class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/$cmsSpace/environments/master/entries',
      {
        'content_type': 'pick',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $cmsToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Contentful request failed: ${response.statusCode}',
      );
    }

    final json =
        jsonDecode(response.body) as Map<String, dynamic>;

    final items = json['items'] as List<dynamic>? ?? [];

    return items.map((item) {
      return Pick.fromContentful(
        item as Map<String, dynamic>,
      );
    }).toList();
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

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
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
  int selectedIndex = 0;

  final pages = const [
  ProfileScreen(),
  PetScreen(),
  GalleryScreen(),
  ShelfScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
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
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          NavigationDestination(
            icon: Icon(Icons.pets),
            label: "My Pet",
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: "Gallery",
          ),
          NavigationDestination(
             icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: "Shelf",
          ),
        ],
      ),
    );
  }
}

// SHELF SCREEN

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Shelf"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "My Picks"),
              Tab(text: "Books"),
              Tab(text: "Movies"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksScreen(),
            BookSearchScreen(),
            MovieSearchScreen(),
          ],
        ),
      ),
    );
  }
}


 // BOOK SEARCH SCREEN

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final OpenLibraryApi api = OpenLibraryApi();
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;
  Future<List<Book>>? _results;

  String _query = '';
  bool _waiting = false;

  // Wait 500 milliseconds after the user stops typing.
  void _onChanged(String text) {
    _debounce?.cancel();

    final query = text.trim();

    setState(() {
      _query = query;
      _results = null;
      _waiting = query.length >= 3;
    });

    // Search only when the query has at least 3 characters.
    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _waiting = false;
        _results = api.search(query);
      });
    });
  }

  // Copy the Open Library ID.
  Future<void> _copyBookId(Book book) async {
    await Clipboard.setData(
      ClipboardData(text: book.workId),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied book ID: ${book.workId}'),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Widget _buildResults() {
    if (_query.isEmpty) {
      return const Center(
        child: Text('Search for your favorite books.'),
      );
    }

    if (_query.length < 3) {
      return const Center(
        child: Text('Enter at least 3 characters to search.'),
      );
    }

    if (_waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _results,
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

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                leading: book.coverId == null
                    ? const SizedBox(
                        width: 55,
                        height: 75,
                        child: Icon(Icons.book, size: 40),
                      )
                    : Image.network(
                        'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                        width: 55,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 55,
                            height: 75,
                            child: Icon(Icons.book, size: 40),
                          );
                        },
                      ),
                title: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${book.authors.isEmpty ? "Unknown author" : book.authors.first}'
                  '\n${book.year ?? "Year unavailable"}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Copy book ID',
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyBookId(book),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: _onChanged,
              decoration: InputDecoration(
                labelText: 'Search books',
                hintText: 'Enter a book title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _onChanged('');
                  },
                ),
              ),
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }
}


 // MOVIE SEARCH SCREEN

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() =>
      _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final OmdbApi api = OmdbApi();
  final TextEditingController searchController =
      TextEditingController();

  Future<List<Movie>>? _results;

  Future<void> _search(String text) async {
    final query = text.trim();

    if (query.isEmpty) return;

    setState(() {
      _results = api.search(query);
    });
  }

  Future<void> _copyMovieId(Movie movie) async {
    await Clipboard.setData(
      ClipboardData(text: movie.imdbId),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied movie ID: ${movie.imdbId}'),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildResults() {
    if (_results == null) {
      return const Center(
        child: Text('Search for your favorite movies.'),
      );
    }

    return FutureBuilder<List<Movie>>(
      future: _results,
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

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                leading: movie.poster == 'N/A' ||
                        movie.poster.isEmpty
                    ? const SizedBox(
                        width: 55,
                        height: 75,
                        child: Icon(Icons.movie, size: 40),
                      )
                    : Image.network(
                        movie.poster,
                        width: 55,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 55,
                            height: 75,
                            child: Icon(Icons.movie, size: 40),
                          );
                        },
                      ),
                title: Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(movie.year),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Copy IMDb ID',
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyMovieId(movie),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (omdbKey.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search Movies'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'OMDb API key is missing. Run the app using '
              '--dart-define=OMDB_KEY=your-key',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onSubmitted: _search,
              decoration: InputDecoration(
                labelText: 'Search movies',
                hintText: 'Enter a movie title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }
}



// PHOTO MODEL

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

const List<Photo> photos = [
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'Chanyeol',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'Xiumin',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'Kyungsoo',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'Baekhyun',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'Sehun',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'Suho',
  ),
];


// GALLERY SCREEN

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
      MaterialPageRoute<bool>(
        builder: (_) => PhotoScreen(photo: photo),
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
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
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
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
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


// PHOTO DETAIL SCREEN

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.star),
              label: const Text('Make favorite'),
            ),
          ),
        ],
      ),
    );
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
  late Future<Map<String, String>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, String>> _loadDetails() async {
    if (widget.pick.kind.toLowerCase() == 'book') {
      final json = await OpenLibraryApi().getDetails(
        widget.pick.externalId,
      );

      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };

      final covers = json['covers'] as List<dynamic>? ?? [];

      return {
        'title': json['title']?.toString() ?? widget.pick.title,
        'summary': description,
        'imageUrl': covers.isEmpty
            ? ''
            : 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg',
      };
    } else {
      final json = await OmdbApi().getDetails(
        widget.pick.externalId,
      );

      final poster = json['Poster']?.toString() ?? 'N/A';

      return {
        'title': json['Title']?.toString() ?? widget.pick.title,
        'summary': json['Plot']?.toString() ?? 'No summary available.',
        'imageUrl': poster == 'N/A' ? '' : poster,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pick.title),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _detailsFuture,
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

          final details = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (details['imageUrl']!.isNotEmpty)
                  Image.network(
                    details['imageUrl']!,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 100,
                      );
                    },
                  )
                else
                  const Icon(Icons.image_not_supported, size: 100),

                const SizedBox(height: 20),

                Text(
                  details['title']!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 20),

                Text(
                  'Why I Recommend It',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(widget.pick.note),

                const SizedBox(height: 20),

                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(details['summary']!),
              ],
            ),
          );
        },
      ),
    );
  }
}



// MY PICKS SCREEN

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key});

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  final PickSource source = ContentfulPickSource();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();

    // Load picks when the screen starts.
    _picksFuture = source.fetchPicks();
  }

  Future<void> _refresh() async {
    final future = source.fetchPicks();

    setState(() {
      _picksFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // FutureBuilder displays the error.
    }
  }

  Widget _buildPicks() {
    return FutureBuilder<List<Pick>>(
      future: _picksFuture,
      builder: (context, snapshot) {
        // LOADING STATE
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        // ERROR STATE
        if (snapshot.hasError) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        final picks = snapshot.data ?? [];

        // EMPTY STATE
        if (picks.isEmpty) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 300,
                child: Center(
                  child: Text('No picks found.'),
                ),
              ),
            ],
          );
        }

        // LIST STATE
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: picks.length,
          itemBuilder: (context, index) {
            final pick = picks[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickDetailScreen(pick: pick),
      ),
    );
  },
                leading: Icon(
                  pick.kind.toLowerCase() == 'book'
                      ? Icons.book
                      : Icons.movie,
                  size: 35,
                ),
                title: Text(pick.title),
                subtitle: Text(pick.note),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Picks'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildPicks(),
      ),
    );
  }
}




// PROFILE MODEL

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







// INFO TILE

class InfoTile extends StatelessWidget {


  final ProfileInfo info;



  const InfoTile({

    super.key,

    required this.info,

  });



  @override
  Widget build(BuildContext context) {


    return Card(

      child: ListTile(

        leading: Icon(info.icon),

        title: Text(info.label),

        subtitle: Text(info.value),

      ),

    );

  }
}








// PROFILE SCREEN
// CLASS SCHEDULE MODEL

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


// PROFILE SCREEN

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<ProfileInfo> infos = const [
    ProfileInfo(
      icon: Icons.school,
      label: "Course",
      value: "Bachelor of Science in Information Technology",
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: "Location",
      value: "Iloilo, Philippines",
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: "Skills",
      value: "Flutter, Dart, Programming",
    ),
    ProfileInfo(
      icon: Icons.star,
      label: "Favorite",
      value: "Technology and creating apps",
    ),
  ];

  final List<String> hobbies = const [
    "Coding",
    "Music",
    "Watching movies",
    "Photography",
    "Gaming",
    "Reading",
  ];

  final List<ClassSlot> classes = const [
    ClassSlot(
      day: "Mon",
      time: "7:00 AM",
      subject: "Human Computer Interaction 2",
    ),
    ClassSlot(
      day: "Tue",
      time: "9:00 AM",
      subject: "App Development",
    ),
    ClassSlot(
      day: "Wed",
      time: "10:00 AM",
      subject: "IT Project Management",
    ),
    ClassSlot(
      day: "Thu",
      time: "1:00 PM",
      subject: "Technopreneurship ",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grasyl Ann Geocadin"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: "Photo of Grasyl Ann Geocadin",
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      "assets/images/profile.jpg",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grasyl Ann Geocadin",
                          style: theme.textTheme.headlineSmall,
                        ),
                        const Text(
                          "Aspiring IT professional and technology enthusiast.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Information",
              style: theme.textTheme.titleLarge,
            ),

            for (final info in infos)
              InfoTile(info: info),

            // HOBBIES CHIPS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Hobbies",
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

            // CLASS SCHEDULE TABLE
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Class Schedule",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Table(
                      border: TableBorder.all(
                        color: theme.dividerColor,
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(55),
                        1: FixedColumnWidth(85),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                          ),
                          children: [
                            for (final heading in [
                              "Day",
                              "Time",
                              "Subject",
                            ])
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
                        for (final slot in classes)
                          TableRow(
                            children: [
                              for (final value in [
                                slot.day,
                                slot.time,
                                slot.subject,
                              ])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(value),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // BIOGRAPHY
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Biography",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "I am a BSIT student who enjoys "
                      "learning programming and developing "
                      "applications using technology.",
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








// PET SCREEN


// PET SCREEN

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer player = AudioPlayer();

  bool playing = false;
  bool heart = false;
  int count = 0;

  @override
  void initState() {
    super.initState();

    player.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        playing = false;
      });
    });
  }

  Future<void> playSound() async {
    setState(() {
      playing = true;
      count++;
    });

    try {
      await player.play(
        AssetSource("sounds/pet_sound.mp3"),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        playing = false;
      });
    }
  }

  Future<void> _confirmReset() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Reset the count?"),
          content: const Text(
            "Are you sure you want to reset the bark count?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      count = 0;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pet"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  heart = !heart;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/pet.jpg",
                      height: 260,
                      width: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (heart)
                    const Icon(
                      Icons.favorite,
                      size: 80,
                      color: Colors.red,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: playing ? null : playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(
                playing ? "Playing..." : "Play Pet Sound",
              ),
            ),
            const SizedBox(height: 10),
            Text("My pet has made a sound $count times."),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: count == 0 ? null : _confirmReset,
              child: const Text("Reset count"),
            ),
          ],
        ),
      ),
    );
  }
}