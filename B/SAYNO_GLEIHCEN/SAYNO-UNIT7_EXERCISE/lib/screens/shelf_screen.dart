import 'package:flutter/material.dart';

import 'books_tab.dart';
import 'movies_tab.dart';
import 'my_picks_tab.dart';

/// The fourth tab: three tabs of its own.
class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // length, the number of tabs and the number of children must match.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite_outline), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Books'),
              Tab(icon: Icon(Icons.movie_outlined), text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [MyPicksTab(), BooksTab(), MoviesTab()],
        ),
      ),
    );
  }
}