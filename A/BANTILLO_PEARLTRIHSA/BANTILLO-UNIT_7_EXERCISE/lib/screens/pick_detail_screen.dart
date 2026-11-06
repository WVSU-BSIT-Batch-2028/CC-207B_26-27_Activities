import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import '../services/omdb_api.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({super.key, required this.pick});

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late Future<Map<String, dynamic>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchDetails();
  }

  Future<Map<String, dynamic>> _fetchDetails() async {
    final isBook = widget.pick.kind.toLowerCase() == 'book';

    final uri = isBook
        ? Uri.https('openlibrary.org', '/works/${widget.pick.externalId}.json')
        : Uri.https('www.omdbapi.com', '/', {
            'apikey': omdbKey,
            'i': widget.pick.externalId,
            'plot': 'short',
          });

    if (!isBook && omdbKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
    }

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load details: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (!isBook && data['Response'] == 'False') {
      throw Exception(data['Error'] ?? 'Movie details not found.');
    }

    return data;
  }

  String _getDescription(dynamic description) {
    if (description is String) {
      return description;
    }

    if (description is Map) {
      return description['value']?.toString() ?? '';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isBook = widget.pick.kind.toLowerCase() == 'book';

    return Scaffold(
      appBar: AppBar(title: const Text('Pick Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load details.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.data ?? {};

          String title;
          String summary;
          String? imageUrl;

          if (isBook) {
            title = data['title']?.toString() ?? widget.pick.title;
            summary = _getDescription(data['description']);

            final covers = data['covers'] as List<dynamic>?;

            if (covers != null && covers.isNotEmpty) {
              imageUrl =
                  'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg';
            }
          } else {
            title = data['Title']?.toString() ?? widget.pick.title;
            summary = data['Plot']?.toString() ?? '';

            final poster = data['Poster']?.toString();

            if (poster != null && poster != 'N/A') {
              imageUrl = poster;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            height: 280,
                            width: 190,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 280,
                                width: 190,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 80,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 280,
                            width: 190,
                            child: Icon(
                              isBook ? Icons.menu_book : Icons.movie_outlined,
                              size: 100,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF344B3A),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Card(
                  elevation: 0,
                  color: const Color.fromARGB(255, 246, 232, 242),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 237, 211, 229),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bookmark_outline),
                            const SizedBox(width: 8),
                            Text(
                              'My Note',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.pick.note,
                          style: const TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  elevation: 0,
                  color: const Color.fromARGB(255, 228, 244, 219),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 205, 240, 207),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.menu_book_outlined),
                            const SizedBox(width: 8),
                            Text(
                              'Summary',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          summary.isNotEmpty
                              ? summary
                              : 'No description available.',
                          style: const TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
