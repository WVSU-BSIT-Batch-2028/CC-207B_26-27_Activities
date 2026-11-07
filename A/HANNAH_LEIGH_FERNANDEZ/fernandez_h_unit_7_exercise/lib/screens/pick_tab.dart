import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pick.dart';
import '../services/sanity_service.dart';

class PickTab extends StatefulWidget {
  const PickTab({super.key});

  @override
  State<PickTab> createState() => _PickTabState();
}

class _PickTabState extends State<PickTab> {
  final SanityService _sanityService = SanityService();

  List<Pick> picks = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPicks();
  }

  Future<void> fetchPicks() async {
    setState(() {
      if (picks.isEmpty) isLoading = true;
      error = null;
    });

    try {
      final result = await _sanityService.fetchPicks();

      if (!mounted) return;

      setState(() {
        picks = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const refreshPhysics = AlwaysScrollableScrollPhysics();

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      child: RefreshIndicator(
        onRefresh: fetchPicks,
        child: Builder(
          builder: (context) {
            if (isLoading && picks.isEmpty) {
              return ListView(
                physics: refreshPhysics,
                children: const [
                  SizedBox(height: 250),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            if (error != null && picks.isEmpty) {
              return ListView(
                physics: refreshPhysics,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 200),
                  Icon(Icons.error_outline, size: 48, color: colors.error),
                  const SizedBox(height: 12),
                  Center(
                    child: Text('Error: $error', textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: FilledButton.tonal(
                      onPressed: fetchPicks,
                      child: const Text('Try Again'),
                    ),
                  ),
                ],
              );
            }

            if (picks.isEmpty) {
              return ListView(
                physics: refreshPhysics,
                children: [
                  const SizedBox(height: 250),
                  Icon(Icons.inbox_outlined, size: 48, color: colors.outline),
                  const SizedBox(height: 12),
                  const Center(child: Text('No picks available yet.')),
                ],
              );
            }

            return ListView.builder(
              physics: refreshPhysics,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: picks.length,
              itemBuilder: (context, index) {
                final pick = picks[index];

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: colors.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colors.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: colors.primaryContainer,
                      child: Icon(
                        pick.kind == 'book' ? Icons.menu_book : Icons.movie,
                        size: 26,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      pick.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        pick.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colors.outline,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PickDetailScreen(pick: pick),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick});

  final Pick pick;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  bool isLoading = true;
  String? error;

  String title = '';
  String summary = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      late String fetchedTitle;
      late String fetchedSummary;
      late String fetchedImage;

      if (widget.pick.kind == 'book') {
        final response = await http.get(
          Uri.parse(
            'https://openlibrary.org/works/'
            '${widget.pick.externalId}.json',
          ),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to load book details');
        }

        final json = jsonDecode(response.body);

        final description = switch (json['description']) {
          final String text => text, // "description": "..."
          {'value': final String text} =>
            text, // "description": {"type": ..., "value": "..."}
          _ => 'No description yet.',
        };

        fetchedTitle = json['title'] ?? widget.pick.title;
        fetchedSummary = description;

        final covers = json['covers'] as List?;

        if (covers != null && covers.isNotEmpty) {
          final coverId = covers.first;
          fetchedImage = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
        } else {
          fetchedImage = '';
        }
      } else {
        const apiKey = String.fromEnvironment('OMDB_KEY');
        if (apiKey.isEmpty) {
          throw Exception(
            'OMDb API key is missing. Run with --dart-define=OMDB_KEY=your-key',
          );
        }

        final response = await http.get(
          Uri.parse(
            'https://www.omdbapi.com/'
            '?apikey=$apiKey'
            '&i=${widget.pick.externalId}'
            '&plot=short',
          ),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to load movie details');
        }

        final json = jsonDecode(response.body);

        if (json['Response'] == 'False') {
          throw Exception(json['Error'] ?? 'Movie not found');
        }

        fetchedTitle = json['Title'] ?? widget.pick.title;
        fetchedSummary = json['Plot'] ?? 'No summary available.';
        fetchedImage = json['Poster'] ?? '';
      }

      if (!mounted) return;

      setState(() {
        title = fetchedTitle;
        summary = fetchedSummary;
        imageUrl = fetchedImage;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isBook = widget.pick.kind == 'book';

    return Scaffold(
      appBar: AppBar(title: const Text('Pick Details'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: (imageUrl.isNotEmpty && imageUrl != 'N/A')
                            ? Image.network(
                                imageUrl,
                                height: 280,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 280,
                                  width: 190,
                                  color: colors.surfaceContainerHighest,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                  ),
                                ),
                              )
                            : Container(
                                height: 280,
                                width: 190,
                                color: colors.surfaceContainerHighest,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Chip(
                    avatar: Icon(
                      isBook ? Icons.menu_book : Icons.movie,
                      size: 18,
                      color: colors.onPrimaryContainer,
                    ),
                    label: Text(isBook ? 'Book' : 'Movie'),
                    backgroundColor: colors.primaryContainer,
                    side: BorderSide.none,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'My Recommendation',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.pick.note,
                      style: TextStyle(
                        color: colors.onSecondaryContainer,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Summary',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(summary, style: const TextStyle(height: 1.5)),
                ],
              ),
            ),
    );
  }
}
