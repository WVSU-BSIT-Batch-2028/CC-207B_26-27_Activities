import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/open_library_api.dart';
import '../models/book.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final _api = OpenLibraryApi();
  final _controller = TextEditingController();
  Timer? _debounce;

  /// null until the first search starts.
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      // a new Future for the FutureBuilder (block body, not =>)
      setState(() {
        _results = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.workId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied ${book.workId}')));
  }

  Widget _cover(Book book) {
    const icon = Icon(Icons.menu_book, size: 32);
    final url = book.coverUrl;
    return SizedBox(
      width: 44,
      height: 60,
      child: url == null
          ? icon
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => icon,
            ),
    );
  }

  Widget _buildResults() {
    final results = _results;
    if (results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Book>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final books = snapshot.data!;
        if (books.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, i) {
            final book = books[i];
            final author =
                book.authors.isEmpty ? 'Unknown author' : book.authors.first;
            final year = book.year == null ? '' : ' · ${book.year}';
            return ListTile(
              leading: _cover(book),
              title: Text(book.title),
              subtitle: Text('$author$year'),
              trailing: IconButton(
                tooltip: 'Copy ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(book),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search books',
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }
}