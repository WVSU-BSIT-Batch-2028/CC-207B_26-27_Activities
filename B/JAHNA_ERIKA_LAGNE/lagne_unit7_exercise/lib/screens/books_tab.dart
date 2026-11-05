
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
  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;
  List<Book> _books = [];

  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.length < 3) {
      setState(() {
        _books = [];
        _isLoading = false;
        _hasSearched = false;
        _errorMessage = null;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _searchBooks(query),
    );
  }

  Future<void> _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await _api.searchBooks(query);

      if (!mounted) return;

      setState(() {
        _books = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _books = [];
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  Future<void> _copyBookId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.id));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied book ID: ${book.id}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBookCover(Book book) {
    if (book.coverUrl == null) {
      return Container(
        width: 85,
        height: 120,
        color: Colors.pink.shade50,
        child: const Icon(
          Icons.menu_book,
          size: 40,
          color: Colors.pink,
        ),
      );
    }

    return Image.network(
      book.coverUrl!,
      width: 85,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 85,
          height: 120,
          color: Colors.pink.shade50,
          child: const Icon(
            Icons.menu_book,
            size: 40,
            color: Colors.pink,
          ),
        );
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildBookCover(book),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Author: ${book.authorName}'),
                  Text(
                    'First published: ${book.firstPublishYear ?? 'Unknown'}',
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _copyBookId(book),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy Book ID'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 45, color: Colors.pink),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search for books...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onSearchChanged('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _errorMessage != null
                  ? _buildMessage(
                      _errorMessage!,
                      Icons.error_outline,
                    )
                  : !_hasSearched
                      ? _buildMessage(
                          'Enter at least 3 characters to search for books.',
                          Icons.menu_book,
                        )
                      : _books.isEmpty
                          ? _buildMessage(
                              'Nothing found. Try another search.',
                              Icons.search_off,
                            )
                          : ListView.builder(
                              itemCount: _books.length,
                              itemBuilder: (context, index) {
                                return _buildBookCard(_books[index]);
                              },
                            ),
        ),
      ],
    );
  }
}
