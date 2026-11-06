import 'package:flutter/material.dart';

import 'books_screen.dart';
import 'movies_screen.dart';
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
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie_outlined), text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          children: [MyPicksScreen(), BooksScreen(), MoviesScreen()],
        ),
      ),
    );
  }
}
