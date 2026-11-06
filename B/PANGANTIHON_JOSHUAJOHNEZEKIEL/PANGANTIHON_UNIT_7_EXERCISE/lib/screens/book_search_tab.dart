import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/book.dart';
import '../data/open_library_api.dart';
import 'catalog_search_tab.dart';

class BookSearchTab extends StatelessWidget {
  const BookSearchTab({super.key, required this.api});

  final OpenLibraryApi api;

  @override
  Widget build(BuildContext context) {
    return CatalogSearchTab<Book>(
      hint: 'Search books',
      search: api.search,
      resultTile: (context, book) => Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          minVerticalPadding: 10,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CatalogCover(
              icon: Icons.menu_book_rounded,
              imageUrl: book.coverId == null ? null : book.coverUrl,
            ),
          ),
          title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            [
                  if (book.authors.isNotEmpty) book.authors.first,
                  if (book.year != null) book.year.toString(),
                ].join(' · ').isEmpty
                ? 'Author or year unavailable'
                : [
                    if (book.authors.isNotEmpty) book.authors.first,
                    if (book.year != null) book.year.toString(),
                  ].join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            tooltip: 'Copy book ID',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () => _copyId(context, book.workId),
          ),
        ),
      ),
    );
  }

  Future<void> _copyId(BuildContext context, String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied book ID: $id')));
  }
}
