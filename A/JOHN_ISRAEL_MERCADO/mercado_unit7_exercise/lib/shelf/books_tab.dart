import 'dart:async';

import 'package:flutter/material.dart';

import 'api.dart';
import 'common.dart';
import 'models.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
  final OpenLibraryApi _api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  @override
  bool get wantKeepAlive => true;

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search books, e.g. hobbit',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(
          child: _results == null
              ? const MessageBox('Type at least 3 letters to search books.')
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return MessageBox(
                        'Something went wrong: ${snapshot.error}',
                      );
                    }
                    final books = snapshot.data!;
                    if (books.isEmpty) {
                      return const MessageBox('Nothing found.');
                    }
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final coverUrl = book.coverId == null
                            ? null
                            : 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg';
                        return ResultTile(
                          leading: imageOrIcon(coverUrl, Icons.menu_book),
                          title: book.title,
                          subtitle: [
                            if (book.authors.isNotEmpty) book.authors.first,
                            if (book.year != null) '${book.year}',
                          ].join(' · '),
                          id: book.workId,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
