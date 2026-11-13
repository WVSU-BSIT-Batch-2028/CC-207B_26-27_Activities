import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'book.dart';
import 'open_library_api.dart';

/// Books tab: search Open Library.
class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  // Keeps this tab's State alive when the user swipes to another tab.
  @override
  bool get wantKeepAlive => true;

  final api = OpenLibraryApi();
  Future<List<Book>>? _results; // null until the first search

  // Waits until the user stops typing for 500 ms, so we do not send a
  // request for every letter.
  Timer? _debounce;
  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      // Block body on purpose: an arrow body would return the Future, and
      // setState does not allow that.
      setState(() {
        _results = api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _copy(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.workId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${book.workId}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search books (3+ letters)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    final future = _results;
    if (future == null) {
      return const Center(child: Text('Type at least 3 letters to search.'));
    }
    return FutureBuilder<List<Book>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }
        final books = snapshot.data!;
        if (books.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, i) => _buildBook(books[i]),
        );
      },
    );
  }

  Widget _buildBook(Book book) {
    final coverId = book.coverId;
    final author = book.authors.isEmpty ? 'Unknown author' : book.authors.first;
    final year = book.year?.toString() ?? 'Year unknown';
    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 64,
        child: coverId == null
            ? const Icon(Icons.menu_book)
            : Image.network(
                'https://covers.openlibrary.org/b/id/$coverId-M.jpg',
                fit: BoxFit.cover,
                webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
      ),
      title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('$author · $year', maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        tooltip: 'Copy work id',
        icon: const Icon(Icons.copy),
        onPressed: () => _copy(book),
      ),
    );
  }
}
