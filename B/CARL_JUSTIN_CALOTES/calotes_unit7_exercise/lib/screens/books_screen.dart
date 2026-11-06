import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  Future<List<Book>>? _searchFuture;

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      setState(() {
        _searchFuture = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _searchFuture = _api.search(query.trim());
      });
    });
  }

  void _copyBookId(String id) {
    Clipboard.setData(ClipboardData(text: id));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book ID copied!')),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _searchFuture == null
                ? const Center(
                    child: Text('Search for a book to get started.'),
                  )
                : FutureBuilder<List<Book>>(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong. Please try again.'),
                        );
                      }

                      final books = snapshot.data ?? [];

                      if (books.isEmpty) {
                        return const Center(
                          child: Text('No books found.'),
                        );
                      }

                      return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];

                          final author = book.authors.isNotEmpty
                              ? book.authors.first
                              : 'Unknown author';

                          final year = book.year?.toString() ?? 'Year unknown';

                          return Card(
                            child: ListTile(
                              leading: book.coverId != null
                                  ? Image.network(
                                      'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.book, size: 40);
                                      },
                                    )
                                  : const Icon(Icons.book, size: 40),
                              title: Text(book.title),
                              subtitle: Text('$author • $year'),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy book ID',
                                onPressed: () => _copyBookId(book.id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
