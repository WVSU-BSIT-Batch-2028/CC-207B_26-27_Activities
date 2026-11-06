import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'item_details.dart';

import 'api_exception.dart';

class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        workId: (json['key'] as String).split('/').last,
        title: json['title'] as String,
        // author_name is missing for some books, and it is a list.
        authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
        year: json['first_publish_year'] as int?,
        coverId: json['cover_i'] as int?,
      );
}

class OpenLibraryApi {
  Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = json['docs'] as List<dynamic>;
    return [for (final d in docs) Book.fromJson(d as Map<String, dynamic>)];
  }

  Future<ItemDetails> details(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw ApiException('Open Library error (${response.statusCode})');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final description = switch (json['description']) {
      final String text => text,
      {'value': final String text} => text,
      _ => 'No description yet.',
    };

    final covers = json['covers'] as List<dynamic>?;
    final coverId =
        (covers != null && covers.isNotEmpty) ? covers.first as int : null;

    return ItemDetails(
      title: json['title'] as String,
      imageUrl: (coverId != null && coverId > 0)
          ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
          : null,
      summary: description,
    );
  }
}

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final OpenLibraryApi api = OpenLibraryApi();
  Timer? _debounce;
  Future<List<Book>>? _results;

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) return;
      setState(() {
        _results = api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _copyId(String id) {
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $id')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search books (3+ letters)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? Center(
                  child: Text(
                    'Type at least 3 letters to search.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : FutureBuilder<List<Book>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    final books = snapshot.data!;
                    if (books.isEmpty) {
                      return Center(
                        child: Text(
                          'Nothing found',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    return ListView(
                      children: [
                        for (final book in books)
                          ListTile(
                            leading: book.coverId == null
                                ? const Icon(Icons.menu_book, size: 40)
                                : Image.network(
                                    'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                                    width: 40,
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Cover of ${book.title}',
                                  ),
                            title: Text(book.title),
                            subtitle: Text([
                              if (book.authors.isNotEmpty) book.authors.first,
                              if (book.year != null) '${book.year}',
                            ].join(' · ')),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copy ID',
                              onPressed: () => _copyId(book.workId),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}