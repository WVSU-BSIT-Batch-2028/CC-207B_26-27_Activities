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

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  final _api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  // Keeps the search text and results when you switch tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String text) {
    final query = text.trim();
    if (query.length < 3) return;
    if (!mounted) return;
    setState(() {
      _results = _api.search(query);
    });
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(text));
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // needed by AutomaticKeepAliveClientMixin
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search books',
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
            onSubmitted: (text) {
              _debounce?.cancel();
              _search(text);
            },
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_results == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Book>>(
      future: _results,
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
          itemBuilder: (context, i) => _buildTile(books[i]),
        );
      },
    );
  }

  Widget _buildTile(Book book) {
    final details = [
      if (book.authors.isNotEmpty) book.authors.first,
      if (book.year != null) '${book.year}',
    ].join(' · ');

    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 56,
        child: book.coverUrl == null
            ? const Icon(Icons.menu_book)
            : ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  book.coverUrl!,
                  fit: BoxFit.cover,
                  semanticLabel: 'Cover of ${book.title}',
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.menu_book),
                ),
              ),
      ),
      title: Text(book.title),
      subtitle: details.isEmpty ? null : Text(details),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.copy),
        onPressed: () => _copyId(book.workId),
      ),
    );
  }
}