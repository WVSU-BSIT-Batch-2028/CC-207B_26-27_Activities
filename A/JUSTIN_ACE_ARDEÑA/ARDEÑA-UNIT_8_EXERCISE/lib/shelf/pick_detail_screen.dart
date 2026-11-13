import 'package:flutter/material.dart';

import 'api_exception.dart';
import 'config.dart';
import 'omdb_api.dart';
import 'open_library_api.dart';
import 'pick.dart';

/// Details of one pick, loaded from the right API with its externalId.
class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<PickDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  // book -> Open Library works/<id>.json, movie -> OMDb ?i=<id>.
  // async, so a throw (no key, unknown kind) becomes an error in the Future
  // and the screen shows it, instead of crashing initState.
  Future<PickDetail> _load() async {
    final pick = widget.pick;
    switch (pick.kind) {
      case 'book':
        return OpenLibraryApi().work(pick.externalId);
      case 'movie':
        if (omdbKey.isEmpty) {
          throw const ApiException(
            'No OMDb key. Run with --dart-define=OMDB_KEY=your-key',
          );
        }
        return OmdbApi().details(pick.externalId);
      default:
        throw ApiException('Unknown kind "${pick.kind}" (use book or movie).');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    return Scaffold(
      appBar: AppBar(title: Text(pick.title, overflow: TextOverflow.ellipsis)),
      body: FutureBuilder<PickDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }
          return _buildDetail(context, snapshot.data!);
        },
      ),
    );
  }

  Widget _buildDetail(BuildContext context, PickDetail detail) {
    final textTheme = Theme.of(context).textTheme;
    final image = detail.imageUrl;
    final note = widget.pick.note;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 240,
          child: image == null
              ? Icon(widget.pick.isBook ? Icons.menu_book : Icons.movie,
                  size: 96)
              : Image.network(
                  image,
                  fit: BoxFit.contain,
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 96),
                ),
        ),
        const SizedBox(height: 16),
        Text(detail.title, style: textTheme.headlineSmall),
        const SizedBox(height: 16),
        // My note: a rounded card with a quote icon, a heading and the text.
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_quote, size: 28),
              const SizedBox(width: 12),
              // Expanded lets a long note wrap instead of overflowing.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Why I recommend it', style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(note.isEmpty ? 'No note.' : note),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(widget.pick.isBook ? 'Description' : 'Plot',
            style: textTheme.titleMedium),
        Text(detail.description),
      ],
    );
  }
}
