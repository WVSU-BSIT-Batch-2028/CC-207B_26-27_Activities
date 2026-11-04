import 'dart:async';

import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/open_library_api.dart';
import '../models/book.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/error_view.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  final _api = OpenLibraryApi();
  Timer? _debounce;
  String _query = '';
  Future<List<Book>>? _results;

  @override
  bool get wantKeepAlive => true; // keep the search when you switch tabs

  void _search(String query) {
    // A block body: setState must not return the Future.
    setState(() {
      _query = query;
      _results = _api.search(query);
    });
  }

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (!mounted || query.length < 3) return;
      _search(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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
          return ErrorView(
            message: messageOf(snapshot.error!),
            onRetry: () => _search(_query),
          );
        }
        final books = snapshot.data!;
        if (books.isEmpty) return const Center(child: Text('Nothing found.'));
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, i) {
            final book = books[i];
            final author = book.authors.isEmpty
                ? 'Unknown author'
                : book.authors.first;
            return ListTile(
              leading: SizedBox(
                width: 44,
                child: book.coverUrl == null
                    ? const Icon(Icons.book)
                    : Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.book),
                      ),
              ),
              title: Text(book.title),
              subtitle: Text(
                [author, if (book.year != null) '${book.year}'].join(' · '),
              ),
              trailing: CopyIdButton(id: book.workId),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search books (Open Library)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }
}
