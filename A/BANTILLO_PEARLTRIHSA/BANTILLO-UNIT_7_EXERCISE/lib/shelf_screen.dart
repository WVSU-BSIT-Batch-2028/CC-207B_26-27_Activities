import 'package:flutter/material.dart';

import 'screens/books_tab.dart';
import 'screens/movies_tab.dart';
import 'screens/my_picks_tab.dart';

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
              Tab(icon: Icon(Icons.favorite), text: 'My Picks'),
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
