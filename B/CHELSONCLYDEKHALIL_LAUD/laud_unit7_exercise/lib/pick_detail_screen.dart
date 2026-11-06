import 'package:flutter/material.dart';
import 'models.dart';
import 'services/open_library_api.dart';
import 'services/omdb_api.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;
  final String omdbKey;

  const PickDetailScreen({
    super.key,
    required this.pick,
    required this.omdbKey,
  });

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future _detailsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.pick.kind == 'book') {
      _detailsFuture = OpenLibraryApi().fetchDetails(widget.pick.externalId);
    } else {
      _detailsFuture = OmdbApi(apiKey: widget.omdbKey).fetchDetails(widget.pick.externalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBook = widget.pick.kind == 'book';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pick.title),
        elevation: 2,
      ),
      body: FutureBuilder(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          String? imageUrl;
          String summary = '';

          if (isBook) {
            final covers = data['covers'] as List<dynamic>?;
            if (covers != null && covers.isNotEmpty) {
              imageUrl = 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg';
            }
            summary = switch (data['description']) {
              final String text => text,
              {'value': final String text} => text,
              _ => 'No description yet.',
            };
          } else {
            final poster = data['Poster'] as String?;
            if (poster != null && poster != 'N/A') imageUrl = poster;
            summary = data['Plot'] as String? ?? 'No plot available.';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                    ),
                  )
                else
                  Icon(isBook ? Icons.book : Icons.movie, size: 120),
                const SizedBox(height: 16),
                Text(
                  widget.pick.title,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${isBook ? "Book" : "Movie"} · ${widget.pick.externalId}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 16),
                Card(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Why I recommend it', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('"${widget.pick.note}"', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(summary, style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}