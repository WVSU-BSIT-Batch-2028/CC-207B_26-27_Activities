import 'package:flutter/material.dart';
import 'book_search_tab.dart';
import 'movie_search_tab.dart';
import 'my_picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Part A.b: ShelfScreen is a DefaultTabController with three tabs
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.favorite),
                text: 'My Picks',
              ),
              Tab(
                icon: Icon(Icons.menu_book),
                text: 'Books',
              ),
              Tab(
                icon: Icon(Icons.movie),
                text: 'Movies',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksTab(),
            BookSearchTab(),
            MovieSearchTab(),
          ],
        ),
      ),
    );
  }
}

