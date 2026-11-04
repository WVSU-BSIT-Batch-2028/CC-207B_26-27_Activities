import 'package:flutter/material.dart';

import '../config.dart';
import '../models/pick.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchDetail();
  }

  // Retry: called when the user taps the retry button on the error screen.
  void _retry() => setState(() => _future = _fetchDetail());

  Future<Map<String, dynamic>> _fetchDetail() {
    final pick = widget.pick;

    // Guard: externalId must not be empty.
    if (pick.externalId.trim().isEmpty) {
      return Future.error(
        'This pick has no external ID stored in the CMS. '
        'Check the externalId field for "${pick.title}".',
      );
    }

    if (pick.kind == PickKind.movie) {
      // Guard: OMDb key must be provided via --dart-define=OMDB_KEY=...
      if (omdbKey.isEmpty) {
        return Future.error(
          'No OMDb API key found.\n\n'
          'Run the app with:\n'
          'flutter run --dart-define=OMDB_KEY=your-key\n'
          '             --dart-define=CMS_URL=your-cms-url',
        );
      }
      return OmdbApi(omdbKey).fetchDetail(pick.externalId.trim());
    }

    // Book: fetch from Open Library works/<id>.json
    return OpenLibraryApi().fetchDetail(pick.externalId.trim());
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final isMovie = pick.kind == PickKind.movie;
    final kindLabel = isMovie ? 'Movie' : 'Book';
    final sourceLabel = isMovie
        ? 'OMDb · ${pick.externalId}'
        : 'Open Library · ${pick.externalId}';

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          // ── Loading ──
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ── Error ──
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48,
                        color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── Success ──
          final data = snapshot.data ?? const {};

          final title = isMovie
              ? (data['Title'] as String? ?? pick.title)
              : (data['title'] as String? ?? pick.title);

          final imageUrl = isMovie ? _moviePoster(data) : _bookCover(data);

          final description = isMovie
              ? (data['Plot'] as String? ?? 'No description yet.')
              : _openLibraryDescription(data);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Cover / poster image
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 120,
                      child: Center(
                          child: Icon(Icons.image_not_supported, size: 64)),
                    ),
                  ),
                )
              else
                const SizedBox(
                  height: 120,
                  child: Center(
                      child: Icon(Icons.image_not_supported, size: 64)),
                ),
              const SizedBox(height: 16),

              // Title
              Text(title,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),

              // "Book · Open Library · OL27482W"
              Text(
                '$kindLabel · $sourceLabel',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // "Why I recommend it" note card (spec Part D.d)
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why I recommend it',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              pick.note,
                              style:
                                  Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Summary / plot
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.5),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  String _openLibraryDescription(Map<String, dynamic> data) {
    final raw = data['description'];
    String text;
    if (raw is String) {
      text = raw;
    } else if (raw is Map && raw['value'] is String) {
      text = raw['value'] as String;
    } else {
      text = '';
    }
    return text.isNotEmpty ? text : 'No description yet.';
  }

  String _bookCover(Map<String, dynamic> data) {
    final covers = data['covers'];
    if (covers is List && covers.isNotEmpty) {
      final first = covers.first;
      if (first is int) {
        return 'https://covers.openlibrary.org/b/id/$first-M.jpg';
      }
    }
    return '';
  }

  String _moviePoster(Map<String, dynamic> data) {
    final poster = data['Poster'];
    if (poster is String && poster != 'N/A') return poster;
    return '';
  }
}
