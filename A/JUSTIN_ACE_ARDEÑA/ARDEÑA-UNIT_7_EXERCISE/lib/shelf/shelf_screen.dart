import 'package:flutter/material.dart';

import 'books_tab.dart';
import 'movies_tab.dart';
import 'picks_tab.dart';

/// The Shelf page: three tabs (My Picks, Books, Movies).
class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // length, the number of tabs and the number of children must match.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shelf'),
          bottom: TabBar(
            // The AppBar is the primary color, so the tab colors are set
            // here to stay readable on it.
            labelColor: scheme.onPrimary,
            unselectedLabelColor: scheme.onPrimary.withValues(alpha: 0.7),
            indicatorColor: scheme.onPrimary,
            tabs: const [
              Tab(icon: Icon(Icons.bookmark), text: 'My Picks'),
              Tab(icon: Icon(Icons.menu_book), text: 'Books'),
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
            ],
          ),
        ),
        // Each tab keeps its state (see AutomaticKeepAliveClientMixin in
        // the tab widgets), so a search is not lost when you switch tabs.
        body: const TabBarView(
          children: [
            PicksTab(),
            BooksTab(),
            MoviesTab(),
          ],
        ),
      ),
    );
  }
}

