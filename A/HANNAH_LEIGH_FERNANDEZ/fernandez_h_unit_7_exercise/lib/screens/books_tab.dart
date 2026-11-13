import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final OpenLibraryApi api = OpenLibraryApi();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();

    final query = text.trim();

    if (query.length < 3) {
      setState(() {
        _results = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _results = api.search(query);
      });
    });
  }

  void _copyId(String id) {
    Clipboard.setData(ClipboardData(text: id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Copied book ID: $id'),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _message(IconData icon, String text, Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Search books (e.g. The Hobbit)...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: colors.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        Expanded(
          child: _results == null
              ? _message(
                  Icons.auto_stories_outlined,
                  'Search for at least 3 letters',
                  colors.outline,
                )
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return _message(
                        Icons.error_outline,
                        'Error: ${snapshot.error}',
                        colors.error,
                      );
                    }

                    final books = snapshot.data ?? [];

                    if (books.isEmpty) {
                      return _message(
                        Icons.search_off,
                        'Nothing found',
                        colors.outline,
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];

                        final placeholder = Container(
                          width: 50,
                          height: 70,
                          color: colors.primaryContainer,
                          child: Icon(
                            book.coverId != null
                                ? Icons.menu_book
                                : Icons.hide_image_outlined,
                            size: 28,
                            color: colors.onPrimaryContainer,
                          ),
                        );

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
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: book.coverId != null
                                  ? Image.network(
                                      'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return placeholder;
                                          },
                                    )
                                  : placeholder,
                            ),

                            title: Text(
                              book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(
                              '${book.authors.isNotEmpty ? book.authors.first : 'Unknown author'}'
                              ' • ${book.year ?? 'Unknown year'}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            trailing: IconButton(
                              icon: Icon(Icons.copy, color: colors.outline),
                              tooltip: 'Copy book ID',
                              onPressed: () => _copyId(book.workId),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
