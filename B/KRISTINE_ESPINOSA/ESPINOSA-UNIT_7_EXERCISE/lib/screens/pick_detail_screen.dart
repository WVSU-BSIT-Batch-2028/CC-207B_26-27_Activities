import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../models/pick.dart';
import 'shelf_widgets.dart';

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
  late Future<PickDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<PickDetails> _load() {
    final pick = widget.pick;
    if (pick.externalId.isEmpty) {
      return Future.error(const ApiException('This pick has no externalId.'));
    }
    if (pick.kind == PickKind.book) return widget.books.details(pick.externalId);
    if (widget.movies.apiKey.isEmpty) {
      return Future.error(
        const ApiException('No OMDb key. Run with --dart-define=OMDB_KEY=...'),
      );
    }
    return widget.movies.details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final textTheme = Theme.of(context).textTheme;
    final isBook = pick.kind == PickKind.book;

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<PickDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CenterMessage(
              icon: Icons.hourglass_top,
              text: 'Loading details...',
              spinner: true,
            );
          }
          if (snapshot.hasError) {
            return CenterMessage(
              icon: Icons.cloud_off,
              text: '${snapshot.error}',
              action: FilledButton.icon(
                onPressed: () => setState(() {
                  _future = _load();
                }),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            );
          }
          final details = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CoverImage(
                        url: details.imageUrl,
                        fallbackIcon: isBook ? Icons.menu_book : Icons.movie,
                        width: 180,
                        height: 270,
                        label: 'Cover of ${details.title}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(details.title, style: textTheme.headlineSmall),
                    if (details.subtitle.isNotEmpty)
                      Text(details.subtitle, style: textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('My note', style: textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(pick.note, style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Summary', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(details.summary, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
