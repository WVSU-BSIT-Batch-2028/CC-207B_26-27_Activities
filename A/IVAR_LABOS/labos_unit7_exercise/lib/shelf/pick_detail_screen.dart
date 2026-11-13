import 'package:flutter/material.dart';

import 'api_exception.dart';
import 'config.dart';
import 'item_details.dart';
import 'message_view.dart';
import 'omdb_api.dart';
import 'open_library_api.dart';
import 'pick.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<ItemDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// The pick only has an ID: ask the right API for everything else.
  Future<ItemDetails> _load() {
    final pick = widget.pick;
    switch (pick.kind) {
      case PickKind.book:
        return OpenLibraryApi().details(pick.externalId);
      case PickKind.movie:
        if (omdbKey.isEmpty) {
          return Future.error(
            const ApiException('Add your OMDB_KEY to see movie details.'),
          );
        }
        return OmdbApi().details(pick.externalId);
    }
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final theme = Theme.of(context);

    final noteCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My note', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(pick.note.isEmpty ? 'No note.' : pick.note),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<ItemDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // My note comes from the CMS, so it stays visible if the API fails.
          if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                noteCard,
                SizedBox(
                  height: 300,
                  child: MessageView(
                    icon: Icons.error_outline,
                    message: errorText(snapshot.error),
                    actionLabel: 'Try again',
                    onAction: _retry,
                  ),
                ),
              ],
            );
          }

          final details = snapshot.data!;
          final imageUrl = details.imageUrl;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (imageUrl != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      height: 280,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_outlined, size: 64),
                    ),
                  ),
                )
              else
                Icon(
                  pick.kind == PickKind.book ? Icons.menu_book : Icons.movie,
                  size: 96,
                ),
              const SizedBox(height: 16),
              Text(details.title, style: theme.textTheme.headlineSmall),
              if (details.subtitle != null) Text(details.subtitle!),
              const SizedBox(height: 16),
              noteCard,
              const SizedBox(height: 16),
              Text('Summary', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(details.summary),
            ],
          );
        },
      ),
    );
  }
}
