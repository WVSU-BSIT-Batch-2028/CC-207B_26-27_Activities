import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/movie.dart';
import '../models/pick.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';

class _PickDetails {
  final String title;
  final String summary;
  final String? imageUrl;

  const _PickDetails({
    required this.title,
    required this.summary,
    this.imageUrl,
  });
}

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<_PickDetails> _detailsFuture = _loadDetails();

  Future<_PickDetails> _loadDetails() async {
    if (widget.pick.isBook) {
      final BookDetails details = await OpenLibraryApi().fetchDetails(
        widget.pick.externalId,
      );
      return _PickDetails(
        title: details.title,
        summary: details.description,
        imageUrl: details.coverUrl,
      );
    }

    if (widget.pick.isMovie) {
      final MovieDetails details = await const OmdbApi(
        apiKey: String.fromEnvironment('OMDB_KEY'),
      ).fetchDetails(widget.pick.externalId);
      return _PickDetails(
        title: details.title,
        summary: details.plot,
        imageUrl: details.posterUrl,
      );
    }

    throw Exception('Unknown pick type: ${widget.pick.kind}');
  }

  @override
  Widget build(BuildContext context) {
    final isBook = widget.pick.isBook;
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<_PickDetails>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load details: ${snapshot.error}'),
              ),
            );
          }

          final details = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (details.imageUrl != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      details.imageUrl!,
                      height: 260,
                      width: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => _imageFallback(isBook),
                    ),
                  ),
                )
              else
                Center(child: _imageFallback(isBook)),
              const SizedBox(height: 20),
              Text(
                details.title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My note', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(widget.pick.note.isEmpty ? 'No note added.' : widget.pick.note),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(details.summary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${isBook ? 'Open Library work ID' : 'IMDb ID'}: ${widget.pick.externalId}',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _imageFallback(bool isBook) => Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isBook ? Icons.menu_book_outlined : Icons.movie_outlined,
          size: 64,
        ),
      );
}
