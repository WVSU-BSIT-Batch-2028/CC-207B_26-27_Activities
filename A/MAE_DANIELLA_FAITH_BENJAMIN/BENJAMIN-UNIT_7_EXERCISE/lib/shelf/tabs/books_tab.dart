import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/open_library_api.dart';
import '../models/book.dart';
import '../widgets/copy_id_button.dart';
import '../widgets/media_artwork.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  final TextEditingController _controller = TextEditingController();
  late final http.Client _client;
  late final OpenLibraryApi _api;
  Timer? _debounce;
  Future<List<Book>>? _future;
  String _query = '';
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _api = OpenLibraryApi(_client);
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    setState(() {
      _query = query;
      _future = null;
      _waiting = query.length >= 3;
    });
    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _waiting = false;
        _future = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _client.close();
    super.dispose();
  }

  Widget _buildResults() {
    if (_query.length < 3) {
      return const Center(
        child: Text('Search by title or author (3+ letters).'),
      );
    }
    if (_waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    final future = _future;
    if (future == null) return const SizedBox.shrink();
    return FutureBuilder<List<Book>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final books = snapshot.data ?? const <Book>[];
        if (books.isEmpty) return const Center(child: Text('Nothing found.'));
        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final book = books[index];
            final author = book.authors.isEmpty
                ? 'Author unavailable'
                : book.authors.first;
            final year = book.year?.toString() ?? 'Year unavailable';
            return ListTile(
              leading: MediaArtwork(url: book.coverUrl, icon: Icons.menu_book),
              title: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('$author · $year'),
              trailing: CopyIdButton(id: book.workId, label: 'Book'),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          decoration: const InputDecoration(
            labelText: 'Search books',
            hintText: 'Title or author',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: _buildResults()),
      ],
    ),
  );
}
