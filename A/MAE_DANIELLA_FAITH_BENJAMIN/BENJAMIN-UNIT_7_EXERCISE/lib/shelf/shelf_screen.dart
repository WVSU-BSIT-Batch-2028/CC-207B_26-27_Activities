import 'package:flutter/material.dart';

import 'tabs/books_tab.dart';
import 'tabs/movies_tab.dart';
import 'tabs/my_picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('My Shelf'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'My Picks', icon: Icon(Icons.bookmark_outline)),
            Tab(text: 'Books', icon: Icon(Icons.menu_book_outlined)),
            Tab(text: 'Movies', icon: Icon(Icons.movie_outlined)),
          ],
        ),
      ),
      body: const TabBarView(children: [MyPicksTab(), BooksTab(), MoviesTab()]),
    ),
  );
}
