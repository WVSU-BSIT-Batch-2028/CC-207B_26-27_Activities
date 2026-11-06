import 'package:flutter/material.dart';

import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../models/pick.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final OpenLibraryApi _openLibrary = OpenLibraryApi();
  late final OmdbApi _omdb = OmdbApi(apiKey: omdbKey);
  late final Future<_PickDetails> _details;

  @override
  void initState() {
    super.initState();
    _details = _loadDetails();
  }

  Future<_PickDetails> _loadDetails() async {
    if (widget.pick.externalId.isEmpty) {
      throw StateError('This pick has no external ID.');
    }

    if (widget.pick.kind == 'book') {
      final book = await _openLibrary.getDetails(widget.pick.externalId);
      return _PickDetails(
        title: book.title,
        year: book.year,
        imageUrl: book.coverId == null
            ? null
            : 'https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg',
        summary: book.description,
      );
    }

    final movie = await _omdb.getDetails(widget.pick.externalId);
    return _PickDetails(
      title: movie.title,
      year: movie.year,
      imageUrl: movie.poster == 'N/A' || movie.poster.isEmpty
          ? null
          : movie.poster,
      summary: movie.plot.isEmpty ? 'No plot available.' : movie.plot,
    );
  }

  @override
  void dispose() {
    _openLibrary.close();
    _omdb.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pick.title)),
      body: FutureBuilder<_PickDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Could not load details: ${snapshot.error}'));
          }

          final details = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: details.imageUrl == null
                    ? Icon(
                        widget.pick.kind == 'book'
                            ? Icons.book
                            : Icons.movie,
                        size: 120,
                      )
                    : Image.network(
                        details.imageUrl!,
                        height: 280,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Icon(
                          widget.pick.kind == 'book'
                              ? Icons.book
                              : Icons.movie,
                          size: 120,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Text(details.title, style: Theme.of(context).textTheme.headlineSmall),
              if (details.year != null && details.year!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(details.year!),
              ],
              const SizedBox(height: 20),
              Text('My note', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(widget.pick.note),
              const SizedBox(height: 20),
              Text('Summary', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(details.summary),
            ],
          );
        },
      ),
    );
  }
}

class _PickDetails {
  const _PickDetails({
    required this.title,
    required this.year,
    required this.imageUrl,
    required this.summary,
  });

  final String title;
  final String? year;
  final String? imageUrl;
  final String summary;
}
