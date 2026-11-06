import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/omdb_api.dart';
import '../data/open_library_api.dart';
import '../data/pick_source.dart';
import '../data/strapi_pick_source.dart';
import 'book_search_tab.dart';
import 'movie_search_tab.dart';
import 'pick_list_tab.dart';

class ShelfScreen extends StatefulWidget {
  const ShelfScreen({super.key});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  late final http.Client _client;
  late final OpenLibraryApi _books;
  late final OmdbApi _movies;
  late final PickSource _picks;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _books = OpenLibraryApi(_client);
    _movies = OmdbApi(_client, apiKey: omdbKey);
    _picks = StrapiPickSource(_client, baseUrl: cmsUrl, token: cmsToken);
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Picks', icon: Icon(Icons.bookmark_outline_rounded)),
              Tab(text: 'Books', icon: Icon(Icons.menu_book_rounded)),
              Tab(text: 'Movies', icon: Icon(Icons.movie_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PickListTab(source: _picks, books: _books, movies: _movies),
            BookSearchTab(api: _books),
            MovieSearchTab(api: _movies),
          ],
        ),
      ),
    );
  }
}
