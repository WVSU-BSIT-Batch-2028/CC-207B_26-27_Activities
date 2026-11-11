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
              Tab(icon: Icon(Icons.bookmark_outline), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Books'),
              Tab(icon: Icon(Icons.movie_outlined), text: 'Movies'),
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
