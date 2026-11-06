import 'package:flutter/material.dart';

import 'api.dart';
import 'models.dart';
import 'widgets.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<PickDetails> _details;

  @override
  void initState() {
    super.initState();
    final pick = widget.pick;
    _details = pick.isBook
        ? OpenLibraryApi().details(pick.externalId)
        : OmdbApi().details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<PickDetails>(
        future: _details,
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

          final details = snapshot.requireData;
          final source = pick.isBook
              ? 'Book · Open Library ${pick.externalId}'
              : 'Movie · OMDb ${pick.externalId}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Cover(
                    url: details.imageUrl,
                    width: 180,
                    height: 260,
                    icon: pick.isBook ? Icons.menu_book : Icons.movie,
                  ),
                ),
                const SizedBox(height: 16),
                Text(pick.title, style: textTheme.headlineSmall),
                Text(
                  details.year == null ? source : '$source · ${details.year}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.format_quote),
                    title: const Text('Why I recommend it'),
                    subtitle: Text(
                      pick.note.isEmpty ? 'No note yet.' : pick.note,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(details.summary, style: textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
