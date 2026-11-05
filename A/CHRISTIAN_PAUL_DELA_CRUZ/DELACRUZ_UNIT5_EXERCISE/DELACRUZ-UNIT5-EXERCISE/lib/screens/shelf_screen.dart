import 'package:flutter/material.dart';

import '../data/pick_source.dart';
import 'book_search_screen.dart';
import 'movie_search_screen.dart';
import 'my_picks_screen.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({
    super.key,
    this.pickSource = const ContentfulPickSource(),
  });

  final PickSource pickSource;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Column(
      children: [
        const TabBar(
          tabs: [
            Tab(text: 'My Picks'),
            Tab(text: 'Books'),
            Tab(text: 'Movies'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              MyPicksScreen(source: pickSource),
              const BookSearchScreen(),
              const MovieSearchScreen(),
            ],
          ),
        ),
      ],
    ),
  );
}
