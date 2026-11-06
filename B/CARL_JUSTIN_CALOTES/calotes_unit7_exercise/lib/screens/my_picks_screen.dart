import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import '../services/contentful_api.dart';

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key});

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  final ContentfulApi _contentfulApi = ContentfulApi();

  late Future<List<Pick>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  void _loadPicks() {
    _picksFuture = _contentfulApi.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    setState(() {
      _loadPicks();
    });

    await _picksFuture;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPicks,
      child: FutureBuilder<List<Pick>>(
        future: _picksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              children: const [
                SizedBox(height: 180),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (snapshot.hasError) {
            return ListView(
              children: [
                const SizedBox(height: 150),
                const Icon(Icons.error_outline, size: 50),
                const SizedBox(height: 12),
                const Center(child: Text('Failed to load your picks.')),
                Center(child: Text('${snapshot.error}')),
                const SizedBox(height: 12),
                const Center(child: Text('Pull down to try again.')),
              ],
            );
          }

          final picks = snapshot.data ?? [];

          if (picks.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 180),
                Icon(Icons.bookmark_border, size: 50),
                SizedBox(height: 12),
                Center(child: Text('You have no picks yet.')),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: Icon(
                    pick.kind == 'book'
                        ? Icons.menu_book
                        : Icons.movie,
                  ),
                  title: Text(pick.title),
                  subtitle: Text(pick.note),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PickDetailScreen(pick: pick),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
  static const String _omdbKey = String.fromEnvironment('OMDB_KEY');

  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    if (widget.pick.kind == 'book') {
      final uri = Uri.https(
        'openlibrary.org',
        '/works/${widget.pick.externalId}.json',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load book details');
      }

      final data = jsonDecode(response.body);

      String description = '';

      if (data['description'] is String) {
        description = data['description'];
      } else if (data['description'] is Map) {
        description = data['description']['value'] ?? '';
      }

      final List covers = data['covers'] ?? [];

      return {
        'title': data['title'] ?? widget.pick.title,
        'summary': description,
        'image': covers.isNotEmpty
            ? 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg'
            : '',
      };
    }

    if (_omdbKey.isEmpty) {
      throw Exception('OMDb API key is missing.');
    }

    final uri = Uri.https(
      'www.omdbapi.com',
      '/',
      {
        'apikey': _omdbKey,
        'i': widget.pick.externalId,
        'plot': 'short',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details');
    }

    final data = jsonDecode(response.body);

    if (data['Response'] == 'False') {
      throw Exception(data['Error'] ?? 'Movie details not found');
    }

    return {
      'title': data['Title'] ?? widget.pick.title,
      'summary': data['Plot'] ?? 'No summary available.',
      'image': data['Poster'] == 'N/A'
          ? ''
          : data['Poster'] ?? '',
    };
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Failed to load details: ${snapshot.error}',
                ),
              ),
            );
          }

          final details = snapshot.data!;
          final image = details['image'] as String;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image.isNotEmpty)
                  Center(
                    child: Image.network(
                      image,
                      height: 250,
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
                  details['title'],
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                const Text(
                  'My Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(widget.pick.note),
                const SizedBox(height: 20),
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  details['summary'].toString().isNotEmpty
                      ? details['summary']
                      : 'No summary available.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
