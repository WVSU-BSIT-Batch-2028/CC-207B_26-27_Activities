import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/book.dart';
import '../services/open_library_api.dart';

class BookSearchTab extends StatefulWidget {
  final OpenLibraryApi? api;

  const BookSearchTab({super.key, this.api});

  @override
  State<BookSearchTab> createState() => _BookSearchTabState();
}

class _BookSearchTabState extends State<BookSearchTab> {
  late final OpenLibraryApi _api;
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Book>>? _results;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? OpenLibraryApi();
  }

  void _performSearch(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      setState(() {
        _results = null;
      });
      return;
    }
    setState(() => _results = _api.search(query));
  }

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) {
        setState(() {
          _results = null;
        });
        return;
      }
      setState(() => _results = _api.search(query)); // a new Future for the FutureBuilder
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _copyWorkId(String workId) {
    Clipboard.setData(ClipboardData(text: workId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $workId to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            onSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search books, e.g. hobbit',
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _performSearch(_controller.text),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(
                  child: Text(
                    'Search for a book (minimum 3 letters)',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    final books = snapshot.data ?? [];
                    if (books.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nothing found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: books.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        final author = book.authors.isNotEmpty
                            ? book.authors.first
                            : 'Unknown author';
                        final subtitle = book.year != null
                            ? '$author · ${book.year}'
                            : author;

                        return ListTile(
                          leading: SizedBox(
                            width: 48,
                            height: 64,
                            child: book.coverUrl != null
                                ? Image.network(
                                    book.coverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.book, size: 36),
                                  )
                                : const Icon(Icons.book, size: 36),
                          ),
                          title: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(subtitle),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy_outlined),
                            tooltip: 'Copy ID: ${book.workId}',
                            onPressed: () => _copyWorkId(book.workId),
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
