import 'dart:async';

import 'package:flutter/material.dart';

import 'api.dart';
import 'config.dart';
import 'models.dart';
import 'pick_detail_screen.dart';
import 'widgets.dart';

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
        body: const TabBarView(
          children: [MyPicksTab(), BooksTab(), MoviesTab()],
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

class _MyPicksTabState extends State<MyPicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = ContentfulPickSource(
    spaceId: cmsSpace,
    token: cmsToken,
  );
  late Future<List<Pick>> _picks;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _picks = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = _source.fetchPicks();
    setState(() => _picks = next);
    try {
      await next;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AsyncListView<Pick>(
      future: _picks,
      emptyText: 'No picks yet. Publish some in your CMS.',
      onRefresh: _refresh,
      itemBuilder: (context, pick) => ListTile(
        leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
        title: Text(pick.title),
        subtitle: Text(pick.note, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
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

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  final OpenLibraryApi api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  @override
  bool get wantKeepAlive => true;

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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SearchField(label: 'Search books, e.g. hobbit', onChanged: _onChanged),
        Expanded(
          child: AsyncListView<Book>(
            future: _results,
            idleText: 'Type at least 3 letters to search.',
            emptyText: 'Nothing found.',
            itemBuilder: (context, book) {
              final author = book.authors.isEmpty
                  ? 'Unknown author'
                  : book.authors.first;
              return ListTile(
                leading: Cover(url: book.coverUrl),
                title: Text(book.title),
                subtitle: Text('$author · ${book.year ?? 'year unknown'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy ID',
                  onPressed: () => copyId(context, book.workId),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MoviesTab extends StatefulWidget {
  const MoviesTab({super.key});

  @override
  State<MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  final OmdbApi api = OmdbApi();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  @override
  bool get wantKeepAlive => true;

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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (omdbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The OMDb key is missing. Run the app like this:',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              SelectableText(
                'flutter run -d chrome --dart-define=OMDB_KEY=your-key',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'or put OMDB_KEY in cms.json and use --dart-define-from-file=cms.json',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SearchField(
          label: 'Search movies, e.g. interstellar',
          onChanged: _onChanged,
        ),
        Expanded(
          child: AsyncListView<Movie>(
            future: _results,
            idleText: 'Type at least 3 letters to search.',
            emptyText: 'Nothing found.',
            itemBuilder: (context, movie) => ListTile(
              leading: Cover(url: movie.poster, icon: Icons.movie),
              title: Text(movie.title),
              subtitle: Text(movie.year),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy ID',
                onPressed: () => copyId(context, movie.imdbId),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
