import 'package:flutter/material.dart';

import 'books_tab.dart';
import 'movies_tab.dart';
import 'my_picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Shelf',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFFFCAE9),
          bottom: const TabBar(
            labelColor: Color(0xFF5B3A4B),
            indicatorColor: Color(0xFF5B3A4B),
            tabs: [
              Tab(
                text: 'My Picks',
                icon: Icon(Icons.favorite),
              ),
              Tab(
                text: 'Books',
                icon: Icon(Icons.menu_book),
              ),
              Tab(
                text: 'Movies',
                icon: Icon(Icons.movie),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyPicksTab(),
            BooksTab(),
            MoviesTab(),
          ],
        ),
      ),
    );
  }
}