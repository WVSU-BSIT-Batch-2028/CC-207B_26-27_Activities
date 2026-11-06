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
  final OpenLibraryApi _openLibraryApi = OpenLibraryApi();
  final OmdbApi _omdbApi = OmdbApi();

  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() {
    if (widget.pick.kind == 'book') {
      return _openLibraryApi.getWork(widget.pick.externalId);
    }

    return _omdbApi.getMovie(widget.pick.externalId);
  }

  String _getBookDescription(dynamic description) {
    if (description is String) {
      return description;
    }

    if (description is Map<String, dynamic>) {
      return description['value'] as String? ?? '';
    }

    return 'No description available.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Details'),
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
            return const Center(
              child: Text('Unable to load details.'),
            );
          }

          final details = snapshot.data!;

          final bool isBook = widget.pick.kind == 'book';

          final String title = isBook
              ? details['title'] as String? ?? widget.pick.title
              : details['Title'] as String? ?? widget.pick.title;

          final String summary = isBook
              ? _getBookDescription(details['description'])
              : details['Plot'] as String? ?? 'No summary available.';

          final int? coverId = isBook && details['covers'] is List
              ? (details['covers'] as List).firstOrNull as int?
              : null;

          final String poster = isBook
              ? coverId != null
                  ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
                  : ''
              : details['Poster'] as String? ?? '';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (poster.isNotEmpty && poster != 'N/A')
                Center(
                  child: Image.network(
                    poster,
                    height: 280,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 100,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'My Note',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.pick.note),
              const SizedBox(height: 20),
              const Text(
                'Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(summary),
            ],
          );
        },
      ),
    );
  }
}