import 'package:flutter/material.dart';

import '../api/omdb_api.dart';
import '../api/open_library_api.dart';
import '../cms/pick_source.dart';
import '../config.dart';
import 'books_screen.dart';
import 'movies_screen.dart';
import 'picks_screen.dart';

/// My Picks, Books, and Movies. The outer [IndexedStack] keeps this mounted.
class ShelfScreen extends StatelessWidget {
  const ShelfScreen({
    super.key,
    this.pickSource,
    this.booksApi,
    this.moviesApi,
    this.apiKey = omdbKey,
  });

  final PickSource? pickSource;
  final OpenLibraryApi? booksApi;
  final OmdbApi? moviesApi;

  /// Defaults to the key compiled in with `--dart-define`.
  final String apiKey;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PicksScreen(source: pickSource),
            BooksScreen(api: booksApi),
            MoviesScreen(api: moviesApi, apiKey: apiKey),
          ],
        ),
      ),
    );
  }
}
