
import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/open_library_api.dart';
import '../services/omdb_api.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({
    super.key,
    required this.pick,
  });

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() {
    if (widget.pick.kind.toLowerCase() == 'book') {
      return OpenLibraryApi().fetchDetails(widget.pick.externalId);
    } else if (widget.pick.kind.toLowerCase() == 'movie') {
      return OmdbApi().fetchDetails(widget.pick.externalId);
    }

    throw Exception('Unsupported pick type: ${widget.pick.kind}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pick.title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Failed to load details:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No details available.'),
            );
          }

          final details = snapshot.data!;

          if (widget.pick.kind.toLowerCase() == 'book') {
            return _buildBookDetails(details);
          }

          return _buildMovieDetails(details);
        },
      ),
    );
  }

  // BOOK DETAILS
  Widget _buildBookDetails(Map<String, dynamic> details) {
    final title = details['title'] as String? ?? widget.pick.title;

    final descriptionData = details['description'];
    String description = 'No description available.';

    if (descriptionData is String) {
      description = descriptionData;
    } else if (descriptionData is Map<String, dynamic>) {
      description =
          descriptionData['value'] as String? ?? description;
    }

    final covers = details['covers'] as List<dynamic>? ?? [];
    final coverId = covers.isNotEmpty ? covers.first : null;

    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : null;

    final subjects = details['subjects'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Book cover
          if (coverUrl != null)
            Image.network(
              coverUrl,
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.menu_book, size: 120);
              },
            )
          else
            const Icon(Icons.menu_book, size: 120),

          const SizedBox(height: 20),

          // 2. Book title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 16),

          // 3. Saved note
          _buildSavedNote(),

          const SizedBox(height: 20),

          // 4. Description
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(description),
          ),

          const SizedBox(height: 20),

          // 5. Subjects
          if (subjects.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Subjects',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(subjects.take(8).join(', ')),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  // MOVIE DETAILS
  Widget _buildMovieDetails(Map<String, dynamic> details) {
    final title = details['Title'] as String? ?? widget.pick.title;
    final year = details['Year'] as String? ?? 'Unknown';
    final plot = details['Plot'] as String? ?? 'No plot available.';
    final genre = details['Genre'] as String? ?? 'Unknown';
    final director = details['Director'] as String? ?? 'Unknown';
    final actors = details['Actors'] as String? ?? 'Unknown';
    final poster = details['Poster'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Movie poster
          if (poster != null && poster != 'N/A')
            Image.network(
              poster,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.movie, size: 120);
              },
            )
          else
            const Icon(Icons.movie, size: 120),

          const SizedBox(height: 20),

          // 2. Movie title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text('Year: $year'),

          const SizedBox(height: 16),

          // 3. Saved note
          _buildSavedNote(),

          const SizedBox(height: 20),

          // 4. Movie descriptions and information
          _buildInfoRow('Genre', genre),
          _buildInfoRow('Director', director),
          _buildInfoRow('Actors', actors),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Plot',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(plot),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('$label: $value'),
      ),
    );
  }

  Widget _buildSavedNote() {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Note',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.pick.note.isNotEmpty
                    ? widget.pick.note
                    : 'No personal note added.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
