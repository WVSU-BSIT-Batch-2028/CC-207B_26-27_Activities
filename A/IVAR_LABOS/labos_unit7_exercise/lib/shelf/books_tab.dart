import 'package:flutter/material.dart';

import 'book.dart';
import 'open_library_api.dart';
import 'search_tab.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final _api = OpenLibraryApi();

  Future<List<SearchResult>> _search(String query) async {
    final books = await _api.search(query);
    return [
      for (final book in books)
        SearchResult(
          id: book.workId,
          title: book.title,
          subtitle: _subtitle(book),
          imageUrl: book.coverUrl,
          fallbackIcon: Icons.menu_book,
        ),
    ];
  }

  String? _subtitle(Book book) {
    final parts = [
      if (book.firstAuthor != null) book.firstAuthor!,
      if (book.year != null) '${book.year}',
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return SearchTab(hint: 'Search books on Open Library', search: _search);
  }
}
