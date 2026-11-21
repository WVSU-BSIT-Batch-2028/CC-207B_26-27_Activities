import 'package:flutter/material.dart';

import '../config.dart';
import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../data/pick_source.dart';
import 'books_tab.dart';
import 'movies_tab.dart';
import 'picks_tab.dart';

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  final _books = OpenLibraryApi(httpClient);
  final _movies = OmdbApi(httpClient, apiKey: omdbKey);
  final PickSource _picks = ContentfulPickSource(
    httpClient,
    spaceId: cmsSpace,
    token: cmsToken,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bookmark), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PicksTab(source: _picks, books: _books, movies: _movies),
            BooksTab(api: _books),
            MoviesTab(api: _movies),
          ],
        ),
      ),
    );
  }
}
