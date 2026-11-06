import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';

import 'book_details_screen.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final OpenLibraryApi _api = OpenLibraryApi();
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

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        setState(() {
          _results = _api.search(query);
        });
      },
    );
  }

  void _copyId(String workId) {
    Clipboard.setData(ClipboardData(text: workId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Book ID copied: $workId'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBookCover(Book book) {
    if (book.coverId == null) {
      return const SizedBox(
        width: 80,
        height: 110,
        child: Icon(Icons.menu_book, size: 40),
      );
    }

    final imageUrl =
        'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg';

    return Image.network(
      imageUrl,
      width: 80,
      height: 110,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox(
          width: 80,
          height: 110,
          child: Icon(Icons.menu_book, size: 40),
        );
      },
    );
  }

  Widget _buildResults() {
    if (_results == null) {
      return const Center(
        child: Text('Search for books using at least 3 letters.'),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading books: ${snapshot.error}'),
          );
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty) {
          return const Center(
            child: Text('Nothing found. Try another search.'),
          );
        }

        
return ListView.builder(
  itemCount: books.length,
  itemBuilder: (context, index) {
    final book = books[index];

    final author = book.authors.isNotEmpty
        ? book.authors.first
        : 'Unknown author';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(
                book: book,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookCover(book),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text('Author: $author'),
                    Text(
                      'Year: ${book.year ?? 'Unknown'}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${book.workId}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy book ID',
                onPressed: () => _copyId(book.workId),
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ),
      ),
    );
  },
);

      },
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Search books...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _debounce?.cancel();
                  setState(() {
                    _results = null;
                  });
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _buildResults(),
        ),
      ],
    );
  }
}
