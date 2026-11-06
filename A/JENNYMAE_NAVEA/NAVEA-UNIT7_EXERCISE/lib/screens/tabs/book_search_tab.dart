import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/open_library_api.dart';
import '../../models/book.dart';

class BookSearchTab extends StatefulWidget {
  const BookSearchTab({super.key, this.api});

  final OpenLibraryApi? api;

  @override
  State<BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends State<BookSearchTab> {
  late final OpenLibraryApi _api = widget.api ?? OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      setState(() => _results = null);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final results = _api.search(query);
      setState(() {
        _results = results;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.api == null) _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              hintText: 'Search books (minimum 3 characters)',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(child: Text('Type at least 3 letters to search'))
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final books = snapshot.data ?? const <Book>[];
                    if (books.isEmpty) {
                      return const Center(child: Text('Nothing found'));
                    }
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final author = book.authors.isEmpty
                            ? 'Unknown author'
                            : book.authors.first;
                        final year = book.year == null ? '' : ' (${book.year})';
                        return ListTile(
                          leading: _BookCover(coverId: book.coverId),
                          title: Text(book.title),
                          subtitle: Text('$author$year'),
                          trailing: IconButton(
                            tooltip: 'Copy book ID',
                            icon: const Icon(Icons.copy),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: book.workId),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied ID: ${book.workId}'),
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
      ],
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.coverId});

  final int? coverId;

  @override
  Widget build(BuildContext context) {
    if (coverId == null) return const Icon(Icons.menu_book_outlined, size: 40);
    return Image.network(
      'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
      width: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Icon(Icons.menu_book_outlined, size: 40),
    );
  }
}
