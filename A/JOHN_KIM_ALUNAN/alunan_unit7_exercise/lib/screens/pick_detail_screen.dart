import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/movie.dart';
import '../models/pick.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';

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
  late Future<Object> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Object> _load() => widget.pick.kind == PickKind.book
      ? widget.books.fetchWork(widget.pick.externalId)
      : widget.movies.fetchById(widget.pick.externalId);

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final isBook = pick.kind == PickKind.book;
    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<Object>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _Message(
              message: snapshot.error.toString(),
              action: _retry,
            );
          }
          final details = snapshot.data;
          final String title;
          final String? year;
          final String summary;
          final String? imageUrl;
          if (details is BookDetails) {
            title = details.title;
            year = details.year?.toString();
            summary = details.description;
            imageUrl = details.coverId == null
                ? null
                : 'https://covers.openlibrary.org/b/id/${details.coverId}-L.jpg';
          } else if (details is MovieDetails) {
            title = details.title;
            year = details.year;
            summary = details.plot;
            imageUrl = details.poster;
          } else {
            return const _Message(message: 'No details found.');
          }

          final textTheme = Theme.of(context).textTheme;
          final colors = Theme.of(context).colorScheme;
          final source = isBook ? 'Open Library' : 'OMDb';
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Center(child: _Cover(url: imageUrl, width: 170, height: 240)),
              const SizedBox(height: 20),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isBook ? 'Book' : 'Movie'} · $source ${pick.externalId}'
                '${year != null && year.isNotEmpty ? ' · $year' : ''}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.format_quote, color: colors.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why I recommend it',
                            style: textTheme.labelLarge?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pick.note.isEmpty ? 'No note yet.' : pick.note,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(summary, style: textTheme.bodyMedium),
            ],
          );
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.message, this.action});

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

class _Cover extends StatelessWidget {
  const _Cover({required this.url, required this.width, required this.height});

  final String? url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported_outlined, size: 40),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}
