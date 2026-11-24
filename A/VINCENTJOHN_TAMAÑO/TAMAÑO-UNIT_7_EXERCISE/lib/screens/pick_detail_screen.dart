import 'package:flutter/material.dart';
import '../models/pick.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;
  final OpenLibraryApi? openLibraryApi;
  final OmdbApi? omdbApi;

  const PickDetailScreen({
    super.key,
    required this.pick,
    this.openLibraryApi,
    this.omdbApi,
  });

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final OpenLibraryApi _openLibraryApi;
  late final OmdbApi _omdbApi;
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _openLibraryApi = widget.openLibraryApi ?? OpenLibraryApi();
    _omdbApi = widget.omdbApi ?? OmdbApi();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    if (widget.pick.isBook) {
      final json =
          await _openLibraryApi.fetchWorkDetails(widget.pick.externalId);
      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };

      // Extract cover ID if present
      int? coverId;
      if (json['covers'] is List && (json['covers'] as List).isNotEmpty) {
        final firstCover = (json['covers'] as List).first;
        if (firstCover is int && firstCover > 0) {
          coverId = firstCover;
        }
      }

      final coverUrl = coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
          : null;

      return {
        'title': json['title'] as String? ?? widget.pick.title,
        'summary': description,
        'imageUrl': coverUrl,
        'source': 'Open Library ${widget.pick.externalId}',
      };
    } else {
      // Movie from OMDb
      if (!_omdbApi.hasKey) {
        return {
          'title': widget.pick.title,
          'summary':
              'Plot details unavailable because OMDB_KEY is not configured.',
          'imageUrl': null,
          'source': 'OMDb ${widget.pick.externalId}',
        };
      }
      final json = await _omdbApi.fetchMovieDetails(widget.pick.externalId);
      final plot = json['Plot'] as String? ?? 'No plot available.';
      final poster = (json['Poster'] == null || json['Poster'] == 'N/A')
          ? null
          : json['Poster'] as String?;

      return {
        'title': json['Title'] as String? ?? widget.pick.title,
        'summary': plot,
        'imageUrl': poster,
        'source': 'OMDb ${widget.pick.externalId}',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final pick = widget.pick;

    return Scaffold(
      appBar: AppBar(
        title: Text(pick.title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load details: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _detailsFuture = _loadDetails();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data ?? {};
          final displayTitle = data['title'] as String? ?? pick.title;
          final summary = data['summary'] as String? ?? 'No description yet.';
          final imageUrl = data['imageUrl'] as String?;
          final source = data['source'] as String? ?? pick.externalId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cover image / poster
                Center(
                  child: Container(
                    width: 160,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade300,
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                              pick.isBook ? Icons.book : Icons.movie,
                              size: 64,
                              color: Colors.grey.shade600,
                            ),
                          )
                        : Icon(
                            pick.isBook ? Icons.book : Icons.movie,
                            size: 64,
                            color: Colors.grey.shade600,
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  displayTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  '${pick.isBook ? "Book" : "Movie"} · $source',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 20),

                // Why I recommend it card
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why I recommend it',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '“ ',
                              style: TextStyle(
                                fontSize: 24,
                                height: 1.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                pick.note,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Summary
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
