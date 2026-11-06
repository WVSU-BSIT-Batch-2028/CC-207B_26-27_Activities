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
  final TextEditingController _searchController = TextEditingController();
  final OpenLibraryApi _api = OpenLibraryApi();

  Timer? _debounce;
  Future<List<Book>>? _booksFuture;

  void _searchBooks(String query) {
    _debounce?.cancel();

    if (query.trim().length < 3) {
      setState(() {
        _booksFuture = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _booksFuture = _api.search(query.trim());
      });
    });
  }

  Future<void> _copyBookId(String workId) async {
    await Clipboard.setData(ClipboardData(text: workId));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Book ID copied: $workId')));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _searchBooks,
            decoration: InputDecoration(
              hintText: 'Search books...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _booksFuture == null
                ? const Center(
                    child: Text('Enter at least 3 characters to search.'),
                  )
                : FutureBuilder<List<Book>>(
                    future: _booksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final books = snapshot.data ?? [];

                      if (books.isEmpty) {
                        return const Center(child: Text('No books found.'));
                      }

                      return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: book.coverId != null
                                  ? Image.network(
                                      'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return const Icon(
                                          Icons.menu_book,
                                          size: 40,
                                        );
                                      },
                                    )
                                  : const Icon(Icons.menu_book, size: 40),
                              title: Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${book.authors.isNotEmpty ? book.authors.first : 'Unknown author'}'
                                '${book.firstPublishYear != null ? '\n${book.firstPublishYear}' : ''}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy Book ID',
                                onPressed: () => _copyBookId(book.workId),
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
