import 'package:flutter/material.dart';

import '../data/pick_source.dart';
import 'tabs/book_search_tab.dart';
import 'tabs/movie_search_tab.dart';
import 'tabs/picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key, this.picksSource});

  final PickSource? picksSource;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PicksTab(source: picksSource),
            BookSearchTab(),
            MovieSearchTab(),
          ],
        ),
      ),
    );
  }
}
