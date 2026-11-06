import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/book.dart';
import '../data/movie.dart';
import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../data/pick.dart';
import 'catalog_search_tab.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({
    super.key,
    required this.pick,
    required this.books,
    required this.movies,
  });

  final Pick pick;
  final OpenLibraryApi books;
  final OmdbApi movies;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Object> _details;

  @override
  void initState() {
    super.initState();
    _details = _loadDetails();
  }

  Future<Object> _loadDetails() => switch (widget.pick.kind) {
    PickKind.book => widget.books.getDetails(widget.pick.externalId),
    PickKind.movie => widget.movies.getDetails(widget.pick.externalId),
  };

  void _retry() {
    final request = _loadDetails();
    setState(() {
      _details = request;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<Object>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error is ApiException
                ? error.message
                : 'Could not load details. Please try again.';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try again'),
                    ),
                    const SizedBox(height: 20),
                    _NoteCard(note: widget.pick.note),
                  ],
                ),
              ),
            );
          }

          final details = snapshot.data;
          return switch (details) {
            BookDetails book => _DetailContent(
              pick: widget.pick,
              title: book.title,
              year: book.year?.toString(),
              summary: book.summary,
              imageUrl: book.coverId == null
                  ? null
                  : 'https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg',
              icon: Icons.menu_book_rounded,
            ),
            Movie movie => _DetailContent(
              pick: widget.pick,
              title: movie.title,
              year: movie.year,
              summary: movie.plot ?? 'No plot summary available.',
              imageUrl: movie.hasPoster ? movie.poster : null,
              icon: Icons.movie_outlined,
            ),
            _ => const Center(child: Text('No details available.')),
          };
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.pick,
    required this.title,
    required this.year,
    required this.summary,
    required this.imageUrl,
    required this.icon,
  });

  final Pick pick;
  final String title;
  final String? year;
  final String summary;
  final String? imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CatalogCover(
                    icon: icon,
                    imageUrl: imageUrl,
                    width: 180,
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.headlineSmall),
              if (year != null) ...[
                const SizedBox(height: 4),
                Text(year!, style: theme.textTheme.bodyMedium),
              ],
              const SizedBox(height: 16),
              _NoteCard(note: pick.note),
              const SizedBox(height: 16),
              Text(
                'About this ${pick.kind.name}',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(summary, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      color: colors.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WHY I RECOMMEND IT',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colors.onSecondaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note.isEmpty ? 'No recommendation note yet.' : note,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colors.onSecondaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
