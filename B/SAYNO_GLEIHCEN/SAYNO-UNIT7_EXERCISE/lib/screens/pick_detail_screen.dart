import 'package:flutter/material.dart';

import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../models/pick.dart';
import '../models/pick_details.dart';
import 'movies_tab.dart' show omdbKey;

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<PickDetails> _future;

  @override
  void initState() {
    super.initState();
    // The request starts here, once, and not in build().
    _future = _load();
  }

  Future<PickDetails> _load() {
    final pick = widget.pick;
    if (pick.kind == PickKind.book) {
      return OpenLibraryApi().details(pick.externalId);
    }
    if (omdbKey.isEmpty) {
      throw const ApiException('No OMDb key. Run with --dart-define-from-file=cms.json');
    }
    return OmdbApi(omdbKey).details(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pick = widget.pick;
    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // My note comes from the CMS, so it shows right away.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My note', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(pick.note, style: textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // The image and the summary come from the API.
          FutureBuilder<PickDetails>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('${snapshot.error}', textAlign: TextAlign.center);
              }
              final details = snapshot.data!;
              final url = details.imageUrl;
              const icon = Icon(Icons.image_not_supported, size: 64);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 320,
                    child: url == null
                        ? icon
                        : Image.network(
                            url,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stack) => icon,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(details.title, style: textTheme.headlineSmall),
                  if (details.year != null) Text(details.year!),
                  const SizedBox(height: 12),
                  Text('Summary', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(details.summary, style: textTheme.bodyMedium),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}