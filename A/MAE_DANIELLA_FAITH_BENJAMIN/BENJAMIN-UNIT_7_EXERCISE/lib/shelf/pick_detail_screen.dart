import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'data/omdb_api.dart';
import 'data/open_library_api.dart';
import 'models/media_details.dart';
import 'models/pick.dart';
import 'widgets/media_artwork.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final http.Client _client;
  late Future<MediaDetails> _future;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _future = _loadDetails();
  }

  Future<MediaDetails> _loadDetails() async {
    if (widget.pick.kind == PickKind.book) {
      final book = await OpenLibraryApi(_client)
          .fetchDetails(widget.pick.externalId);
      return MediaDetails(
        title: book.title,
        year: book.year ?? 'Year unavailable',
        summary: book.summary,
        artworkUrl: book.coverUrl,
      );
    }
    final movie = await OmdbApi(
      _client,
      apiKey: omdbKey,
    ).fetchDetails(widget.pick.externalId);
    return MediaDetails(
      title: movie.title,
      year: movie.year,
      summary: movie.summary,
      artworkUrl: movie.posterUrl,
    );
  }

  void _retry() {
    setState(() {
      _future = _loadDetails();
    });
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.pick.title)),
    body: FutureBuilder<MediaDetails>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 42),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        final details = snapshot.data!;
        final isBook = widget.pick.kind == PickKind.book;
        final colorScheme = Theme.of(context).colorScheme;
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: MediaArtwork(
                url: details.artworkUrl,
                icon: isBook ? Icons.menu_book : Icons.movie,
                width: 190,
                height: 280,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              details.title.isEmpty ? widget.pick.title : details.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              '${isBook ? 'Book' : 'Movie'} · ${isBook ? 'Open Library ID' : 'IMDb ID'}: ${widget.pick.externalId}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              details.year,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.favorite, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why I recommend it',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.pick.note,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Summary', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              details.summary.isEmpty
                  ? 'No summary available.'
                  : details.summary,
            ),
          ],
        );
      },
    ),
  );
}
