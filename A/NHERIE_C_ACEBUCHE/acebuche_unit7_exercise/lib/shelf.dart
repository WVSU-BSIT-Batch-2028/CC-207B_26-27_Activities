import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const omdbKey = String.fromEnvironment('OMDB_KEY');

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

Future<Map<String, dynamic>> getJson(
  Uri uri, {
  Map<String, String>? headers,
}) async {
  final response = await http
      .get(uri, headers: headers)
      .timeout(const Duration(seconds: 20));
  if (response.statusCode != 200) {
    throw ApiException(
      'Request failed (${response.statusCode}). Please try again.',
    );
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}

class Book {
  final String workId, title;
  final List<String> authors;
  final int? year, coverId;
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
    authors: (json['author_name'] as List<dynamic>? ?? []).cast<String>(),
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );
}

class ShelfItem {
  final String id, title, subtitle;
  final String? image;
  const ShelfItem(this.id, this.title, this.subtitle, this.image);
}

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final json = await getJson(
      Uri.https('openlibrary.org', '/search.json', {
        'q': query,
        'fields': 'key,title,author_name,first_publish_year,cover_i',
        'limit': '20',
      }),
    );
    return (json['docs'] as List<dynamic>)
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PickDetails> details(String id) async {
    final json = await getJson(Uri.https('openlibrary.org', '/works/$id.json'));
    final summary = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };
    final covers = json['covers'] as List<dynamic>? ?? [];
    final cover = covers.whereType<int>().where((id) => id > 0).firstOrNull;
    return PickDetails(
      json['title'] as String? ?? 'Untitled',
      summary,
      cover == null ? null : 'https://covers.openlibrary.org/b/id/$cover-L.jpg',
      json['first_publish_date'] as String? ?? 'Publication year unavailable',
    );
  }
}

class OmdbApi {
  Future<Map<String, dynamic>> request(Map<String, String> params) async {
    if (omdbKey.isEmpty) throw ApiException('Set OMDB_KEY to load movies.');
    final json = await getJson(
      Uri.https('www.omdbapi.com', '/', {'apikey': omdbKey, ...params}),
    );
    if (json['Response'] == 'False' && json['Error'] != 'Movie not found!') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }
    return json;
  }

  Future<List<ShelfItem>> search(String query) async {
    final json = await request({'s': query, 'type': 'movie'});
    return (json['Search'] as List<dynamic>? ?? [])
        .map(
          (e) => ShelfItem(
            e['imdbID'] as String,
            e['Title'] as String,
            e['Year'] as String,
            e['Poster'] == 'N/A' ? null : e['Poster'] as String?,
          ),
        )
        .toList();
  }

  Future<PickDetails> details(String id) async {
    final json = await request({'i': id, 'plot': 'short'});
    if (json['Response'] == 'False') throw ApiException('Movie not found!');
    return PickDetails(
      json['Title'] as String,
      json['Plot'] == 'N/A' ? 'No summary available.' : json['Plot'] as String,
      json['Poster'] == 'N/A' ? null : json['Poster'] as String?,
      json['Year'] as String? ?? 'Year unavailable',
    );
  }
}

class Pick {
  final String title, kind, externalId, note;
  const Pick(this.title, this.kind, this.externalId, this.note);
  factory Pick.fromJson(Map<String, dynamic> json) {
    final kind = json['kind'] as String? ?? '';
    final id = json['externalId'] as String? ?? '';
    if (!['book', 'movie'].contains(kind) ||
        !(kind == 'book' ? RegExp(r'^OL\d+W$') : RegExp(r'^tt\d+$')).hasMatch(
          id,
        )) {
      throw ApiException('A CMS pick has an invalid kind or externalId.');
    }
    return Pick(
      json['title'] as String? ?? 'Untitled',
      kind,
      id,
      json['note'] as String? ?? '',
    );
  }
}

abstract interface class PickSource {
  Future<List<Pick>> fetchPicks();
}

class ContentfulPickSource implements PickSource {
  @override
  Future<List<Pick>> fetchPicks() async {
    const space = String.fromEnvironment('CMS_SPACE');
    const token = String.fromEnvironment('CMS_TOKEN');
    const environment = String.fromEnvironment(
      'CMS_ENVIRONMENT',
      defaultValue: 'master',
    );
    if (space.isEmpty || token.isEmpty) {
      throw ApiException(
        'Pass CMS_SPACE and CMS_TOKEN using --dart-define-from-file=cms.json.',
      );
    }
    final picks = <Pick>[];
    var skip = 0;
    while (true) {
      final json = await getJson(
        Uri.https(
          'cdn.contentful.com',
          '/spaces/$space/environments/$environment/entries',
          {'content_type': 'pick', 'limit': '100', 'skip': '$skip'},
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      final items = json['items'] as List<dynamic>;
      picks.addAll(
        items.map((e) => Pick.fromJson(e['fields'] as Map<String, dynamic>)),
      );
      skip += items.length;
      if (items.isEmpty || skip >= (json['total'] as int)) break;
    }
    return picks;
  }
}

class PickDetails {
  final String title, summary, year;
  final String? image;
  const PickDetails(this.title, this.summary, this.image, this.year);
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});
  @override
  Widget build(BuildContext context) => DefaultTabController(
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
        children: [PicksTab(), SearchTab(movie: false), SearchTab(movie: true)],
      ),
    ),
  );
}

class Cover extends StatelessWidget {
  final String? url;
  final bool movie;
  const Cover(this.url, {super.key, this.movie = false});
  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      movie ? Icons.movie_outlined : Icons.menu_book,
      size: 40,
    );
    return SizedBox(
      width: 56,
      height: 78,
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              fit: BoxFit.contain,
              errorBuilder: (_, error, stack) => placeholder,
            ),
    );
  }
}

class SearchTab extends StatefulWidget {
  final bool movie;
  const SearchTab({super.key, required this.movie});
  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with AutomaticKeepAliveClientMixin {
  Timer? _debounce;
  Future<List<ShelfItem>>? _results;
  @override
  bool get wantKeepAlive => true;
  void _onChanged(String text) {
    _debounce?.cancel();
    setState(() => _results = null);
    final query = text.trim();
    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _results = widget.movie
            ? OmdbApi().search(query)
            : OpenLibraryApi()
                  .search(query)
                  .then(
                    (books) => books
                        .map(
                          (b) => ShelfItem(
                            b.workId,
                            b.title,
                            '${b.authors.firstOrNull ?? 'Unknown author'} • ${b.year ?? 'Year unknown'}',
                            b.coverId == null
                                ? null
                                : 'https://covers.openlibrary.org/b/id/${b.coverId}-M.jpg',
                          ),
                        )
                        .toList(),
                  );
        _results!.ignore();
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
    super.build(context);
    if (widget.movie && omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SelectableText(
            'Get an OMDb key at omdbapi.com/apikey.aspx. Add OMDB_KEY to cms.json, then restart with flutter run --dart-define-from-file=cms.json.',
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              labelText: widget.movie ? 'Search movies' : 'Search books',
              hintText: 'Type at least 3 characters',
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(
                  child: Text('Type at least 3 characters to search.'),
                )
              : FutureBuilder<List<ShelfItem>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Search failed: ${snapshot.error}\nEdit your search to try again.',
                          ),
                        ),
                      );
                    }
                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: Cover(item.image, movie: widget.movie),
                          title: Text(item.title),
                          subtitle: Text('${item.subtitle}\n${item.id}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Copy ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: item.id),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied ${item.id}')),
                                );
                              }
                            },
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

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});
  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource source = ContentfulPickSource();
  late Future<List<Pick>> _picks;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _picks = source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = source.fetchPicks();
    setState(() {
      _picks = next;
    });
    try {
      await next;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Pick>>(
        future: _picks,
        builder: (context, snapshot) {
          final picks = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              picks.isNotEmpty) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: picks.length,
              itemBuilder: (context, i) {
                final pick = picks[i];
                return ListTile(
                  leading: Icon(
                    pick.kind == 'book' ? Icons.menu_book : Icons.movie,
                  ),
                  title: Text(pick.title),
                  subtitle: Text(pick.note),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PickDetailScreen(pick: pick),
                    ),
                  ),
                );
              },
            );
          }
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              if (snapshot.connectionState != ConnectionState.done)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.hasError)
                Text('Could not load picks: ${snapshot.error}')
              else
                const Text('No picks yet. Publish your picks in Contentful.'),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
            ],
          );
        },
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
  late Future<PickDetails> _details;
  Future<PickDetails> _load() => widget.pick.kind == 'book'
      ? OpenLibraryApi().details(widget.pick.externalId)
      : OmdbApi().details(widget.pick.externalId);
  @override
  void initState() {
    super.initState();
    _details = _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.pick.title)),
    body: FutureBuilder<PickDetails>(
      future: _details,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('${snapshot.error}'),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _details = _load();
                  }),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final details = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: SizedBox(
                height: 230,
                child: details.image == null
                    ? Icon(
                        widget.pick.kind == 'book'
                            ? Icons.menu_book
                            : Icons.movie,
                        size: 80,
                      )
                    : Image.network(
                        details.image!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, error, stack) =>
                            const Icon(Icons.broken_image, size: 80),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              details.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(details.year),
            const SizedBox(height: 20),
            Text(
              'Why I recommend it',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(widget.pick.note),
            const SizedBox(height: 20),
            Text('Summary', style: Theme.of(context).textTheme.titleMedium),
            Text(details.summary),
          ],
        );
      },
    ),
  );
}
