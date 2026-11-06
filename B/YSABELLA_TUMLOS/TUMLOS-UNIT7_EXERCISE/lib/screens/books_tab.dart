import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/network_cover.dart';
import '../widgets/search_tab.dart';
import '../widgets/shelf_card.dart';

class BooksTab extends StatelessWidget {
  const BooksTab({super.key});

  static const _api = OpenLibraryApi();

  @override
  Widget build(BuildContext context) {
    return SearchTab<Book>(
      hint: 'Search books by title or author',
      search: _api.search,
      itemBuilder: (context, book) {
        final details = [
          if (book.authors.isNotEmpty) book.authors.first,
          if (book.year != null) '${book.year}',
        ];

        return ShelfCard(
          leading: NetworkCover(
            url: book.coverUrl,
            width: 52,
            height: 76,
            icon: Icons.menu_book_rounded,
          ),
          title: book.title,
          subtitle: details.isEmpty ? 'Unknown author' : details.join(' \u00b7 '),
          trailing: CopyIdButton(id: book.workId),
        );
      },
    );
  }
}
