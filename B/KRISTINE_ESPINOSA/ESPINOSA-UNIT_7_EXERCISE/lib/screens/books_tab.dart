import 'dart:async';

import 'package:flutter/material.dart';

import '../data/open_library_api.dart';
import '../models/book.dart';
import 'shelf_widgets.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key, required this.api});

  final OpenLibraryApi api;

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab>
    with AutomaticKeepAliveClientMixin {
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
        _results = widget.api.search(query);
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
              labelText: 'Search books',
              helperText: 'Type at least 3 letters',
              border: OutlineInputBorder(),
            ),
            onChanged: _onChanged,
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    final results = _results;
    if (results == null) {
      return const CenterMessage(
        icon: Icons.menu_book,
        text: 'Search Open Library for a book.',
      );
    }
    return FutureBuilder<List<Book>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CenterMessage(
            icon: Icons.hourglass_top,
            text: 'Searching...',
            spinner: true,
          );
        }
        if (snapshot.hasError) {
          return CenterMessage(
            icon: Icons.cloud_off,
            text: '${snapshot.error}',
          );
        }
        final books = snapshot.data!;
        if (books.isEmpty) {
          return const CenterMessage(
            icon: Icons.search_off,
            text: 'Nothing found',
          );
        }
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, i) {
            final book = books[i];
            final author = book.authors.isEmpty
                ? 'Unknown author'
                : book.authors.first;
            return ListTile(
              leading: CoverImage(
                url: book.coverUrl,
                fallbackIcon: Icons.menu_book,
                label: 'Cover of ${book.title}',
              ),
              title: Text(book.title),
              subtitle: Text(
                '$author${book.year == null ? '' : ' · ${book.year}'}\n${book.workId}',
              ),
              isThreeLine: true,
              trailing: CopyIdButton(id: book.workId),
            );
          },
        );
      },
    );
  }
}
