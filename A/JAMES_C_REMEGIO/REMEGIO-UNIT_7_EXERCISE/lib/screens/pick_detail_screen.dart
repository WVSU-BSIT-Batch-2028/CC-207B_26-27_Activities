import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../api/omdb_api.dart';
import '../api/open_library_api.dart';
import '../config.dart';
import '../models/book_details.dart';
import '../models/movie_details.dart';
import '../models/pick.dart';
import '../widgets/cover_image.dart';
import '../widgets/omdb_setup_message.dart';
import '../widgets/state_message.dart';

/// Cover, year, CMS note, and API summary for one pick.
class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({
    super.key,
    required this.pick,
    this.books,
    this.movies,
    this.apiKey = omdbKey,
  });

  final Pick pick;
  final OpenLibraryApi? books;
  final OmdbApi? movies;
  final String apiKey;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final OpenLibraryApi _books;
  late final OmdbApi _movies;
  late final bool _ownsBooks;
  late final bool _ownsMovies;
  late Future<_PickView> _future;

  @override
  void initState() {
    super.initState();
    _ownsBooks = widget.books == null;
    _ownsMovies = widget.movies == null;
    _books = widget.books ?? OpenLibraryApi();
    _movies = widget.movies ?? OmdbApi(apiKey: widget.apiKey);
    _future = _load();
  }

  @override
  void dispose() {
    if (_ownsBooks) _books.close();
    if (_ownsMovies) _movies.close();
    super.dispose();
  }

  Future<_PickView> _load() async {
    final Pick pick = widget.pick;
    if (pick.isBook) {
      final BookDetails details = await _books.fetchWork(pick.externalId);
      return _PickView(
        title: details.title,
        year: details.year?.toString(),
        imageUrl: details.coverUrl,
        summary: details.summary,
        imageLabel: 'Cover of ${details.title}',
        fallbackIcon: Icons.menu_book_outlined,
      );
    }
    if (pick.isMovie) {
      if (widget.apiKey.trim().isEmpty) throw const MissingOmdbKey();
      final MovieDetails details = await _movies.fetchById(pick.externalId);
      return _PickView(
        title: details.title,
        year: details.year,
        imageUrl: details.posterUrl,
        summary: details.summary,
        imageLabel: 'Poster of ${details.title}',
        fallbackIcon: Icons.movie_outlined,
      );
    }
    throw ApiException(
      'This pick\'s kind is "${pick.kind}". It must be book or movie.',
    );
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<_PickView>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<_PickView> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: StateMessage(
                icon: Icons.downloading_outlined,
                text: 'Loading details…',
                showSpinner: true,
              ),
            );
          }
          if (snapshot.hasError) {
            if (snapshot.error is MissingOmdbKey) {
              return const OmdbSetupMessage();
            }
            return Center(
              child: StateMessage(
                icon: Icons.cloud_off,
                text: messageOf(snapshot.error!),
                action: FilledButton(
                  onPressed: _retry,
                  child: const Text('Try again'),
                ),
              ),
            );
          }
          return _DetailBody(pick: widget.pick, view: snapshot.data!);
        },
      ),
    );
  }
}

class _PickView {
  const _PickView({
    required this.title,
    required this.year,
    required this.imageUrl,
    required this.summary,
    required this.imageLabel,
    required this.fallbackIcon,
  });

  final String title;
  final String? year;
  final String? imageUrl;
  final String summary;
  final String imageLabel;
  final IconData fallbackIcon;
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.pick, required this.view});

  final Pick pick;
  final _PickView view;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String note = pick.note.trim().isEmpty
        ? 'No recommendation note yet.'
        : pick.note.trim();
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CoverImage(
                      url: view.imageUrl,
                      fallbackIcon: view.fallbackIcon,
                      semanticLabel: view.imageLabel,
                      width: 120,
                      height: 180,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            view.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                          if (view.year != null) ...<Widget>[
                            const SizedBox(height: 8),
                            Text(
                              view.year!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TextCard(title: 'My recommendation', body: note),
            const SizedBox(height: 16),
            _TextCard(title: 'Summary', body: view.summary),
          ],
        ),
      ),
    );
  }
}

class _TextCard extends StatelessWidget {
  const _TextCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
