import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../models/book.dart';
import '../models/movie.dart';
import '../models/pick.dart';
import '../services/contentful_pick_source.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';
import '../services/pick_source.dart';
import 'pick_detail_screen.dart';

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  final _books = OpenLibraryApi();
  final _movies = OmdbApi();
  final _picks = ContentfulPickSource();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Material(
            color: Colors.transparent,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
                Tab(icon: Icon(Icons.menu_book), text: 'Books'),
                Tab(icon: Icon(Icons.movie), text: 'Movies'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                PicksTab(source: _picks, books: _books, movies: _movies),
                BookSearchTab(api: _books),
                MovieSearchTab(api: _movies),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- My Picks

class PicksTab extends StatefulWidget {
  const PicksTab({
    super.key,
    required this.source,
    required this.books,
    required this.movies,
  });

  final PickSource source;
  final OpenLibraryApi books;
  final OmdbApi movies;

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin<PicksTab> {
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.source.fetchPicks();
  }

  Future<void> _refresh() async {
    final next = widget.source.fetchPicks();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } catch (_) {
      // The FutureBuilder shows the error. Refresh just needs to finish.
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder<List<Pick>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ShelfMessage(
            message: snapshot.error.toString(),
            action: _refresh,
          );
        }
        final picks = snapshot.data ?? const <Pick>[];
        return RefreshIndicator(
          onRefresh: _refresh,
          child: picks.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 180),
                    Center(child: Text('No picks yet.')),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: picks.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: colors.outlineVariant),
                  itemBuilder: (context, index) {
                    final pick = picks[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Icon(
                        pick.kind == PickKind.book
                            ? Icons.menu_book
                            : Icons.movie,
                        color: colors.onSurfaceVariant,
                      ),
                      title: Text(
                        pick.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        pick.note.isEmpty ? 'No note yet.' : pick.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PickDetailScreen(
                            pick: pick,
                            books: widget.books,
                            movies: widget.movies,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// ------------------------------------------------------------------- Books

class BookSearchTab extends StatefulWidget {
  const BookSearchTab({super.key, required this.api});

  final OpenLibraryApi api;

  @override
  State<BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends State<BookSearchTab>
    with AutomaticKeepAliveClientMixin<BookSearchTab> {
  final _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(text));
  }

  void _search(String text) {
    final query = text.trim();
    if (query.length < 3 || !mounted) return;
    // The braces matter. setState must not return the Future.
    setState(() {
      _results = widget.api.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _SearchLayout<Book>(
      controller: _controller,
      hint: 'Search books, e.g. hobbit',
      onChanged: _onChanged,
      onSubmitted: _search,
      future: _results,
      emptyHint: 'Type at least 3 letters to search for a book.',
      itemBuilder: (book) => _ResultRow(
        image: book.coverId == null
            ? null
            : 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
        title: book.title,
        subtitle: [
          if (book.authors.isNotEmpty) book.authors.first,
          if (book.year != null) book.year.toString(),
        ].join(' · '),
        id: book.workId,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

// ------------------------------------------------------------------ Movies

class MovieSearchTab extends StatefulWidget {
  const MovieSearchTab({super.key, required this.api});

  final OmdbApi api;

  @override
  State<MovieSearchTab> createState() => _MovieSearchTabState();
}

class _MovieSearchTabState extends State<MovieSearchTab>
    with AutomaticKeepAliveClientMixin<MovieSearchTab> {
  final _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(text));
  }

  void _search(String text) {
    final query = text.trim();
    if (query.length < 3 || !mounted) return;
    setState(() {
      _results = widget.api.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (omdbKey.isEmpty) {
      return const _ShelfMessage(
        message:
            'Add an OMDb key before searching.\n\n'
            'flutter run --dart-define-from-file=dart_defines.json\n\n'
            'or\n\n'
            'flutter run --dart-define=OMDB_KEY=your-key '
            '--dart-define=CMS_SPACE=your-space-id '
            '--dart-define=CMS_TOKEN=your-content-delivery-token',
      );
    }
    return _SearchLayout<Movie>(
      controller: _controller,
      hint: 'Search movies, e.g. interstellar',
      onChanged: _onChanged,
      onSubmitted: _search,
      future: _results,
      emptyHint: 'Type at least 3 letters to search for a movie.',
      itemBuilder: (movie) => _ResultRow(
        image: movie.poster,
        title: movie.title,
        subtitle: movie.year,
        id: movie.imdbId,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

// ------------------------------------------------------------ Shared parts

class _SearchLayout<T> extends StatelessWidget {
  const _SearchLayout({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
    required this.future,
    required this.emptyHint,
    required this.itemBuilder,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final Future<List<T>>? future;
  final String emptyHint;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: hint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
        Expanded(
          child: future == null
              ? Center(child: Text(emptyHint))
              : FutureBuilder<List<T>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return _ShelfMessage(
                        message: snapshot.error.toString(),
                        action: () => onSubmitted(controller.text),
                      );
                    }
                    final items = snapshot.data ?? <T>[];
                    if (items.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: colors.outlineVariant),
                      itemBuilder: (_, index) => itemBuilder(items[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.id,
  });

  final String? image;
  final String title;
  final String subtitle;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _ShelfCover(url: image),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle.isEmpty ? 'Details unavailable' : subtitle),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.content_copy_outlined),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: id));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ID copied  $id')),
            );
          }
        },
      ),
    );
  }
}

class _ShelfMessage extends StatelessWidget {
  const _ShelfMessage({required this.message, this.action});

  final String message;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: action, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShelfCover extends StatelessWidget {
  const _ShelfCover({required this.url});

  final String? url;

  static const double _width = 40;
  static const double _height = 56;

  @override
  Widget build(BuildContext context) {
    final placeholder = SizedBox(
      width: _width,
      height: _height,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.network(
        url!,
        width: _width,
        height: _height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}
