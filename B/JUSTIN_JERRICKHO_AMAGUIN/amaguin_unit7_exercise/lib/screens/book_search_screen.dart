import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/book.dart';
import '../services/open_library_api.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key, this.api});

  final OpenLibraryApi? api;

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen>
    with AutomaticKeepAliveClientMixin {
  late final OpenLibraryApi _api;
  Timer? _debounce;
  Future<List<Book>>? _results;
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? OpenLibraryApi();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _query = text.trim();
    // Detach old results immediately so late responses cannot show stale books.
    setState(() {
      _results = null;
    });
    if (_query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) _search();
    });
  }

  void _search() {
    final next = _api.search(_query);
    // Observe fast errors before FutureBuilder subscribes on the next frame.
    // The original Future still delivers its error to FutureBuilder.
    next.ignore();
    setState(() {
      _results = next;
    });
  }

  Future<void> _copyId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.workId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied ID: ${book.workId}')));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.api == null) _api.close();
    super.dispose();
  }

  Widget _message(String text, {bool retry = false}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            if (retry) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _search,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cover(Book book) {
    const fallback = Center(
      child: Icon(Icons.menu_book, semanticLabel: 'No cover available'),
    );
    final url = book.coverUrl;
    return SizedBox(
      width: 48,
      height: 64,
      child: url == null
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                semanticLabel: 'Cover of ${book.title}',
                errorBuilder: (_, _, _) => fallback,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : fallback,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: 'Search books',
              hintText: 'Type at least 3 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? _message(
                  _query.length < 3
                      ? 'Type at least 3 characters to search for books.'
                      : 'Waiting for you to finish typing…',
                )
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return _message('${snapshot.error}', retry: true);
                    }
                    final books = snapshot.data ?? const <Book>[];
                    if (books.isEmpty) return _message('Nothing found');

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: books.length,
                      separatorBuilder: (_, _) => const Divider(),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final author = book.authors.isEmpty
                            ? 'Unknown author'
                            : book.authors.first;
                        return ListTile(
                          leading: _cover(book),
                          title: Text(book.title),
                          subtitle: Text(
                            '$author · ${book.year ?? 'Unknown year'}\n${book.workId}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Copy ID for ${book.title}',
                            onPressed: () => _copyId(book),
                            icon: const Icon(Icons.copy_outlined),
                          ),
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
