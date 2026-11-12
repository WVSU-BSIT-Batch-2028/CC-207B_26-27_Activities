import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/cms_service.dart';
import '../services/open_library_api.dart';

class ResultTile extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final String id;
  final bool isPicked;

  const ResultTile({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    required this.id,
    this.isPicked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = SizedBox(
      width: 40,
      height: 56,
      child: Icon(fallbackIcon, color: theme.colorScheme.secondary),
    );

    return ListTile(
      leading: imageUrl == null
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl!,
                width: 40,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              ),
            ),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPicked)
            Tooltip(
              message: 'In My Picks',
              child: Icon(
                Icons.favorite,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
          IconButton(
            tooltip: 'Copy ID',
            icon: const Icon(Icons.content_copy_outlined),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: id));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Copied $id')));
            },
          ),
        ],
      ),
    );
  }
}

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with AutomaticKeepAliveClientMixin {
  final api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    final query = text.trim();
    if (query.length < 3) {
      if (_results != null) setState(() => _results = null);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final results = api.search(query);
      setState(() {
        _results = results;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              labelText: 'Search books, e.g. hobbit',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search.'))
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Something went wrong: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    final books = snapshot.data!;
                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found.'));
                    }
                    return ValueListenableBuilder<Set<String>>(
                      valueListenable: pickedIds,
                      builder: (context, ids, _) => ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, i) {
                          final b = books[i];
                          final author = b.authors.isEmpty
                              ? 'Unknown author'
                              : b.authors.first;
                          return ResultTile(
                            imageUrl: b.coverUrl,
                            fallbackIcon: Icons.menu_book_outlined,
                            title: b.title,
                            subtitle: '$author · ${b.year ?? 'n/a'}',
                            id: b.workId,
                            isPicked: ids.contains(b.workId),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
