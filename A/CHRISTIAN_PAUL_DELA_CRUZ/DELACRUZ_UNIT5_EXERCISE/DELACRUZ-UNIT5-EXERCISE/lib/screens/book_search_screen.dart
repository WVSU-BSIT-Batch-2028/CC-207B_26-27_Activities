import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/media_apis.dart';
import '../models/book.dart';
import '../widgets/cover_thumbnail.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key, this.api = const OpenLibraryApi()});

  final OpenLibraryApi api;

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  Timer? _debounce;
  Future<List<Book>>? _results;
  String _query = '';

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    setState(() {
      _query = query;
      _results = null;
    });
    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _results = widget.api.search(query);
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _copyId(Book book) async {
    await Clipboard.setData(ClipboardData(text: book.workId));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied ${book.workId}')));
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Search books',
            hintText: 'Enter at least 3 letters',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: _onChanged,
        ),
      ),
      Expanded(
        child: _query.length < 3
            ? const Center(child: Text('Search for a book by title or author.'))
            : _results == null
            ? const Center(child: Text('Searching shortly...'))
            : FutureBuilder<List<Book>>(
                future: _results,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Could not search books: ${snapshot.error}',
                        ),
                      ),
                    );
                  }
                  final books = snapshot.data ?? const <Book>[];
                  if (books.isEmpty) {
                    return const Center(child: Text('Nothing found.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: books.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final metadata = [
                        if (book.author != null) book.author!,
                        if (book.year != null) book.year.toString(),
                      ].join(' • ');
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 6),
                        leading: CoverThumbnail(
                          url: book.coverUrl,
                          fallbackIcon: Icons.menu_book_outlined,
                        ),
                        title: Text(book.title),
                        subtitle: metadata.isEmpty ? null : Text(metadata),
                        trailing: IconButton(
                          tooltip: 'Copy book ID',
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyId(book),
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
