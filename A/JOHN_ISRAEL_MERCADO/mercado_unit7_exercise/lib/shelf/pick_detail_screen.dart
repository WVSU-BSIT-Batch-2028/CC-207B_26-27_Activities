import 'package:flutter/material.dart';

import 'api.dart';
import 'common.dart';
import 'models.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<ItemDetails> _details;

  @override
  void initState() {
    super.initState();
    final pick = widget.pick;
    _details = pick.kind == 'movie'
        ? OmdbApi().details(pick.externalId)
        : OpenLibraryApi().details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pick = widget.pick;
    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<ItemDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return MessageBox('Could not load details: ${snapshot.error}');
          }
          final details = snapshot.data!;
          final isMovie = pick.kind == 'movie';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 300,
                    child: imageOrIcon(
                      details.imageUrl,
                      isMovie ? Icons.movie : Icons.menu_book,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(details.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  '${isMovie ? 'Movie · IMDb' : 'Book · Open Library'} ${pick.externalId}',
                  style: theme.textTheme.labelSmall,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.format_quote, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Why I recommend it',
                              style: theme.textTheme.labelLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(pick.note, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(details.summary),
              ],
            ),
          );
        },
      ),
    );
  }
}
