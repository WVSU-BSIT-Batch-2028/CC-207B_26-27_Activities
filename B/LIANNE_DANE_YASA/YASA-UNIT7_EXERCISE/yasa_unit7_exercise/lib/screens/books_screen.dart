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

  Timer? _debounce;
  Future<List<Book>>? _searchFuture;

  String _query = '';
  bool _isDebouncing = false;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    setState(() {
      _query = query;
      _searchFuture = null;
      _isDebouncing = query.length >= 3;
    });

    if (query.length < 3) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      setState(() {
        _isDebouncing = false;
        _searchFuture = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _copyBookId(Book book) {
    Clipboard.setData(ClipboardData(text: book.workId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied ${book.workId}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Enter at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_query.isEmpty) {
      return const Center(
        child: Text('Search for a book to get started.'),
      );
    }

    if (_query.length < 3) {
      return const Center(
        child: Text('Enter at least 3 characters to search.'),
      );
    }

    if (_isDebouncing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final future = _searchFuture;

    if (future == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<Book>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty) {
          return const Center(
            child: Text('Nothing found.'),
          );
        }

        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1),
          itemBuilder: (context, index) {
            final book = books[index];

            final author = book.authors.isNotEmpty
                ? book.authors.first
                : 'Unknown author';

            final year = book.firstPublishYear?.toString() ??
                'Unknown year';

            return ListTile(
              leading: book.coverId != null
                  ? Image.network(
                      'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.menu_book, size: 40);
                      },
                    )
                  : const Icon(Icons.menu_book, size: 40),
              title: Text(book.title),
              subtitle: Text('$author • $year'),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy book ID',
                onPressed: () => _copyBookId(book),
              ),
            );
          },
        );
      },
    );
  }
}
