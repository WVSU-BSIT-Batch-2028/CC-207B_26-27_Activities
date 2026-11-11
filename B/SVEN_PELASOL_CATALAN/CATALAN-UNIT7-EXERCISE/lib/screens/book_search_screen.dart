import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';

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
  String _query = '';
  int _searchGeneration = 0;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    final generation = ++_searchGeneration;

    setState(() {
      _query = query;
      _results = null;
    });

    if (query.length < 3) return;

    // Start the request only after the user has stopped typing for 500 ms.
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _startSearch(query, generation);
    });
  }

  void _startSearch(String query, int generation) {
    if (!mounted || generation != _searchGeneration) return;
    debugPrint('[Books] Starting Open Library search for: $query');
    final request = _api.search(query);
    setState(() {
      _results = request;
    });
  }

  void _submitSearch(String text) {
    _debounce?.cancel();
    final query = text.trim();
    final generation = ++_searchGeneration;
    setState(() => _query = query);
    if (query.length >= 3) _startSearch(query, generation);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchGeneration++;
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.workId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied book ID: ${book.workId}')),
    );
  }

  Widget _cover(Book book) {
    if (book.coverUrl == null) {
      return const SizedBox(
        width: 52,
        height: 76,
        child: Icon(Icons.menu_book_outlined, size: 34),
      );
    }
    return Image.network(
      book.coverUrl!,
      width: 52,
      height: 76,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 52,
        height: 76,
        child: Icon(Icons.menu_book_outlined, size: 34),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            onSubmitted: _submitSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search books',
              hintText: 'Try The Hobbit',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
                icon: const Icon(Icons.close),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildResults(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_query.length < 3) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Enter at least 3 characters to search Open Library.'),
        ),
      );
    }
    if (_results == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Waiting 500 ms before searching…'),
          ],
        ),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Could not search books: ${snapshot.error}'),
            ),
          );
        }
        final books = snapshot.data ?? const <Book>[];
        if (books.isEmpty) {
          return const Center(child: Text('Nothing found. Try another title.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          itemCount: books.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final book = books[index];
            final author = book.authors.isEmpty ? 'Author unavailable' : book.authors.first;
            final year = book.year == null ? 'Year unavailable' : '${book.year}';
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _cover(book),
              ),
              title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text('$author • $year'),
              trailing: IconButton(
                tooltip: 'Copy book ID',
                onPressed: () => _copyId(book),
                icon: const Icon(Icons.copy_outlined),
              ),
            );
          },
        );
      },
    );
  }
}
