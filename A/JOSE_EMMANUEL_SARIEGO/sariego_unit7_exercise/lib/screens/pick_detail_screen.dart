import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/open_library_api.dart';
import '../services/omdb_api.dart';

class PickDetailScreen extends StatelessWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  Future<Map<String, dynamic>> _loadDetails() {
    if (pick.kind == 'book') {
      return OpenLibraryApi().getDetails(pick.externalId);
    }

    return OmdbApi().getDetails(pick.externalId);
  }

  @override
  Widget build(BuildContext context) {
    final isBook = pick.kind == 'book';

    return Scaffold(
      appBar: AppBar(title: const Text('Pick Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load details: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No details available.'));
          }

          final details = snapshot.data!;

          final String title = isBook
              ? details['title'] ?? pick.title
              : details['Title'] ?? pick.title;

          final String description = isBook
              ? _getDescription(details['description'])
              : details['Plot'] ?? 'No description available.';

          final String imageUrl = isBook
              ? _getBookCover(details)
              : details['Poster'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageUrl.isNotEmpty && imageUrl != 'N/A')
                  Image.network(
                    imageUrl,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Icon(Icons.image_not_supported, size: 100);
                    },
                  )
                else
                  Icon(isBook ? Icons.menu_book : Icons.movie, size: 100),

                const SizedBox(height: 20),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 12),

                Chip(label: Text(isBook ? 'Book' : 'Movie')),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                const SizedBox(height: 8),

                Text(description, style: const TextStyle(fontSize: 15)),

                const SizedBox(height: 20),

                if (isBook) ...[
                  _detailRow(
                    'First Published',
                    details['first_publish_date'] ?? 'Unknown',
                  ),
                  _detailRow('Subjects', _getSubjects(details['subjects'])),
                ] else ...[
                  _detailRow('Year', details['Year'] ?? 'Unknown'),
                  _detailRow('Genre', details['Genre'] ?? 'Unknown'),
                  _detailRow('Director', details['Director'] ?? 'Unknown'),
                  _detailRow('Actors', details['Actors'] ?? 'Unknown'),
                  _detailRow('IMDb Rating', details['imdbRating'] ?? 'N/A'),
                ],

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Note',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                const SizedBox(height: 8),

                Text(pick.note.isEmpty ? 'No note added.' : pick.note),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _getDescription(dynamic value) {
    if (value is String) return value;

    if (value is Map<String, dynamic>) {
      return value['value']?.toString() ?? 'No description available.';
    }

    return 'No description available.';
  }

  static String _getBookCover(Map<String, dynamic> details) {
    final covers = details['covers'];

    if (covers is List && covers.isNotEmpty) {
      return 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg';
    }

    return '';
  }

  static String _getSubjects(dynamic subjects) {
    if (subjects is List && subjects.isNotEmpty) {
      return subjects.take(5).join(', ');
    }

    return 'Unknown';
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
