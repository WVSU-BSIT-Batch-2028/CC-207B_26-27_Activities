
import 'package:flutter/material.dart';

import 'my_picks_screen.dart';
import 'books_screen.dart';
import 'movies_screen.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shelf'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksScreen(),
            BooksScreen(),
            MoviesScreen(),
          ],
        ),
      ),
    );
  }
}
