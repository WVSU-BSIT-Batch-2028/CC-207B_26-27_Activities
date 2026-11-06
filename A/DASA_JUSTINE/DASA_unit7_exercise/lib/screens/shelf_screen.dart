
import 'package:flutter/material.dart';

import 'book_search_screen.dart';
import 'movie_search_screen.dart';
import 'my_picks_screen.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'My Picks',
                icon: Icon(Icons.favorite_outline),
              ),
              Tab(
                text: 'Books',
                icon: Icon(Icons.menu_book),
              ),
              Tab(
                text: 'Movies',
                icon: Icon(Icons.movie_outlined),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksScreen(),
            BookSearchScreen(),
            MovieSearchScreen(),
          ],
        ),
      ),
    );
  }
}
