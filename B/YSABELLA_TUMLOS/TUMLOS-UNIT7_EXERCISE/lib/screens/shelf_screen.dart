import 'package:flutter/material.dart';

import '../widgets/glass_bar_background.dart';
import '../widgets/glass_title.dart';
import 'books_tab.dart';
import 'movies_tab.dart';
import 'picks_tab.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const GlassTitle('My Shelf'),
          flexibleSpace: const GlassBarBackground(),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Picks'),
              Tab(text: 'Books'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PicksTab(), BooksTab(), MoviesTab()],
        ),
      ),
    );
  }
}
