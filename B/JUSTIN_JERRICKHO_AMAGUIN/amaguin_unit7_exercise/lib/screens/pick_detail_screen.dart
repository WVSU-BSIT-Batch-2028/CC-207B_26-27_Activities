import 'package:flutter/material.dart';

import '../config.dart' as config;
import '../models/pick.dart';
import '../models/shelf_detail.dart';
import '../services/omdb_api.dart';
import '../services/open_library_api.dart';
import '../widgets/shelf_status.dart';

class PickDetailScreen extends StatefulWidget {
  const PickDetailScreen({super.key, required this.pick, this.loadDetails});

  final Pick pick;
  final Future<ShelfDetail> Function()? loadDetails;

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  late final OpenLibraryApi _books;
  late final OmdbApi _movies;
  late Future<ShelfDetail> _detail;

  Future<ShelfDetail> _load() =>
      widget.loadDetails?.call() ??
      (widget.pick.kind == PickKind.book
          ? _books.details(widget.pick.externalId)
          : _movies.details(widget.pick.externalId));

  @override
  void initState() {
    super.initState();
    _books = OpenLibraryApi();
    _movies = OmdbApi(key: config.omdbKey);
    _detail = _load();
    _detail.ignore();
  }

  void _retry() {
    final next = _load();
    next.ignore();
    setState(() {
      _detail = next;
    });
  }

  @override
  void dispose() {
    _books.close();
    _movies.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.pick.title)),
    body: FutureBuilder<ShelfDetail>(
      future: _detail,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ShelfStatus(
            message: '${snapshot.error}',
            icon: Icons.error_outline,
            onRetry: _retry,
          );
        }
        final detail = snapshot.data!;
        final theme = Theme.of(context);
        final fallback = Center(
          child: Icon(
            widget.pick.kind == PickKind.book
                ? Icons.menu_book
                : Icons.movie_outlined,
            size: 64,
            semanticLabel: 'No image available',
          ),
        );
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 220,
                    child: detail.imageUrl == null
                        ? fallback
                        : Image.network(
                            detail.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => fallback,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(detail.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(detail.year ?? 'Publication year unavailable'),
                const SizedBox(height: 24),
                Text('Why I recommend it', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(widget.pick.note),
                const SizedBox(height: 24),
                Text('Summary', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(detail.summary),
                const SizedBox(height: 24),
                Text(
                  'Details from ${widget.pick.kind == PickKind.book ? 'Open Library' : 'OMDb'}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
