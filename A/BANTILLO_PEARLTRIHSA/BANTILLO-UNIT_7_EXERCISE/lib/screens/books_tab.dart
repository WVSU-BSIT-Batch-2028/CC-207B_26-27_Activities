
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
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  Future<List<Book>>? _booksFuture;

  bool _isDebouncing = false;

  void _searchBooks(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.length < 3) {
      setState(() {
        _booksFuture = null;
        _isDebouncing = false;
      });
      return;
    }

    setState(() {
      _isDebouncing = true;
      _booksFuture = null;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _isDebouncing = false;
        _booksFuture = _api.search(query);
      });
    });
  }

  void _copyBookId(String workId) {
    Clipboard.setData(ClipboardData(text: workId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book ID copied!'),
        duration: Duration(seconds: 2),
      ),
    );
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
            hintText: 'Search for a book...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchBooks('');
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildSearchResults()),
      ],
    ),
  );
}

  Widget _buildSearchResults() {
    if (_isDebouncing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_booksFuture == null) {
      return const Center(
        child: Text('Enter at least 3 characters to search for books.'),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong. Please try again.'),
          );
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty) {
          return const Center(child: Text('No books found.'));
        }

        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 20),
          itemBuilder: (context, index) {
            final book = books[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: SizedBox(
                width: 55,
                height: 75,
                child: book.coverId != null
                    ? Image.network(
                        'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.menu_book,
                            size: 40,
                          );
                        },
                      )
                    : const Icon(Icons.menu_book, size: 40),
              ),
              title: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${book.authors.isNotEmpty ? book.authors.first : 'Unknown author'}'
                '${book.firstPublishYear != null ? ' • ${book.firstPublishYear}' : ''}',
              ),
              trailing: IconButton(
                tooltip: 'Copy Book ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyBookId(book.workId),
              ),
            );
          },
        );
      },
    );
  }
}
