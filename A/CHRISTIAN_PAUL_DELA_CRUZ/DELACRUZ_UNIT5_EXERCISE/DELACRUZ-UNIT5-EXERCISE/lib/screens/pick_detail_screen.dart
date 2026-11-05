import 'package:flutter/material.dart';

import '../data/media_apis.dart';
import '../models/book.dart';
import '../models/movie.dart';
import '../models/pick.dart';
import '../widgets/cover_thumbnail.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({
    required this.pick,
    super.key,
    this.openLibrary = const OpenLibraryApi(),
    this.omdb = const OmdbApi(),
  });

  final Pick pick;
  final OpenLibraryApi openLibrary;
  final OmdbApi omdb;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final Future<Object> _details;

  @override
  void initState() {
    super.initState();
    _details = widget.pick.kind == PickKind.book
        ? widget.openLibrary.fetchWork(widget.pick.externalId)
        : widget.omdb.fetchById(widget.pick.externalId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.pick.title)),
    body: FutureBuilder<Object>(
      future: _details,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Could not load details: ${snapshot.error}'),
            ),
          );
        }
        final details = snapshot.data;
        final title = switch (details) {
          BookWork book => book.title,
          Movie movie => movie.title,
          _ => widget.pick.title,
        };
        final imageUrl = switch (details) {
          BookWork book => book.coverUrl,
          Movie movie => movie.posterUrl,
          _ => null,
        };
        final year = switch (details) {
          BookWork book => book.year?.toString() ?? 'Year unavailable',
          Movie movie => movie.year,
          _ => 'Year unavailable',
        };
        final summary = switch (details) {
          BookWork book => book.description,
          Movie movie => movie.plot,
          _ => 'No description available.',
        };
        final icon = widget.pick.kind == PickKind.book
            ? Icons.menu_book_outlined
            : Icons.movie_outlined;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CoverThumbnail(
                      url: imageUrl,
                      fallbackIcon: icon,
                      width: 180,
                      height: 250,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(year, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  Text(
                    'Why I recommend it',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(widget.pick.note),
                  const SizedBox(height: 20),
                  Text('About', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(summary),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
