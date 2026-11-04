import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../models/pick.dart';
import '../widgets/error_view.dart';

class _Details {
  const _Details({this.imageUrl, required this.summary});
  final String? imageUrl;
  final String summary;
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<_Details> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  Future<_Details> _load() async {
    final pick = widget.pick;

    if (pick.isBook) {
      final json = await OpenLibraryApi().work(pick.externalId);

      // description is a String or {"value": "..."}.
      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };

      int? coverId;
      for (final c in (json['covers'] as List<dynamic>?) ?? const []) {
        if (c is int && c > 0) {
          coverId = c;
          break;
        }
      }
      return _Details(
        imageUrl: coverId == null
            ? null
            : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
        summary: description,
      );
    }

    if (omdbKey.isEmpty) {
      throw ApiException(
        'The OMDb key is missing. Run with --dart-define-from-file=cms.json',
      );
    }
    final json = await OmdbApi().details(pick.externalId);
    final poster = json['Poster'] as String?;
    return _Details(
      imageUrl: (poster == null || poster == 'N/A') ? null : poster,
      summary: json['Plot'] as String? ?? 'No plot yet.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<_Details>(
        future: _future,
        builder: (context, snapshot) {
          final done = snapshot.connectionState == ConnectionState.done;
          final details = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Image from the API (or an icon).
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: details?.imageUrl == null
                      ? Icon(
                          pick.isBook ? Icons.menu_book : Icons.movie,
                          size: 96,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            details!.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              pick.isBook ? Icons.menu_book : Icons.movie,
                              size: 96,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(pick.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),

              // My note, from the CMS.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why I recommend it',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(pick.note.isEmpty ? 'No note yet.' : pick.note),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Summary, from the API.
              if (!done)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.hasError)
                ErrorView(message: messageOf(snapshot.error!), onRetry: _retry)
              else ...[
                Text('Summary', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(details!.summary),
              ],
            ],
          );
        },
      ),
    );
  }
}
