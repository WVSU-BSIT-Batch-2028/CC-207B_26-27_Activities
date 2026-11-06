import 'package:flutter/material.dart';

import '../api/open_library_api.dart';
import '../models/book.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/cover_image.dart';
import '../widgets/search_page.dart';

/// Open Library search. The API object lives for the life of this tab.
class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key, this.api});

  final OpenLibraryApi? api;

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with AutomaticKeepAliveClientMixin {
  late final OpenLibraryApi _api;
  late final bool _ownsApi;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _ownsApi = widget.api == null;
    _api = widget.api ?? OpenLibraryApi();
  }

  @override
  void dispose() {
    if (_ownsApi) _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SearchPage<Book>(
      hint: 'Search books',
      instructions: 'Type at least 3 letters to search Open Library.',
      search: _api.search,
      itemBuilder: (BuildContext context, Book book) =>
          BookResultTile(book: book),
    );
  }
}

class BookResultTile extends StatelessWidget {
  const BookResultTile({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CoverImage(
              url: book.coverId == null
                  ? null
                  : openLibraryCoverUrl(book.coverId!),
              fallbackIcon: Icons.menu_book_outlined,
              semanticLabel: 'Cover of ${book.title}',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.authorLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(book.yearLabel, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            CopyIdButton(id: book.workId, tooltip: 'Copy work ID'),
          ],
        ),
      ),
    );
  }
}
